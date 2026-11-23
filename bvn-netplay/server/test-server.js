'use strict';

const assert = require('assert');
const net = require('net');
const { createNetplayServer, recommendDelayFrames, formatChecksumDiff } = require('./server');

class MockFlashClient {
  constructor(port) {
    this.port = port;
    this.socket = null;
    this.buffer = '';
    this.queue = [];
    this.waiters = [];
  }

  connect() {
    return new Promise((resolve, reject) => {
      this.socket = net.createConnection({ host: '127.0.0.1', port: this.port }, () => {
        this.socket.setNoDelay(true);
        resolve();
      });
      this.socket.on('error', reject);
      this.socket.on('data', (chunk) => {
        this.buffer += chunk.toString('utf8');
        let idx;
        while ((idx = this.buffer.indexOf('\0')) !== -1) {
          const msg = this.buffer.slice(0, idx);
          this.buffer = this.buffer.slice(idx + 1);
          if (this.waiters.length > 0) {
            const w = this.waiters.shift();
            w(msg);
          } else {
            this.queue.push(msg);
          }
        }
      });
    });
  }

  send(msg) {
    this.socket.write(msg + '\0');
  }

  nextMsg(timeoutMs = 3000) {
    if (this.queue.length > 0) {
      return Promise.resolve(this.queue.shift());
    }
    return new Promise((resolve, reject) => {
      const timer = setTimeout(() => {
        reject(new Error(`Timeout waiting for server message (${timeoutMs}ms)`));
      }, timeoutMs);
      this.waiters.push((msg) => {
        clearTimeout(timer);
        resolve(msg);
      });
    });
  }

  async nextWhere(prefix, timeoutMs = 3000) {
    const deadline = Date.now() + timeoutMs;
    while (true) {
      const rem = deadline - Date.now();
      if (rem <= 0) throw new Error(`Timeout waiting for prefix "${prefix}"`);
      const msg = await this.nextMsg(rem);
      if (msg.startsWith(prefix)) return msg;
    }
  }

  close() {
    if (this.socket) this.socket.destroy();
  }
}

async function runTests() {
  assert.strictEqual(recommendDelayFrames(10, 35), 2);
  assert.strictEqual(recommendDelayFrames(10, 65), 3);
  assert.strictEqual(recommendDelayFrames(10, 105), 4);
  assert.strictEqual(recommendDelayFrames(140, 20), 5);
  assert.strictEqual(recommendDelayFrames(200, 20), 6);
  const diffSample = formatChecksumDiff(
    '320,-25,1000,10,12,650,-25,950,0,5,59',
    '320,-25,1000,10,12,650,-25,900,0,7,59'
  );
  assert(diffSample.includes('p2.hp: P1=950 vs P2=900'));
  assert(diffSample.includes('p2.fr: P1=5 vs P2=7'));
  console.log('[PASS] 0. Adaptive delay & checksum field-diff helpers verified');

  const silentLogger = { log() {}, warn() {}, error() {} };
  const srv = createNetplayServer({
    logger: silentLogger,
    disablePolicyPort843: true,
    desyncLogPath: null,
    stepDelayMs: 20
  });

  await new Promise((resolve) => srv.listen(0, '127.0.0.1', resolve));
  const port = srv.server.address().port;
  console.log(`[TEST] Server listening on 127.0.0.1:${port}`);

  const p1 = new MockFlashClient(port);
  const p2 = new MockFlashClient(port);

  try {
    await p1.connect();
    await p2.connect();

    // 1. Flash policy handshake
    p1.send('<policy-file-request/>');
    const policy = await p1.nextMsg();
    assert(policy.includes('<cross-domain-policy>'), 'Expected Flash policy XML');
    console.log('[PASS] 1. Flash policy-file-request handled');

    // 2. Ping / Pong with RTT telemetry
    p1.send('P|12345|12');
    assert.strictEqual(await p1.nextMsg(), 'Q|12345');
    console.log('[PASS] 2. Ping/Pong verified');

    // 3. Create Room (AUTO delay = 0) & Join Room (P2)
    p1.send('C|2.6|0|1000|60');
    const r1 = (await p1.nextWhere('R|')).split('|');
    const roomCode = r1[1];
    p2.send(`J|${roomCode}|9.9`);
    assert((await p2.nextWhere('E|')).startsWith('E|VERSION_MISMATCH'));
    p2.send(`J|${roomCode}|2.6`);
    await p2.nextWhere('R|');
    assert((await p1.nextWhere('O|')).startsWith('O|JOINED'));

    p2.send('P|555|70');
    await p2.nextWhere('Q|555');
    const tel = (await p1.nextWhere('T|12|70|')).split('|');
    assert.strictEqual(tel[3], '3');
    console.log(`[PASS] 3. Room create/join, version guard & AUTO telemetry (${roomCode}, rec=3f)`);

    // 4. Host starts SELECT
    p1.send('B|0|1500|60');
    const m1 = (await p1.nextWhere('M|SELECT|')).split('|');
    const m2 = (await p2.nextWhere('M|SELECT|')).split('|');
    assert.strictEqual(m1.join('|'), m2.join('|'));
    const selectEpoch = parseInt(m1[2], 10);
    console.log(`[PASS] 4. SELECT phase synchronized (epoch=${selectEpoch})`);

    // 5. Authoritative Character / Assist / Map Selection Business Rules
    // 5a. Cursor moves relay strictly tagged with sender slot
    p1.send('S|0|M|3|7');
    assert.strictEqual(await p2.nextWhere('S|'), 'S|1|0|M|3|7');
    p2.send('S|0|M|9|5');
    assert.strictEqual(await p1.nextWhere('S|'), 'S|2|0|M|9|5');

    // 5b. Lock fighters -> both advance to Assist Select (STEP 1)
    p1.send('S|0|K|一护');
    assert.strictEqual(await p2.nextWhere('S|1|0|K|'), 'S|1|0|K|一护');
    p2.send('S|0|K|鸣人');
    assert.strictEqual(await p1.nextWhere('S|2|0|K|'), 'S|2|0|K|鸣人');
    assert.strictEqual(await p1.nextWhere('S|STEP|1|'), 'S|STEP|1|一护|鸣人');
    assert.strictEqual(await p2.nextWhere('S|STEP|1|'), 'S|STEP|1|一护|鸣人');

    // 5c. Assist cannot duplicate own fighter
    p1.send('S|1|K|一护');
    assert.strictEqual(await p1.nextWhere('E|'), 'E|DUPLICATE_FZ');

    // 5d. Valid assists -> both advance to Map Select (STEP 2)
    p1.send('S|1|K|魂');
    p2.send('S|1|K|夜一');
    assert.strictEqual(await p1.nextWhere('S|STEP|2|'), 'S|STEP|2|魂|夜一');
    assert.strictEqual(await p2.nextWhere('S|STEP|2|'), 'S|STEP|2|魂|夜一');

    // 5e. Map Select: P2 attempt must be ignored; ONLY P1 can move & lock Map!
    p2.send('S|2|K|木叶村');
    p1.send('S|2|M|2|0');
    assert.strictEqual(await p2.nextWhere('S|1|2|M|'), 'S|1|2|M|2|0');
    p1.send('S|2|K|双极');
    const step3P1 = await p1.nextWhere('S|STEP|3|');
    const step3P2 = await p2.nextWhere('S|STEP|3|');
    assert.strictEqual(step3P1, 'S|STEP|3|一护|鸣人|魂|夜一|双极');
    assert.strictEqual(step3P2, step3P1);
    console.log('[PASS] 5. Strict Character/Assist/Map select sync & slot isolation verified');

    // 6. Loading barrier -> FIGHT
    p1.send('L|一护|鸣人|魂|夜一|双极');
    p2.send('L|一护|鸣人|魂|夜一|双极');
    const g1 = (await p1.nextWhere('G|')).split('|');
    const g2 = (await p2.nextWhere('G|')).split('|');
    assert.strictEqual(g1.join('|'), g2.join('|'));
    const fightEpoch = parseInt(g1[1], 10);
    assert.strictEqual(fightEpoch, selectEpoch + 1);
    console.log(`[PASS] 6. Loading barrier -> FIGHT (epoch=${fightEpoch}, seed=${g1[2]})`);

    // 7. 10,000-Frame Stress Test
    p1.send(`I|${selectEpoch}|0|15`);
    const TOTAL_FRAMES = 10000;
    const t0 = Date.now();
    const BATCH = 3;
    for (let f = 0; f < TOTAL_FRAMES; f++) {
      const mask1 = (f * 7) & 0x3ff;
      const mask2 = (f * 13 + 3) & 0x3ff;
      p1.send(`I|${fightEpoch}|${f}|${mask1}`);
      p2.send(`I|${fightEpoch}|${f}|${mask2}`);
      if (f >= BATCH - 1) {
        const checkF = f - (BATCH - 1);
        const em1 = (checkF * 7) & 0x3ff;
        const em2 = (checkF * 13 + 3) & 0x3ff;
        const exp = `F|${fightEpoch}|${checkF}|${em1}|${em2}`;
        assert.strictEqual(await p1.nextWhere('F|'), exp);
        assert.strictEqual(await p2.nextWhere('F|'), exp);
      }
    }
    for (let checkF = TOTAL_FRAMES - (BATCH - 1); checkF < TOTAL_FRAMES; checkF++) {
      const em1 = (checkF * 7) & 0x3ff;
      const em2 = (checkF * 13 + 3) & 0x3ff;
      const exp = `F|${fightEpoch}|${checkF}|${em1}|${em2}`;
      assert.strictEqual(await p1.nextWhere('F|'), exp);
      assert.strictEqual(await p2.nextWhere('F|'), exp);
    }
    const elapsed = Date.now() - t0;
    const avgMs = (elapsed / TOTAL_FRAMES).toFixed(4);
    assert.strictEqual(srv.rooms.get(roomCode).frames.size, 0, 'Frame map must not leak');
    console.log(`[PASS] 7. 10,000 lockstep frames paired in ${elapsed}ms (${avgMs}ms/frame, 0 leaks)`);

    // 8. Checksum OK & field-level desync alert
    p1.send(`H|${fightEpoch}|30|320,-25,1000,0,1,650,-25,1000,0,1,59`);
    p2.send(`H|${fightEpoch}|30|320,-25,1000,0,1,650,-25,1000,0,1,59`);
    assert.strictEqual(await p1.nextWhere('K|'), `K|${fightEpoch}|30`);
    assert.strictEqual(await p2.nextWhere('K|'), `K|${fightEpoch}|30`);

    p1.send(`H|${fightEpoch}|60|320,-25,950,10,12,650,-25,1000,0,1,58`);
    p2.send(`H|${fightEpoch}|60|320,-25,900,10,12,650,-25,1000,0,1,58`);
    const d1 = await p1.nextWhere('D|');
    const d2 = await p2.nextWhere('D|');
    assert.strictEqual(d1, d2);
    assert(d1.includes('p1.hp: P1=950 vs P2=900'));
    console.log(`[PASS] 8. Checksum OK & field-level desync alert (${d1})`);

    // 9. Match end -> Rematch back to SELECT
    p1.send('E|1');
    p2.send('E|1');
    const rm1 = await p1.nextWhere('M|SELECT|');
    const rm2 = await p2.nextWhere('M|SELECT|');
    assert.strictEqual(rm1, rm2);
    assert(rm1.startsWith(`M|SELECT|${fightEpoch + 1}|`));
    console.log('[PASS] 9. Rematch synchronization verified');

    // 10. Disconnect cleanup
    p2.close();
    assert((await p1.nextWhere('W|')).startsWith('W|PEER_LEFT|'));
    p1.close();
    await new Promise((r) => setTimeout(r, 50));
    assert.strictEqual(srv.rooms.size, 0);
    console.log('[PASS] 10. Disconnect notification & room cleanup verified');

    console.log('\nALL 11 SERVER TESTS PASSED!');
  } finally {
    p1.close();
    p2.close();
    await new Promise((resolve) => srv.close(resolve));
  }
}

runTests().catch((err) => {
  console.error('[FAIL]', err);
  process.exit(1);
});

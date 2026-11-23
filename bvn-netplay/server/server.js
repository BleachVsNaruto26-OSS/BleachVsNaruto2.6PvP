'use strict';

const net = require('net');
const os = require('os');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const DEFAULT_PORT = parseInt(process.env.PORT || '9000', 10);
const MAX_BUFFER_BYTES = 65536;
const ROOM_CHARS = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
const CHECKSUM_FIELDS = [
  'p1.x', 'p1.y', 'p1.hp', 'p1.ql', 'p1.fr',
  'p2.x', 'p2.y', 'p2.hp', 'p2.ql', 'p2.fr',
  'time'
];
const POLICY_RESPONSE =
  '<?xml version="1.0"?>' +
  '<cross-domain-policy>' +
  '<allow-access-from domain="*" to-ports="*" />' +
  '</cross-domain-policy>\0';

function parseCliPort(argv) {
  for (let i = 2; i < argv.length; i++) {
    if ((argv[i] === '--port' || argv[i] === '-p') && argv[i + 1]) {
      const parsed = parseInt(argv[i + 1], 10);
      if (Number.isInteger(parsed) && parsed > 0 && parsed <= 65535) {
        return parsed;
      }
    }
  }
  return DEFAULT_PORT;
}

function clampInt(val, min, max, fallback) {
  const n = parseInt(val, 10);
  if (Number.isNaN(n)) return fallback;
  if (n < min) return min;
  if (n > max) return max;
  return n;
}

function recommendDelayFrames(p1Rtt, p2Rtt) {
  const maxRtt = Math.max(p1Rtt || 0, p2Rtt || 0);
  if (maxRtt < 45) return 2;
  if (maxRtt < 85) return 3;
  if (maxRtt < 120) return 4;
  if (maxRtt < 160) return 5;
  return 6;
}

function formatChecksumDiff(h1, h2) {
  const a = String(h1 || '').split(',');
  const b = String(h2 || '').split(',');
  const diffs = [];
  const len = Math.max(a.length, b.length);
  for (let i = 0; i < len; i++) {
    if (a[i] !== b[i]) {
      const name = CHECKSUM_FIELDS[i] || `f${i}`;
      diffs.push(`${name}: P1=${a[i]} vs P2=${b[i]}`);
    }
  }
  return diffs.length > 0 ? diffs.join(', ') : 'raw mismatch';
}

function randomSeed() {
  return (crypto.randomBytes(4).readUInt32BE(0) & 0x7fffffff) || 123456789;
}

function generateRoomCode(existingRooms) {
  for (let attempt = 0; attempt < 200; attempt++) {
    let code = '';
    for (let i = 0; i < 4; i++) {
      code += ROOM_CHARS[crypto.randomInt(0, ROOM_CHARS.length)];
    }
    if (!existingRooms.has(code)) return code;
  }
  throw new Error('Exhausted room codes');
}

function getLocalIPv4Addresses() {
  const ifaces = os.networkInterfaces();
  const list = [];
  for (const name of Object.keys(ifaces)) {
    for (const info of ifaces[name] || []) {
      if (info.family === 'IPv4' && !info.internal) {
        list.push({ name, address: info.address });
      }
    }
  }
  return list;
}

function createEmptyPicks() {
  return {
    stage: 0, // 0 = Fighter, 1 = Assist, 2 = Map, 3 = Loading
    p1Fighter: '',
    p2Fighter: '',
    p1Fz: '',
    p2Fz: '',
    map: ''
  };
}

function createNetplayServer(options = {}) {
  const logger = options.logger || console;
  const stepDelayMs = options.stepDelayMs === undefined ? 450 : options.stepDelayMs;
  const desyncLogPath = options.desyncLogPath === undefined
    ? path.join(__dirname, 'desync.log')
    : options.desyncLogPath;
  const rooms = new Map();
  const clients = new Set();
  let nextClientId = 1;

  function appendDesyncLog(line) {
    if (!desyncLogPath) return;
    try {
      fs.appendFileSync(desyncLogPath, `[${new Date().toISOString()}] ${line}\n`, 'utf8');
    } catch (_err) {}
  }

  function send(client, msg) {
    if (!client || client.closed || !client.socket || client.socket.destroyed) return;
    try {
      client.socket.write(msg + '\0');
    } catch (_err) {}
  }

  function broadcast(room, msg) {
    if (room.p1) send(room.p1, msg);
    if (room.p2) send(room.p2, msg);
  }

  function clearStepTimer(room) {
    if (room && room.stepTimer) {
      clearTimeout(room.stepTimer);
      room.stepTimer = null;
    }
  }

  function scheduleRoomStep(room, expectedEpoch, fn) {
    clearStepTimer(room);
    if (stepDelayMs <= 0) {
      if (room.epoch === expectedEpoch && room.p1 && room.p2) fn();
      return;
    }
    room.stepTimer = setTimeout(() => {
      room.stepTimer = null;
      if (room.epoch === expectedEpoch && room.p1 && room.p2) fn();
    }, stepDelayMs);
  }

  function broadcastTelemetry(room) {
    if (!room) return;
    const r1 = room.p1 ? room.p1.rttMs : 0;
    const r2 = room.p2 ? room.p2.rttMs : 0;
    const rec = recommendDelayFrames(r1, r2);
    broadcast(room, `T|${r1}|${r2}|${rec}`);
  }

  function resolveEffectiveDelay(room) {
    if (room.delayMode === 0) {
      const r1 = room.p1 ? room.p1.rttMs : 0;
      const r2 = room.p2 ? room.p2.rttMs : 0;
      return recommendDelayFrames(r1, r2);
    }
    return room.delayMode;
  }

  function resetEpochState(room, nextState) {
    clearStepTimer(room);
    room.epoch += 1;
    room.state = nextState;
    room.frames.clear();
    room.checksums.clear();
    room.loaded = { 1: null, 2: null };
    room.ended = { 1: false, 2: false };
    room.desyncCount = 0;
    if (nextState === 'SELECT' || nextState === 'LOBBY_WAIT' || nextState === 'LOBBY_READY') {
      room.picks = createEmptyPicks();
    }
  }

  function leaveRoom(client, reason) {
    const room = client.room;
    if (!room) return;

    const slot = client.slot;
    client.room = null;
    client.slot = 0;

    if (slot === 1 && room.p1 === client) room.p1 = null;
    if (slot === 2 && room.p2 === client) room.p2 = null;

    const peer = slot === 1 ? room.p2 : room.p1;

    if (room.p1 === null && room.p2 === null) {
      clearStepTimer(room);
      rooms.delete(room.code);
      logger.log(`[ROOM ${room.code}] Closed (empty)`);
      return;
    }

    if (peer) {
      if (slot === 1) {
        clearStepTimer(room);
        send(peer, `W|HOST_LEFT|${reason || 'DISCONNECTED'}`);
        peer.room = null;
        peer.slot = 0;
        rooms.delete(room.code);
        logger.log(`[ROOM ${room.code}] Disbanded because P1 left (${reason})`);
      } else {
        resetEpochState(room, 'LOBBY_WAIT');
        send(peer, `W|PEER_LEFT|${reason || 'DISCONNECTED'}`);
        logger.log(`[ROOM ${room.code}] P2 left (${reason}); P1 back to waiting`);
      }
    }
  }

  function handleSelectMessage(client, room, parts) {
    // Client -> Server:
    //   S|<stage:0|1|2>|M|<x>|<y>         (cursor move for client's own slot)
    //   S|<stage:0|1|2>|K|<pickId>        (lock pick for client's own slot)
    if (room.state !== 'SELECT' || !room.p1 || !room.p2) return;
    const stage = parseInt(parts[1], 10);
    const action = parts[2];
    const slot = client.slot;
    const peer = slot === 1 ? room.p2 : room.p1;

    if (stage !== room.picks.stage) return;

    // Business rule: On Map Select (stage 2), ONLY P1 (Host) can move/lock map!
    if (stage === 2 && slot !== 1) return;

    if (action === 'M') {
      const gx = parseInt(parts[3], 10);
      const gy = parseInt(parts[4], 10);
      if (Number.isNaN(gx) || Number.isNaN(gy)) return;
      // Only allow moving if this slot has not locked yet
      if (stage === 0 && ((slot === 1 && room.picks.p1Fighter) || (slot === 2 && room.picks.p2Fighter))) return;
      if (stage === 1 && ((slot === 1 && room.picks.p1Fz) || (slot === 2 && room.picks.p2Fz))) return;
      if (stage === 2 && room.picks.map) return;
      // Relay cursor move to peer tagged with authoritative sender slot
      send(peer, `S|${slot}|${stage}|M|${gx}|${gy}`);
      return;
    }

    if (action === 'K') {
      const pickId = (parts[3] || '').trim();
      if (!pickId) return;

      if (stage === 0) {
        if (slot === 1) {
          if (room.picks.p1Fighter) return;
          room.picks.p1Fighter = pickId;
        } else {
          if (room.picks.p2Fighter) return;
          room.picks.p2Fighter = pickId;
        }
        logger.log(`[ROOM ${room.code}] P${slot} locked Fighter: ${pickId}`);
        send(peer, `S|${slot}|0|K|${pickId}`);

        if (room.picks.p1Fighter && room.picks.p2Fighter) {
          const ep = room.epoch;
          room.picks.stage = 1;
          scheduleRoomStep(room, ep, () => {
            logger.log(`[ROOM ${room.code}] Both fighters locked -> Assist Select (${room.picks.p1Fighter} vs ${room.picks.p2Fighter})`);
            broadcast(room, `S|STEP|1|${room.picks.p1Fighter}|${room.picks.p2Fighter}`);
          });
        }
        return;
      }

      if (stage === 1) {
        // Business rule: Assist cannot be identical to own Fighter
        const ownFighter = slot === 1 ? room.picks.p1Fighter : room.picks.p2Fighter;
        if (pickId === ownFighter) {
          send(client, 'E|DUPLICATE_FZ');
          return;
        }
        if (slot === 1) {
          if (room.picks.p1Fz) return;
          room.picks.p1Fz = pickId;
        } else {
          if (room.picks.p2Fz) return;
          room.picks.p2Fz = pickId;
        }
        logger.log(`[ROOM ${room.code}] P${slot} locked Assist: ${pickId}`);
        send(peer, `S|${slot}|1|K|${pickId}`);

        if (room.picks.p1Fz && room.picks.p2Fz) {
          const ep = room.epoch;
          room.picks.stage = 2;
          scheduleRoomStep(room, ep, () => {
            logger.log(`[ROOM ${room.code}] Both assists locked -> Map Select (${room.picks.p1Fz} / ${room.picks.p2Fz})`);
            broadcast(room, `S|STEP|2|${room.picks.p1Fz}|${room.picks.p2Fz}`);
          });
        }
        return;
      }

      if (stage === 2) {
        if (room.picks.map) return;
        room.picks.map = pickId;
        logger.log(`[ROOM ${room.code}] P1 locked Map: ${pickId}`);
        send(peer, `S|1|2|K|${pickId}`);

        const ep = room.epoch;
        room.picks.stage = 3;
        scheduleRoomStep(room, ep, () => {
          const p = room.picks;
          logger.log(
            `[ROOM ${room.code}] Entering Battle Loading: P1=${p.p1Fighter}(${p.p1Fz}) vs P2=${p.p2Fighter}(${p.p2Fz}) @ ${p.map}`
          );
          broadcast(
            room,
            `S|STEP|3|${p.p1Fighter}|${p.p2Fighter}|${p.p1Fz}|${p.p2Fz}|${p.map}`
          );
        });
      }
    }
  }

  function handleMessage(client, raw) {
    const msg = raw.trim();
    if (!msg) return;

    if (msg.startsWith('<policy-file-request')) {
      try {
        client.socket.write(POLICY_RESPONSE);
      } catch (_err) {}
      return;
    }

    const parts = msg.split('|');
    const cmd = parts[0];

    switch (cmd) {
      case 'P': {
        if (parts[2] !== undefined && parts[2] !== '') {
          const rtt = clampInt(parts[2], 0, 5000, client.rttMs);
          client.rttMs = rtt;
          if (client.room && (client.room.state === 'LOBBY_WAIT' || client.room.state === 'LOBBY_READY')) {
            broadcastTelemetry(client.room);
          }
        }
        send(client, `Q|${parts[1] || '0'}`);
        return;
      }

      case 'C': {
        if (client.room) leaveRoom(client, 'SWITCH_ROOM');
        const ver = parts[1] || '2.6';
        const delayMode = clampInt(parts[2], 0, 6, 0);
        const maxhp = clampInt(parts[3], 500, 5000, 1000);
        const maxtime = clampInt(parts[4], 30, 100, 60);
        const code = generateRoomCode(rooms);

        const room = {
          code,
          ver,
          delayMode,
          effectiveDelay: delayMode === 0 ? 2 : delayMode,
          maxhp,
          maxtime,
          state: 'LOBBY_WAIT',
          epoch: 0,
          seed: 0,
          matchMeta: '',
          picks: createEmptyPicks(),
          stepTimer: null,
          p1: client,
          p2: null,
          frames: new Map(),
          checksums: new Map(),
          loaded: { 1: null, 2: null },
          ended: { 1: false, 2: false },
          desyncCount: 0,
          createdAt: Date.now()
        };

        rooms.set(code, room);
        client.room = room;
        client.slot = 1;

        logger.log(
          `[ROOM ${code}] Created by #${client.id} (${client.addr}) ver=${ver} delayMode=${delayMode === 0 ? 'AUTO' : delayMode} hp=${maxhp} time=${maxtime}`
        );
        send(client, `R|${code}|1|${delayMode}|${maxhp}|${maxtime}`);
        broadcastTelemetry(room);
        return;
      }

      case 'J': {
        if (client.room) leaveRoom(client, 'SWITCH_ROOM');
        const code = (parts[1] || '').toUpperCase().trim();
        const ver = parts[2] || '2.6';
        const room = rooms.get(code);

        if (!room) {
          send(client, 'E|ROOM_NOT_FOUND');
          return;
        }
        if (room.p2 !== null) {
          send(client, 'E|ROOM_FULL');
          return;
        }
        if (room.ver !== ver) {
          send(client, `E|VERSION_MISMATCH|${room.ver}`);
          return;
        }

        room.p2 = client;
        room.state = 'LOBBY_READY';
        client.room = room;
        client.slot = 2;

        logger.log(`[ROOM ${code}] Joined by #${client.id} (${client.addr}) as P2`);
        send(client, `R|${code}|2|${room.delayMode}|${room.maxhp}|${room.maxtime}`);
        send(room.p1, `O|JOINED|${client.addr}`);
        send(room.p2, `O|JOINED|${room.p1.addr}`);
        broadcastTelemetry(room);
        return;
      }

      case 'B': {
        const room = client.room;
        if (!room) {
          send(client, 'E|NOT_IN_ROOM');
          return;
        }
        if (client.slot !== 1) {
          send(client, 'E|HOST_ONLY');
          return;
        }
        if (!room.p2) {
          send(client, 'E|WAIT_P2');
          return;
        }

        if (parts[1] !== undefined && parts[1] !== '') {
          room.delayMode = clampInt(parts[1], 0, 6, room.delayMode);
        }
        if (parts[2] !== undefined && parts[2] !== '') {
          room.maxhp = clampInt(parts[2], 500, 5000, room.maxhp);
        }
        if (parts[3] !== undefined && parts[3] !== '') {
          room.maxtime = clampInt(parts[3], 30, 100, room.maxtime);
        }

        resetEpochState(room, 'SELECT');
        room.seed = randomSeed();
        room.effectiveDelay = resolveEffectiveDelay(room);

        logger.log(
          `[ROOM ${room.code}] -> SELECT epoch=${room.epoch} seed=${room.seed} delay=${room.effectiveDelay} (mode=${room.delayMode === 0 ? 'AUTO' : room.delayMode}) hp=${room.maxhp} time=${room.maxtime}`
        );
        broadcast(
          room,
          `M|SELECT|${room.epoch}|${room.seed}|${room.effectiveDelay}|${room.maxhp}|${room.maxtime}`
        );
        return;
      }

      case 'S': {
        const room = client.room;
        if (!room) return;
        handleSelectMessage(client, room, parts);
        return;
      }

      case 'L': {
        const room = client.room;
        if (!room || !room.p1 || !room.p2) return;

        const sig = parts.slice(1, 6).join('|');
        room.loaded[client.slot] = sig;
        logger.log(`[ROOM ${room.code}] P${client.slot} loaded (${sig})`);

        if (room.loaded[1] !== null && room.loaded[2] !== null) {
          room.matchMeta = room.loaded[1];
          if (room.loaded[1] !== room.loaded[2]) {
            const detail = `PICK_MISMATCH P1=(${room.loaded[1]}) vs P2=(${room.loaded[2]})`;
            logger.warn(`[ROOM ${room.code}] ${detail}`);
            appendDesyncLog(`ROOM=${room.code} ${detail}`);
            broadcast(room, `D|${room.epoch}|0|PICK_MISMATCH`);
          }
          resetEpochState(room, 'FIGHT');
          room.seed = randomSeed();
          room.effectiveDelay = resolveEffectiveDelay(room);
          logger.log(
            `[ROOM ${room.code}] -> FIGHT epoch=${room.epoch} seed=${room.seed} delay=${room.effectiveDelay} picks=(${room.matchMeta})`
          );
          broadcast(
            room,
            `G|${room.epoch}|${room.seed}|${room.effectiveDelay}|${room.maxhp}|${room.maxtime}`
          );
        }
        return;
      }

      case 'I': {
        const room = client.room;
        if (!room || !room.p1 || !room.p2) return;

        const epoch = parseInt(parts[1], 10);
        if (epoch !== room.epoch) return;

        const frame = parseInt(parts[2], 10);
        const mask = parseInt(parts[3], 10) & 0x3ff;
        if (Number.isNaN(frame) || frame < 0) return;

        let entry = room.frames.get(frame);
        if (!entry) {
          entry = { p1: undefined, p2: undefined };
          room.frames.set(frame, entry);
        }

        if (client.slot === 1) entry.p1 = mask;
        else entry.p2 = mask;

        if (entry.p1 !== undefined && entry.p2 !== undefined) {
          room.frames.delete(frame);
          if (room.frames.size > 120) {
            for (const f of room.frames.keys()) {
              if (f < frame - 60) room.frames.delete(f);
            }
          }
          broadcast(room, `F|${epoch}|${frame}|${entry.p1}|${entry.p2}`);
        }
        return;
      }

      case 'H': {
        const room = client.room;
        if (!room || !room.p1 || !room.p2) return;

        const epoch = parseInt(parts[1], 10);
        if (epoch !== room.epoch) return;

        const frame = parseInt(parts[2], 10);
        const hash = parts[3] || '';
        if (Number.isNaN(frame)) return;

        let entry = room.checksums.get(frame);
        if (!entry) {
          entry = { p1: null, p2: null };
          room.checksums.set(frame, entry);
        }
        if (client.slot === 1) entry.p1 = hash;
        else entry.p2 = hash;

        if (entry.p1 !== null && entry.p2 !== null) {
          room.checksums.delete(frame);
          if (entry.p1 !== entry.p2) {
            room.desyncCount += 1;
            const diffStr = formatChecksumDiff(entry.p1, entry.p2);
            const summary =
              `ROOM=${room.code} DESYNC #${room.desyncCount} epoch=${epoch} frame=${frame} ` +
              `picks=(${room.matchMeta}) diff=[${diffStr}]`;
            logger.warn(`[${summary}]`);
            appendDesyncLog(summary);
            broadcast(room, `D|${epoch}|${frame}|${diffStr}`);
          } else {
            broadcast(room, `K|${epoch}|${frame}`);
          }
        }
        return;
      }

      case 'E': {
        const room = client.room;
        if (!room || !room.p1 || !room.p2) return;

        room.ended[client.slot] = true;
        const winner = parts[1] || '0';
        logger.log(`[ROOM ${room.code}] P${client.slot} reported match end (winner=P${winner})`);

        if (room.ended[1] && room.ended[2]) {
          resetEpochState(room, 'SELECT');
          room.seed = randomSeed();
          room.effectiveDelay = resolveEffectiveDelay(room);
          logger.log(
            `[ROOM ${room.code}] Rematch -> SELECT epoch=${room.epoch} seed=${room.seed} delay=${room.effectiveDelay}`
          );
          broadcast(
            room,
            `M|SELECT|${room.epoch}|${room.seed}|${room.effectiveDelay}|${room.maxhp}|${room.maxtime}`
          );
        }
        return;
      }

      case 'X': {
        leaveRoom(client, 'LEFT');
        return;
      }

      default:
        send(client, `E|UNKNOWN_CMD|${cmd}`);
    }
  }

  const server = net.createServer((socket) => {
    socket.setNoDelay(true);
    socket.setKeepAlive(true, 10000);

    const client = {
      id: nextClientId++,
      socket,
      addr: `${socket.remoteAddress}:${socket.remotePort}`,
      room: null,
      slot: 0,
      rttMs: 0,
      buffer: '',
      closed: false
    };
    clients.add(client);
    logger.log(`[CONN] Client #${client.id} connected from ${client.addr}`);

    socket.on('data', (chunk) => {
      client.buffer += chunk.toString('utf8');
      if (client.buffer.length > MAX_BUFFER_BYTES) {
        logger.warn(`[CONN] Client #${client.id} exceeded max buffer, closing`);
        socket.destroy();
        return;
      }

      let sepIdx;
      while ((sepIdx = client.buffer.indexOf('\0')) !== -1) {
        const frame = client.buffer.slice(0, sepIdx);
        client.buffer = client.buffer.slice(sepIdx + 1);
        handleMessage(client, frame);
      }
    });

    const onDisconnect = (reason) => {
      if (client.closed) return;
      client.closed = true;
      clients.delete(client);
      leaveRoom(client, reason);
      logger.log(`[CONN] Client #${client.id} disconnected (${reason})`);
    };

    socket.on('close', () => onDisconnect('CLOSED'));
    socket.on('error', (err) => onDisconnect(err.code || 'ERROR'));
  });

  let policyServer = null;
  function startPolicyServer() {
    if (options.disablePolicyPort843) return;
    policyServer = net.createServer((socket) => {
      socket.on('data', (chunk) => {
        if (chunk.toString('utf8').includes('policy-file-request')) {
          socket.end(POLICY_RESPONSE);
        }
      });
      socket.on('error', () => {});
    });
    policyServer.on('error', () => {
      policyServer = null;
    });
    policyServer.listen(843, '0.0.0.0');
  }

  return {
    server,
    rooms,
    clients,
    listen(port, host = '0.0.0.0', cb) {
      startPolicyServer();
      return server.listen(port, host, cb);
    },
    close(cb) {
      for (const r of rooms.values()) {
        clearStepTimer(r);
      }
      for (const c of clients) {
        try {
          c.socket.destroy();
        } catch (_err) {}
      }
      if (policyServer) {
        try {
          policyServer.close();
        } catch (_err) {}
      }
      server.close(cb);
    }
  };
}

if (require.main === module) {
  const port = parseCliPort(process.argv);
  const instance = createNetplayServer();
  instance.listen(port, '0.0.0.0', () => {
    console.log('====================================================');
    console.log('  BVN 2.6 NETPLAY RELAY SERVER (TCP / XMLSocket)');
    console.log('====================================================');
    console.log(`  Port: ${port} (TCP_NODELAY enabled)`);
    console.log('  Localhost (test 2 cua so tren 1 PC): 127.0.0.1');
    const ips = getLocalIPv4Addresses();
    if (ips.length > 0) {
      console.log('  Dia chi LAN / VPN ao (dua cho ban choi):');
      for (const item of ips) {
        console.log(`    - ${item.address}  (${item.name})`);
      }
    }
    console.log('  Desync diagnostic log: server/desync.log');
    console.log('====================================================');
    console.log('  Nhan Ctrl+C de tat server.');
  });
}

module.exports = { createNetplayServer, recommendDelayFrames, formatChecksumDiff };

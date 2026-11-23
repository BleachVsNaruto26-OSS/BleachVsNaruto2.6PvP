'use strict';

const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

const GAME_DIR = path.resolve(__dirname, '..', '..', 'bvn2.6sieuvip', 'bvn2.6sieuvip');
const FIGHTER_DIR = path.join(GAME_DIR, 'fighter');
const FZ_DIR = path.join(FIGHTER_DIR, 'fz');

function inspectSwf(filePath) {
  const raw = fs.readFileSync(filePath);
  const sig = raw.slice(0, 3).toString('ascii');
  const ver = raw[3];
  let body = raw.slice(8);
  if (sig === 'CWS') {
    body = zlib.inflateSync(body);
  }
  const text = body.toString('latin1');

  const has = (token) => new RegExp(`\\b${token}\\b`).test(text);
  const count = (token) => (text.match(new RegExp(`\\b${token}\\b`, 'g')) || []).length;

  return {
    file: path.basename(filePath),
    sig,
    ver,
    kb: Math.round(raw.length / 1024),
    isDown: count('isDown'),
    keyListener: count('addListener') + count('getCode'),
    zhanting: count('zhanting'),
    onEnterFrameHook: has('on_enterframe'),
    setInterval: count('setInterval'),
    setTimeout: count('setTimeout'),
    getTimer: count('getTimer'),
    localConn: has('LocalConnection') || has('XMLSocket')
  };
}

function runAudit() {
  const fighters = fs.readdirSync(FIGHTER_DIR)
    .filter((f) => f.toLowerCase().endsWith('.swf'))
    .sort()
    .map((f) => inspectSwf(path.join(FIGHTER_DIR, f)));

  const assists = fs.readdirSync(FZ_DIR)
    .filter((f) => f.toLowerCase().endsWith('.swf'))
    .sort()
    .map((f) => inspectSwf(path.join(FZ_DIR, f)));

  console.log('=== PHASE 4 COMPATIBILITY AUDIT: 36 FIGHTERS ===');
  let fighterIssues = 0;
  for (const r of fighters) {
    const flags = [];
    if (r.isDown === 0) flags.push('NO_ISDOWN');
    if (r.keyListener > 0) flags.push(`KEY_LISTENER(${r.keyListener})`);
    if (r.zhanting === 0) flags.push('NO_ZHANTING');
    if (!r.onEnterFrameHook) flags.push('NO_ON_ENTERFRAME');
    if (r.localConn) flags.push('NET_API');
    if (flags.length > 0) fighterIssues++;
    console.log(
      `${r.file.padEnd(18)} v${String(r.ver).padEnd(2)} ${String(r.kb).padStart(4)}KB | ` +
      `isDown=${r.isDown} zhanting=${String(r.zhanting).padStart(2)} ` +
      `intv=${r.setInterval} tout=${r.setTimeout} on_ef=${r.onEnterFrameHook ? 'Y' : 'N'} | ` +
      `${flags.length ? 'WARN: ' + flags.join(',') : 'OK'}`
    );
  }

  console.log('\n=== PHASE 4 COMPATIBILITY AUDIT: 27 ASSISTS (fz/) ===');
  let assistIssues = 0;
  for (const r of assists) {
    const flags = [];
    if (r.keyListener > 0) flags.push(`KEY_LISTENER(${r.keyListener})`);
    if (r.zhanting === 0) flags.push('NO_ZHANTING');
    if (r.ver > 10) flags.push(`SWF_V${r.ver}`);
    if (r.localConn) flags.push('NET_API');
    if (flags.length > 0) assistIssues++;
    console.log(
      `${r.file.padEnd(18)} v${String(r.ver).padEnd(2)} ${String(r.kb).padStart(4)}KB | ` +
      `zhanting=${String(r.zhanting).padStart(2)} intv=${r.setInterval} tout=${r.setTimeout} | ` +
      `${flags.length ? 'NOTE: ' + flags.join(',') : 'OK'}`
    );
  }

  console.log('\n=== SUMMARY ===');
  console.log(`Fighters scanned: ${fighters.length} (warnings: ${fighterIssues})`);
  console.log(`Assists scanned : ${assists.length} (notes: ${assistIssues})`);
}

runAudit();

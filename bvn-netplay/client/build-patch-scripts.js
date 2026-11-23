'use strict';

const fs = require('fs');
const path = require('path');

const SRC_SCRIPTS = path.resolve(__dirname, '..', '..', 'scripts');
const OUT_SCRIPTS = path.resolve(__dirname, 'patch_scripts');
const NETPLAY_MOD = path.resolve(__dirname, 'netplay_module.as');

function readUtf8(p) {
  return fs.readFileSync(p, 'utf8');
}

function writeOut(relPath, content) {
  const dest = path.join(OUT_SCRIPTS, relPath);
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  fs.writeFileSync(dest, content, 'utf8');
  console.log('[GEN]', relPath);
}

function replaceOnce(text, target, replacement, label) {
  const normalizedTarget = target.replace(/\r\n/g, '\n');
  const usesCrlf = text.includes('\r\n');
  const norm = text.replace(/\r\n/g, '\n');
  const idx = norm.indexOf(normalizedTarget);
  if (idx === -1) {
    throw new Error(`Target snippet not found in ${label}:\n${target}`);
  }
  const secondIdx = norm.indexOf(normalizedTarget, idx + normalizedTarget.length);
  if (secondIdx !== -1) {
    throw new Error(`Target snippet matched multiple times in ${label}`);
  }
  const replaced =
    norm.slice(0, idx) +
    replacement.replace(/\r\n/g, '\n') +
    norm.slice(idx + normalizedTarget.length);
  return usesCrlf ? replaced.replace(/\n/g, '\r\n') : replaced;
}

// 1. frame_1/DoAction.as -> Clicking "More Games" opens Online 2P Lobby
{
  const rel = path.join('frame_1', 'DoAction.as');
  let code = readUtf8(path.join(SRC_SCRIPTS, rel));
  code = replaceOnce(
    code,
    'function showCommt()\n{\n',
    'function showCommt()\n{\n   if(_root.Net != undefined)\n   {\n      _root.Net.openLobby();\n      return undefined;\n   }\n',
    rel
  );
  writeOut(rel, code);
}

// 2. frame_8/DoAction.as -> Disable local pause menu during Online + append full NetPlay module
{
  const rel = path.join('frame_8', 'DoAction.as');
  let code = readUtf8(path.join(SRC_SCRIPTS, rel));
  code = replaceOnce(
    code,
    'function setMenuEnable(v)\n{\n   _menuEnabled = v;',
    'function setMenuEnable(v)\n{\n   if(_root.Net != undefined && _root.Net.active)\n   {\n      v = false;\n   }\n   _menuEnabled = v;',
    rel
  );
  const netMod = readUtf8(NETPLAY_MOD);
  code = code.trimEnd() + '\r\n\r\n' + netMod.replace(/\r?\n/g, '\r\n');
  writeOut(rel, code);
}

// 3. DefineSprite_620 (Main Menu) -> Block background menu scrolling while Online Lobby popup is open
{
  const rel = path.join(
    'DefineSprite_620',
    'frame_1',
    'PlaceObject2_619_28',
    'CLIPACTIONRECORD onClipEvent(enterFrame).as'
  );
  let code = readUtf8(path.join(SRC_SCRIPTS, rel));
  code = replaceOnce(
    code,
    'onClipEvent(enterFrame){\n   if(an == 0)',
    'onClipEvent(enterFrame){\n   if(_root.Net != undefined && (_root.Net.lobbyOpen || _root.Net.active))\n   {\n      return undefined;\n   }\n   if(an == 0)',
    rel
  );
  writeOut(rel, code);
}

// 4. DefineSprite_1477 / 1480 / 1505 (Fighter / Assist / Map Select)
// Strict per-slot ownership + real-time cursor/lock sync via Server (no cross-player control!)
for (const [spriteId, stageNum] of [
  ['DefineSprite_1477', 0],
  ['DefineSprite_1480', 1],
  ['DefineSprite_1505', 2]
]) {
  const rel = path.join(spriteId, 'frame_1', 'DoAction.as');
  let code = readUtf8(path.join(SRC_SCRIPTS, rel));

  // Add __initializing guard around init() + notify Net.onSelectMounted at end of init()
  code = replaceOnce(
    code,
    'function init(type)\n{\n   isFighter = type == 0;\n   isFZ = type == 1;\n   isMap = type == 2;\n   if(isMap)\n   {\n      updateXY(1,1,0);\n      return undefined;\n   }',
    'function init(type)\n{\n   _this.__initializing = true;\n   isFighter = type == 0;\n   isFZ = type == 1;\n   isMap = type == 2;\n   if(isMap)\n   {\n      updateXY(1,1,0);\n      _this.__initializing = false;\n      if(_root.Net != undefined && _root.Net.active)\n      {\n         _root.Net.onSelectMounted(_this,2);\n      }\n      return undefined;\n   }',
    rel
  );
  code = replaceOnce(
    code,
    '   if(p2enable)\n   {\n      showP2();\n   }\n}',
    '   if(p2enable)\n   {\n      showP2();\n   }\n   _this.__initializing = false;\n   if(_root.Net != undefined && _root.Net.active)\n   {\n      _root.Net.onSelectMounted(_this,type);\n   }\n}',
    rel
  );

  // Add online local-only caozuo helper + strict slot check on updateXY
  code = replaceOnce(
    code,
    'function updateXY(player, x, y)\n{\n   var _loc5_;\n   if(_grid[y][x])\n   {\n      if(isFZ)\n      {\n         _loc5_ = _grid[y][x];\n         if(_root["p" + player + "selt"] == _loc5_._name)\n         {\n            return false;\n         }\n      }\n      trace(x + "," + y);\n      _this["_p" + player + "selt"] = _grid[y][x];\n      _this["curx" + player] = x;\n      _this["cury" + player] = y;\n      updateSelect(player);\n      return true;\n   }\n   return false;\n}',
    'function updateXY(player, x, y)\n{\n   var _loc5_;\n   if(_grid[y][x])\n   {\n      if(isFZ)\n      {\n         _loc5_ = _grid[y][x];\n         if(_root["p" + player + "selt"] == _loc5_._name)\n         {\n            return false;\n         }\n      }\n      trace(x + "," + y);\n      _this["_p" + player + "selt"] = _grid[y][x];\n      _this["curx" + player] = x;\n      _this["cury" + player] = y;\n      updateSelect(player);\n      if(_root.Net != undefined && _root.Net.active && !_this.__initializing && !_this.__remoteCall)\n      {\n         var stgN = isMap ? 2 : (isFZ ? 1 : 0);\n         _root.Net.sendSelectMove(stgN,x,y);\n      }\n      return true;\n   }\n   return false;\n}\nfunction caozuoOnline(player)\n{\n   if(_this["czint" + player] == undefined)\n   {\n      _this["czint" + player] = 10;\n   }\n   _this["czint" + player]++;\n   if(_this["czint" + player] < 5)\n   {\n      return undefined;\n   }\n   if(_root.Net.isLocalKeyIndexDown(2))\n   {\n      _this["czint" + player] = 0;\n      left(player);\n      _root.keysound1.start();\n   }\n   if(_root.Net.isLocalKeyIndexDown(3))\n   {\n      _this["czint" + player] = 0;\n      right(player);\n      _root.keysound1.start();\n   }\n   if(_root.Net.isLocalKeyIndexDown(0))\n   {\n      _this["czint" + player] = 0;\n      up(player);\n      _root.keysound1.start();\n   }\n   if(_root.Net.isLocalKeyIndexDown(1))\n   {\n      _this["czint" + player] = 0;\n      down(player);\n      _root.keysound1.start();\n   }\n   if(_root.Net.isLocalKeyIndexDown(4))\n   {\n      _this["czint" + player] = 0;\n      var stgN = isMap ? 2 : (isFZ ? 1 : 0);\n      var pickId = "";\n      if(isMap)\n      {\n         pickId = _root.curStage;\n      }\n      else if(isFZ)\n      {\n         pickId = _root["p" + player + "sf"];\n         if(_root["p" + player + "selt"] == pickId)\n         {\n            if(player == 1) { _root.txt = "不能重复选择"; _root.txtst = 0; }\n            else { _root.txt2 = "不能重复选择"; _root.txtst2 = 0; }\n            return undefined;\n         }\n      }\n      else\n      {\n         pickId = _root["p" + player + "selt"];\n      }\n      if(pickId == "" || pickId == undefined)\n      {\n         return undefined;\n      }\n      _root.keysound2.start();\n      if(_this["player" + player] != undefined)\n      {\n         _this["player" + player].gotoAndPlay(2);\n      }\n      _this["p" + player + "enable"] = false;\n      _root.Net.sendSelectLock(stgN,pickId);\n   }\n}',
    rel
  );

  // Replace onEnterFrame so online mode STRICTLY isolates each player to their own slot!
  code = replaceOnce(
    code,
    'onEnterFrame = function()\n{\n   if(p1enable)\n   {\n      caozuo(1,_root.a,_root.d,_root.w,_root.s,_root.j,_root.k);\n   }\n   if(p2enable)\n   {\n      if(_root.modo == 2 or _root.modo == 4)\n      {\n         caozuo(2,_root.a,_root.d,_root.w,_root.s,_root.j,_root.k);\n      }\n      else\n      {\n         caozuo(2,_root.左箭,_root.右箭,_root.上箭,_root.下箭,_root.N1,_root.N2);\n      }\n   }\n};',
    'onEnterFrame = function()\n{\n   if(_root.Net != undefined && _root.Net.active)\n   {\n      if(isMap)\n      {\n         if(_root.Net.slot == 1 && p1enable)\n         {\n            caozuoOnline(1);\n         }\n      }\n      else if(_root.Net.slot == 1 && p1enable)\n      {\n         caozuoOnline(1);\n      }\n      else if(_root.Net.slot == 2 && p2enable)\n      {\n         caozuoOnline(2);\n      }\n      return undefined;\n   }\n   if(p1enable)\n   {\n      caozuo(1,_root.a,_root.d,_root.w,_root.s,_root.j,_root.k);\n   }\n   if(p2enable)\n   {\n      if(_root.modo == 2 or _root.modo == 4)\n      {\n         caozuo(2,_root.a,_root.d,_root.w,_root.s,_root.j,_root.k);\n      }\n      else\n      {\n         caozuo(2,_root.左箭,_root.右箭,_root.上箭,_root.下箭,_root.N1,_root.N2);\n      }\n   }\n};',
    rel
  );

  writeOut(rel, code);
}

// 5. DefineSprite_1814/frame_1/DoAction.as (HP/Qi bar: prevent ql += 0.2 while stalled)
{
  const rel = path.join('DefineSprite_1814', 'frame_1', 'DoAction.as');
  let code = readUtf8(path.join(SRC_SCRIPTS, rel));
  code = replaceOnce(
    code,
    'onEnterFrame = function()\n{\n   p1hp = _root.game.p1.mc.hp / _root.maxhp * 100;',
    'onEnterFrame = function()\n{\n   if(_root.Net != undefined && _root.Net.stalled)\n   {\n      return undefined;\n   }\n   p1hp = _root.game.p1.mc.hp / _root.maxhp * 100;',
    rel
  );
  writeOut(rel, code);
}

// 6. DefineSprite_1848/frame_350/DoAction.as & DefineSprite_1858/frame_394/DoAction.as (Match End -> Rematch)
for (const rel of [
  path.join('DefineSprite_1848', 'frame_350', 'DoAction.as'),
  path.join('DefineSprite_1858', 'frame_394', 'DoAction.as')
]) {
  let code = readUtf8(path.join(SRC_SCRIPTS, rel));
  code = replaceOnce(
    code,
    '   if(_root.modo == 2 or _root.modo == 3)\n   {\n      _root.clearint();\n      _root.gotoAndStop("选人画面");\n   }\n}\nelse if(_root.p2ws == 3)\n{\n   if(_root.modo == 1)\n   {\n      _root.clearint();\n      _root.gotoAndStop("继续");\n   }\n   if(_root.modo == 2 or _root.modo == 3)\n   {\n      _root.clearint();\n      _root.gotoAndStop("选人画面");\n   }\n}',
    '   if(_root.modo == 2 or _root.modo == 3)\n   {\n      _root.clearint();\n      if(_root.Net != undefined && _root.Net.active)\n      {\n         _root.Net.onMatchFinished(1);\n      }\n      else\n      {\n         _root.gotoAndStop("选人画面");\n      }\n   }\n}\nelse if(_root.p2ws == 3)\n{\n   if(_root.modo == 1)\n   {\n      _root.clearint();\n      _root.gotoAndStop("继续");\n   }\n   if(_root.modo == 2 or _root.modo == 3)\n   {\n      _root.clearint();\n      if(_root.Net != undefined && _root.Net.active)\n      {\n         _root.Net.onMatchFinished(2);\n      }\n      else\n      {\n         _root.gotoAndStop("选人画面");\n      }\n   }\n}',
    rel
  );
  writeOut(rel, code);
}

// 7. DefineSprite_1989/frame_1/DoAction.as (Save loading MC reference)
{
  const rel = path.join('DefineSprite_1989', 'frame_1', 'DoAction.as');
  let code = readUtf8(path.join(SRC_SCRIPTS, rel));
  code = replaceOnce(
    code,
    '_root.loadingGame = true;',
    '_root.loadingGame = true;\n_root.__loadingMC = this;',
    rel
  );
  writeOut(rel, code);
}

// 8. DefineSprite_1900/frame_10/DoAction.as (Signal server when SWFs loaded)
{
  const rel = path.join('DefineSprite_1900', 'frame_10', 'DoAction.as');
  let code = readUtf8(path.join(SRC_SCRIPTS, rel));
  code = replaceOnce(
    code,
    'if(playComplete)\n{\n   startGame();\n}',
    'if(_root.Net != undefined && _root.Net.active)\n{\n   _root.Net.onAssetsLoaded();\n}\nelse if(playComplete)\n{\n   startGame();\n}',
    rel
  );
  writeOut(rel, code);
}

// 9. DefineSprite_1991/frame_1/DoAction.as (Guard camera/wall loop during stall + synced renderSkip)
{
  const rel = path.join('DefineSprite_1991', 'frame_1', 'DoAction.as');
  let code = readUtf8(path.join(SRC_SCRIPTS, rel));
  code = replaceOnce(
    code,
    '      if(Key.isDown(_root.j) || Key.isDown(_root.N1))',
    '      var skipHit = (_root.Net != undefined && _root.Net.active) ? (_root.Net.isKeyDown(_root.j) || _root.Net.isKeyDown(_root.N1)) : (Key.isDown(_root.j) || Key.isDown(_root.N1));\n      if(skipHit)',
    rel
  );
  code = replaceOnce(
    code,
    'onEnterFrame = function()\n{\n   renderSkip();',
    'onEnterFrame = function()\n{\n   if(_root.Net != undefined && _root.Net.stalled)\n   {\n      return undefined;\n   }\n   renderSkip();',
    rel
  );
  writeOut(rel, code);
}

console.log('\nDone! Generated 12 patched AS2 files in:', OUT_SCRIPTS);

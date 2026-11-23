function yfgj(nam)
{
   var _loc3_ = _root.game[nam + "fz"];
   var _loc2_ = _root.game[nam];
   var _loc6_ = nam != "p1" ? _root.game.p1 : _root.game.p2;
   _loc3_.attacking = true;
   var _loc5_ = _loc2_._x >= _loc6_._x ? -1 : 1;
   _loc3_._x = _loc2_._x - 20 * (_loc2_._xscale <= 0 ? -1 : 1);
   _loc3_._y = _loc2_._y;
   _loc3_._xscale = _loc5_ * 100;
   _root.game[nam + "fz"].gotoAndPlay(2);
}
function removeFZ(mc)
{
   mc.attacking = false;
   mc.动作 = 0;
   fzccXg(mc);
   mc.stop();
}
function gostg(stg)
{
   var _loc5_ = _root.getFighterData(_root.p1selt);
   var _loc6_ = _loc5_.isNaruto;
   var _loc3_ = _root.bleachStages;
   var _loc8_;
   var _loc9_;
   if(stg < _loc3_.length)
   {
      if(_loc6_)
      {
         _loc3_ = _root.narutoStages;
      }
      _root.p2selt = _loc3_[stg];
   }
   else if(stg == _root.totalstage)
   {
      _root.p2selt = _root.bossStage;
   }
   else if(_loc5_.vs)
   {
      _loc8_ = _loc5_.vs;
      _root.p2selt = _loc8_[stg - _loc3_.length];
   }
   else
   {
      _loc9_ = !_loc6_ ? narutoElseStages : bleachElseStages;
      _root.p2selt = _loc9_[stg - _loc3_.length];
   }
   var _loc2_ = _root.getFighterData(_root.p2selt);
   _root.p2sf = _loc2_.fz;
   _root.curStage = _loc2_.map;
   var _loc7_;
   if(_loc2_.map)
   {
      _root.curStage = _loc2_.map;
   }
   else
   {
      _loc7_ = !_loc2_.isNaruto ? bleachStageMaps : narutoStageMaps;
      _root.curStage = _loc7_[stg];
   }
}
function onPassStg()
{
   _root.stage += 1;
   if(_root.stage >= _root.totalstage)
   {
      _root.gotoAndStop("congratution");
      return undefined;
   }
   if(_root.stages2.length < 1 && _root.bossStages.length < 1)
   {
      _root.gotoAndStop("congratution");
   }
   gostg(_root.stage);
}
function getRandInArray(a, remove, beside)
{
   var _loc2_ = Math.floor(Math.random() * a.length);
   var _loc3_ = a[_loc2_];
   if(_loc3_ == beside)
   {
      return getRandInArray(a,remove,beside);
   }
   if(remove)
   {
      a.splice(_loc2_,1);
   }
   return _loc3_;
}
function getRandInObject(o)
{
   for(var _loc2_ in o)
   {
      return o[_loc2_];
      break;
   }
   return undefined;
}
function shine(color)
{
   if(isNaN(color))
   {
      color = 16777215;
   }
   _root.shinemc.gotoAndStop("colors");
   var _loc2_ = _root.shinemc.cmc;
   var _loc4_ = new Color(_loc2_);
   _loc4_.setRGB(color);
   _loc2_.gotoAndPlay(2);
}
function debug(txt)
{
   if(!_root.debugtxt)
   {
      return undefined;
   }
   _root.debugtxt.text += txt + "\n";
}
function touchFloorEffect(selfmc)
{
   addChildXG(selfmc,"XG_hitfloor",0,0);
}
function array_indexOf(array, val)
{
   var _loc1_ = 0;
   while(_loc1_ < array.length)
   {
      if(array[_loc1_] == val)
      {
         return _loc1_;
      }
      _loc1_ = _loc1_ + 1;
   }
   return -1;
}
function showFace(pn, frame)
{
   var _loc2_ = _root.ts_face;
   var _loc4_ = _loc2_.bg;
   var _loc6_ = _loc2_.face_p1;
   var _loc5_ = _loc2_.face_p2;
   trace("showFace: " + pn + " , " + frame);
   if(_loc4_._currentframe == 1)
   {
      _loc4_.gotoAndPlay("in");
   }
   var _loc3_ = pn != 2 ? _loc5_ : _loc6_;
   _loc3_.face.gotoAndStop(frame);
   _loc3_.gotoAndPlay("in");
}
function hideFace(pn)
{
   var _loc2_ = _root.ts_face;
   var _loc3_ = _loc2_.bg;
   var _loc5_ = _loc2_.face_p1;
   var _loc4_ = _loc2_.face_p2;
   _loc3_.gotoAndStop(1);
   _loc5_.gotoAndStop(1);
   _loc4_.gotoAndStop(1);
}
function bsd(pn, xg, fz)
{
   _root.zhanting = true;
   shine();
   blackStg();
   if(pn != 1 && pn != 2)
   {
      return undefined;
   }
   var _loc4_ = pn != 1 ? 1 : 2;
   var _loc6_ = _root.game["p" + _loc4_];
   var _loc9_ = _root.game["p" + pn];
   var _loc5_ = _loc6_.mc;
   var _loc8_ = _loc9_.mc;
   var _loc3_ = _root.game["p" + _loc4_ + "fz"];
   var _loc10_ = _root.game["p" + pn + "fz"];
   if(xg == undefined)
   {
      xg = "XG_bs";
   }
   if(fz)
   {
      _loc3_.bs = 1;
      stopMc(_loc5_);
      addChildXG(_loc3_,xg);
   }
   else
   {
      _loc5_.bs = 1;
      stopMc(_loc3_);
      addChildXG(_loc6_,xg);
   }
   stopMc(_loc8_);
   stopMc(_loc10_);
}
function stopMc(mc)
{
   if(mc.hited == 0 && mc.bs == 0 && mc.sw === false)
   {
      mc.stop();
   }
}
function playMc(mc)
{
   if(_root.gamePaused)
   {
      return undefined;
   }
   if(mc.attacking === false)
   {
      return undefined;
   }
   if(mc.hited == 0 && mc.sw === false)
   {
      mc.play();
   }
}
function bsw(pn, fz)
{
   var _loc5_ = pn != 1 ? 1 : 2;
   var _loc9_ = _root.game["p" + _loc5_];
   var _loc8_ = _root.game["p" + pn];
   var _loc2_ = _loc9_.mc;
   var _loc3_ = _loc8_.mc;
   var _loc4_ = _root.game["p" + _loc5_ + "fz"];
   var _loc7_ = _root.game["p" + pn + "fz"];
   trace("_root.gamePaused :" + _root.gamePaused + "\n" + "targetMC.bs:" + _loc3_.bs + "\n" + "targetFZ.bs:" + _loc7_.bs + "\n" + "selfMC.bs:" + _loc2_.bs + "\n" + "selfFZ.bs:" + _loc4_.bs);
   if(fz)
   {
      _loc4_.bs = 0;
      playMc(_loc2_);
   }
   else
   {
      _loc2_.bs = 0;
      if(_root.gamePaused || _loc3_.bs == 1)
      {
         stopMc(_loc2_);
         return undefined;
      }
      playMc(_loc4_);
   }
   playMc(_loc3_);
   playMc(_loc7_);
   hideFace(pn);
   resumeBlackStg();
   _root.zhanting = false;
}
function blackStg(frame)
{
   if(frame == undefined)
   {
      frame = 2;
   }
   _root.game.bgmc._visible = _root.game.fgmc._visible = false;
   _root.blackMu.gotoAndStop(frame);
}
function resumeBlackStg()
{
   _root.game.bgmc._visible = _root.game.fgmc._visible = true;
   _root.blackMu.gotoAndStop(1);
}
function cbsd(pn)
{
   bsd(pn,"XG_cbs");
   _root.焦点 = pn != 2 ? "p2" : "p1";
}
function cbsw(pn)
{
   _root.焦点 = "all";
   bsw(pn);
}
function BG_Black(isshow)
{
   if(isshow == true)
   {
      heimu._visible = true;
   }
   else
   {
      heimu._visible = false;
   }
}
function initGameStart()
{
   _root.xuntiaoInitlize();
}
function startGame()
{
   _root.chushi();
   _root.p2loaded = true;
   _root.stageSound.start(0,999);
   _root.stageSound.setVolume(80);
}
function fadinXuetiao()
{
   _root.xuetiao.gotoAndPlay("in");
}
function fadoutXuetiao()
{
   _root.xuetiao.gotoAndPlay("out");
}
function bdxg(selfmc)
{
   var _loc2_;
   var _loc3_;
   switch(selfmc.bdzl)
   {
      case 1:
         addChildXG(selfmc._parent,"XG_kan");
         break;
      case 2:
         addChildXG(selfmc._parent,"XG_qdj");
         break;
      case 3:
         addChildXG(selfmc._parent,"XG_qdjx");
         break;
      case 4:
         addChildXG(selfmc._parent,"XG_mfdj");
         break;
      case 5:
         addChildXG(selfmc._parent,"XG_mfdjx");
         break;
      case 6:
         addChildXG(selfmc._parent,"XG_kanx");
         break;
      case 7:
         selfmc._parent.setColor([{rb:255,gb:25,bb:-255},{rb:255,gb:86,bb:-255}]);
         addChildXG(selfmc._parent,"XG_fire");
         break;
      case 8:
         selfmc._parent.setColor([{rb:0,gb:153,bb:255},{rb:0,gb:198,bb:255}]);
         addChildXG(selfmc._parent,"XG_ice");
         break;
      case 9:
         selfmc._parent.setColor([{rb:71,gb:91,bb:255},{rb:178,gb:142,bb:255}]);
         addChildXG(selfmc._parent,"XG_leidian");
         break;
      case 10:
         _loc2_ = new Array();
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0,0,0,1,0]);
         _loc3_ = new flash.filters.ColorMatrixFilter(_loc2_);
         selfmc.filters = [_loc3_];
         addChildXG(selfmc._parent,"XG_stone");
      default:
         return;
   }
}
function bdfyxg(selfmc)
{
   switch(selfmc.bdzl)
   {
      case 1:
         addChildXG(selfmc._parent,"XG_fykan");
         break;
      case 6:
         addChildXG(selfmc._parent,"XG_fykanx");
         break;
      case 2:
         addChildXG(selfmc._parent,"XG_fyq");
         break;
      case 3:
         addChildXG(selfmc._parent,"XG_fyqx");
         break;
      case 4:
         addChildXG(selfmc._parent,"XG_mffy");
         break;
      case 5:
      case 7:
      case 8:
      case 9:
      case 10:
         addChildXG(selfmc._parent,"XG_mffyx");
      default:
         return;
   }
}
function bdfyxg2(selfmc)
{
   switch(selfmc.bdzl)
   {
      case 1:
      case 2:
         addChildXG(selfmc._parent,"XG_fyq");
         break;
      case 3:
      case 6:
         addChildXG(selfmc._parent,"XG_fyqx");
         break;
      case 4:
         addChildXG(selfmc._parent,"XG_mffy");
         break;
      case 5:
      case 7:
      case 8:
      case 9:
      case 10:
         addChildXG(selfmc._parent,"XG_mffyx");
      default:
         return;
   }
}
function shunbuxg(player)
{
   addChildXG(player,"XG_rush",0,0);
}
function jumpxg(player)
{
   addChildXG(player,"XG_jump",0,0);
}
function luodixg(player)
{
   addChildXG(player,"XG_luodi",0,0);
}
function fzccXg(fz)
{
   addChildXG(fz,"XG_fzcc",0,0);
}
function addChildXG(playermc, xgclass, offsetY, offsetX)
{
   if(xgclass == "" || xgclass == undefined)
   {
      return undefined;
   }
   var _loc2_ = _root.game.layer_effect.getNextHighestDepth();
   _root.game.layer_effect.attachMovie(xgclass,"xgmc" + _loc2_,_loc2_);
   var _loc3_ = _root.game.layer_effect["xgmc" + _loc2_];
   if(offsetX == undefined)
   {
      offsetX = 0;
   }
   if(offsetY == undefined)
   {
      offsetY = -25;
   }
   _loc3_._x = playermc._x + offsetX;
   _loc3_._y = playermc._y + offsetY;
   _loc3_._xscale = playermc._xscale;
}
function addStgHit(pn, xgmc, hitObj)
{
   stgi++;
   var _loc2_;
   var _loc4_ = pn != 1 ? 1 : 2;
   var _loc5_ = _root.game.layer_effect.getNextHighestDepth();
   var _loc6_ = "stgk" + stgi + "_P" + _loc4_;
   var _loc3_ = _root.game["p" + _loc4_];
   _loc2_ = _root.game.layer_effect.attachMovie(xgmc,_loc6_,_loc5_);
   _loc2_.hitObj = hitObj;
   _loc2_._x = _loc3_._x;
   _loc2_._y = _loc3_._y;
   _loc2_._xscale = _loc3_._xscale;
   if(stgi > 10)
   {
      stgi = 1;
   }
}
function setMenuEnable(v)
{
   if(_root.Net != undefined && _root.Net.active)
   {
      v = false;
   }
   _menuEnabled = v;
   if(!v)
   {
      if(_root.game_menu)
      {
         _root.game_menu._visible = false;
      }
   }
}
function startFight()
{
   _root.zhanting = false;
   _root.readying = false;
   _root.setMenuEnable(true);
}
function KOplay(pn)
{
   _root.KO.play();
   var _loc2_ = pn != 1 ? "p1" : "p2";
   _root.焦点 = _loc2_;
   blackStg("KO");
}
function KOstart()
{
   koPause = true;
   setMenuEnable(false);
   pauseGame();
}
function KOend()
{
   resumeBlackStg();
   koPause = false;
   resumeGame2();
}
function pauseGame2()
{
   pauseGame();
   _root.gamePaused = true;
}
function resumeGame2()
{
   _root.gamePaused = false;
   resumeGame();
}
function pauseGame()
{
   if(_root.gamePaused)
   {
      return undefined;
   }
   _root.zhanting = true;
   stopMc(_root.game.p1.mc);
   stopMc(_root.game.p2.mc);
   stopMc(_root.game.p1fz);
   stopMc(_root.game.p2fz);
}
function resumeGame()
{
   if(koPause)
   {
      return undefined;
   }
   if(_root.gamePaused)
   {
      return undefined;
   }
   _root.zhanting = false;
   playMc(_root.game.p1.mc);
   playMc(_root.game.p2.mc);
   playMc(_root.game.p1fz);
   playMc(_root.game.p2fz);
   resumeBlackStg();
}
function shadowEffect(mc, param)
{
   if(param == null)
   {
      param = {};
   }
   if(isNaN(param.alphaStart))
   {
      param.alphaStart = 100;
   }
   if(isNaN(param.alphaLose))
   {
      param.alphaLose = 10;
   }
   var _loc7_ = _root.game.lyr_plr_bkeft;
   var _loc6_ = _loc7_.getNextHighestDepth();
   var _loc8_ = new flash.display.BitmapData(mc._width,mc._height,true,0);
   var _loc5_ = mc.getBounds(mc);
   var _loc9_ = new flash.geom.Matrix(1,0,0,1,- _loc5_.xMin,- _loc5_.yMin);
   _loc8_.draw(mc,_loc9_,param.colorTransform);
   _loc7_.createEmptyMovieClip("mc" + _loc6_,_loc6_);
   var _loc4_ = _loc7_["mc" + _loc6_];
   _loc4_._xscale = mc._xscale;
   _loc4_.attachBitmap(_loc8_,_loc6_);
   _loc4_._x = mc._x + _loc5_.xMin * (mc._xscale <= 0 ? -1 : 1);
   _loc4_._y = mc._y + _loc5_.yMin;
   _loc4_._alpha = param.alphaStart;
   _loc4_.onEnterFrame = function()
   {
      this._alpha -= param.alphaLose;
      if(this._alpha <= 0)
      {
         this.removeMovieClip();
      }
   };
}
function getDayDiff(d1, d2)
{
   var _loc1_ = d1.getTime() - d2.getTime();
   return _loc1_ / 86400000;
}
_root.clearint = function()
{
   clearInterval(_root.timeset);
   clearInterval(_root.xtset);
   clearInterval(_root.kcint);
   clearInterval(_root.nxtfht);
   clearInterval(_root.scrnset);
   clearInterval(_root.airanset);
   clearInterval(_root.feiint);
   clearInterval(_root.feiint2);
   clearInterval(_root.zdbxint);
};
_root.showKeyName = function(key)
{
   var _loc1_ = new Object();
   _loc1_[49] = "1";
   _loc1_[50] = "2";
   _loc1_[51] = "3";
   _loc1_[52] = "4";
   _loc1_[53] = "5";
   _loc1_[54] = "6";
   _loc1_[55] = "7";
   _loc1_[56] = "8";
   _loc1_[57] = "9";
   _loc1_[48] = "0";
   _loc1_[81] = "Q";
   _loc1_[87] = "W";
   _loc1_[69] = "E";
   _loc1_[82] = "R";
   _loc1_[84] = "T";
   _loc1_[89] = "Y";
   _loc1_[85] = "U";
   _loc1_[73] = "I";
   _loc1_[79] = "O";
   _loc1_[80] = "P";
   _loc1_[219] = "[";
   _loc1_[221] = "]";
   _loc1_[65] = "A";
   _loc1_[83] = "S";
   _loc1_[68] = "D";
   _loc1_[70] = "F";
   _loc1_[71] = "G";
   _loc1_[72] = "H";
   _loc1_[74] = "J";
   _loc1_[75] = "K";
   _loc1_[76] = "L";
   _loc1_[186] = ";";
   _loc1_[222] = "\'";
   _loc1_[90] = "Z";
   _loc1_[88] = "X";
   _loc1_[67] = "C";
   _loc1_[86] = "V";
   _loc1_[66] = "B";
   _loc1_[78] = "N";
   _loc1_[77] = "M";
   _loc1_[32] = "Space";
   _loc1_[38] = "↑";
   _loc1_[40] = "↓";
   _loc1_[37] = "←";
   _loc1_[39] = "→";
   _loc1_[45] = "Ins";
   _loc1_[36] = "Hom";
   _loc1_[33] = "PaU";
   _loc1_[46] = "Del";
   _loc1_[35] = "End";
   _loc1_[34] = "PaD";
   _loc1_[96] = "Num0";
   _loc1_[110] = "Num.";
   _loc1_[97] = "Num1";
   _loc1_[98] = "Num2";
   _loc1_[99] = "Num3";
   _loc1_[100] = "Num4";
   _loc1_[101] = "Num5";
   _loc1_[102] = "Num6";
   _loc1_[103] = "Num7";
   _loc1_[104] = "Num8";
   _loc1_[105] = "Num9";
   _loc1_[106] = "Num*";
   _loc1_[111] = "Num/";
   _loc1_[107] = "Num+";
   _loc1_[109] = "Num-";
   return _loc1_[key];
};
var chushi = function()
{
   if(_root.p1cpu == false)
   {
      _root.game.p1.mc.上 = _root.w;
      _root.game.p1.mc.下 = _root.s;
      _root.game.p1.mc.左 = _root.a;
      _root.game.p1.mc.右 = _root.d;
      _root.game.p1.mc.斩 = _root.j;
      _root.game.p1.mc.跳 = _root.k;
      _root.game.p1.mc.冲 = _root.l;
      _root.game.p1.mc.招 = _root.u;
      _root.game.p1.mc.必杀 = _root.i;
      _root.game.p1.mc.换 = _root.o;
   }
   if(_root.p2cpu == false)
   {
      _root.game.p2.mc.上 = _root.上箭;
      _root.game.p2.mc.下 = _root.下箭;
      _root.game.p2.mc.左 = _root.左箭;
      _root.game.p2.mc.右 = _root.右箭;
      _root.game.p2.mc.斩 = _root.N1;
      _root.game.p2.mc.跳 = _root.N2;
      _root.game.p2.mc.冲 = _root.N3;
      _root.game.p2.mc.招 = _root.N4;
      _root.game.p2.mc.必杀 = _root.N5;
      _root.game.p2.mc.换 = _root.N6;
   }
   _root.p1bs = _root.p1selt;
   _root.p2bs = _root.p2selt;
   _root.game.p1._x = _root.p1ox;
   _root.game.p2._x = _root.p2ox;
   _root.game.p1._y = _root.p1oy;
   _root.game.p2._y = _root.p2oy;
   _root.game.p1._xscale = 100;
   _root.game.p2._xscale = -100;
   _root.game.p1.mc.hp = _root.game.p2.mc.hp = _root.maxhp;
   _root.game.p1.isNaruto = _root.getFighterData(_root.p1selt).isNaruto;
   _root.game.p2.isNaruto = _root.getFighterData(_root.p2selt).isNaruto;
};
var stgi = 0;
var _menuEnabled = false;
var koPause = false;

// ============================================================================
// BVN 2.6 NETPLAY MODULE (Pure ActionScript 2 - Direct Select Sync + Fight Lockstep)
// Injected at the end of launch.swf -> scripts/frame_8/DoAction.as
// ============================================================================
if(_root.Net == undefined)
{
   var __bvnNetInit = function()
   {
      var NET_VER = "2.6";
      var FPS_MS = 33.333333;

      // Unlock built-in AVM1 READONLY/DONTDELETE flags before patching!
      ASSetPropFlags(Key,null,0,7);
      ASSetPropFlags(Math,null,0,7);
      ASSetPropFlags(_global,["setInterval","clearInterval","setTimeout","clearTimeout"],0,7);

      var origKeyIsDown = Key.isDown;
      var origMathRandom = Math.random;
      var origSetInterval = _global.setInterval;
      var origClearInterval = _global.clearInterval;
      var origSetTimeout = _global.setTimeout;
      var origClearTimeout = _global.clearTimeout;
      var noopFn = function() {};

      var net = {};
      _root.Net = net;

      // Connection & Room State
      net.sock = null;
      net.connected = false;
      net.active = false;
      net.lobbyOpen = false;
      net.phase = "OFFLINE";       // OFFLINE | LOBBY | SELECT | LOADING | FIGHT | MATCH_END
      net.slot = 0;                // 1 = P1 (Host), 2 = P2 (Guest)
      net.roomCode = "";
      net.peerJoined = false;
      net.host = "127.0.0.1";
      net.port = 9000;
      net.delayMode = 0;           // 0 = AUTO, 1..6 = manual frames
      net.delay = 2;
      net.recDelay = 2;
      net.p1Rtt = 0;
      net.p2Rtt = 0;
      net.cfgHp = 1000;
      net.cfgTime = 60;
      net.pingMs = 0;
      net.lastPingSent = 0;
      net.statusText = "Nhap IP server roi bam TAO PHONG hoac VAO PHONG.";

      // Authoritative Select State
      net.selectStage = 0;         // 0 = Fighter, 1 = Assist, 2 = Map
      net.localLocked = false;
      net.peerLocked = false;
      net.pendingMoves = {};
      net.pendingLocks = {};
      net.pendingStep = null;

      // Lockstep Fight State
      net.epoch = 0;
      net.execFrame = 0;
      net.sendFrame = 0;
      net.inputBuf = {};
      net.curP1Mask = 0;
      net.curP2Mask = 0;
      net.stalled = false;
      net.stallStartMs = 0;
      net.fightReady = false;
      net.syncState = "OK";
      net.desyncFrame = -1;

      // Saved original game state
      net.savedKeys = null;
      net.localKeys = null;
      net.savedZhanting = false;
      net.frozenClips = [];
      net.frozenFighters = [];

      // Seeded PRNG (Park-Miller LCG - exact in IEEE-754 double)
      net.rngEnabled = false;
      net.rngState = 123456789;

      // Virtual Frame-Based Timers (used during LOADING/FIGHT)
      net.vTimersEnabled = false;
      net.vTimersPaused = false;
      net.vTimerNextId = 100000;
      net.vTimers = {};

      // UI references
      net.lobbyMc = null;
      net.hudMc = null;
      net.badgeMc = null;
      net.ui = {};

      var netSO = SharedObject.getLocal("bvn_net_cfg");
      if(netSO.data.host != undefined && netSO.data.host != "")
      {
         net.host = String(netSO.data.host);
      }
      if(netSO.data.port != undefined && !isNaN(Number(netSO.data.port)))
      {
         net.port = Number(netSO.data.port);
      }
      if(netSO.data.delayMode != undefined && !isNaN(Number(netSO.data.delayMode)))
      {
         net.delayMode = Number(netSO.data.delayMode);
         if(net.delayMode < 0) net.delayMode = 0;
         if(net.delayMode > 6) net.delayMode = 6;
      }

      // ---- Helpers ----
      function trimStr(s)
      {
         if(s == undefined) return "";
         var str = String(s);
         var start = 0;
         var end = str.length - 1;
         while(start <= end && (str.charCodeAt(start) <= 32)) start++;
         while(end >= start && (str.charCodeAt(end) <= 32)) end--;
         if(start > end) return "";
         return str.substring(start,end + 1);
      }

      function saveNetCfg()
      {
         netSO.data.host = net.host;
         netSO.data.port = net.port;
         netSO.data.delayMode = net.delayMode;
         netSO.flush();
      }

      // ---- Seeded PRNG ----
      net.seedRng = function(seedVal)
      {
         var s = Number(seedVal);
         if(isNaN(s) || s <= 0) s = 123456789;
         net.rngState = s % 2147483647;
         if(net.rngState <= 0) net.rngState = 123456789;
         net.rngEnabled = true;
      };

      net.patchedMathRandom = function()
      {
         if(!net.rngEnabled)
         {
            return origMathRandom();
         }
         net.rngState = (net.rngState * 16807) % 2147483647;
         if(net.rngState <= 0)
         {
            net.rngState += 2147483646;
         }
         return (net.rngState - 1) / 2147483646;
      };
      Math.random = net.patchedMathRandom;

      // ---- Virtual Frame-Based Timers ----
      function registerVTimer(once, rawArgs)
      {
         var id = net.vTimerNextId;
         net.vTimerNextId++;
         var entry = {};
         entry.once = once;
         var ms = 33;
         var argStart = 2;
         if(typeof rawArgs[0] == "object" && typeof rawArgs[1] == "string")
         {
            entry.isMethod = true;
            entry.obj = rawArgs[0];
            entry.method = rawArgs[1];
            ms = Number(rawArgs[2]);
            argStart = 3;
         }
         else
         {
            entry.isMethod = false;
            entry.fn = rawArgs[0];
            ms = Number(rawArgs[1]);
            argStart = 2;
         }
         if(isNaN(ms) || ms < 1) ms = 33;
         var ticks = Math.round(ms / FPS_MS);
         if(ticks < 1) ticks = 1;
         entry.period = ticks;
         entry.remain = ticks;
         entry.args = [];
         var idx = argStart;
         while(idx < rawArgs.length)
         {
            entry.args.push(rawArgs[idx]);
            idx++;
         }
         net.vTimers[id] = entry;
         return id;
      }

      net.clearAllVTimers = function()
      {
         net.vTimers = {};
      };

      function tickVirtualTimers()
      {
         if(!net.vTimersEnabled || net.vTimersPaused) return undefined;
         var ids = [];
         for(var k in net.vTimers)
         {
            ids.push(k);
         }
         ids.sort(function(a, b)
         {
            return Number(a) - Number(b);
         });
         var i = 0;
         while(i < ids.length)
         {
            var id = ids[i];
            var t = net.vTimers[id];
            if(t != undefined)
            {
               t.remain -= 1;
               if(t.remain <= 0)
               {
                  if(t.once)
                  {
                     delete net.vTimers[id];
                  }
                  else
                  {
                     t.remain = t.period;
                  }
                  if(t.isMethod)
                  {
                     if(t.obj != undefined && t.obj[t.method] != undefined)
                     {
                        t.obj[t.method].apply(t.obj,t.args);
                     }
                  }
                  else if(t.fn != undefined)
                  {
                     t.fn.apply(null,t.args);
                  }
               }
            }
            i++;
         }
      }

      _global.setInterval = function(a, b, c, d, e)
      {
         if(net.vTimersEnabled)
         {
            return registerVTimer(false,arguments);
         }
         if(arguments.length == 2) return origSetInterval(a,b);
         if(arguments.length == 3) return origSetInterval(a,b,c);
         if(arguments.length == 4) return origSetInterval(a,b,c,d);
         return origSetInterval(a,b,c,d,e);
      };

      _global.clearInterval = function(id)
      {
         if(net.vTimers[id] != undefined)
         {
            delete net.vTimers[id];
         }
         origClearInterval(id);
      };

      if(origSetTimeout != undefined)
      {
         _global.setTimeout = function(a, b, c, d, e)
         {
            if(net.vTimersEnabled)
            {
               return registerVTimer(true,arguments);
            }
            if(arguments.length == 2) return origSetTimeout(a,b);
            if(arguments.length == 3) return origSetTimeout(a,b,c);
            if(arguments.length == 4) return origSetTimeout(a,b,c,d);
            return origSetTimeout(a,b,c,d,e);
         };
      }

      if(origClearTimeout != undefined)
      {
         _global.clearTimeout = function(id)
         {
            if(net.vTimers[id] != undefined)
            {
               delete net.vTimers[id];
            }
            origClearTimeout(id);
         };
      }

      // ---- Key Handling & 10-bit Input Mask ----
      // localKeys indices: 0:W 1:S 2:A 3:D 4:J 5:K 6:L 7:U 8:I 9:O
      function captureAndNormalizeKeys()
      {
         if(net.savedKeys == null)
         {
            net.savedKeys = {
               w:_root.w, s:_root.s, a:_root.a, d:_root.d,
               j:_root.j, k:_root.k, l:_root.l, u:_root.u, i:_root.i, o:_root.o,
               up:_root.上箭, dn:_root.下箭, lt:_root.左箭, rt:_root.右箭,
               n1:_root.N1, n2:_root.N2, n3:_root.N3, n4:_root.N4, n5:_root.N5, n6:_root.N6
            };
            net.localKeys = [
               _root.w, _root.s, _root.a, _root.d,
               _root.j, _root.k, _root.l, _root.u, _root.i, _root.o
            ];
         }
         _root.w = 87; _root.s = 83; _root.a = 65; _root.d = 68;
         _root.j = 74; _root.k = 75; _root.l = 76; _root.u = 85; _root.i = 73; _root.o = 79;
         _root.上箭 = 38; _root.下箭 = 40; _root.左箭 = 37; _root.右箭 = 39;
         _root.N1 = 97; _root.N2 = 98; _root.N3 = 99; _root.N4 = 100; _root.N5 = 101; _root.N6 = 102;
      }

      function restoreOriginalKeys()
      {
         if(net.savedKeys != null)
         {
            _root.w = net.savedKeys.w; _root.s = net.savedKeys.s;
            _root.a = net.savedKeys.a; _root.d = net.savedKeys.d;
            _root.j = net.savedKeys.j; _root.k = net.savedKeys.k;
            _root.l = net.savedKeys.l; _root.u = net.savedKeys.u;
            _root.i = net.savedKeys.i; _root.o = net.savedKeys.o;
            _root.上箭 = net.savedKeys.up; _root.下箭 = net.savedKeys.dn;
            _root.左箭 = net.savedKeys.lt; _root.右箭 = net.savedKeys.rt;
            _root.N1 = net.savedKeys.n1; _root.N2 = net.savedKeys.n2;
            _root.N3 = net.savedKeys.n3; _root.N4 = net.savedKeys.n4;
            _root.N5 = net.savedKeys.n5; _root.N6 = net.savedKeys.n6;
            net.savedKeys = null;
            net.localKeys = null;
         }
      }

      // Direct physical key reader for local player's own P1 bindings (used during SELECT)
      net.isLocalKeyIndexDown = function(idx)
      {
         if(net.lobbyOpen || net.localKeys == null) return false;
         return origKeyIsDown(net.localKeys[idx]);
      };

      function sampleLocalMask()
      {
         var lk = net.localKeys;
         if(lk == null) return 0;
         var m = 0;
         if(origKeyIsDown(lk[0])) m |= 1;
         if(origKeyIsDown(lk[1])) m |= 2;
         if(origKeyIsDown(lk[2])) m |= 4;
         if(origKeyIsDown(lk[3])) m |= 8;
         if(origKeyIsDown(lk[4])) m |= 16;
         if(origKeyIsDown(lk[5])) m |= 32;
         if(origKeyIsDown(lk[6])) m |= 64;
         if(origKeyIsDown(lk[7])) m |= 128;
         if(origKeyIsDown(lk[8])) m |= 256;
         if(origKeyIsDown(lk[9])) m |= 512;
         return m;
      }

      net.patchedKeyIsDown = function(code)
      {
         if(net.lobbyOpen)
         {
            return false;
         }
         if(!net.active)
         {
            return origKeyIsDown(code);
         }
         if(net.phase == "FIGHT")
         {
            if(code == 87) return (net.curP1Mask & 1) != 0;
            if(code == 83) return (net.curP1Mask & 2) != 0;
            if(code == 65) return (net.curP1Mask & 4) != 0;
            if(code == 68) return (net.curP1Mask & 8) != 0;
            if(code == 74) return (net.curP1Mask & 16) != 0;
            if(code == 75) return (net.curP1Mask & 32) != 0;
            if(code == 76) return (net.curP1Mask & 64) != 0;
            if(code == 85) return (net.curP1Mask & 128) != 0;
            if(code == 73) return (net.curP1Mask & 256) != 0;
            if(code == 79) return (net.curP1Mask & 512) != 0;

            if(code == 38) return (net.curP2Mask & 1) != 0;
            if(code == 40) return (net.curP2Mask & 2) != 0;
            if(code == 37) return (net.curP2Mask & 4) != 0;
            if(code == 39) return (net.curP2Mask & 8) != 0;
            if(code == 97) return (net.curP2Mask & 16) != 0;
            if(code == 98) return (net.curP2Mask & 32) != 0;
            if(code == 99) return (net.curP2Mask & 64) != 0;
            if(code == 100) return (net.curP2Mask & 128) != 0;
            if(code == 101) return (net.curP2Mask & 256) != 0;
            if(code == 102) return (net.curP2Mask & 512) != 0;
            return false;
         }
         return false;
      };

      Key.isDown = net.patchedKeyIsDown;
      net.isKeyDown = net.patchedKeyIsDown;
      net.keyHookOk = (Key.isDown == net.patchedKeyIsDown);

      // ---- Authoritative Character / Assist / Map Select Sync ----
      function resetSelectBuffers()
      {
         net.selectStage = 0;
         net.localLocked = false;
         net.peerLocked = false;
         net.pendingMoves = {};
         net.pendingLocks = {};
         net.pendingStep = null;
         _root.__selectMC = undefined;
         _root.__selectType = -1;
      }

      net.sendSelectMove = function(stage, gx, gy)
      {
         if(!net.active || net.phase != "SELECT") return undefined;
         if(stage == 2 && net.slot != 1) return undefined;
         net.sendRaw("S|" + stage + "|M|" + gx + "|" + gy);
      };

      net.sendSelectLock = function(stage, pickId)
      {
         if(!net.active || net.phase != "SELECT") return undefined;
         if(stage == 2 && net.slot != 1) return undefined;
         net.localLocked = true;
         net.sendRaw("S|" + stage + "|K|" + pickId);
         updateHud();
      };

      function applyRemoteLockOnMC(mc, stage, fromSlot, pickId)
      {
         if(stage == 0)
         {
            _root["p" + fromSlot + "selt"] = pickId;
            if(mc[pickId] != undefined)
            {
               mc["_p" + fromSlot + "selt"] = mc[pickId];
               mc.updateSelect(fromSlot);
            }
         }
         else if(stage == 1)
         {
            _root["p" + fromSlot + "sf"] = pickId;
            if(mc[pickId] != undefined)
            {
               mc["_p" + fromSlot + "selt"] = mc[pickId];
               mc.updateSelect(fromSlot);
            }
         }
         else if(stage == 2)
         {
            _root.curStage = pickId;
            if(mc[pickId] != undefined)
            {
               mc._p1selt = mc[pickId];
               mc.updateSelect(1);
            }
         }
         mc["p" + fromSlot + "enable"] = false;
         if(mc["player" + fromSlot] != undefined)
         {
            mc["player" + fromSlot].gotoAndPlay(2);
         }
         _root.keysound2.start();
         net.peerLocked = true;
         updateHud();
      }

      function executeSelectStep(stepParts)
      {
         var nextStage = Number(stepParts[2]);
         if(nextStage == 1)
         {
            // Both fighters locked -> move to Assist Select
            _root.p1selt = stepParts[3];
            _root.p2selt = stepParts[4];
            net.selectStage = 1;
            net.localLocked = false;
            net.peerLocked = false;
            if(_root.__selectMC != undefined && _root.__selectMC._parent != undefined)
            {
               _root.__selectMC._parent.gotoAndPlay("辅助人选");
            }
            updateHud();
            return undefined;
         }
         if(nextStage == 2)
         {
            // Both assists locked -> move to Map Select
            _root.p1sf = stepParts[3];
            _root.p2sf = stepParts[4];
            net.selectStage = 2;
            net.localLocked = false;
            net.peerLocked = false;
            if(_root.__selectMC != undefined && _root.__selectMC._parent != undefined)
            {
               _root.__selectMC._parent.gotoAndPlay("地图");
            }
            updateHud();
            return undefined;
         }
         if(nextStage == 3)
         {
            // Authoritative full picks -> enter Battle Scene Loading
            _root.p1selt = stepParts[3];
            _root.p2selt = stepParts[4];
            _root.p1sf = stepParts[5];
            _root.p2sf = stepParts[6];
            _root.curStage = stepParts[7];
            net.onEnterLoading();
            _root.gotoAndStop("游戏场景");
         }
      }

      net.onSelectMounted = function(mc, stage)
      {
         if(!net.active || net.phase != "SELECT") return undefined;
         _root.__selectMC = mc;
         _root.__selectType = stage;

         // Strict business rule: enforce which cursor belongs to local player
         if(stage == 2)
         {
            // Map select: ONLY P1 (Host) can move/confirm; P2 only watches
            mc.p1enable = (net.slot == 1);
            mc.p2enable = false;
         }
         else
         {
            mc.p1enable = (net.slot == 1);
            mc.p2enable = (net.slot == 2);
         }

         // Replay any peer move/lock received during transition animation
         var peerSlot = (net.slot == 1) ? 2 : 1;
         var mKey = stage + "_" + peerSlot;
         if(net.pendingMoves[mKey] != undefined)
         {
            var mv = net.pendingMoves[mKey];
            delete net.pendingMoves[mKey];
            mc.__remoteCall = true;
            mc.updateXY(peerSlot,mv.x,mv.y);
            mc.__remoteCall = false;
         }
         if(net.pendingLocks[mKey] != undefined)
         {
            var lkId = net.pendingLocks[mKey];
            delete net.pendingLocks[mKey];
            applyRemoteLockOnMC(mc,stage,peerSlot,lkId);
         }
         if(net.pendingStep != null && Number(net.pendingStep[2]) > stage)
         {
            var st = net.pendingStep;
            net.pendingStep = null;
            executeSelectStep(st);
         }
         updateHud();
      };

      // ---- Safe Frame-Delta Freeze / Unfreeze + Fighter kis/on_enterframe Guards ----
      function trackTree(mc, depth)
      {
         if(mc == undefined || mc._target == undefined || depth > 8) return undefined;
         var nm = mc._name;
         if(nm == "__netLoop" || nm == "__netLobby" || nm == "__netHud" || nm == "__netBadge")
         {
            return undefined;
         }
         if(mc._totalframes > 1)
         {
            mc.__netLastF = mc._currentframe;
         }
         for(var k in mc)
         {
            var ch = mc[k];
            if(typeof ch == "movieclip" && ch._parent == mc)
            {
               trackTree(ch,depth + 1);
            }
         }
      }

      function collectAndFreeze(mc, depth, outArr)
      {
         if(mc == undefined || mc._target == undefined || depth > 8) return undefined;
         var nm = mc._name;
         if(nm == "__netLoop" || nm == "__netLobby" || nm == "__netHud" || nm == "__netBadge")
         {
            return undefined;
         }
         if(mc._totalframes > 1 && mc.__netLastF != undefined && mc._currentframe != mc.__netLastF)
         {
            mc.stop();
            outArr.push(mc);
         }
         for(var k in mc)
         {
            var ch = mc[k];
            if(typeof ch == "movieclip" && ch._parent == mc)
            {
               collectAndFreeze(ch,depth + 1,outArr);
            }
         }
      }

      function stubFighterEnterFrame(fmc)
      {
         if(fmc != undefined && typeof fmc.on_enterframe == "function" && fmc.on_enterframe != noopFn)
         {
            net.frozenFighters.push({mc:fmc, fn:fmc.on_enterframe});
            fmc.on_enterframe = noopFn;
         }
      }

      function ensureFighterKisHook()
      {
         if(_root.game == undefined) return undefined;
         if(_root.game.p1 != undefined && _root.game.p1.mc != undefined && _root.game.p1.mc.kis != net.patchedKeyIsDown)
         {
            _root.game.p1.mc.kis = net.patchedKeyIsDown;
         }
         if(_root.game.p2 != undefined && _root.game.p2.mc != undefined && _root.game.p2.mc.kis != net.patchedKeyIsDown)
         {
            _root.game.p2.mc.kis = net.patchedKeyIsDown;
         }
      }

      function beginStall()
      {
         if(net.stalled) return undefined;
         net.stalled = true;
         net.stallStartMs = getTimer();
         net.savedZhanting = _root.zhanting;
         _root.zhanting = true;
         net.frozenClips = [];
         net.frozenFighters = [];
         if(net.phase == "FIGHT")
         {
            if(_root.game != undefined)
            {
               stubFighterEnterFrame(_root.game.p1.mc);
               stubFighterEnterFrame(_root.game.p2.mc);
            }
            collectAndFreeze(_root.game,0,net.frozenClips);
            collectAndFreeze(_root.ready,0,net.frozenClips);
            collectAndFreeze(_root.KO,0,net.frozenClips);
            collectAndFreeze(_root.timeover,0,net.frozenClips);
            collectAndFreeze(_root.qjxg,0,net.frozenClips);
            collectAndFreeze(_root.ts_face,0,net.frozenClips);
            collectAndFreeze(_root.__loadingMC,0,net.frozenClips);
         }
      }

      function endStall()
      {
         if(!net.stalled) return undefined;
         net.stalled = false;
         _root.zhanting = net.savedZhanting;
         var fi = 0;
         while(fi < net.frozenFighters.length)
         {
            var item = net.frozenFighters[fi];
            if(item.mc != undefined && item.mc._target != undefined)
            {
               item.mc.on_enterframe = item.fn;
            }
            fi++;
         }
         net.frozenFighters = [];
         var i = 0;
         while(i < net.frozenClips.length)
         {
            var mc = net.frozenClips[i];
            if(mc != undefined && mc._target != undefined)
            {
               mc.__netLastF = mc._currentframe;
               mc.play();
            }
            i++;
         }
         net.frozenClips = [];
      }

      // ---- Lockstep Fight Epoch Management ----
      function startFightEpoch(epochNum, seedVal, delayVal, hpVal, timeVal)
      {
         endStall();
         net.phase = "FIGHT";
         net.epoch = epochNum;
         net.delay = delayVal;
         net.execFrame = 0;
         net.sendFrame = delayVal;
         net.inputBuf = {};
         net.curP1Mask = 0;
         net.curP2Mask = 0;
         net.syncState = "OK";
         net.desyncFrame = -1;

         if(!isNaN(hpVal) && hpVal >= 500) _root.maxhp = hpVal;
         if(!isNaN(timeVal) && timeVal >= 30) _root.maxtime = timeVal;

         var f = 0;
         while(f < delayVal)
         {
            net.inputBuf[f] = {p1:0, p2:0};
            f++;
         }

         net.seedRng(seedVal);
         net.vTimersEnabled = true;
         net.vTimersPaused = false;
         ensureFighterKisHook();
         updateHud();
      }

      // ---- Network I/O ----
      net.sendRaw = function(msg)
      {
         if(net.sock != null && net.connected)
         {
            net.sock.send(msg);
         }
      };

      net.disconnect = function(reasonText, goToMenu)
      {
         endStall();
         if(net.sock != null)
         {
            if(net.connected)
            {
               net.sock.send("X");
            }
            net.sock.close();
            net.sock = null;
         }
         net.connected = false;
         net.active = false;
         net.phase = "OFFLINE";
         net.slot = 0;
         net.roomCode = "";
         net.peerJoined = false;
         net.fightReady = false;
         net.rngEnabled = false;
         net.vTimersEnabled = false;
         net.vTimersPaused = false;
         net.clearAllVTimers();
         resetSelectBuffers();
         _root.loadingFunc = undefined;
         restoreOriginalKeys();
         hideHud();
         if(reasonText != undefined && reasonText != "")
         {
            net.statusText = reasonText;
         }
         if(goToMenu)
         {
            stopAllSounds();
            if(_root.stageSound != undefined) _root.stageSound.stop();
            _root.clearint();
            _root.gotoAndStop("MENU");
            net.openLobby();
         }
         else
         {
            refreshLobbyUI();
         }
      };

      function connectAndRun(onReadyFn)
      {
         if(net.sock != null)
         {
            net.sock.close();
            net.sock = null;
            net.connected = false;
         }
         readInputsFromUI();
         saveNetCfg();
         net.statusText = "Dang ket noi " + net.host + ":" + net.port + "...";
         refreshLobbyUI();

         var s = new XMLSocket();
         net.sock = s;
         s.onConnect = function(ok)
         {
            if(net.sock != s) return undefined;
            if(!ok)
            {
               net.connected = false;
               net.statusText = "LOI: Khong ket noi duoc " + net.host + ":" + net.port + " (kiem tra Server / Firewall)";
               refreshLobbyUI();
               return undefined;
            }
            net.connected = true;
            net.lastPingSent = getTimer();
            net.sendRaw("P|" + net.lastPingSent + "|" + net.pingMs);
            if(onReadyFn != undefined) onReadyFn();
         };
         s.onData = function(src)
         {
            if(net.sock != s) return undefined;
            onServerMessage(src);
         };
         s.onClose = function()
         {
            if(net.sock != s) return undefined;
            var wasPlaying = (net.phase == "SELECT" || net.phase == "LOADING" || net.phase == "FIGHT" || net.phase == "MATCH_END");
            net.sock = null;
            net.connected = false;
            net.disconnect("Mat ket noi voi Server!",wasPlaying);
         };
         s.connect(net.host,net.port);
      }

      function onServerMessage(raw)
      {
         if(raw == undefined || raw == "") return undefined;
         var parts = raw.split("|");
         var cmd = parts[0];

         if(cmd == "Q")
         {
            var sent = Number(parts[1]);
            if(!isNaN(sent))
            {
               net.pingMs = getTimer() - sent;
            }
            refreshLobbyUI();
            updateHud();
            return undefined;
         }

         if(cmd == "T")
         {
            net.p1Rtt = Number(parts[1]);
            net.p2Rtt = Number(parts[2]);
            net.recDelay = Number(parts[3]);
            refreshLobbyUI();
            return undefined;
         }

         if(cmd == "R")
         {
            net.roomCode = parts[1];
            net.slot = Number(parts[2]);
            net.delayMode = Number(parts[3]);
            net.cfgHp = Number(parts[4]);
            net.cfgTime = Number(parts[5]);
            net.active = true;
            net.phase = "LOBBY";
            net.peerJoined = (net.slot == 2);
            if(net.slot == 1)
            {
               net.statusText = "TAO PHONG THANH CONG! Ma phong: " + net.roomCode + " - Dang cho P2 vao...";
            }
            else
            {
               net.statusText = "DA VAO PHONG " + net.roomCode + " (Ban la P2) - Cho P1 bam BAT DAU...";
            }
            refreshLobbyUI();
            return undefined;
         }

         if(cmd == "O")
         {
            net.peerJoined = true;
            if(net.slot == 1)
            {
               net.statusText = "P2 DA VAO PHONG " + net.roomCode + "! Bam [BAT DAU CHON TUONG].";
            }
            else
            {
               net.statusText = "Da ket noi voi chu phong (P1). Cho P1 bam BAT DAU...";
            }
            refreshLobbyUI();
            return undefined;
         }

         if(cmd == "M" && parts[1] == "SELECT")
         {
            // M|SELECT|epoch|seed|effectiveDelay|hp|time
            endStall();
            net.epoch = Number(parts[2]);
            net.delay = Number(parts[4]);
            var hp = Number(parts[5]);
            var tm = Number(parts[6]);
            net.closeLobby(true);
            stopAllSounds();
            if(_root.stageSound != undefined) _root.stageSound.stop();
            captureAndNormalizeKeys();
            net.clearAllVTimers();
            net.vTimersEnabled = false;
            net.vTimersPaused = false;
            net.rngEnabled = false;
            resetSelectBuffers();
            net.phase = "SELECT";
            _root.clearint();
            _root.modo = 3;
            _root.p1cpu = false;
            _root.p2cpu = false;
            if(!isNaN(hp) && hp >= 500) _root.maxhp = hp;
            if(!isNaN(tm) && tm >= 30) _root.maxtime = tm;
            showHud();
            _root.gotoAndStop("选人画面");
            return undefined;
         }

         if(cmd == "S")
         {
            if(parts[1] == "STEP")
            {
               var nxt = Number(parts[2]);
               if(_root.__selectMC != undefined || nxt == 3)
               {
                  executeSelectStep(parts);
               }
               else
               {
                  net.pendingStep = parts;
               }
               return undefined;
            }
            // Peer select event: S|<fromSlot>|<stage>|M|x|y  OR  S|<fromSlot>|<stage>|K|pickId
            var fromSlot = Number(parts[1]);
            var stg = Number(parts[2]);
            var act = parts[3];
            var targetSlot = (stg == 2) ? 1 : fromSlot;
            if(act == "M")
            {
               var gx = Number(parts[4]);
               var gy = Number(parts[5]);
               if(_root.__selectMC != undefined && _root.__selectType == stg)
               {
                  _root.__selectMC.__remoteCall = true;
                  _root.__selectMC.updateXY(targetSlot,gx,gy);
                  _root.__selectMC.__remoteCall = false;
                  _root.keysound1.start();
               }
               else
               {
                  net.pendingMoves[stg + "_" + targetSlot] = {x:gx, y:gy};
               }
               return undefined;
            }
            if(act == "K")
            {
               var pickId = parts[4];
               if(_root.__selectMC != undefined && _root.__selectType == stg)
               {
                  applyRemoteLockOnMC(_root.__selectMC,stg,targetSlot,pickId);
               }
               else
               {
                  net.pendingLocks[stg + "_" + targetSlot] = pickId;
               }
               return undefined;
            }
            return undefined;
         }

         if(cmd == "G")
         {
            var ep2 = Number(parts[1]);
            var sd2 = Number(parts[2]);
            var dl2 = Number(parts[3]);
            var hp2 = Number(parts[4]);
            var tm2 = Number(parts[5]);
            net.fightReady = true;
            startFightEpoch(ep2,sd2,dl2,hp2,tm2);
            if(_root.__loadingMC != undefined && _root.__loadingMC._target != undefined)
            {
               _root.__loadingMC.gotoAndPlay("skip");
            }
            return undefined;
         }

         if(cmd == "F")
         {
            var fEpoch = Number(parts[1]);
            if(fEpoch != net.epoch) return undefined;
            var fNum = Number(parts[2]);
            net.inputBuf[fNum] = {p1:Number(parts[3]), p2:Number(parts[4])};
            return undefined;
         }

         if(cmd == "K")
         {
            net.syncState = "OK";
            updateHud();
            return undefined;
         }

         if(cmd == "D")
         {
            net.syncState = "DESYNC";
            net.desyncFrame = Number(parts[2]);
            updateHud();
            return undefined;
         }

         if(cmd == "W")
         {
            var wType = parts[1];
            if(wType == "HOST_LEFT")
            {
               net.disconnect("Chu phong (P1) da thoat phong!",true);
            }
            else
            {
               endStall();
               net.peerJoined = false;
               net.phase = "LOBBY";
               net.fightReady = false;
               net.rngEnabled = false;
               net.vTimersEnabled = false;
               net.vTimersPaused = false;
               net.clearAllVTimers();
               resetSelectBuffers();
               _root.loadingFunc = undefined;
               restoreOriginalKeys();
               hideHud();
               stopAllSounds();
               if(_root.stageSound != undefined) _root.stageSound.stop();
               _root.clearint();
               _root.gotoAndStop("MENU");
               net.statusText = "P2 da thoat! Phong " + net.roomCode + " dang cho doi thu moi...";
               net.openLobby();
            }
            return undefined;
         }

         if(cmd == "E")
         {
            var errCode = parts[1];
            if(errCode == "ROOM_NOT_FOUND") net.statusText = "LOI: Khong tim thay ma phong nay!";
            else if(errCode == "ROOM_FULL") net.statusText = "LOI: Phong da du 2 nguoi!";
            else if(errCode == "VERSION_MISMATCH") net.statusText = "LOI: Khac phien ban game (can " + parts[2] + ")!";
            else if(errCode == "DUPLICATE_FZ")
            {
               net.localLocked = false;
               if(_root.__selectMC != undefined)
               {
                  _root.__selectMC["p" + net.slot + "enable"] = true;
               }
            }
            else net.statusText = "LOI Server: " + errCode;
            refreshLobbyUI();
            return undefined;
         }
      }

      // ---- Hooks called from launch.swf scenes ----
      net.onEnterLoading = function()
      {
         if(!net.active) return undefined;
         endStall();
         net.clearAllVTimers();
         net.phase = "LOADING";
         net.fightReady = false;
         net.vTimersEnabled = true;
         net.vTimersPaused = true;
         net.curP1Mask = 0;
         net.curP2Mask = 0;
         _root.loadingFunc = function()
         {
            return net.fightReady == true;
         };
         updateHud();
      };

      net.canStartFight = function()
      {
         return net.fightReady == true;
      };

      net.onAssetsLoaded = function()
      {
         if(!net.active || net.phase != "LOADING") return undefined;
         ensureFighterKisHook();
         net.sendRaw("L|" + _root.p1selt + "|" + _root.p2selt + "|" + _root.p1sf + "|" + _root.p2sf + "|" + _root.curStage);
         updateHud();
      };

      net.onMatchFinished = function(winnerSlot)
      {
         if(!net.active) return undefined;
         endStall();
         net.phase = "MATCH_END";
         net.vTimersPaused = true;
         net.clearAllVTimers();
         net.sendRaw("E|" + winnerSlot);
         updateHud();
      };

      // ---- 11-Field Deterministic Checksum ----
      function computeFightChecksum()
      {
         var p1 = _root.game.p1;
         var p2 = _root.game.p2;
         if(p1 == undefined || p2 == undefined || p1.mc == undefined || p2.mc == undefined)
         {
            return "";
         }
         return Math.round(p1._x) + "," + Math.round(p1._y) + "," + Math.round(p1.mc.hp) + "," + Math.round(p1.mc.ql) + "," + p1.mc._currentframe + "," +
                Math.round(p2._x) + "," + Math.round(p2._y) + "," + Math.round(p2.mc.hp) + "," + Math.round(p2.mc.ql) + "," + p2.mc._currentframe + "," +
                _root.gametime;
      }

      // ---- Master Loop (30 FPS) ----
      var loopMc = _root.createEmptyMovieClip("__netLoop",99998);
      var f2WasDown = false;
      loopMc.onEnterFrame = function()
      {
         var f2Now = origKeyIsDown(113);
         if(f2Now && !f2WasDown)
         {
            if(net.lobbyOpen)
            {
               net.closeLobby(false);
            }
            else if(net.phase == "OFFLINE" || net.phase == "LOBBY")
            {
               net.openLobby();
            }
         }
         f2WasDown = f2Now;

         if(net.badgeMc != null)
         {
            net.badgeMc._visible = (!net.lobbyOpen && (net.phase == "OFFLINE" || net.phase == "LOBBY") && _root._currentframe == 10);
            if(net.badgeMc._visible && net.badgeMc.openBtn != undefined)
            {
               net.badgeMc.openBtn.lbl.text = (net.active && net.roomCode != "") ? ("PHONG " + net.roomCode + " [F2]") : "ONLINE 2P [F2]";
            }
         }

         if(net.connected && (getTimer() - net.lastPingSent > 1500))
         {
            net.lastPingSent = getTimer();
            net.sendRaw("P|" + net.lastPingSent + "|" + net.pingMs);
         }

         if(!net.active || net.phase != "FIGHT") return undefined;

         // Guarantee both fighters always read networked inputs (even after Bankai/form switch)
         ensureFighterKisHook();

         // 1. Send local input for upcoming future frame (execFrame + delay)
         while(net.sendFrame <= net.execFrame + net.delay)
         {
            var localMask = sampleLocalMask();
            net.sendRaw("I|" + net.epoch + "|" + net.sendFrame + "|" + localMask);
            net.sendFrame++;
         }

         // 2. Check if paired input for execFrame has arrived
         var pair = net.inputBuf[net.execFrame];
         if(pair == undefined)
         {
            beginStall();
            updateHud();
            return undefined;
         }

         // 3. Advance simulation by 1 deterministic frame
         if(net.stalled)
         {
            endStall();
         }
         net.curP1Mask = pair.p1;
         net.curP2Mask = pair.p2;
         delete net.inputBuf[net.execFrame - 12];

         trackTree(_root.game,0);
         trackTree(_root.ready,0);
         trackTree(_root.KO,0);
         trackTree(_root.timeover,0);
         trackTree(_root.qjxg,0);
         trackTree(_root.ts_face,0);
         trackTree(_root.__loadingMC,0);

         tickVirtualTimers();

         if(_root.p2loaded == true && (net.execFrame % 30 == 0) && net.execFrame > 0)
         {
            var h = computeFightChecksum();
            if(h != "")
            {
               net.sendRaw("H|" + net.epoch + "|" + net.execFrame + "|" + h);
            }
         }

         net.execFrame++;
         if(net.execFrame % 6 == 0)
         {
            updateHud();
         }
      };

      // ---- Pure AS2 UI Drawing Helpers ----
      function drawBox(mc, x, y, w, h, fillCol, fillAlpha, borderCol)
      {
         mc.clear();
         if(borderCol != undefined)
         {
            mc.lineStyle(1,borderCol,100);
         }
         mc.beginFill(fillCol,fillAlpha);
         mc.moveTo(x,y);
         mc.lineTo(x + w,y);
         mc.lineTo(x + w,y + h);
         mc.lineTo(x,y + h);
         mc.lineTo(x,y);
         mc.endFill();
      }

      function makeLabel(parent, name, depth, x, y, w, h, txt, size, color, bold, align)
      {
         parent.createTextField(name,depth,x,y,w,h);
         var tf = parent[name];
         tf.selectable = false;
         tf.multiline = true;
         tf.wordWrap = true;
         var fmt = new TextFormat("_sans",size,color,bold);
         if(align != undefined) fmt.align = align;
         tf.setNewTextFormat(fmt);
         tf.text = txt;
         tf.setTextFormat(fmt);
         return tf;
      }

      function makeInput(parent, name, depth, x, y, w, h, initTxt, maxC)
      {
         parent.createTextField(name,depth,x,y,w,h);
         var tf = parent[name];
         tf.type = "input";
         tf.border = true;
         tf.borderColor = 0x3B82F6;
         tf.background = true;
         tf.backgroundColor = 0x0F172A;
         if(maxC != undefined) tf.maxChars = maxC;
         var fmt = new TextFormat("_sans",13,0xF8FAFC,true);
         tf.setNewTextFormat(fmt);
         tf.text = initTxt;
         tf.setTextFormat(fmt);
         return tf;
      }

      function makeButton(parent, name, depth, x, y, w, h, label, bgCol, onClick)
      {
         var b = parent.createEmptyMovieClip(name,depth);
         b._x = x;
         b._y = y;
         b.__bgCol = bgCol;
         b.__w = w;
         b.__h = h;
         b.__enabled = true;
         drawBox(b,0,0,w,h,bgCol,100,0x94A3B8);
         b.lbl = makeLabel(b,"t",1,0,Math.floor((h - 18) / 2),w,20,label,12,0xFFFFFF,true,"center");
         b.onRollOver = function()
         {
            if(!this.__enabled) return undefined;
            drawBox(this,0,0,this.__w,this.__h,this.__bgCol,85,0xFFFFFF);
         };
         b.onRollOut = b.onReleaseOutside = function()
         {
            if(!this.__enabled) return undefined;
            drawBox(this,0,0,this.__w,this.__h,this.__bgCol,100,0x94A3B8);
         };
         b.onRelease = function()
         {
            if(!this.__enabled) return undefined;
            onClick();
         };
         return b;
      }

      function setButtonEnabled(b, en)
      {
         b.__enabled = en;
         b._alpha = en ? 100 : 40;
         b.useHandCursor = en;
      }

      function readInputsFromUI()
      {
         if(net.ui.ipInput != undefined)
         {
            var h = trimStr(net.ui.ipInput.text);
            if(h != "") net.host = h;
         }
         if(net.ui.portInput != undefined)
         {
            var p = Number(trimStr(net.ui.portInput.text));
            if(!isNaN(p) && p > 0 && p <= 65535) net.port = p;
         }
      }

      function buildLobbyUI()
      {
         if(net.lobbyMc != null) return undefined;
         var m = _root.createEmptyMovieClip("__netLobby",99990);
         net.lobbyMc = m;

         var blk = m.createEmptyMovieClip("blk",1);
         drawBox(blk,0,0,600,400,0x000000,72);
         blk.onPress = function() {};
         blk.useHandCursor = false;

         var panel = m.createEmptyMovieClip("panel",2);
         drawBox(panel,55,22,490,356,0x111827,96,0x38BDF8);
         var hdr = m.createEmptyMovieClip("hdr",3);
         drawBox(hdr,55,22,490,34,0x1E293B,100,0x38BDF8);

         makeLabel(m,"title",10,68,29,390,22,"BVN 2.6 ONLINE 2P  (LAN / VPN)",14,0x38BDF8,true,"left");
         makeButton(m,"btnX",11,514,27,24,24,"X",0xB91C1C,function()
         {
            net.closeLobby(false);
         });

         makeLabel(m,"hint",12,68,62,464,18,"Ca 2 PC deu choi bang WASD + J K L U I O  |  Phim F2: Mo/Dong cua so nay",11,0x94A3B8,false,"left");

         makeLabel(m,"lIp",13,68,88,75,20,"Server IP:",12,0xE2E8F0,true,"left");
         net.ui.ipInput = makeInput(m,"inIp",14,145,86,210,22,net.host,45);

         makeLabel(m,"lPort",15,368,88,40,20,"Port:",12,0xE2E8F0,true,"left");
         net.ui.portInput = makeInput(m,"inPort",16,410,86,70,22,String(net.port),5);

         makeLabel(m,"lSet",17,68,120,75,20,"Cai dat:",12,0xE2E8F0,true,"left");
         makeButton(m,"btnDm",18,145,118,24,22,"-",0x334155,function()
         {
            if(net.delayMode > 0) net.delayMode--;
            saveNetCfg();
            refreshLobbyUI();
         });
         net.ui.delayLbl = makeLabel(m,"lDel",19,170,120,86,20,"Delay: AUTO",11,0x38BDF8,true,"center");
         makeButton(m,"btnDp",20,257,118,24,22,"+",0x334155,function()
         {
            if(net.delayMode < 6) net.delayMode++;
            saveNetCfg();
            refreshLobbyUI();
         });

         net.ui.btnHp = makeButton(m,"btnHp",21,292,118,95,22,"HP: 1000",0x334155,function()
         {
            if(net.cfgHp == 1000) net.cfgHp = 1500;
            else if(net.cfgHp == 1500) net.cfgHp = 2000;
            else net.cfgHp = 1000;
            refreshLobbyUI();
         });

         net.ui.btnTime = makeButton(m,"btnTm",22,397,118,95,22,"Time: 60s",0x334155,function()
         {
            if(net.cfgTime == 60) net.cfgTime = 99;
            else if(net.cfgTime == 99) net.cfgTime = 100;
            else net.cfgTime = 60;
            refreshLobbyUI();
         });

         net.ui.btnCreate = makeButton(m,"btnCreate",23,68,156,175,30,"TAO PHONG (P1)",0x2563EB,function()
         {
            connectAndRun(function()
            {
               net.sendRaw("C|" + NET_VER + "|" + net.delayMode + "|" + net.cfgHp + "|" + net.cfgTime);
            });
         });

         makeLabel(m,"lCode",24,262,162,68,20,"Ma phong:",12,0xE2E8F0,true,"left");
         net.ui.codeInput = makeInput(m,"inCode",25,332,160,64,24,"",4);
         net.ui.btnJoin = makeButton(m,"btnJoin",26,404,156,128,30,"VAO PHONG (P2)",0x0D9488,function()
         {
            var code = trimStr(net.ui.codeInput.text).toUpperCase();
            if(code.length < 4)
            {
               net.statusText = "Hay nhap du 4 ky tu Ma phong (do P1 tao)!";
               refreshLobbyUI();
               return undefined;
            }
            connectAndRun(function()
            {
               net.sendRaw("J|" + code + "|" + NET_VER);
            });
         });

         var stBox = m.createEmptyMovieClip("stBox",27);
         drawBox(stBox,68,200,464,98,0x0B1220,100,0x334155);
         net.ui.roomBig = makeLabel(m,"roomBig",28,78,206,444,24,"CHUA VAO PHONG",16,0xFACC15,true,"center");
         net.ui.telLbl = makeLabel(m,"telLbl",32,78,232,444,18,"",11,0x38BDF8,false,"center");
         net.ui.statusLbl = makeLabel(m,"stLbl",29,78,252,444,42,net.statusText,12,0xE2E8F0,false,"center");

         net.ui.btnStart = makeButton(m,"btnStart",30,68,312,280,34,"BAT DAU CHON TUONG",0x16A34A,function()
         {
            if(net.slot == 1 && net.peerJoined)
            {
               net.sendRaw("B|" + net.delayMode + "|" + net.cfgHp + "|" + net.cfgTime);
            }
         });
         net.ui.btnLeave = makeButton(m,"btnLeave",31,364,312,168,34,"ROI PHONG",0xDC2626,function()
         {
            net.disconnect("Da roi phong.",false);
         });

         net.lobbyMc._visible = false;
      }

      function refreshLobbyUI()
      {
         if(net.lobbyMc == null) return undefined;
         net.ui.delayLbl.text = (net.delayMode == 0) ? ("AUTO(" + net.recDelay + "f)") : ("Delay: " + net.delayMode + "f");
         net.ui.btnHp.lbl.text = "HP: " + net.cfgHp;
         net.ui.btnTime.lbl.text = (net.cfgTime == 100) ? "Time: INF" : ("Time: " + net.cfgTime + "s");

         if(net.active && net.roomCode != "")
         {
            var roleStr = (net.slot == 1) ? "P1 (HOST)" : "P2 (GUEST)";
            net.ui.roomBig.text = "PHONG: " + net.roomCode + "  |  " + roleStr;
            net.ui.telLbl.text = "Ping P1: " + net.p1Rtt + "ms  |  Ping P2: " + (net.peerJoined ? (net.p2Rtt + "ms") : "--") + "  |  Goi y: " + net.recDelay + "f";
         }
         else
         {
            net.ui.roomBig.text = "CHUA VAO PHONG";
            net.ui.telLbl.text = "";
         }
         net.ui.statusLbl.text = net.statusText;

         setButtonEnabled(net.ui.btnStart,(net.active && net.slot == 1 && net.peerJoined));
         setButtonEnabled(net.ui.btnLeave,(net.active || net.connected));
      }

      net.openLobby = function()
      {
         buildLobbyUI();
         net.lobbyOpen = true;
         net.lobbyMc._visible = true;
         refreshLobbyUI();
      };

      net.closeLobby = function(keepConnection)
      {
         if(net.lobbyMc != null)
         {
            net.lobbyMc._visible = false;
         }
         net.lobbyOpen = false;
      };

      // ---- In-Game Compact HUD ----
      function buildHud()
      {
         if(net.hudMc != null) return undefined;
         var h = _root.createEmptyMovieClip("__netHud",99995);
         net.hudMc = h;
         var bg = h.createEmptyMovieClip("bg",1);
         drawBox(bg,115,2,370,19,0x000000,76,0x38BDF8);
         h.txt = makeLabel(h,"t",2,120,3,320,18,"ONLINE",11,0x38BDF8,true,"left");
         makeButton(h,"quit",3,444,3,39,17,"THOAT",0xB91C1C,function()
         {
            net.disconnect("Ban da thoat tran Online.",true);
         });
         h._visible = false;
      }

      function showHud()
      {
         buildHud();
         net.hudMc._visible = true;
         updateHud();
      }

      function hideHud()
      {
         if(net.hudMc != null) net.hudMc._visible = false;
      }

      function updateHud()
      {
         if(net.hudMc == null || !net.hudMc._visible) return undefined;
         var stateStr = net.syncState;
         var col = 0x4ADE80;
         if(net.phase == "SELECT")
         {
            col = 0x38BDF8;
            if(net.selectStage == 0)
            {
               stateStr = net.localLocked ? "DA KHOA TUONG - CHO DOI THU" : "CHON TUONG (WASD + J)";
            }
            else if(net.selectStage == 1)
            {
               stateStr = net.localLocked ? "DA KHOA TRO THU - CHO DOI THU" : "CHON TRO THU (WASD + J)";
            }
            else
            {
               stateStr = (net.slot == 1) ? (net.localLocked ? "DANG VAO TRAN..." : "CHON MAP (WASD + J)") : "CHO P1 CHON MAP...";
            }
            var fmtS = new TextFormat("_sans",11,col,true);
            net.hudMc.txt.text = "P" + net.slot + " [" + net.roomCode + "] " + net.pingMs + "ms | " + stateStr;
            net.hudMc.txt.setTextFormat(fmtS);
            return undefined;
         }
         if(net.phase == "LOADING")
         {
            stateStr = "DANG TAI...";
            col = 0x38BDF8;
         }
         else if(net.phase == "MATCH_END")
         {
            stateStr = "CHO VAN MOI...";
            col = 0x38BDF8;
         }
         else if(net.stalled)
         {
            stateStr = "CHO DOI THU...";
            col = 0xFACC15;
         }
         else if(net.syncState == "DESYNC")
         {
            stateStr = "DESYNC@F" + net.desyncFrame;
            col = 0xF87171;
         }
         var fmt = new TextFormat("_sans",11,col,true);
         net.hudMc.txt.text = "P" + net.slot + " [" + net.roomCode + "] " + net.pingMs + "ms D" + net.delay + " F" + net.execFrame + " " + stateStr;
         net.hudMc.txt.setTextFormat(fmt);
      }

      // ---- Clickable Badge on Main Menu ----
      function buildMenuBadge()
      {
         var b = _root.createEmptyMovieClip("__netBadge",99985);
         net.badgeMc = b;
         makeButton(b,"openBtn",1,464,8,128,24,"ONLINE 2P [F2]",0x1D4ED8,function()
         {
            net.openLobby();
         });
         b._visible = false;
      }
      buildMenuBadge();
   };
   __bvnNetInit();
}

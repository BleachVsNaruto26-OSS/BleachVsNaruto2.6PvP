stop();
loadComplete = true;
_parent.skipAble = true;
if(_root.Net != undefined && _root.Net.active)
{
   _root.Net.onAssetsLoaded();
}
else if(playComplete)
{
   startGame();
}

function showStart()
{
   loading._visible = false;
   _root.play();
}
stop();
startBtn._visible = false;
var persent = 0;
onEnterFrame = function()
{
   total = _root.getBytesTotal();
   loaded = _root.getBytesLoaded();
   persent = loaded / total * 100;
   bar._xscale = persent;
   if(loaded >= total)
   {
      delete onEnterFrame;
      _root.startGame();
   }
};

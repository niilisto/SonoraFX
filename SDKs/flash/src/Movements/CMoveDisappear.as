//----------------------------------------------------------------------------------
//
// CMOVEDISAPPEAR : Mouvement disparition
//
//----------------------------------------------------------------------------------
package Movements
{
	import Objects.*;
	import Animations.*;
		
	public class CMoveDisappear extends CMove
	{
		public function CMoveDisappear()
		{
		}
		
	    public override function init(ho:CObject, mvPtr:CMoveDef):void
	    {
			hoPtr=ho;
	    }
	    public override function move():void
	    {
			if ((hoPtr.hoFlags&CObject.HOF_FADEOUT)==0)
			{
			    if (hoPtr.roa!=null)
			    {
					hoPtr.roa.animate();
					if (hoPtr.roa.raAnimForced!=CAnim.ANIMID_DISAPPEAR+1)
					{
					    hoPtr.hoAdRunHeader.destroy_Add(hoPtr.hoNumber);
					}
			    }
			}
	    }
	    public override function setXPosition(x:int):void
	    {        
			if (hoPtr.hoX!=x)
			{
			    hoPtr.hoX=x;
			    hoPtr.rom.rmMoveFlag=true;
			    hoPtr.roc.rcChanged=true;
			}
	    }
	    public override function setYPosition(y:int):void
	    {
			if (hoPtr.hoY!=y)
			{
			    hoPtr.hoY=y;
			    hoPtr.rom.rmMoveFlag=true;
			    hoPtr.roc.rcChanged=true;
			}
	    }

	}
}
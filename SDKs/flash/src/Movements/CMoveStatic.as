//----------------------------------------------------------------------------------
//
// CMOVESTATIC : Mouvement statique
//
//----------------------------------------------------------------------------------

package Movements
{
	import Objects.*;
	
	public class CMoveStatic extends CMove
	{
		public function CMoveStatic()
		{
		}

	    public override function init(ho:CObject, mvPtr:CMoveDef):void
	    {
	        hoPtr=ho;
			hoPtr.roc.rcSpeed=0;
			hoPtr.roc.rcCheckCollides=true;			//; Force la detection de collision
			hoPtr.roc.rcChanged=true;
	    }
	    public override function move():void
	    {
	        if (hoPtr.roa!=null)
	        {
				if (hoPtr.roa.animate())
				{
					return;
				}
	        }
			if (hoPtr.roc.rcCheckCollides)			//; Faut-il tester les collisions?
			{
	            hoPtr.roc.rcCheckCollides=false;		//; Va tester une fois!
	            hoPtr.hoAdRunHeader.newHandle_Collisions(hoPtr);
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
		    hoPtr.roc.rcCheckCollides=true;					//; Force la detection de collision
	    }
	    public override function setYPosition(y:int):void
	    {
			if (hoPtr.hoY!=y)
			{
			    hoPtr.hoY=y;
			    hoPtr.rom.rmMoveFlag=true;
			    hoPtr.roc.rcChanged=true;
			}
		    hoPtr.roc.rcCheckCollides=true;					//; Force la detection de collision
	    }

	}
}
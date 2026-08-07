// ------------------------------------------------------------------------------
// 
// NEAR BORDERS?
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_EXTNEARBORDERS extends CCnd implements IEvaExpObject
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return evaExpObject(rhPtr, this);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			return evaExpObject(rhPtr, this);
	    }
	    public function evaExpRoutine(hoPtr:CObject, bord:int, comp:int):Boolean
	    {
			var xw:int=hoPtr.hoAdRunHeader.rhWindowX+bord;						// Compare en X
			var x:int=hoPtr.hoX-hoPtr.hoImgXSpot;	
			if (x<=xw) return negaTRUE();
		
			xw=hoPtr.hoAdRunHeader.rhWindowX+hoPtr.hoAdRunHeader.rh3WindowSx-bord;
			x+=hoPtr.hoImgWidth;
			if (x>=xw) return negaTRUE();
		
			var yw:int=hoPtr.hoAdRunHeader.rhWindowY+bord;						// Compare en Y
			var y:int=hoPtr.hoY-hoPtr.hoImgYSpot;
			if (y<=yw) return negaTRUE();
		
			yw=hoPtr.hoAdRunHeader.rhWindowY+hoPtr.hoAdRunHeader.rh3WindowSy-bord;
			y+=hoPtr.hoImgHeight;
			if (y>=yw) return negaTRUE();
		
			return negaFALSE();
	    }
	}
}
//----------------------------------------------------------------------------------
//
// LIMITE EN BAS TERRAIN
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_PLAYYBOTTOM extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var r:int=rhPtr.rhWindowY;
			if ((rhPtr.rh3Scrolling & CRun.RH3SCROLLING_SCROLL) != 0)
				r=rhPtr.rh3DisplayY;
			r+=rhPtr.rh3WindowSy;
			if (r>rhPtr.rhLevelSy)
				r=rhPtr.rhLevelSy;
	
			rhPtr.getCurrentResult().forceInt(r);
		}    
	}
}
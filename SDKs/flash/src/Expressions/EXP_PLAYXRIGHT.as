//----------------------------------------------------------------------------------
//
// LIMITE A DROITE TERRAIN
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_PLAYXRIGHT extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var r:int=rhPtr.rhWindowX;
			if ((rhPtr.rh3Scrolling & CRun.RH3SCROLLING_SCROLL) != 0)
				r=rhPtr.rh3DisplayX;
			r+=rhPtr.rh3WindowSx;
			if (r>rhPtr.rhLevelSx)
				r=rhPtr.rhLevelSx;
	
			rhPtr.getCurrentResult().forceInt(r);
		}    
	}
}
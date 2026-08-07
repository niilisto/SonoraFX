//----------------------------------------------------------------------------------
//
// LIMITE EN HAUT TERRAIN
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_PLAYYTOP extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var r:int=rhPtr.rhWindowY;
			if ((rhPtr.rh3Scrolling & CRun.RH3SCROLLING_SCROLL) != 0)
				r=rhPtr.rh3DisplayY;
			if (r<0) 
				r=0;
	
			rhPtr.getCurrentResult().forceInt(r);
		}    
	}
}
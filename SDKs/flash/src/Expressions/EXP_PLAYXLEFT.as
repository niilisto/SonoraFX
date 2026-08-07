//----------------------------------------------------------------------------------
//
// LIMITE A GAUCHE TERRAIN
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	
	import RunLoop.*;

	public class EXP_PLAYXLEFT extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var r:int=rhPtr.rhWindowX;
			if ((rhPtr.rh3Scrolling & CRun.RH3SCROLLING_SCROLL) != 0)
				r=rhPtr.rh3DisplayX;
			if (r<0) 
				r=0;
	
			rhPtr.getCurrentResult().forceInt(r);
		}    
	}
}
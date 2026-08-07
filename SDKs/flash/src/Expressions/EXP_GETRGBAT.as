//----------------------------------------------------------------------------------
//
// COULEUR POINT IMAGE
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;
	import Banks.*;
	import Objects.*;
	import Services.*;

	public class EXP_GETRGBAT extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var hoPtr:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			rhPtr.rh4CurToken++;
			if (hoPtr==null)
			{
				rhPtr.getCurrentResult().forceInt(0);
				return;
			}
			var x:int=rhPtr.get_ExpressionInt();
			rhPtr.rh4CurToken++;
			var y:int=rhPtr.get_ExpressionInt();
	
			rhPtr.getCurrentResult().forceInt(rhPtr.getRGBAt(hoPtr, x, y));
		}    
	}
}
//----------------------------------------------------------------------------------
//
// VALEUR ABSOLUE
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_ABS extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var value:Number=rhPtr.get_ExpressionDouble();
			rhPtr.getCurrentResult().forceDouble(Math.abs(value));
		}    
	}
}
//----------------------------------------------------------------------------------
//
// EXPONANTIELLE
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_EXP extends CExp
	{
	    
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var value:Number=rhPtr.get_ExpressionDouble();
			rhPtr.getCurrentResult().forceDouble(Math.exp(value));
		}
	    
	}
}
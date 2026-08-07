//----------------------------------------------------------------------------------
//
// FLOAT TO STRING
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_ATAN2 extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{
			rhPtr.rh4CurToken++;
			var value1:Number=rhPtr.get_ExpressionDouble();
			rhPtr.rh4CurToken++;
			var value2:Number=rhPtr.get_ExpressionDouble();
		        
			rhPtr.getCurrentResult().forceDouble(Math.atan2(value1, value2)*57.295779513082320876798154814105);        
		}        
	}
}
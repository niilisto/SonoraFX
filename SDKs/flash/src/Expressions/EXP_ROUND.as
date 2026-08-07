//----------------------------------------------------------------------------------
//
// ROUND
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_ROUND extends CExp
	{
	    
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var value:Number=rhPtr.get_ExpressionDouble();
			var v:Number=Math.floor(value);
			if (value-v>0.5)
				v++;
			rhPtr.getCurrentResult().forceInt(int(v));
		}
	    
	}
}
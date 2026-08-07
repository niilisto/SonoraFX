//----------------------------------------------------------------------------------
//
// PARTIE ENTIERE
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_INT extends CExp
	{
	    
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var value:Number=rhPtr.get_ExpressionDouble();
			rhPtr.getCurrentResult().forceInt(int(value));
		}
	    
	}
}
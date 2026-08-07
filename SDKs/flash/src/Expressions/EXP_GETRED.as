//----------------------------------------------------------------------------------
//
// GET RED
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_GETRED extends CExp
	{
	    
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var rgb:int=rhPtr.get_ExpressionInt();
			rhPtr.getCurrentResult().forceInt(rgb&255);
		}
	    
	}
}
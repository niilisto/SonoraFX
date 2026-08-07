//----------------------------------------------------------------------------------
//
// LEN$
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_LEN extends CExp
	{
	    
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var pString:String=rhPtr.get_ExpressionString();
			rhPtr.getCurrentResult().forceInt(pString.length);
		}
	    
	}
}
//----------------------------------------------------------------------------------
//
// BINARY
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_BIN extends CExp
	{
	    
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var a:int=rhPtr.get_ExpressionInt();
			var s:String="0b"+a.toString(2);
			rhPtr.getCurrentResult().forceString(s);
		}	    
	}
}
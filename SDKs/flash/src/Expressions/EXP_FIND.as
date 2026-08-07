//----------------------------------------------------------------------------------
//
// FIND
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_FIND extends CExp
	{
	    
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var pMainString:String=rhPtr.get_ExpressionString();
			rhPtr.rh4CurToken++;
			var pSubString:String=rhPtr.get_ExpressionString();
			rhPtr.rh4CurToken++;
			var firstChar:int=rhPtr.get_ExpressionInt();
	
			if (firstChar>=pMainString.length)
			{
				rhPtr.getCurrentResult().forceInt(-1);
				return;
			}
			rhPtr.getCurrentResult().forceInt(pMainString.indexOf(pSubString, firstChar));
		}
	    
	}
}
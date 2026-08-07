//----------------------------------------------------------------------------------
//
// OUVERTURE PARENTHESE
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	
	import RunLoop.*;

	public class EXP_PARENTH1 extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var value:CValue=rhPtr.getExpression();
			rhPtr.getCurrentResult().forceValue(value);
		}    
	}
}
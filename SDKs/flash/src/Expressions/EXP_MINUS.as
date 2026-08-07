//----------------------------------------------------------------------------------
//
// OPERATEUR MOINS
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_MINUS extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{
			if (rhPtr.bOperande)
			{
				rhPtr.rh4CurToken++;
				rhPtr.rh4Tokens[rhPtr.rh4CurToken].evaluate(rhPtr);
				rhPtr.getCurrentResult().negate();
			}   
			else
			{     
				rhPtr.getCurrentResult().sub(rhPtr.getNextResult());
			}
		}    
	    
	}
}
//----------------------------------------------------------------------------------
//
// OPERATEUR MULTIPLY
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_MULT extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().mul(rhPtr.getNextResult());
		}    
	    
	}
}
//----------------------------------------------------------------------------------
//
// OPERATEUR DIVIDE
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_DIV extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().div(rhPtr.getNextResult());
		}    
	    
	}
}
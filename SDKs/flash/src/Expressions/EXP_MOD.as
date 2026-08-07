//----------------------------------------------------------------------------------
//
// OPERATEUR MODULO
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_MOD extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().mod(rhPtr.getNextResult());
		}    
	    
	}
}
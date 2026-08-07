//----------------------------------------------------------------------------------
//
// OPERATEUR MODULO
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_POW extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().pow(rhPtr.getNextResult());
		}    
	}
}
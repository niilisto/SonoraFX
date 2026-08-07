//----------------------------------------------------------------------------------
//
// OPERATEUR XOR
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_XOR extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().xorLog(rhPtr.getNextResult());
		}    
	}
}
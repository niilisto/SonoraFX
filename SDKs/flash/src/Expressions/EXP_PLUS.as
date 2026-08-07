//----------------------------------------------------------------------------------
//
// OPERATEUR PLUS
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_PLUS extends CExp
	{    
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().add(rhPtr.getNextResult());
		}    
	}
}
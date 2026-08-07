//----------------------------------------------------------------------------------
//
// OPERATEUR OR
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_OR extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().orLog(rhPtr.getNextResult());
		}   
	}
}
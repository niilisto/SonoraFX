//----------------------------------------------------------------------------------
//
// OPERATEUR AND
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_AND extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().andLog(rhPtr.getNextResult());
		}    
	}
}
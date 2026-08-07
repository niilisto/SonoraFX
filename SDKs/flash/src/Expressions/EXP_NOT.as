//----------------------------------------------------------------------------------
//
// OPERATEUR NOT
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_NOT extends CExp
	{
	    
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var value:int=rhPtr.get_ExpressionInt();
			rhPtr.getCurrentResult().forceInt(value^0xFFFFFFFF);
		}
	    
	}
}
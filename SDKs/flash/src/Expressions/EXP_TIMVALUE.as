//----------------------------------------------------------------------------------
//
// TIMER 1/1000
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_TIMVALUE extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().forceInt(int(rhPtr.rhTimer));
		}    
	}
}
//----------------------------------------------------------------------------------
//
// TIMER MINUTES
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_TIMMINITS extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var s:int=int(rhPtr.rhTimer/60000);
			rhPtr.getCurrentResult().forceInt(s%60);
		}    
	}
}
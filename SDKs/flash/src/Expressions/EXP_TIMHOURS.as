//----------------------------------------------------------------------------------
//
// TIMER HOURS
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_TIMHOURS extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var s:int=int(rhPtr.rhTimer/3600000);
			rhPtr.getCurrentResult().forceInt(s);
		}    
	}
}
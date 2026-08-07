//----------------------------------------------------------------------------------
//
// TIMER 1/100
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	
	import RunLoop.*;

	public class EXP_TIMCENT extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var c:int=int(rhPtr.rhTimer/10);
			rhPtr.getCurrentResult().forceInt(c%100);
		}    
	}
}
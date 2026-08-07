//----------------------------------------------------------------------------------
//
// TIMER SECONDS
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	
	import RunLoop.*;

	public class EXP_TIMSECONDS extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var s:int=int(rhPtr.rhTimer/1000);
			rhPtr.getCurrentResult().forceInt(s%60);
		}    
	}
}
//----------------------------------------------------------------------------------
//
// LIVES
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_PLALIVES extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().forceInt(rhPtr.rhApp.getLives()[oi]);
		}    
	}
}
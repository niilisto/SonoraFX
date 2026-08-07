//----------------------------------------------------------------------------------
//
// MOUSEWHEELDELTA
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;
	import Objects.*;

	public class EXP_MOUSEWHEELDELTA extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{
			rhPtr.getCurrentResult().forceInt(rhPtr.rhApp.deltaWheel*40);	
		}    
	}
}
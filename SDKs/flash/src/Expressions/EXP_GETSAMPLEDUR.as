//----------------------------------------------------------------------------------
//
// GET SAMPLE DURATION
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_GETSAMPLEDUR extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var name:String=rhPtr.get_ExpressionString();
			rhPtr.getCurrentResult().forceInt(rhPtr.rhApp.soundPlayer.getSampleDur(name));	
		}
	}
}
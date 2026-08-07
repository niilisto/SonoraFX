//----------------------------------------------------------------------------------
//
// GET SAMPLE POSITION
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_GETSAMPLEPOS extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var name:String=rhPtr.get_ExpressionString();
			rhPtr.getCurrentResult().forceInt(rhPtr.rhApp.soundPlayer.getSamplePosition(name));	
		}
	}
}
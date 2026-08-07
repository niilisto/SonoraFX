//----------------------------------------------------------------------------------
//
// GET SAMPLE VOLUME
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_GETSAMPLEVOL extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var name:String=rhPtr.get_ExpressionString();
			rhPtr.getCurrentResult().forceInt(rhPtr.rhApp.soundPlayer.getSampleVolume(name)*100+0.5);	
		}
	}
}
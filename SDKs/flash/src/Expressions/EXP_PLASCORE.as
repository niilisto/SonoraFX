//----------------------------------------------------------------------------------
//
// SCORE
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_PLASCORE extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var scores:Array=rhPtr.rhApp.getScores();
			rhPtr.getCurrentResult().forceInt(scores[oi]);
		}    
	}
}
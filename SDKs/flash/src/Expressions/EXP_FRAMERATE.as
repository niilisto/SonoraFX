//----------------------------------------------------------------------------------
//
// FRAME RATE
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	
	import RunLoop.*;

	public class EXP_FRAMERATE extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var n:int;
			var total:int;
			for (n=0; n<CRun.MAX_FRAMERATE; n++)
				total+=rhPtr.rh4FrameRateArray[n];
			rhPtr.getCurrentResult().forceInt((1000*CRun.MAX_FRAMERATE)/total);
		}    
	}
}
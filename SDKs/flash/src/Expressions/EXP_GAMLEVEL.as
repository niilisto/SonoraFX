//----------------------------------------------------------------------------------
//
// NIVEAU COURANT
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_GAMLEVEL extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var NG:int=0;
			if (rhPtr.rhApp.bShiftFrameNumber)
			{
				NG=1;
			}
			rhPtr.getCurrentResult().forceInt(rhPtr.rhApp.currentFrame-NG);
		}    
	}
}
//----------------------------------------------------------------------------------
//
// LEVEL
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	
	import RunLoop.*;

	public class EXP_GAMLEVELNEW extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{       
			var NG:int=0;
			if (rhPtr.rhApp.bShiftFrameNumber)
			{
				NG=1;
			}
			rhPtr.getCurrentResult().forceInt(rhPtr.rhApp.currentFrame+1-NG);
		}    
	}
}
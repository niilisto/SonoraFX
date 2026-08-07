//----------------------------------------------------------------------------------
//
// GET SAMPLE VOL
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_GETCHANNELVOL extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var value:Number=rhPtr.get_ExpressionInt();
			rhPtr.getCurrentResult().forceInt(rhPtr.rhApp.soundPlayer.getChannelVolume(value-1)*100+0.5);	
		}
	}
}
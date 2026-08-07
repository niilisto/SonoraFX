//----------------------------------------------------------------------------------
//
// GET SAMPLE VOL
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_GETCHANNELPOS extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var value:Number=rhPtr.get_ExpressionInt();
			rhPtr.getCurrentResult().forceInt(rhPtr.rhApp.soundPlayer.getChannelPos(value-1));	
		}
	}
}
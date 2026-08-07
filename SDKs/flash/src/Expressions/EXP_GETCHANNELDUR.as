//----------------------------------------------------------------------------------
//
// GET CHANNEL PAN
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_GETCHANNELDUR extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var value:Number=rhPtr.get_ExpressionInt();
			rhPtr.getCurrentResult().forceInt(rhPtr.rhApp.soundPlayer.getChannelDur(value-1));	
		}
	}
}
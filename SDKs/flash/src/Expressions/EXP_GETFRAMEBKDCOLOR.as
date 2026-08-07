//----------------------------------------------------------------------------------
//
// FRAME BACK COLOR
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;
	import Services.*;

	public class EXP_GETFRAMEBKDCOLOR extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().forceInt(CServices.swapRGB(rhPtr.rhFrame.leBackground));
		}    
	}
}
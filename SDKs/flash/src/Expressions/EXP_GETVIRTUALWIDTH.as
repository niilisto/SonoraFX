//----------------------------------------------------------------------------------
//
// VIRTUAL WIDTH
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_GETVIRTUALWIDTH extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().forceInt(rhPtr.rhFrame.leVirtualRect.right);
		}    
	}
}
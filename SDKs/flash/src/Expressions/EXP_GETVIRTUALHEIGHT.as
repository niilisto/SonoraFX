//----------------------------------------------------------------------------------
//
// VIRTUAL HEIGHT
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_GETVIRTUALHEIGHT extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().forceInt(rhPtr.rhFrame.leVirtualRect.bottom);
		}    
	}
}
//----------------------------------------------------------------------------------
//
// NEW LINE
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;
	import Application.*;

	public class EXP_NEWLINE extends CExp
	{
	    
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().forceString("\n");
//			rhPtr.getCurrentResult().forceString(CRunApp.debug);
		}
	    
	}
}
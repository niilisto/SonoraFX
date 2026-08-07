//----------------------------------------------------------------------------------
//
// TOTAL NUMBER OF OBJECTS
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_CRENUMBERALL extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().forceInt(rhPtr.rhNObjects);
		}    
	}
}
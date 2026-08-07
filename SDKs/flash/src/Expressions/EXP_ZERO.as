//----------------------------------------------------------------------------------
//
// ZERO
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;
	
	public class EXP_ZERO extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().forceInt(0);
		}    
	}
}
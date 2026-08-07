//----------------------------------------------------------------------------------
//
// EMPTY STRING
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;
	
	public class EXP_EMPTY extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().forceString("");
		}    
	}
}
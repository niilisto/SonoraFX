//----------------------------------------------------------------------------------
//
// GLOBAL STRING
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_STRINGGLO extends CExp
	{
	    
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;						// Saute le token
			var num:int=(rhPtr.get_ExpressionInt()-1);
			rhPtr.getCurrentResult().forceString(rhPtr.rhApp.getGlobalStringAt(num));
		}
	    
	}
}
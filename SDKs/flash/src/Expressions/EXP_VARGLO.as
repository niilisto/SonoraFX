//----------------------------------------------------------------------------------
//
// VARIABLE GLOBALE
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_VARGLO extends CExp
	{
	    
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;						// Saute le token
	
			var num:int=(rhPtr.get_ExpressionInt()-1);
			rhPtr.getCurrentResult().forceValue(rhPtr.rhApp.getGlobalValueAt(num));
		}
	    
	}
}
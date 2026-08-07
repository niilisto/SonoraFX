//----------------------------------------------------------------------------------
//
// RANDOM
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_RANDOM extends CExp
	{
	    
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;						// Saute le token
			var num:int=rhPtr.get_ExpressionInt();			// Le parametre
			rhPtr.getCurrentResult().forceInt(rhPtr.random(num));		// Genere le chiffre
		}
	}
}
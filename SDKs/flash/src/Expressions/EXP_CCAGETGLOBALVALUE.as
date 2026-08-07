//----------------------------------------------------------------------------------
//
// GLOBAL VALUE
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;
	import Objects.*;

	public class EXP_CCAGETGLOBALVALUE extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var pHo:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			rhPtr.rh4CurToken++;					// Saute le token
			var num:int=rhPtr.get_ExpressionInt();			// Le numero du flag
			if (pHo==null)
			{
				rhPtr.getCurrentResult().forceInt(0);
				return;
			}	
			rhPtr.getCurrentResult().forceValue((CCCA(pHo)).getGlobalValue(num));
		}
	    
	}
}
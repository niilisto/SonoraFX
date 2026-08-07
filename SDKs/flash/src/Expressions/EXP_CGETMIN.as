//----------------------------------------------------------------------------------
//
// VALEUR MINI COMPTEUR
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;
	import Objects.*;

	public class EXP_CGETMIN extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
	 		var hoPtr:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			if (hoPtr==null)
			{
				rhPtr.getCurrentResult().forceInt(0);
				return;
			}
			rhPtr.getCurrentResult().forceValue((CCounter(hoPtr)).cpt_GetMin());
		}
	    
	}
}
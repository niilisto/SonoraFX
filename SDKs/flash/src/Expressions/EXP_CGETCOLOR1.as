//----------------------------------------------------------------------------------
//
// COULEUR 1 COMPTEUR
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	
	import Objects.*;
	
	import RunLoop.*;
	import Services.*;

	public class EXP_CGETCOLOR1 extends CExpOi
	{    
		public override function evaluate(rhPtr:CRun):void
		{        
	 		var hoPtr:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			if (hoPtr==null)
			{
				rhPtr.getCurrentResult().forceInt(0);
				return;
			}
			var rgb:int=(CCounter(hoPtr)).cpt_GetColor1();
			rhPtr.getCurrentResult().forceInt(CServices.swapRGB(rgb));
	   }
	    
	}
}
//----------------------------------------------------------------------------------
//
// GET FONT COLOR
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;
	import Objects.*;
	import Services.*;

	public class EXP_EXTGETFONTCOLOR extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
	 		var pHo:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			if (pHo==null)
			{
				rhPtr.getCurrentResult().forceInt(0);
				return;
			}
			var rgb:int=CRun.getObjectTextColor(pHo);
			rgb=CServices.swapRGB(rgb);
			rhPtr.getCurrentResult().forceInt(rgb);
		}    
	}
}
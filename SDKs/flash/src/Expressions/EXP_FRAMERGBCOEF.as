//----------------------------------------------------------------------------------
//
// FRAME RGB COEFFICIENT
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	
	import RunLoop.*;
	import Sprites.*;
	import Services.*;
	
	public class EXP_FRAMERGBCOEF extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var effect:int = rhPtr.rhApp.effect;
			var effectParam:int = rhPtr.rhApp.effectParam;
			var rgb:int = 0;
			var rgbaCoeff:int = effectParam;
			
			if ((effect & CRSpr.BOP_MASK) == CRSpr.BOP_EFFECTEX || (effect & CRSpr.BOP_RGBAFILTER) != 0)
				rgb = CServices.swapRGB((rgbaCoeff & 0x00FFFFFF));
			else
				rgb = 0x00FFFFFF;
			
			rhPtr.getCurrentResult().forceInt(rgb);
		}
	}
}
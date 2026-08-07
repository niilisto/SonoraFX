//----------------------------------------------------------------------------------
//
// ALPHA COEFFICIENT
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	
	import Objects.*;
	
	import RunLoop.*;
	import Sprites.*;
	import Services.*;

	public class EXP_EXTALPHACOEF extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var pHo:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			if (pHo==null || (pHo!=null && pHo.ros==null))
			{
				rhPtr.getCurrentResult().forceInt(0);
				return;
			}
			var effect:int = pHo.ros.rsEffect;
			var effectParam:int = pHo.ros.rsEffectParam;
			var alpha:int = 0;
			var rgbaCoeff:int = effectParam;
			
			if ((effect & CRSpr.BOP_MASK) == CRSpr.BOP_EFFECTEX || (effect & CRSpr.BOP_RGBAFILTER) != 0)
			{
				alpha = 255 - ((rgbaCoeff >> 24)&0xFF);
			}
			else
			{
				if (effectParam == -1)
					alpha = 0;
				else
					alpha = effectParam * 2;
			}
			rhPtr.getCurrentResult().forceInt(alpha);
		}
	}
}
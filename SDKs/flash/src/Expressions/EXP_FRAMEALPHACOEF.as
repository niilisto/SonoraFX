//----------------------------------------------------------------------------------
//
// FRAME ALPHA COEFFICIENT
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	
	import RunLoop.*;
	
	import Sprites.*;
	
	public class EXP_FRAMEALPHACOEF extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var effect:int = rhPtr.rhApp.effect;
			var effectParam:int = rhPtr.rhApp.effectParam;
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
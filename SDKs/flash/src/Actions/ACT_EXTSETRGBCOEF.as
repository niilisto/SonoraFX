// -----------------------------------------------------------------------------
//
// SET RGB COEF
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Sprites.*;
	import Services.*;

	public class ACT_EXTSETRGBCOEF extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
			
			if (pHo.ros == null)
				return;
			
			var argb:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			var wasSemi:Boolean = ((pHo.ros.rsEffect & CRSpr.BOP_RGBAFILTER) == 0);
			pHo.ros.rsEffect = (pHo.ros.rsEffect & CRSpr.BOP_MASK) | CRSpr.BOP_RGBAFILTER;
			
			var rgbaCoeff:int = pHo.ros.rsEffectParam;
			var alphaPart:int;
			if (wasSemi)
			{
				if (pHo.ros.rsEffectParam == -1)
				{
					alphaPart = 0xFF000000;
				}
				else
				{
					alphaPart = (255 - (pHo.ros.rsEffectParam*2))<<24;
				}
			}
			else
			{
				alphaPart = rgbaCoeff & 0xFF000000;
			}
			
			var rgbPart:int = CServices.swapRGB(argb & 0x00FFFFFF);
			var filter:int = alphaPart | rgbPart;
			pHo.ros.rsEffectParam = filter;
			
			pHo.ros.modifSpriteEffect(pHo.ros.rsEffect, pHo.ros.rsEffectParam);
		}
	}
}
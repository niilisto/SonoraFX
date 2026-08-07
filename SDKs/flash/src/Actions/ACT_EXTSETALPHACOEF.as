// -----------------------------------------------------------------------------
//
// SET ALPHA COEF
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Sprites.*;
	import Services.*;
	
	public class ACT_EXTSETALPHACOEF extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
			
			if (pHo.ros == null)
				return;

			var alpha:int = CServices.clamp(255-rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0])), 0, 255);
			var wasSemi:Boolean = ((pHo.ros.rsEffect & CRSpr.BOP_RGBAFILTER) == 0);
			pHo.ros.rsEffect = (pHo.ros.rsEffect & CRSpr.BOP_MASK) | CRSpr.BOP_RGBAFILTER;
			
			var rgbaCoeff:int = 0x00FFFFFF;
			
			if (!wasSemi)
				rgbaCoeff = pHo.ros.rsEffectParam;
			
			var alphaPart:int = alpha << 24;
			var rgbPart:int = (rgbaCoeff & 0x00FFFFFF);
			pHo.ros.rsEffectParam = alphaPart | rgbPart;
			
			pHo.ros.modifSpriteEffect(pHo.ros.rsEffect, pHo.ros.rsEffectParam);
		}
	}
}
// -----------------------------------------------------------------------------
//
// SET FRAME ALPHA COEF
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;
	import Application.*;
	import Sprites.*;
	import Services.*;
	
	public class ACT_SETFRAMEALPHACOEF extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var alpha:int = CServices.clamp(255-rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0])), 0, 255);
			var wasSemi:Boolean = ((rhPtr.rhApp.effect & CRSpr.BOP_RGBAFILTER) == 0);
			rhPtr.rhApp.effect = (rhPtr.rhApp.effect & CRSpr.BOP_MASK) | CRSpr.BOP_RGBAFILTER;
			
			var rgbaCoeff:int = 0x00FFFFFF;
			
			if (!wasSemi)
				rgbaCoeff = rhPtr.rhApp.effectParam;
			
			var alphaPart:int = alpha << 24;
			var rgbPart:int = (rgbaCoeff & 0x00FFFFFF);
			rhPtr.rhApp.effectParam = alphaPart | rgbPart;
			
			rhPtr.rhApp.setEffect(rhPtr.rhApp.effect, rhPtr.rhApp.effectParam);
		}
	}
}
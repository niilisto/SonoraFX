// -----------------------------------------------------------------------------
//
// SET FRAME RGB COEF
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
	
	public class ACT_SETFRAMERGBCOEF extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var argb:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			var wasSemi:Boolean = ((rhPtr.rhApp.effect & CRSpr.BOP_RGBAFILTER) == 0);
			rhPtr.rhApp.effect = (rhPtr.rhApp.effect & CRSpr.BOP_MASK) | CRSpr.BOP_RGBAFILTER;
			
			var rgbaCoeff:int = rhPtr.rhApp.effectParam;
			var alphaPart:int;
			if (wasSemi)
			{
				if (rhPtr.rhApp.effectParam == -1)
				{
					alphaPart = 0xFF000000;
				}
				else
				{
					alphaPart = (255 - (rhPtr.rhApp.effectParam*2))<<24;
				}
			}
			else
			{
				alphaPart = rgbaCoeff & 0xFF000000;
			}
			
			var rgbPart:int = CServices.swapRGB(argb & 0x00FFFFFF);
			var filter:int = alphaPart | rgbPart;
			rhPtr.rhApp.effectParam = filter;
			
			rhPtr.rhApp.setEffect(rhPtr.rhApp.effect, rhPtr.rhApp.effectParam);			
		}
	}
}
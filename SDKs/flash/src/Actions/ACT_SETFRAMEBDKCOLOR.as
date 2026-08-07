// -----------------------------------------------------------------------------
//
// SET FRAME BACKGROUND COLOR
//
// -----------------------------------------------------------------------------
package Actions
{
	import Frame.CLayer;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Services.*;

	public class ACT_SETFRAMEBDKCOLOR extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var color:int;
			if ( evtParams[0].code==24)		// PARAM_COLOUR
				color=(PARAM_COLOUR(evtParams[0])).color;
			else
			{
				color=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
				color=CServices.swapRGB(color);
			}
			rhPtr.rhFrame.leBackground = color;

			var layer:CLayer=rhPtr.rhFrame.layers[0];
			layer.fillBack(rhPtr.rhFrame.leEditWinWidth, rhPtr.rhFrame.leEditWinHeight, color); 
		}
	}
}
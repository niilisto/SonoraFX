// -----------------------------------------------------------------------------
//
// SET FRAME WIDTH
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_SETFRAMEWIDTH extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var newWidth:int = rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
	
			// Set new width
			var nOldWidth:int = rhPtr.rhFrame.leWidth;
			rhPtr.rhFrame.leWidth = newWidth;
	
			// Set virtual width
			if ( nOldWidth == rhPtr.rhFrame.leVirtualRect.right )
				rhPtr.rhFrame.leVirtualRect.right = rhPtr.rhLevelSx = newWidth;
	
			// Redraw frame
			//var n:int;
			//for (n=0; n<rhPtr.rhFrame.nLayers; n++)
			//{
			//	rhPtr.rhFrame.layers[n].resetLevelBackground();
			//}
			rhPtr.drawLevel();
		}
	}
}
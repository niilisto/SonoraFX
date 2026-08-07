// -----------------------------------------------------------------------------
//
// SET FRAME HEIGHT
//
// -----------------------------------------------------------------------------
package Actions
{
	import Params.*;
	
	import RunLoop.*;

	public class ACT_SETFRAMEHEIGHT extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var newHeight:int = rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
	
			// Set new width
			var nOldHeight:int = rhPtr.rhFrame.leHeight;
			rhPtr.rhFrame.leHeight = newHeight;
	
			// Set virtual width
			if ( nOldHeight == rhPtr.rhFrame.leVirtualRect.bottom )
				rhPtr.rhFrame.leVirtualRect.bottom = rhPtr.rhLevelSy = newHeight;
	
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
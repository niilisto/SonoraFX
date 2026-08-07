// -----------------------------------------------------------------------------
//
// SET FRAME HEIGHT
//
// -----------------------------------------------------------------------------
package Actions
{
	import Params.*;
	import Application.*;
	import RunLoop.*;

	public class ACT_SETFRAMERATE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var value:int = rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			if (value >= 1 && value <= 1000)
			{
				// Get top-level application
				var app:CRunApp = rhPtr.rhApp;
				while (app.parentApp != null)
					app = app.parentApp;
				
				// Set new frame rate
				app.stage.frameRate = value;
			}
		}
	}
}
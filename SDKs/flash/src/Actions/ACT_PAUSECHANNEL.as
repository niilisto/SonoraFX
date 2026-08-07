// -----------------------------------------------------------------------------
//
// PAUSE CHANNEL
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_PAUSECHANNEL extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var channel:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			rhPtr.rhApp.soundPlayer.pauseChannel(channel-1);
		}
	}
}
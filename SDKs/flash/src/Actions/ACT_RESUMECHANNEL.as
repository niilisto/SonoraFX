// -----------------------------------------------------------------------------
//
// RESUME CHANNEL
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_RESUMECHANNEL extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var channel:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			rhPtr.rhApp.soundPlayer.resumeChannel(channel-1);
		}
	}
}
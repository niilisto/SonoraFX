// -----------------------------------------------------------------------------
//
// STOP CHANNEL
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_STOPCHANNEL extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var channel:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			rhPtr.rhApp.soundPlayer.stopChannel(channel-1);
		}
	}
}
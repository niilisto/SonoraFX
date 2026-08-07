// -----------------------------------------------------------------------------
//
// SET CHANNEL POS
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_SETCHANNELPOS extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var channel:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			var position:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]));
			if (position>=0)
			{
				rhPtr.rhApp.soundPlayer.setChannelPos(channel-1, Number(position));
			}
		}
	}
}
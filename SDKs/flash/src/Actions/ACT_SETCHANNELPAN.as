// -----------------------------------------------------------------------------
//
// SET CHANNEL PAN
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_SETCHANNELPAN extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var channel:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			var pan:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]));
			if (pan>=-100 && pan<=100)
			{
				rhPtr.rhApp.soundPlayer.setChannelPan(channel-1, (Number(pan))/100.0);
			}
		}
	}
}
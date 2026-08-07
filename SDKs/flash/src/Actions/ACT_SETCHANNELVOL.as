// -----------------------------------------------------------------------------
//
// SET CHANNEL VOLUME
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_SETCHANNELVOL extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var channel:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			var volume:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]));
			if (volume>=0 && volume<=100)
			{
				rhPtr.rhApp.soundPlayer.setChannelVolume(channel-1, Number(Number(volume))/100.0);
			}
		}
	}
}
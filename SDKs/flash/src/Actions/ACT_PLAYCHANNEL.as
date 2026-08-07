// -----------------------------------------------------------------------------
//
// PLAY CHANNEL
//
// -----------------------------------------------------------------------------
package Actions
{
	import Params.*;
	
	import RunLoop.*;

	public class ACT_PLAYCHANNEL extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var p:PARAM_SAMPLE=PARAM_SAMPLE(evtParams[0]);
			var bPrio:Boolean=(p.sndFlags&PARAM_SAMPLE.PSOUNDFLAG_UNINTERRUPTABLE)!=0;
			var channel:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]));
			rhPtr.rhApp.soundPlayer.play(p.sndHandle, 1, channel-1, bPrio);
		}
	}
}
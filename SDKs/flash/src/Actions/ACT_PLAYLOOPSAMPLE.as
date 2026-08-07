// -----------------------------------------------------------------------------
//
// PLAY AND LOOP SAMPLE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Params.*;
	
	import RunLoop.*;

	public class ACT_PLAYLOOPSAMPLE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var p:PARAM_SAMPLE=PARAM_SAMPLE(evtParams[0]);
			var nLoops:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]));
			var bPrio:Boolean=(p.sndFlags&PARAM_SAMPLE.PSOUNDFLAG_UNINTERRUPTABLE)!=0;
			rhPtr.rhApp.soundPlayer.play(p.sndHandle, nLoops, -1, bPrio);        
		}
	}
}
// -----------------------------------------------------------------------------
//
// PAUSE SAMPLE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Params.*;
	
	import RunLoop.*;

	public class ACT_PAUSESAMPLE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var p:PARAM_SAMPLE =PARAM_SAMPLE(evtParams[0]);
			rhPtr.rhApp.soundPlayer.pauseHandle(p.sndHandle);
		}
	}
}
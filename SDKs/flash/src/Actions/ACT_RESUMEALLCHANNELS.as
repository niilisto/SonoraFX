// -----------------------------------------------------------------------------
//
// RESUME ALL CHANNELS
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;

	public class ACT_RESUMEALLCHANNELS extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			rhPtr.rhApp.soundPlayer.resume();
		}
	}
}
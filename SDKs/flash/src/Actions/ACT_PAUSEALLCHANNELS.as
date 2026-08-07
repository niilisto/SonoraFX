// -----------------------------------------------------------------------------
//
// PAUSE ALL CHANNELS
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;

	public class ACT_PAUSEALLCHANNELS extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			rhPtr.rhApp.soundPlayer.pause();
		}
	}
}
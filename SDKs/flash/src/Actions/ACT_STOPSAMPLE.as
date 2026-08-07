// -----------------------------------------------------------------------------
//
// STOP SAMPLE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;

	public class ACT_STOPSAMPLE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			rhPtr.rhApp.soundPlayer.stopAllSounds();
		}
	}
}
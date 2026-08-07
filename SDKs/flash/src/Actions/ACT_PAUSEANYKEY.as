// -----------------------------------------------------------------------------
//
// PAUSE ANY TOUCHE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;

	public class ACT_PAUSEANYKEY extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			rhPtr.rh4PauseKey=-1;
			rhPtr.rhQuit=CRun.LOOPEXIT_PAUSEGAME;
		}
	}
}
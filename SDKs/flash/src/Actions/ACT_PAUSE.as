// -----------------------------------------------------------------------------
//
// PAUSE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_PAUSE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
	       	rhPtr.rh4PauseKey=PARAM_KEY(evtParams[0]).key;
			rhPtr.rhQuit=CRun.LOOPEXIT_PAUSEGAME;	       		        
		}
	}
}
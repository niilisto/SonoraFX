// -----------------------------------------------------------------------------
//
// RESTART APPLICATION
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;

	public class ACT_RESTARTGAME extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			rhPtr.rhQuit=CRun.LOOPEXIT_NEWGAME;
		}
	}
}
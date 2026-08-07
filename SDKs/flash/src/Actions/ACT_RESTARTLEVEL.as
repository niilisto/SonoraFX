// -----------------------------------------------------------------------------
//
// RESTART LEVEL
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;

	public class ACT_RESTARTLEVEL extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			rhPtr.rhQuit=CRun.LOOPEXIT_RESTART;
		}
	}
}
// -----------------------------------------------------------------------------
//
// NEXT LEVEL
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;

	public class ACT_NEXTLEVEL extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			rhPtr.rhQuit=CRun.LOOPEXIT_NEXTLEVEL;
		}
	}
}
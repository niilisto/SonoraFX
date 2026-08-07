// -----------------------------------------------------------------------------
//
// END APPLICATION
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;

	public class ACT_ENDGAME extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			rhPtr.rhQuit=CRun.LOOPEXIT_ENDGAME;
		}
	}
}
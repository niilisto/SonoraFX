// -----------------------------------------------------------------------------
//
// SHOW CURSOR
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;

	public class ACT_SHOWCURSOR extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			if (rhPtr.rhMouseUsed==0)
			{
				rhPtr.showMouse();
			}
		}
	}
}
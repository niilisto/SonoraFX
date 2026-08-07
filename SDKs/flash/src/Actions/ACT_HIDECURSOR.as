// -----------------------------------------------------------------------------
//
// HIDE CURSOR
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;

	public class ACT_HIDECURSOR extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			if (rhPtr.rhMouseUsed==0)
			{
				rhPtr.hideMouse();
			}
		}
	}
}
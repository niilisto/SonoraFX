// -----------------------------------------------------------------------------
//
// RESTORE INPUT
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;

	public class ACT_RESTINPUT extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			rhPtr.rh2InputMask[evtOi]=0xFF;	
		}
	}
}
// -----------------------------------------------------------------------------
//
// DISABLE INPUT
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;

	public class ACT_NOINPUT extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			rhPtr.rh2InputMask[evtOi]=0;										// Plus d'entree
		}
	}
}
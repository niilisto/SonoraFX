// -----------------------------------------------------------------------------
//
// WRAP
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Objects.*;
	import Movements.*;

	public class ACT_EXTWRAP extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;

			if (pHo.rom!=null)
			{
				pHo.rom.rmEventFlags|=CRMvt.EF_WRAP;				// Il faut wrapper
			}
		}
	}
}
// -----------------------------------------------------------------------------
//
// SHOW
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import RunLoop.*;
	
	import Sprites.*;

	public class ACT_EXTSHOW extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject =rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) return;       
			CRun.objectShow(pHo);
		}
	}
}
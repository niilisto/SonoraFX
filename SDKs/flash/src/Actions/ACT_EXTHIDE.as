// -----------------------------------------------------------------------------
//
// HIDE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Objects.*;
	import Sprites.*;

	public class ACT_EXTHIDE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
			CRun.objectHide(pHo);
		}
	}
}
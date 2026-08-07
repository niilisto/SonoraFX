// -----------------------------------------------------------------------------
//
// RESTORE DIRECTION
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Objects.*;

	public class ACT_EXTRESTDIR extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			pHo.roa.animDir_Restore();
			pHo.roc.rcChanged=true;
		}
	}
}
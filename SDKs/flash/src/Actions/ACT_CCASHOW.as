// -----------------------------------------------------------------------------
//
// SHOW
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import RunLoop.*;

	public class ACT_CCASHOW extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			(CCCA(pHo)).show();	
		}
	}
}
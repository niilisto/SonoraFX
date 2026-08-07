// -----------------------------------------------------------------------------
//
// SHUFFLE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import RunLoop.*;

	public class ACT_EXTSHUFFLE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) return;
	
			rhPtr.rhEvtProg.rh2ShuffleBuffer.add(pHo);
		}
	}
}
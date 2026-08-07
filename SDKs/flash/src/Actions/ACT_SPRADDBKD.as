// -----------------------------------------------------------------------------
//
// SPRITE ADD BACKGROUND
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_SPRADDBKD extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			// Un cran d'animation sans effet
			if (pHo.roa!=null)
				pHo.roa.animIn(0);
	
			rhPtr.activeToBackdrop(pHo, (PARAM_SHORT(evtParams[0])).value);
		}
	}
}
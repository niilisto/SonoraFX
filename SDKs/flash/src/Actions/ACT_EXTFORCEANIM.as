// -----------------------------------------------------------------------------
//
// FORCE ANIMATION
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Objects.*;
	import Params.*;

	public class ACT_EXTFORCEANIM extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			var ani:int;
			if (evtParams[0].code==10)	    // PARAM_ANIMATION)
				ani=(PARAM_SHORT(evtParams[0])).value;
			else
				ani=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
	
			pHo.roa.animation_Force(ani);
			pHo.roc.rcChanged=true;				// Build 243	
		}
	}
}
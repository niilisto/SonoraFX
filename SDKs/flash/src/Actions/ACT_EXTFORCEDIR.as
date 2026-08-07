// -----------------------------------------------------------------------------
//
// FORCE DIRECTION
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Objects.*;
	import Params.*;

	public class ACT_EXTFORCEDIR extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			var ani:int;
			if (evtParams[0].code==29)	    // PARAM_NEWDIRECTION)
				ani=rhPtr.get_Direction( (PARAM_INT(evtParams[0])).value );
			else
				ani=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
	
			pHo.roa.animDir_Force(ani);
			pHo.roc.rcChanged=true;				// Build 243	
		}
	}
}
// -----------------------------------------------------------------------------
//
// FORCE ANIMATION FRAME
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;
	import Objects.*;

	public class ACT_EXTFORCEFRAME extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			var frame:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));

			pHo.roa.animFrame_Force(frame);
			pHo.roc.rcChanged=true;         
		}
	}
}
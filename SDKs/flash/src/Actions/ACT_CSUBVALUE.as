// -----------------------------------------------------------------------------
//
// COUNTER SUBTRACT VALUE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Expressions.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_CSUBVALUE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			var pValue:CValue=rhPtr.get_EventExpressionAny(CParamExpression(evtParams[0]));
			(CCounter(pHo)).cpt_Sub(pValue);
		}
	}
}
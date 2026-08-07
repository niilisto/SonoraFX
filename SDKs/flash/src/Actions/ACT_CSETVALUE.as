// -----------------------------------------------------------------------------
//
// SET COUNTER VALUE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Expressions.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_CSETVALUE extends CAct
	{    
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			var pValue:CValue=rhPtr.get_EventExpressionAny(CParamExpression(evtParams[0]));
			var pCounter:CCounter=CCounter(pHo);
			pCounter.cpt_ToFloat(pValue);
			pCounter.cpt_Change(pValue);
		}
	}
}
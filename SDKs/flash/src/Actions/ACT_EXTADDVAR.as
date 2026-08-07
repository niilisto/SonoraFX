// -----------------------------------------------------------------------------
//
// ADD TO ALTERABLE VALUE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Expressions.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Values.*;

	public class ACT_EXTADDVAR extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			var num:int;
			if (evtParams[0].code==53)
				num=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			else
				num=(PARAM_SHORT(evtParams[0])).value;
	
			if (num>=0 && num<CRVal.VALUES_NUMBEROF_ALTERABLE)
			{
				if (pHo.rov!=null)
				{
					var pValue2:CValue=rhPtr.get_EventExpressionAny(CParamExpression(evtParams[1]));
					pHo.rov.getValue(num).add(pValue2);
				}
			}        
		}
	}
}
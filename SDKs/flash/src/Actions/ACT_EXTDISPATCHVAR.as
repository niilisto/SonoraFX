// -----------------------------------------------------------------------------
//
// DISPATCH VAR
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_EXTDISPATCHVAR extends CAct
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
	
			var pBuffer:PARAM_INT=PARAM_INT(evtParams[2]);
			if (rhPtr.rhEvtProg.rh2ActionLoopCount==0)
			{
				pBuffer.value=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]));
			}
			else
			{
				pBuffer.value++;
			}
			if (pHo.rov!=null)
			{
				pHo.rov.getValue(num).forceInt(pBuffer.value);
			}        
		}
	}
}
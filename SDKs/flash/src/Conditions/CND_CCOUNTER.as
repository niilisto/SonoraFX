// ------------------------------------------------------------------------------
// 
// COUNTER EQUALS
// 
// ------------------------------------------------------------------------------

package Conditions
{
	import Expressions.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_CCOUNTER extends CCnd
	{    
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var pHo:CObject=rhPtr.rhEvtProg.evt_FirstObject(evtOiList);
	        var cpt:int=rhPtr.rhEvtProg.evtNSelectedObjects;
			var value1:CValue=new CValue(0);
			while(pHo!=null)
			{
			    value1.forceValue((CCounter(pHo)).cpt_GetValue());
			    var value2:CValue=rhPtr.get_EventExpressionAny(CParamExpression(evtParams[0]));
			    if (CRun.compareTo(value1, value2, (CParamExpression(evtParams[0])).comparaison)==false)
			    {
					cpt--;
					rhPtr.rhEvtProg.evt_DeleteCurrentObject();
			    }
			    pHo=rhPtr.rhEvtProg.evt_NextObject();
			}
			return (cpt!=0);
	    }
	}
}
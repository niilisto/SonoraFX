// ------------------------------------------------------------------------------
// 
// COMPARE TO ALTERABLE VALUE
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Expressions.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Values.*;
	
	public class CND_EXTCMPVAR extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			// Boucle d'exploration
			var pHo:CObject=rhPtr.rhEvtProg.evt_FirstObject(evtOiList);
			if (pHo==null) return false;
			
			var cpt:int=rhPtr.rhEvtProg.evtNSelectedObjects;
			var value1:CValue=new CValue(0);
			var value2:CValue;
			var p:CParamExpression=CParamExpression(evtParams[1]);
			do
			{
			    var num:int;
			    if (evtParams[0].code==53)		// PARAM_ALTVALUE_EXP)
					num=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			    else
					num=(PARAM_SHORT(evtParams[0])).value;
					
			    if (num>=0 && num<CRVal.VALUES_NUMBEROF_ALTERABLE && pHo.rov!=null)
			    {
					value1.forceValue(pHo.rov.getValue(num));
					value2=rhPtr.get_EventExpressionAny(p);
			
					if (CRun.compareTo(value1, value2, p.comparaison)==false)
					{
					    cpt--;
					    rhPtr.rhEvtProg.evt_DeleteCurrentObject();
					}
			    }
			    else
			    {
					cpt--;
					rhPtr.rhEvtProg.evt_DeleteCurrentObject();
			    }
			    pHo=rhPtr.rhEvtProg.evt_NextObject();
			}while(pHo!=null);	
			return (cpt!=0);
	    }
	}
}
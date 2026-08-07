// ------------------------------------------------------------------------------
// 
// CND_CHOOSEVALUE_OLD
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Expressions.*;
	
	import OI.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_CHOOSEVALUE_OLD extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var cpt:int=0;
			
			// Boucle d'exploration
			var pHo:CObject=rhPtr.rhEvtProg.evt_FirstObjectFromType(COI.OBJ_SPR);		//!!! QUE FAIRE?
			while(pHo!=null)
			{
			    cpt++;
		
			    var number:int;
			    if (evtParams[0].code==53)	    // pEvp->evpCode==PARAM_ALTVALUE_EXP
					number=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			    else
					number=(PARAM_SHORT(evtParams[0])).value;
			    var value2:CValue=rhPtr.get_EventExpressionAny(CParamExpression(evtParams[1]));
		
			    if (pHo.rov!=null)
			    {
					var value:CValue=new CValue(0);
					value.forceValue(pHo.rov.getValue(number));
					var comp:int=(CParamExpression(evtParams[1])).comparaison;
					if (CRun.compareTo(value, value2, comp)==false)
					{
					    rhPtr.rhEvtProg.evt_DeleteCurrentObject();
					    cpt--;
					}
			    }
			    pHo=rhPtr.rhEvtProg.evt_NextObjectFromType();
			};
			// Vrai / Faux?
			if (cpt!=0) 
			    return true;
			return false;        
	    }
	}
}
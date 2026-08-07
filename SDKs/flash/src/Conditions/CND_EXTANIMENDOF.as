// ------------------------------------------------------------------------------
// 
// END OF ANIMATION
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_EXTANIMENDOF extends CCnd implements IEvaExpObject, IEvaObject
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			var ani:int;
			if (evtParams[0].code==10)	// PARAM_ANIMATION)
			{
			    ani=(PARAM_SHORT(evtParams[0])).value;						//; Comparee au parametre animation
			}	
			else
			{
			    ani=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			}
		
			if (ani!=rhPtr.rhEvtProg.rhCurParam0) 
			    return false;				// L'animation courante
			rhPtr.rhEvtProg.evt_AddCurrentObject(hoPtr);	// Stocke l'objet courant
			return true;
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			if (evtParams[0].code==10)		// PARAM_ANIMATION)					// Le parametre direction?
			    return evaObject(rhPtr, this);
		
			return evaExpObject(rhPtr, this);					// Une expression
	    }
	    public function evaExpRoutine(hoPtr:CObject, value:int, comp:int):Boolean
	    {
			if (value!=hoPtr.roa.raAnimOn) 
			    return false;
			if (hoPtr.roa.raAnimNumberOfFrame==0) 
			    return true;
			return false;
	    }
	    public function evaObjectRoutine(hoPtr:CObject):Boolean
	    {
			var anim:int=(PARAM_SHORT(evtParams[0])).value;
			if (anim!=hoPtr.roa.raAnimOn) 
			    return false;
			if (hoPtr.roa.raAnimNumberOfFrame==0) 
			    return true;
			return false;
	    }
	}
}
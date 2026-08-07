// ------------------------------------------------------------------------------
// 
// CND_NUMOFALLZONE_OLD
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Expressions.*;
	
	import OI.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_NUMOFALLZONE_OLD extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			// Le nombre d'objets
			rhPtr.rhEvtProg.count_ZoneTypeObjects(PARAM_ZONE(evtParams[0]), -1, COI.OBJ_SPR);
		
			// Le parametre
			var value2:CValue=rhPtr.get_EventExpressionAny(CParamExpression(evtParams[1]));
			var comp:int=(CParamExpression(evtParams[1])).comparaison;
			var value:CValue=new CValue(0);
			value.forceInt(rhPtr.rhEvtProg.evtNSelectedObjects);
			return CRun.compareTo(value, value2, comp);
	    }
	}
}
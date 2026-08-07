// ------------------------------------------------------------------------------
// 
// COMPARE TO NUMBER OF OBJECTS IN ZONE
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_EXTNUMBERZONE extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var count:int=rhPtr.rhEvtProg.count_ZoneOneObject(evtOiList, PARAM_ZONE(evtParams[0]));
			var number:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]));
			return CRun.compareTer(count, number, (CParamExpression(evtParams[1])).comparaison);
	    }
	}
}
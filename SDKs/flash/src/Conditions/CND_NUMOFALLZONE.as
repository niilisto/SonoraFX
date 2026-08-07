// ------------------------------------------------------------------------------
// 
// NUMBER OF OBJECTS IN A ZONE
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_NUMOFALLZONE extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			// Le nombre d'objets
			rhPtr.rhEvtProg.count_ZoneTypeObjects(PARAM_ZONE(evtParams[0]), -1, 0);
			return compareCondition(rhPtr, 1, rhPtr.rhEvtProg.evtNSelectedObjects);
	    }
	}
}
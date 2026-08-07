// ------------------------------------------------------------------------------
// 
// NO MORE OBJECTS IN A ZONE
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_NOMOREALLZONE extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var p:PARAM_ZONE=PARAM_ZONE(evtParams[0]);
			rhPtr.rhEvtProg.count_ZoneTypeObjects(p, -1, 0);
			if (rhPtr.rhEvtProg.evtNSelectedObjects!=0) 
			    return false;
			return true;
	    }
	}
}
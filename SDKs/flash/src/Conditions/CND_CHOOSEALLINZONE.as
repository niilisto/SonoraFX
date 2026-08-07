// ------------------------------------------------------------------------------
// 
// PICK OBJECTS IN ZONE
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_CHOOSEALLINZONE extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var p:PARAM_ZONE=PARAM_ZONE(evtParams[0]);
			if (rhPtr.rhEvtProg.select_ZoneTypeObjects(p, 0)!=0) 
			    return true;
			return false;	    
	    }
	}
}
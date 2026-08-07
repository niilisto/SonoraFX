// ------------------------------------------------------------------------------
// 
// CND_NOMOREALLZONE_OLD
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import OI.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_NOMOREALLZONE_OLD extends CCnd
	{	    
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			rhPtr.rhEvtProg.count_ZoneTypeObjects(PARAM_ZONE(evtParams[0]), -1, COI.OBJ_SPR);
			if (rhPtr.rhEvtProg.evtNSelectedObjects!=0) 
			    return false;
			return true;
	    }
	}
}
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
	
	public class CND_CHOOSEZONE extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var p:PARAM_ZONE=PARAM_ZONE(evtParams[0]);
			rhPtr.rhEvtProg.count_ZoneTypeObjects(p, -1, 0);			// Compte le objets	
			if (rhPtr.rhEvtProg.evtNSelectedObjects==0) 
			    return false;
			
			var rnd:int=rhPtr.random(rhPtr.rhEvtProg.evtNSelectedObjects);
			var pHo:CObject=rhPtr.rhEvtProg.count_ZoneTypeObjects(p, rnd, 0);		// Pointe le bon objet
			rhPtr.rhEvtProg.evt_DeleteCurrent();
			rhPtr.rhEvtProg.evt_AddCurrentObject(pHo);
			return true;
	    }
	}
}
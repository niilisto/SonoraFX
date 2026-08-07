// ------------------------------------------------------------------------------
// 
// CND_CHOOSEZONE_OLD
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import OI.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_CHOOSEZONE_OLD extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var p:PARAM_ZONE=PARAM_ZONE(evtParams[0]);
			rhPtr.rhEvtProg.count_ZoneTypeObjects(p, -1, COI.OBJ_SPR);			// Compte le objets	
			if (rhPtr.rhEvtProg.evtNSelectedObjects==0) 
			    return false;
			
			var rnd:int=rhPtr.random(rhPtr.rhEvtProg.evtNSelectedObjects);
			var pHo:CObject=rhPtr.rhEvtProg.count_ZoneTypeObjects(p, rnd, COI.OBJ_SPR);		// Pointe le bon objet
			rhPtr.rhEvtProg.evt_DeleteCurrent();
			rhPtr.rhEvtProg.evt_AddCurrentObject(pHo);
			return true;
	    }
	}
}
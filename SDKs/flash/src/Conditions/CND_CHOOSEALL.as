// ------------------------------------------------------------------------------
// 
// PICK ALL OBJECTS
// 
// ------------------------------------------------------------------------------

package Conditions
{
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_CHOOSEALL extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			rhPtr.rhEvtProg.count_ObjectsFromType(0, -1);	//; Trouve l'objet a choisir
			if (rhPtr.rhEvtProg.evtNSelectedObjects==0) 
			    return false;
			var rnd:int=rhPtr.random(rhPtr.rhEvtProg.evtNSelectedObjects);
			var pHo:CObject=rhPtr.rhEvtProg.count_ObjectsFromType(0, rnd);
			rhPtr.rhEvtProg.evt_DeleteCurrent();				// Vire tout
			rhPtr.rhEvtProg.evt_AddCurrentObject(pHo);					// Met le seul
			return true;
	    }
	}
}
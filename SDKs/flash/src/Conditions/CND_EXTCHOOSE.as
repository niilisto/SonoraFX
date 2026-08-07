// ------------------------------------------------------------------------------
// 
// PICK AN OBJECT
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Conditions.*;
	import RunLoop.*;
	import Objects.*;
	
	public class CND_EXTCHOOSE extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun) :Boolean
	    {
			rhPtr.rhEvtProg.count_ObjectsFromOiList(evtOiList, -1);		// Combien d'objets?
			if (rhPtr.rhEvtProg.evtNSelectedObjects==0) 
				return false;
			var rnd:int=rhPtr.random(rhPtr.rhEvtProg.evtNSelectedObjects);
			var pHo:CObject=rhPtr.rhEvtProg.count_ObjectsFromOiList(evtOiList, rnd);	// Va choisir
			rhPtr.rhEvtProg.evt_ForceOneObject(evtOiList, pHo);
			return true;
	    }
	}
}
// ------------------------------------------------------------------------------
// 
// CND_NUMOFALLOBJECT_OLD
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import OI.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_NUMOFALLOBJECT_OLD extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			rhPtr.rhEvtProg.count_ObjectsFromType(COI.OBJ_SPR, -1);
			return compareCondition(rhPtr, 0, rhPtr.rhEvtProg.evtNSelectedObjects);
	    }
	}
}
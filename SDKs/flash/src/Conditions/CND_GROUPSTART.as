//----------------------------------------------------------------------------------
//
// Start of group
//
//----------------------------------------------------------------------------------
package Conditions
{
	import Events.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_GROUPSTART extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
	        return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var pEvg:CEventGroup=rhPtr.rhEvtProg.rhEventGroup;
			if ((pEvg.evgFlags&CEventGroup.EVGFLAGS_ONCE)!=0)
			    return false;					// Deja evalue?
			pEvg.evgFlags|=CEventGroup.EVGFLAGS_ONCE;		//; Marque pour le prochain!
			return true;
	    }    
	}
}
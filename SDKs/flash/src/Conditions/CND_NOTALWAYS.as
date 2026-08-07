//----------------------------------------------------------------------------------
//
// NOT ALWAYS
//
//----------------------------------------------------------------------------------
package Conditions
{
	import Events.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_NOTALWAYS extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
	        return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var pEvg:CEventGroup=rhPtr.rhEvtProg.rhEventGroup;
			if ((pEvg.evgFlags&CEventGroup.EVGFLAGS_NOTALWAYS)!=0)
			    return true;				// Deja evalue?
			if ((pEvg.evgFlags&CEventGroup.EVGFLAGS_NOMORE)!=0)
			    return false;				//; Verification, valide?
			pEvg.evgInhibit=-2;											// Premier coup!
			pEvg.evgFlags|=CEventGroup.EVGFLAGS_NOTALWAYS;
			return true;
	    }    
	}
}
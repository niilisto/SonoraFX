//----------------------------------------------------------------------------------
//
// ON GROUP ACTIVATED
//
//----------------------------------------------------------------------------------
package Conditions
{
	import Events.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_GROUPACTIVATED extends CCnd
	{   
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
	        return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {	
			var p:PARAM_GROUPOINTER=PARAM_GROUPOINTER(evtParams[0]);
			var evgPtr:CEventGroup=rhPtr.rhEvtProg.events[p.pointer];
			if ((evgPtr.evgFlags & CEventGroup.EVGFLAGS_INACTIVE) != 0)
				return negaFALSE();
			return negaTRUE();
	    }   
	}
}
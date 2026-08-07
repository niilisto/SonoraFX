// ------------------------------------------------------------------------------
// 
// TIMER EQUALS
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Events.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_TIMER extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			if ((evtFlags&CEvent.EVFLAGS_DONE)!=0)
			    return  false;	
		
			var p:PARAM_TIME=PARAM_TIME(evtParams[0]);
			var time:int=p.timer;
			if (rhPtr.rhTimer<time) 
			    return false;				// Compare au timer
			evtFlags|=CEvent.EVFLAGS_DONE;			// Marque l'evenement
			return true;
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			return false;        
	    }
	}
}
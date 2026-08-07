// ------------------------------------------------------------------------------
// 
// EVERY
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_EVERY extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var p:PARAM_EVERY=PARAM_EVERY(evtParams[0]);
		
			p.compteur-=rhPtr.rhTimerDelta;
			if (p.compteur>0) 
			    return false;	
			p.compteur+=p.delay;
			return true;
	    }
	}
}
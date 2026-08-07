// ------------------------------------------------------------------------------
// 
// JOYSTICK PRESSED
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_JOYPRESSED extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			var joueur:int=evtOi;						//; Le numero du player
			if (joueur!=rhPtr.rhEvtProg.rhCurOi) 
			    return false;
		
			var j:int=rhPtr.rhEvtProg.rhCurParam0;
			var p:PARAM_SHORT=PARAM_SHORT(evtParams[0]);
			j&=p.value;
			if (j!=p.value) 
			    return false;
			return true;
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var joueur:int=evtOi;						//; Le numero du player
			var b:int=(rhPtr.rh2NewPlayer[joueur]&rhPtr.rhPlayer[joueur]);
		
			var s:int=b;
			var p:PARAM_SHORT=PARAM_SHORT(evtParams[0]);
			s&=p.value;
			if (p.value!=s) 
			    return false;
			return true;
	    }
	}
}
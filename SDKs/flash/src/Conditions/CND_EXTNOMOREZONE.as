// ------------------------------------------------------------------------------
// 
// NO MORE OBJECT IN ZONE
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_EXTNOMOREZONE extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var count:int=rhPtr.rhEvtProg.count_ZoneOneObject(evtOiList, PARAM_ZONE(evtParams[0]));
			return count==0;
	    }
	}
}
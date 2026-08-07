// ------------------------------------------------------------------------------
// 
// NO MORE LIVE
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_NOMORELIVE extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			if (rhPtr.rhApp.getLives()[evtOi]!=0)
			    return false;
			return true;
	    }
	}
}
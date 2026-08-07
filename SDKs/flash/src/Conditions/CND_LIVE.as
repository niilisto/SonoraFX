// ------------------------------------------------------------------------------
// 
// LIVES
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_LIVE extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			return compareCondition(rhPtr, 0, rhPtr.rhApp.getLives()[evtOi]);
	    }
	}
}
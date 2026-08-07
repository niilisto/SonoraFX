// ------------------------------------------------------------------------------
// 
// START OF FRAME
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_START extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			if (rhPtr.rhLoopCount>2) 
			    return false;
			return true;
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			if (rhPtr.rhLoopCount>2) 
			    return false;
			return true;
	    }
	}
}
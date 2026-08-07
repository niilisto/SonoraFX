// ------------------------------------------------------------------------------
// 
// MOUSE WHEEL DOWN
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class CND_MOUSEWHEELDOWN  extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return true;
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
	    	if (rhPtr.rhWheelCount==rhPtr.rh4EventCount)
	    	{
	    		return true;
	    	}
			return false;
	    }
	}
}
// ------------------------------------------------------------------------------
// 
// END OF PAUSE
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_ENDOFPAUSE extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return true;        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			if (rhPtr.rh4EndOfPause!=rhPtr.rhLoopCount-1) 
			    return false;
			return true;
	    }
	}
}
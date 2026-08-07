// ------------------------------------------------------------------------------
// 
// QUIT APPLICATION?
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_QUITAPPLICATION extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return true;        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			return false;        
	    }
	}
}
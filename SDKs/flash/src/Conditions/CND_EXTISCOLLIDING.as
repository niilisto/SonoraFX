// ------------------------------------------------------------------------------
// 
// IS COLLIDING?
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_EXTISCOLLIDING extends CCnd
	{    
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return isColliding(rhPtr);        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			return isColliding(rhPtr);
	    }
	}
}
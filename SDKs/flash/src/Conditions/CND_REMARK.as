//----------------------------------------------------------------------------------
//
// REMARK
//
//----------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_REMARK extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
	        return false;
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
	        return false;
	    }    
	}
}
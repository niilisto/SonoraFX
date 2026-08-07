// ------------------------------------------------------------------------------
// 
// IS FLAG SET?
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_EXTFLAGSET extends CCnd implements IEvaExpObject
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return evaExpObject(rhPtr, this);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			return evaExpObject(rhPtr, this);
	    }
	    public function evaExpRoutine(hoPtr:CObject, value:int, comp:int):Boolean
	    {
			value&=31;
			if (hoPtr.rov!=null)
			{
			    if ( (hoPtr.rov.rvValueFlags&(1<<value))!=0 ) 
			    {
			    	return true;
			    }
			}
			return false;
	    }
	}
}
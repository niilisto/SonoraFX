// ------------------------------------------------------------------------------
// 
// COMPARE TO FIXED VALUE
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_EXTCMPVARFIXED extends CCnd implements IEvaExpObject
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
			var fixed:int=(hoPtr.hoCreationId<<16)|( (hoPtr.hoNumber)&0xFFFF );
			return CRun.compareTer(fixed, value, comp);
	    }
	}
}
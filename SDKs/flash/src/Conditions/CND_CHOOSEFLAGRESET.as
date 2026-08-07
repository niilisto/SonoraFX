// ------------------------------------------------------------------------------
// 
// CHOOSE OBJECTS WITH FLAG RESET
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_CHOOSEFLAGRESET extends CCnd implements IChooseValue
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			return evaChooseValue(rhPtr, this);
	    }
	    public function evaluate(pHo:CObject, value:int):Boolean
	    {
			if (pHo.rov!=null)
			{
			    if ((pHo.rov.rvValueFlags&(1<<value))==0) 
				return true;
			}
			return false;
	    }
	}
}
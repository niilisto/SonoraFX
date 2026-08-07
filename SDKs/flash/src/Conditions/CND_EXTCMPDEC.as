// ------------------------------------------------------------------------------
// 
// COMPARE TO DEC
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_EXTCMPDEC extends CCnd implements IEvaExpObject
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
			return CRun.compareTer(hoPtr.rom.rmMovement.rmDec, value, comp);
	    }
	}
}
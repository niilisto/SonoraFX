// ------------------------------------------------------------------------------
// 
// IS REVERSED?
// 
// ------------------------------------------------------------------------------

package Conditions
{
	import Conditions.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_EXTREVERSED extends CCnd implements IEvaObject
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return evaObject(rhPtr, this);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			return evaObject(rhPtr, this);
	    }
	    public function evaObjectRoutine(hoPtr:CObject):Boolean
	    {
			if (hoPtr.rom.rmReverse==0) 
			    return negaFALSE();
			return negaTRUE();
	    }
	}
}
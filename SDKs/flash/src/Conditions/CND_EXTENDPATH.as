// ------------------------------------------------------------------------------
// 
// END OF PATH?
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Movements.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_EXTENDPATH extends CCnd implements IEvaObject
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return true;        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			return evaObject(rhPtr, this);
	    }
	    public function evaObjectRoutine(hoPtr:CObject):Boolean
	    {
			if (hoPtr.roc.rcMovementType!=CMoveDef.MVTYPE_TAPED) 
			    return false;
			return checkMark(hoPtr.hoAdRunHeader, hoPtr.hoMark2);
	    }
	}
}
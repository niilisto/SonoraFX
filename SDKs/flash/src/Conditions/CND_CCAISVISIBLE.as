// ------------------------------------------------------------------------------
// 
// CCA VISIBLE?
// 
// ------------------------------------------------------------------------------

package Conditions
{	
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_CCAISVISIBLE extends CCnd implements IEvaObject
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			return evaObject(rhPtr, this);
	    }
	    public function evaObjectRoutine(hoPtr:CObject):Boolean
	    {
			if ((CCCA(hoPtr)).isVisible())
				return negaTRUE();
			else 
				return negaFALSE();
	    }        
	}
}
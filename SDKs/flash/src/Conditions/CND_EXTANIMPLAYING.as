// ------------------------------------------------------------------------------
// 
// IS ANIMATION PLAYING?
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_EXTANIMPLAYING extends CCnd implements IEvaExpObject, IEvaObject
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			if (evtParams[0].code==10)		// PARAM_ANIMATION)					// Le parametre direction?
			    return evaObject(rhPtr, this);
			return evaExpObject(rhPtr, this);					// Une expression
	    }
	    public function evaExpRoutine(hoPtr:CObject, value:int, comp:int):Boolean
	    {
			if (value!=hoPtr.roa.raAnimOn) 
			    return negaFALSE();
			if (hoPtr.roa.raAnimNumberOfFrame!=0) 
			    return negaTRUE();
			return negaFALSE();
	    }
	    public function evaObjectRoutine(hoPtr:CObject):Boolean
	    {
			var anim:int=(PARAM_SHORT(evtParams[0])).value;
			if (anim!=hoPtr.roa.raAnimOn) 
			    return negaFALSE();
			if (hoPtr.roa.raAnimNumberOfFrame!=0) 
			    return negaTRUE();
			return negaFALSE();
	    }    
	}
}
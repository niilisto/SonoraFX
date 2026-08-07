// ------------------------------------------------------------------------------
// 
// FACING A DIRECTION?
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_EXTFACING extends CCnd implements IEvaExpObject, IEvaObject
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);
	   	}
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			if (evtParams[0].code==29)		// PARAM_NEWDIRECTION)					// Le parametre direction?
			    return evaObject(rhPtr, this);
			return evaExpObject(rhPtr, this);					// Une expression
	    }
	    public function evaObjectRoutine(hoPtr:CObject):Boolean
	    {
			var mask:int=(PARAM_INT(evtParams[0])).value;
			var dir:int;
			var i:int=1;
			for (dir=0; dir<32; dir++)
			{
				if ( ((i<<dir)&mask) != 0 )
			    {
					if (hoPtr.hoAdRunHeader.getDir(hoPtr)==dir) 
					{
					    return negaTRUE();
					}
			    }
			}
			return negaFALSE();
	    }    
	    public function evaExpRoutine(hoPtr:CObject, value:int, comp:int):Boolean
	    {
			value&=31;
			if (hoPtr.hoAdRunHeader.getDir(hoPtr)==value) 
			{
			    return negaTRUE();
			}
			return negaFALSE();
	    }
	}
}
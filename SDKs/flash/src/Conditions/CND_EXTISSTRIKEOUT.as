// ------------------------------------------------------------------------------
// 
// IS STRIKED OUT?
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import RunLoop.*;
	
	import Services.CFontInfo;
	
	public class CND_EXTISSTRIKEOUT extends CCnd implements IEvaObject
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return evaObject(rhPtr, this);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			return evaObject(rhPtr, this);
	    }
	    public function evaObjectRoutine(pHo:CObject):Boolean
	    {
			var info:CFontInfo=CRun.getObjectFont(pHo);
			if (info.lfStrikeOut!=0)
			    return true;
			return false;
	    }
	}
}
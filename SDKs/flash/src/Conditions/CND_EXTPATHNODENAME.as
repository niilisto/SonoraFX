// ------------------------------------------------------------------------------
// 
// NODE NAME REACHED?
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Movements.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_EXTPATHNODENAME extends CCnd implements IEvaObject
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			var pName:String=rhPtr.get_EventExpressionString(CParamExpression(evtParams[0]));
			if (hoPtr.hoMT_NodeName!=null)
			{
			    if (hoPtr.hoMT_NodeName==pName)
			    {
					return true;
			    }
			}
			return false;
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			return evaObject(rhPtr, this);        
	    }
	    public function evaObjectRoutine(hoPtr:CObject):Boolean
	    {
			if (hoPtr.roc.rcMovementType!=CMoveDef.MVTYPE_TAPED) 
			    return false;
			if (checkMark(hoPtr.hoAdRunHeader, hoPtr.hoMark1))
			{
			    var pName:String=hoPtr.hoAdRunHeader.get_EventExpressionString(CParamExpression(evtParams[0]));
			    if (hoPtr.hoMT_NodeName!=null)
			    {
					if (hoPtr.hoMT_NodeName==pName)
					{
					    return true;
					}
			    }
			}
			return false;
	    }
	}
}
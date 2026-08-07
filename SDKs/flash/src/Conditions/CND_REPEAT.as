//----------------------------------------------------------------------------------
//
// REPEAT N TIMES
//
//----------------------------------------------------------------------------------
package Conditions
{
	import Events.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_REPEAT extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
	        return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var pEvg:CEventGroup=rhPtr.rhEvtProg.rhEventGroup;
			if ((pEvg.evgFlags&CEventGroup.EVGFLAGS_REPEAT)!=0)
			    return true;				//; Deja evalue?
			if ((pEvg.evgFlags&CEventGroup.EVGFLAGS_NOMORE)!=0)
			    return false;				//; Verification, valide?
			
			// Va evaluer l'expression
			pEvg.evgInhibitCpt=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));		//; Repeat valide!
			pEvg.evgFlags|=CEventGroup.EVGFLAGS_REPEAT;
			return true;
	    }    
	}
}
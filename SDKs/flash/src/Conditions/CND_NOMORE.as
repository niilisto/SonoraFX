//----------------------------------------------------------------------------------
//
// NO MORE
//
//----------------------------------------------------------------------------------
package Conditions
{
	import Events.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_NOMORE extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
	        return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var pEvg:CEventGroup=rhPtr.rhEvtProg.rhEventGroup;
			if ((pEvg.evgFlags&CEventGroup.EVGFLAGS_NOMORE)!=0) 
			    return true;				//; Deja evalue
			if ((pEvg.evgFlags&(CEventGroup.EVGFLAGS_REPEAT|CEventGroup.EVGFLAGS_NOTALWAYS))!=0) 
			    return false;	//; Verification, valide?
		
			// Va evaluer l'expression
	        if (evtParams[0].code == CParam.PARAM_EXPRESSIONNUM)
	        {
	            pEvg.evgInhibit = rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]))/10;
	        }
	        else
	        {
				pEvg.evgInhibit=((PARAM_TIME(evtParams[0])).timer/10);				//; Valeur du timer /10
	        }
			pEvg.evgInhibitCpt=0;									// Init du compteur
			pEvg.evgFlags|=CEventGroup.EVGFLAGS_NOMORE;						// NOMORE valide!
			return true;
	    }    
	}
}
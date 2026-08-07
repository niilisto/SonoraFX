// ------------------------------------------------------------------------------
// 
// IN PLAYFIELD?
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Conditions.*;
	
	import Events.*;
	
	import Movements.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class CND_EXTINPLAYFIELD extends CCnd implements IEvaObject
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
	        var evpPtr:PARAM_SHORT=PARAM_SHORT(evtParams[0]);
	        if ( (evpPtr.value&(rhPtr.rhEvtProg.rhCurParam0))==0 )	//; Prend le deuxieme parametre (directions)
	            return false;
	
			if (compute_NoRepeat(hoPtr))
			{
	            rhPtr.rhEvtProg.evt_AddCurrentObject(hoPtr);	// Stocke l'objet courant
	            return true;
			}
		
			// Si une action STOP dans le groupe, il faut la faire!!!
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			var pEvg:CEventGroup=rhPtr.rhEvtProg.rhEventGroup;
			if ((pEvg.evgFlags&CEventGroup.EVGFLAGS_STOPINGROUP)==0) 
		    	return false;
			rhPtr.rhEvtProg.rh3DoStop=true;
			return true;
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			return evaObject(rhPtr, this);
	    }
	    public function evaObjectRoutine(pHo:CObject):Boolean
	    {
			if ( (pHo.rom.rmEventFlags&CRMvt.EF_GOESOUTPLAYFIELD)!=0 ) 
			    return negaTRUE();
			return negaFALSE();
	    }
	}
}
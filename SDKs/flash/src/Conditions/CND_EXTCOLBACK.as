// ------------------------------------------------------------------------------
// 
// COLLISION WITH BACKGROUND
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Events.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	import Sprites.*;
	
	public class CND_EXTCOLBACK extends CCnd implements IEvaObject
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			if (compute_NoRepeat(hoPtr))				// One shot
			{
			    rhPtr.rhEvtProg.evt_AddCurrentObject(hoPtr);	//; Stocke l'objet courant
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
	    public function evaObjectRoutine(hoPtr:CObject):Boolean
	    {
			if (hoPtr.hoAdRunHeader.colMask_TestObject_IXY(hoPtr, hoPtr.roc.rcImage, hoPtr.roc.rcAngle, hoPtr.roc.rcScaleX, hoPtr.roc.rcScaleY, hoPtr.hoX, hoPtr.hoY, 0, CColMask.CM_TEST_PLATFORM)) 
			    return negaTRUE();
			return negaFALSE();
	    }
	}
}
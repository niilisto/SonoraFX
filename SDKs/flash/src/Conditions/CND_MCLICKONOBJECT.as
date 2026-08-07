// ------------------------------------------------------------------------------
// 
// CLICK ON OBJECT
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Events.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_MCLICKONOBJECT extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			var p:PARAM_SHORT=PARAM_SHORT(evtParams[0]);
			if (rhPtr.rhEvtProg.rhCurParam0!=p.value) 
			    return false;		    	// La touche
		
			var oi:int=rhPtr.rhEvtProg.rhCurParam1;							//; L'objet qui clique
			var po:PARAM_OBJECT=PARAM_OBJECT(evtParams[1]);
			if (oi==po.oi)								//; L'oi sur lequel on clique
			{
			    rhPtr.rhEvtProg.evt_AddCurrentObject(rhPtr.rhEvtProg.rh4_2ndObject);
			    return true;
			}
		
			var oil:int=po.oiList;
			if ((oil&0x8000)==0) 
			    return false;							// Un Qualifier?
			var qoil:CQualToOiList=rhPtr.rhEvtProg.qualToOiList[oil&0x7FFF];
			var qoi:int;
			for (qoi=0; qoi<qoil.qoiList.length; qoi+=2)
			{
			    if (qoil.qoiList[qoi]==oi)
			    {
					rhPtr.rhEvtProg.evt_AddCurrentQualifier(oil);
					rhPtr.rhEvtProg.evt_AddCurrentObject(rhPtr.rhEvtProg.rh4_2ndObject);
					return true;
			    }
			}
			return false;
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var p:PARAM_SHORT=PARAM_SHORT(evtParams[0]);
			if (rhPtr.rhEvtProg.rh2CurrentClick!=p.value) 
			    return false;		    	// La touche
		
			var po:PARAM_OBJECT=PARAM_OBJECT(evtParams[1]);
			return rhPtr.getMouseOnObjectsEDX(po.oiList, false);
	    }
	}
}
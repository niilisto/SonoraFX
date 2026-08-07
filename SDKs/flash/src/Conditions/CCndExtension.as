// ------------------------------------------------------------------------------
// 
// EXTENSION conditions
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Events.*;
	
	import Expressions.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	import Services.*;
		
	public class CCndExtension extends CCnd
	{
	    public override function eva1(rhPtr:CRun, pHo:CObject):Boolean
	    {
	        if (pHo == null)
	        {
	            return eva2(rhPtr);
	        }
	        var extPtr:CExtension = CExtension(pHo);
	        pHo.hoFlags |= CObject.HOF_TRUEEVENT;
	        var cond:int = -(evtCode>>16) - CEventProgram.EVENTS_EXTBASE - 1;				// Vire le type
	        if (extPtr.condition(cond, this))
	        {
	            rhPtr.rhEvtProg.evt_AddCurrentObject(pHo);
	            return true;
	        }
	        return false;
	    }
	
	    public override function eva2(rhPtr:CRun):Boolean
	    {
	        // Boucle d'exploration
	        var pHo:CObject = rhPtr.rhEvtProg.evt_FirstObject(evtOiList);
	        var cpt:int = rhPtr.rhEvtProg.evtNSelectedObjects;
	        var cond:int = -(evtCode>>16) - CEventProgram.EVENTS_EXTBASE - 1;				// Vire le type
	
	        while (pHo != null)
	        {
	            var pExt:CExtension = CExtension(pHo);
	            pHo.hoFlags &= ~CObject.HOF_TRUEEVENT;
	            if (pExt.condition(cond, this))
	            {
	                if ((evtFlags2 & EVFLAG2_NOT) != 0)
	                {
	                    cpt--;
	                    rhPtr.rhEvtProg.evt_DeleteCurrentObject();			// On le vire!
	                }
	            }
	            else
	            {
	                if ((evtFlags2 & EVFLAG2_NOT) == 0)
	                {
	                    cpt--;
	                    rhPtr.rhEvtProg.evt_DeleteCurrentObject();			// On le vire!
	                }
	            }
	            pHo = rhPtr.rhEvtProg.evt_NextObject();
	        }
	        // Vrai / Faux?
	        if (cpt != 0)
	        {
	            return true;
	        }
	        return false;
	    }

	    // Recolte des parametres
	    // ----------------------
	    public function getParamObject(rhPtr:CRun, num:int):PARAM_OBJECT 
	    {
	        return PARAM_OBJECT(evtParams[num]);
	    }
	
	    public function getParamTime(rhPtr:CRun, num:int):int
	    {
	        if (evtParams[num].code == 2)	    // PARAM_TIME
	        {
	            return ( PARAM_TIME(evtParams[num]) ).timer;
	        }
	        return rhPtr.get_EventExpressionInt( CParamExpression(evtParams[num]) );
	    }
	
	    public function getParamBorder(rhPtr:CRun, num:int):int
	    {
	        return ( PARAM_SHORT(evtParams[num]) ).value;
	    }
	
	    public function getParamAltValue(rhPtr:CRun, num:int):int
	    {
	        return ( PARAM_SHORT(evtParams[num]) ).value;
	    }
	
	    public function getParamDirection( rhPtr:CRun, num:int):int
	    {
	        return ( PARAM_SHORT(evtParams[num]) ).value;
	    }
	
	    public function getParamAnimation(rhPtr:CRun, num:int):int
	    {
	        if (evtParams[num].code == 10)	    // PARAM_TIME
	        {
	            return ( PARAM_SHORT(evtParams[num]) ).value;
	        }
	        return rhPtr.get_EventExpressionInt( CParamExpression(evtParams[num]) );
	    }
	
	    public function getParamPlayer(rhPtr:CRun, num:int):int
	    {
	        return ( PARAM_SHORT(evtParams[num]) ).value;
	    }
	
	    public function getParamEvery(rhPtr:CRun, num:int):PARAM_EVERY 
	    {
	        return PARAM_EVERY(evtParams[num]);
	    }
	
	    public function getParamKey(rhPtr:CRun, num:int):int
	    {
	        return ( PARAM_KEY(evtParams[num]) ).key;
	    }
	
	    public function getParamSpeed(rhPtr:CRun, num:int):int
	    {
	        return rhPtr.get_EventExpressionInt( CParamExpression(evtParams[num]) );
	    }
	
	    public function getParamPosition(rhPtr:CRun, num:int):PARAM_POSITION 
	    {
	        return PARAM_POSITION(evtParams[num]);
	    }
	
	    public function getParamJoyDirection(rhPtr:CRun, num:int):int
	    {
	        return ( PARAM_SHORT(evtParams[num]) ).value;
	    }
	
	    public function getParamExpression(rhPtr:CRun, num:int):int
	    {
	        return rhPtr.get_EventExpressionInt( CParamExpression(evtParams[num]) );
	    }
	
	    public function getParamColour(rhPtr:CRun, num:int):int
	    {
	        if (evtParams[num].code == 24)	    // PARAM_COLOUR
	        {
	            return ( PARAM_COLOUR(evtParams[num]) ).color;
	        }
	        return CServices.swapRGB(rhPtr.get_EventExpressionInt( CParamExpression(evtParams[num])));
	    }
	
	    public function getParamFrame(rhPtr:CRun, num:int):int
	    {
	        return ( PARAM_SHORT(evtParams[num]) ).value;
	    }
	
	    public function getParamNewDirection(rhPtr:CRun, num:int):int
	    {
	        if (evtParams[num].code == 29)	    // PARAM_NEWDIRECTION
	        {
	            return ( PARAM_SHORT(evtParams[num]) ).value;
	        }
	        return rhPtr.get_EventExpressionInt( CParamExpression(evtParams[num]) );
	    }
	
	    public function getParamClick(rhPtr:CRun, num:int):int
	    {
	        return ( PARAM_SHORT(evtParams[num]) ).value;
	    }
	
	    public function getParamExpString(rhPtr:CRun, num:int):String
	    {
	        return rhPtr.get_EventExpressionString( CParamExpression(evtParams[num]) );
	    }
	
	    public function compareValues(rhPtr:CRun, num:int, value:CValue):Boolean
	    {
	        var value2:CValue = rhPtr.get_EventExpressionAny( CParamExpression(evtParams[num]) );
	        var comp:int = ( CParamExpression(evtParams[num]) ).comparaison;
	        return CRun.compareTo(value, value2, comp);
	    }
	
	    public function compareTime(rhPtr:CRun, num:int, t:int):Boolean
	    {
	        var p:PARAM_CMPTIME = PARAM_CMPTIME(evtParams[num]);
	        var value2:CValue = new CValue(p.timer);
	        var comp:int = p.comparaison;
	        var value:CValue = new CValue(t);
	        return CRun.compareTo(value, value2, comp);
	    }

	}
}
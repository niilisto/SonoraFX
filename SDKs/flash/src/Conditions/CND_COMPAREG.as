//----------------------------------------------------------------------------------
//
// COMPARE TO GLOBAL VALUE
//
//----------------------------------------------------------------------------------
package Conditions
{
	import Expressions.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_COMPAREG extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
	        return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var num:int;
			if (evtParams[0].code==52)	    // PARAM_VARGLOBAL_EXP 
			    num=(rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]))-1);	// &15; YVES: enleve
			else
			    num=(PARAM_SHORT(evtParams[0])).value;
		
			var gValue:CValue=new CValue(0);
			gValue.forceValue(rhPtr.rhApp.getGlobalValueAt(num));
			var value:CValue=rhPtr.get_EventExpressionAny(CParamExpression(evtParams[1]));
			var comp:int=(CParamExpression(evtParams[1])).comparaison;
			return CRun.compareTo(gValue, value, comp);
	    }
	    
	}
}
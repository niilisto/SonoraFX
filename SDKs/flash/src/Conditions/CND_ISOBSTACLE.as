// ------------------------------------------------------------------------------
// 
// IS OBSTACLE AT XY
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Sprites.*;
	import Application.*;
	
	public class CND_ISOBSTACLE extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var x:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]))-rhPtr.rhWindowX;
			var y:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]))-rhPtr.rhWindowY;
		
			if ( rhPtr.colMask_Test_XY(x, y, -1, CRunFrame.CM_TEST_OBSTACLE) )
			    return negaTRUE();
			return negaFALSE();
	    }
	}
}
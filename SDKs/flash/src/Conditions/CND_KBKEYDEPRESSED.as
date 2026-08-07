// ------------------------------------------------------------------------------
// 
// KEY DOWN
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.PARAM_KEY;
	
	import RunLoop.*;
	
	public class CND_KBKEYDEPRESSED extends CCnd
	{	    
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
	        return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
	        if (rhPtr.rh4DemoMode==CDemoRecord.DEMOPLAY)
	        {
	            if (rhPtr.rh4Demo.getKeyState((PARAM_KEY(evtParams[0])).key)==false) 
	                return negaFALSE();
	        }
	        else
	        {
	            if (rhPtr.rhApp.getKeyState((PARAM_KEY(evtParams[0])).key)==false) 
	                return negaFALSE();
	        }
	        return negaTRUE();
	    }
	}
}
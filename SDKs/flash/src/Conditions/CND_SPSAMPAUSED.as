// ------------------------------------------------------------------------------
// 
// SPECIFIC SAMPLE PAUSED?
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_SPSAMPAUSED extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var p:PARAM_SAMPLE=PARAM_SAMPLE(evtParams[0]);
			if (rhPtr.rhApp.soundPlayer.isSamplePaused(p.sndHandle))
			{
				return negaTRUE();
			}
			return negaFALSE();
	    }
	}
}
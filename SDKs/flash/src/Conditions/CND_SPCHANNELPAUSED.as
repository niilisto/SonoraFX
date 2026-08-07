// ------------------------------------------------------------------------------
// 
// CHANNEL PAUSED?
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_SPCHANNELPAUSED extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var channel:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			if (rhPtr.rhApp.soundPlayer.isChannelPaused(channel-1))
			{
				return negaTRUE();
			}
			return negaFALSE();
	    }
	}
}
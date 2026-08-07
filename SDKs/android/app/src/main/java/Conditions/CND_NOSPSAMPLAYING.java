// ------------------------------------------------------------------------------
// 
// NO SPECIFIC SAMPLE PLAYING?
// 
// ------------------------------------------------------------------------------
package Conditions;

import Objects.CObject;
import Params.PARAM_SAMPLE;
import RunLoop.CRun;

public class CND_NOSPSAMPLAYING extends CCnd
{
    public boolean eva1(CRun rhPtr, CObject hoPtr)
    {
	return eva2(rhPtr);
    }
    public boolean eva2(CRun rhPtr)
    {
	PARAM_SAMPLE p=(PARAM_SAMPLE)evtParams[0];
	if(!rhPtr.rhApp.soundPlayer.isSamplePlaying(p.sndHandle))
	{
		return negaTRUE();
	}
	return negaFALSE();
    }
}

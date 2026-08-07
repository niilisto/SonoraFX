// ------------------------------------------------------------------------------
// 
// NO SAMPLE PLAYING?
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_NOSAMPLAYING extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			if (!rhPtr.rhApp.soundPlayer.isSoundPlaying())
			{
				return negaTRUE();
			}
			return negaFALSE();
	    }
	}
}
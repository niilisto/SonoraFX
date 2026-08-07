//----------------------------------------------------------------------------------
//
// GET SAMPLE MAIN BOL
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;
	
	public class EXP_GETSAMPLEMAINVOL extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().forceInt(rhPtr.rhApp.soundPlayer.getMainVolume()*100+0.5);	
		}
	}
}
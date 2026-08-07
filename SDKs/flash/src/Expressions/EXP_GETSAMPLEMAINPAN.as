//----------------------------------------------------------------------------------
//
// GET SAMPLE MAIN PAN
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_GETSAMPLEMAINPAN extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{
			var p:Number=rhPtr.rhApp.soundPlayer.getMainPan()*100;        
			if (p<0)
			{
				p-=0.5;
			}
			else
			{
				p+=0.5;
			}
			rhPtr.getCurrentResult().forceInt(p);	
		}
	}
}
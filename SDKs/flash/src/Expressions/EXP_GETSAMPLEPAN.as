//----------------------------------------------------------------------------------
//
// GET SAMPLE POSITION
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_GETSAMPLEPAN extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var name:String=rhPtr.get_ExpressionString();
			var p:Number=rhPtr.rhApp.soundPlayer.getSamplePan(name)*100;	
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
//----------------------------------------------------------------------------------
//
// GET CHANNEL PAN
//
//----------------------------------------------------------------------------------
package Expressions
{
	import RunLoop.*;

	public class EXP_GETCHANNELPAN extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var value:Number=rhPtr.get_ExpressionInt();
			var p:Number=rhPtr.rhApp.soundPlayer.getChannelPan(value-1)*100;
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
//----------------------------------------------------------------------------------
//
// RACINE CARREE
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_SQR extends CExp
	{
	    
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var value:Number=rhPtr.get_ExpressionDouble();
			if (value<0)
			{
				rhPtr.getCurrentResult().forceDouble(0);
			}
			else
			{
				rhPtr.getCurrentResult().forceDouble(Math.sqrt(value));
			}
		}
	    
	}
}
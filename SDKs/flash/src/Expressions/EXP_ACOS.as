//----------------------------------------------------------------------------------
//
// ARC COSINUS
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_ACOS extends CExp
	{	    
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var value:Number=rhPtr.get_ExpressionDouble();
			var temp:Number=Math.acos(value)*57.295779513082320876798154814105;
			rhPtr.getCurrentResult().forceDouble(temp);
		}	   
	}
}
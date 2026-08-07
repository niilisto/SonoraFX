//----------------------------------------------------------------------------------
//
// GET RGB
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_GETRGB extends CExp
	{
	    
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var r:int=rhPtr.get_ExpressionInt();
			rhPtr.rh4CurToken++;
			var g:int=rhPtr.get_ExpressionInt();
			rhPtr.rh4CurToken++;
			var b:int=rhPtr.get_ExpressionInt();
	
			var rgb:int=((b&255)<<16) + ((g&255)<<8) + (r&255);
			rhPtr.getCurrentResult().forceInt(rgb);
		}
	    
	}
}
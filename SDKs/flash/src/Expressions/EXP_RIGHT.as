//----------------------------------------------------------------------------------
//
// RIGHT$
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_RIGHT extends CExp
	{
	    
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var string:String=rhPtr.get_ExpressionString();
			rhPtr.rh4CurToken++;
			var pos:int=rhPtr.get_ExpressionInt();
	
			if (pos<0)
				pos=0;
			if (pos>string.length)
				pos=string.length;
			rhPtr.getCurrentResult().forceString(string.substring(string.length-pos, string.length));
		}
	    
	}
}
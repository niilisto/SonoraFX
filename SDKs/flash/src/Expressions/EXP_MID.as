//----------------------------------------------------------------------------------
//
// MID$
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_MID extends CExp
	{
	    
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var string:String=rhPtr.get_ExpressionString();
			rhPtr.rh4CurToken++;
			var start:int=rhPtr.get_ExpressionInt();
			rhPtr.rh4CurToken++;
			var len:int=rhPtr.get_ExpressionInt();
	
			if (start<0)
				start=0;
			if (start>string.length)
				start=string.length;
			if (len<0)
				len=0;
			if (start+len>string.length)
				len=string.length-start;
			rhPtr.getCurrentResult().forceString(string.substr(start, len));
		}
	    
	}
}
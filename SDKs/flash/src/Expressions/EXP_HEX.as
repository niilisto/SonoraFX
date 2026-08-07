//----------------------------------------------------------------------------------
//
// HEXADECIMAL
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_HEX extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var a:int=rhPtr.get_ExpressionInt();
			var s:String="0x"+a.toString(16);
			rhPtr.getCurrentResult().forceString(s);
		}    
	}
}
//----------------------------------------------------------------------------------
//
// VAL
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	
	import RunLoop.*;
	
	import Services.*;

	public class EXP_VAL extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
	
			var s:String=rhPtr.get_ExpressionString();
			var val:CFuncVal=new CFuncVal();
			switch(val.parse(s))
			{
				case 0:
					rhPtr.getCurrentResult().forceInt(val.intValue);
					return;
				case 1:
					rhPtr.getCurrentResult().forceDouble(val.doubleValue);
					return;
			}
		}    
	}
}
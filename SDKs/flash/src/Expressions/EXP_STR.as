//----------------------------------------------------------------------------------
//
// STR$
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	
	import RunLoop.*;

	public class EXP_STR extends CExp
	{    
		public override function evaluate(rhPtr:CRun):void
		{        
	 		rhPtr.rh4CurToken++;
			var pValue:CValue=rhPtr.getExpression();
			var s:String="";
			switch(pValue.getType())
			{
				case 0:	    // TYPE_LONG:
					s=pValue.getInt().toString(10);
					break;
				case 1:	    // TYPE_DOUBLE:
					s=pValue.getDouble().toString();
					break;
			}
			rhPtr.getCurrentResult().forceString(s);
	   }
	    
	}
}
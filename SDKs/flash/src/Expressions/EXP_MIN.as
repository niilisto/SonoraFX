//----------------------------------------------------------------------------------
//
// MINIMUM
//
//----------------------------------------------------------------------------------
package Expressions
{
	import RunLoop.*;

	public class EXP_MIN extends CExp
	{
	    
		public override function evaluate(rhPtr:CRun):void
		{        
	        rhPtr.rh4CurToken++;
	        var aValue:CValue = rhPtr.get_ExpressionAny();
	        rhPtr.rh4CurToken++;
	        var bValue:CValue = rhPtr.get_ExpressionAny();
	        if (aValue.getType()==CValue.TYPE_INT && bValue.getType()==CValue.TYPE_INT)
	        {
	            var a:int=aValue.getInt();
	            var b:int=bValue.getInt();
	            if (a<b)
	            {
	                rhPtr.getCurrentResult().forceInt(a);
	            }
	            else
	            {
	                rhPtr.getCurrentResult().forceInt(b);
	            }
	        }
	        else
	        {
	            rhPtr.getCurrentResult().forceDouble(Math.min(aValue.getDouble(), bValue.getDouble()));
	        }
		}
	    
	}
}
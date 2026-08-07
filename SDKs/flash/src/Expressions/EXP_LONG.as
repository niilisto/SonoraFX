//----------------------------------------------------------------------------------
//
// LONG
//
//----------------------------------------------------------------------------------
package Expressions
{
	import RunLoop.*;
	
	public class EXP_LONG extends CExp
	{
	    public var value:int;
	    
	    public override function evaluate(rhPtr:CRun):void
	    {        
			rhPtr.getCurrentResult().forceInt(value);
	    }    
	}
}
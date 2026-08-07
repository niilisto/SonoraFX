//----------------------------------------------------------------------------------
//
// VALEUR A VIRGULE
//
//----------------------------------------------------------------------------------
package Expressions
{
	import RunLoop.*;
	
	public class EXP_DOUBLE extends CExp
	{
	    public var value:Number;

	    public override function evaluate(rhPtr:CRun):void
	    {        
			rhPtr.getCurrentResult().forceDouble(value);
	    }
	}
}
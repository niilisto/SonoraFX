//----------------------------------------------------------------------------------
//
// GLOBAL STRING
//
//----------------------------------------------------------------------------------
package Expressions
{
	import RunLoop.*;
	
	public class EXP_STRINGGLONAMED extends CExp
	{
	    public var number:int;

	    public override function evaluate(rhPtr:CRun):void
	    {        
			rhPtr.getCurrentResult().forceString(rhPtr.rhApp.getGlobalStringAt(number));
	    }
	}
}
//----------------------------------------------------------------------------------
//
// VARIABLE GLOBALE
//
//----------------------------------------------------------------------------------
package Expressions
{
	import RunLoop.*;
	
	public class EXP_VARGLONAMED extends CExp
	{
	    public var number:int;
	    
	    public override function evaluate(rhPtr:CRun):void
	    {        
			rhPtr.getCurrentResult().forceValue(rhPtr.rhApp.getGlobalValueAt(number));
	    }
	}
}
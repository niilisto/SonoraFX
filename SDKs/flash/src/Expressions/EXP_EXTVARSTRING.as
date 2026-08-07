//----------------------------------------------------------------------------------
//
// ALTERABLE STRING
//
//----------------------------------------------------------------------------------
package Expressions
{
	import RunLoop.*;
	import Objects.*;

	public class EXP_EXTVARSTRING extends CExpOi
	{
	    public var number:int;

	    public override function evaluate(rhPtr:CRun):void
	    {        
		 	var pHo:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			if (pHo==null)
			{
			    rhPtr.getCurrentResult().forceString("");
			    return;
			}
			rhPtr.getCurrentResult().forceString(pHo.rov.getString(number));
	    }    
	}
}
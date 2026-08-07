//----------------------------------------------------------------------------------
//
// EXTENSION
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Events.*;
	
	import Objects.*;
	
	import RunLoop.*;

	public class CExpExtension extends CExpOi
	{
	    public override function evaluate(rhPtr:CRun):void
	    {
	        var pHo:CObject = rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
	        if (pHo == null)
	        {
	            rhPtr.getCurrentResult().forceInt(0);
	            return;
	        }
	        var pExt:CExtension = CExtension(pHo);
	        var exp:int = (code >> 16) - CEventProgram.EVENTS_EXTBASE;				// Vire le type
	        var result:CValue = pExt.expression(exp);
	        rhPtr.getCurrentResult().forceValue(result);
	    }
	}
}
//----------------------------------------------------------------------------------
//
// DIRECTION
//
//----------------------------------------------------------------------------------
package Expressions
{
	import RunLoop.*;
	import Objects.*;
	
	public class EXP_EXTDIR extends CExpOi
	{
	    public override function evaluate(rhPtr:CRun):void
	    {        
			var pHo:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			if (pHo==null)
			{
			    rhPtr.getCurrentResult().forceInt(0);
			    return;
			}
			rhPtr.getCurrentResult().forceInt(rhPtr.getDir(pHo));
	    }    
	}
}
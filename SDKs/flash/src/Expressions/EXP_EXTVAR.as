//----------------------------------------------------------------------------------
//
// ALTERABLE VALUE
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Objects.*;
	
	import RunLoop.*;

	public class EXP_EXTVAR extends CExpOi
	{
		public var number:int;
		
	    public override function evaluate(rhPtr:CRun):void
	    {        
		 	var pHo:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			if (pHo==null)
			{
			    rhPtr.getCurrentResult().forceInt(0);
			    return;
			}
			if (pHo.rov!=null)
			{
			    rhPtr.getCurrentResult().forceValue(pHo.rov.getValue(number));
			}
			else
			{
			    rhPtr.getCurrentResult().forceInt(0);
			}
	    }    
	}
}
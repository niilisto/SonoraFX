//----------------------------------------------------------------------------------
//
// SEMI-TRANSPARENCY
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Objects.*;
	
	import RunLoop.*;

	public class EXP_EXTGETSEMITRANSPARENCY extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
	 		var pHo:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			if (pHo==null)
			{
				rhPtr.getCurrentResult().forceInt(0);
				return;
			}
			var t:int=0;
			if (pHo.ros!=null)
			{
				t=pHo.ros.getSemiTransparency();
			}
			rhPtr.getCurrentResult().forceInt(t);			
		}    
	}
}
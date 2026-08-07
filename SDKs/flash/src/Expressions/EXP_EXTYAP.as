//----------------------------------------------------------------------------------
//
// GET Y ACTION POINT
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Banks.*;
	
	import Expressions.*;
	
	import Objects.*;
	
	import RunLoop.*;

	public class EXP_EXTYAP extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{       
			var y:int=0;
	 		var pHo:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			if (pHo!=null)
			{
				y=pHo.hoY;
				if (pHo.roa!=null)
				{
					if ( pHo.roc.rcImage>=0 )
					{
						var ifo:CImage;
						ifo=rhPtr.rhApp.imageBank.getImageInfoEx(pHo.roc.rcImage, pHo.roc.rcAngle, pHo.roc.rcScaleX, pHo.roc.rcScaleY);
						if (ifo!=null)
						{
							rhPtr.getCurrentResult().forceInt(y+ifo.yAP-ifo.ySpot);
							return;
						}
					}
				}
			}
			rhPtr.getCurrentResult().forceInt(y);
		}    
	}
}
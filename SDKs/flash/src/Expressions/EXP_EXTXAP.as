//----------------------------------------------------------------------------------
//
// GET X ACTION POINT
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;
	import Objects.*;
	import Banks.*;

	public class EXP_EXTXAP extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var x:int=0;
	 		var pHo:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			if (pHo!=null)
			{
				x=pHo.hoX;
				if (pHo.roa!=null)
				{
					if ( pHo.roc.rcImage>=0 )
					{
						var ifo:CImage;
						ifo=rhPtr.rhApp.imageBank.getImageInfoEx(pHo.roc.rcImage, pHo.roc.rcAngle, pHo.roc.rcScaleX, pHo.roc.rcScaleY);
						if (ifo!=null)
						{
							rhPtr.getCurrentResult().forceInt(x+ifo.xAP-ifo.xSpot);
							return;
						}
					}
				}
			}		    
			rhPtr.getCurrentResult().forceInt(x);
		}    
	}
}
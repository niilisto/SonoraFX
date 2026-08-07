// -----------------------------------------------------------------------------
//
// SET FONT SIZE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Services.*;

	public class ACT_EXTSETFONTSIZE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			var newSize:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			var bResize:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]));
	
			var lf:CFontInfo =CRun.getObjectFont(pHo);
	
			var oldSize:int=lf.lfHeight;
			lf.lfHeight = newSize;
	
			if (bResize==0)
			{
				CRun.setObjectFont(pHo, lf, null);
			}
			else
			{
				var rc:CRect=new CRect();
				var coef:Number = 1.0;
				if ( oldSize != 0 )
					coef=(Number(newSize))/(Number(oldSize));
				rc.right=(pHo.hoImgWidth*coef);
				rc.bottom=(pHo.hoImgHeight*coef);
				rc.left=0;
				rc.top=0;
				CRun.setObjectFont(pHo, lf, rc);
			}
		}
	}
}
// -----------------------------------------------------------------------------
//
// SET SCALE X
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.CActive;
	import Objects.CObject;
	
	import Params.CParamExpression;
	
	import RunLoop.CRun;
	
	import Sprites.CRSpr;

	public class ACT_SPRSETSCALEX extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			// Recupere parametres
			var fScale:Number = Number(rhPtr.get_EventExpressionDouble(CParamExpression(evtParams[0])));
			if (fScale<0)
			{
				fScale=0;
			}

			pHo.ros.rsFlags &= ~CRSpr.RSFLAG_ROTATE_ANTIA;
			if (rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]))!=0)
				pHo.ros.rsFlags |= CRSpr.RSFLAG_ROTATE_ANTIA;

			pHo.setScale(fScale, pHo.roc.rcScaleY);
		}
	}
}
// -----------------------------------------------------------------------------
//
// SET ANGLE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Banks.CImage;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Sprites.*;
	import Banks.*;
	
	public class ACT_SPRSETANGLE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			// Recupere parametres
			var nAngle:Number= rhPtr.get_EventExpressionDouble(CParamExpression(evtParams[0]));
			
			var pMovement:CRunMBase= null;
			if(rhPtr.rh4Box2DObject)
				pMovement = rhPtr.GetMBase(pHo);
			if (pMovement!=null)
			{
				pMovement.setAngle(nAngle);
				return;
			}
			
			var bAntiA:Boolean= false;
			if (rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]))!=0)
				bAntiA=true;
			
			nAngle %= 360.0;
			if ( nAngle < 0)
				nAngle += 360;		
						
			var bOldAntiA:Boolean = false;
			if ( (pHo.ros.rsFlags&CRSpr.RSFLAG_ROTATE_ANTIA)!= 0)
				bOldAntiA=true;
			if ( pHo.roc.rcAngle!=nAngle || bOldAntiA!=bAntiA )
			{
				pHo.roc.rcAngle=nAngle;
				pHo.ros.rsFlags &= ~CRSpr.RSFLAG_ROTATE_ANTIA;
				if ( bAntiA )
					pHo.ros.rsFlags |= CRSpr.RSFLAG_ROTATE_ANTIA;
				pHo.roc.rcChanged = true;

	            var ifo:CImage = pHo.hoAdRunHeader.rhApp.imageBank.getImageInfoEx(pHo.roc.rcImage, pHo.roc.rcAngle, pHo.roc.rcScaleX, pHo.roc.rcScaleY);
				if(ifo != null) {
		            pHo.hoImgWidth=ifo.width;
		            pHo.hoImgHeight=ifo.height;
		            pHo.hoImgXSpot=ifo.xSpot;
		            pHo.hoImgYSpot=ifo.ySpot;						
					pHo.hoImgXAP=ifo.xAP;
					pHo.hoImgYAP=ifo.yAP;
				}
				
			}
		}
	}
}
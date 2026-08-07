// -----------------------------------------------------------------------------
//
// CREATE OBJECT
//
// -----------------------------------------------------------------------------
package Actions
{
	import Frame.*;
	
	import OI.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_CREATE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			// Cherche la position de creation
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			var pEvp:PARAM_CREATE=PARAM_CREATE(evtParams[0]);
			var pInfo:CPositionInfo=new CPositionInfo();
			if (pEvp.read_Position(rhPtr, 0x11, pInfo))
			{
				if (pInfo.bRepeat)
				{
					evtFlags|=ACTFLAGS_REPEAT;					// Refaire cette action
					rhPtr.rhEvtProg.rh2ActionLoop=true;			// Refaire un tour d'actions
				}
				else
				{
					evtFlags&=~ACTFLAGS_REPEAT;					// Ne pas refaire cette action
				}
	
				// Cree l'objet
				// ~~~~~~~~~~~~
				var number:int=rhPtr.f_CreateObject(pEvp.cdpHFII, pEvp.cdpOi, pInfo.x, pInfo.y, pInfo.dir, 0, pInfo.layer, -1);
		
				// Met l'objet dans la liste des objets selectionnes
				// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				if (number>=0)
				{
					var pHo:CObject=rhPtr.rhObjectList[number];
					rhPtr.rhEvtProg.evt_AddCurrentObject(pHo);
					
					if(rhPtr.rh4Box2DObject) {
						var mBase:CRunMBase= rhPtr.GetMBase(pHo);
						if (mBase != null)
							mBase.CreateBody();
						else
						{
							if (rhPtr.rh4Box2DBase != null)
							{
								rhPtr.rh4Box2DBase.rAddNormalObject(pHo);
							}
						}
					}
					if (pInfo.layer != -1)
					{
						if ((pHo.hoOEFlags & CObjectCommon.OEFLAG_SPRITES) != 0)
						{
							// Hide object if layer hidden
							var pLayer:CLayer= rhPtr.rhFrame.layers[pInfo.layer];
							if ((pLayer.dwOptions & (CLayer.FLOPT_TOHIDE | CLayer.FLOPT_VISIBLE)) != CLayer.FLOPT_VISIBLE)
							{
								pHo.ros.obHide();
							}
						}
					}
				}
			}
		}
	}
}
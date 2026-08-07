// -----------------------------------------------------------------------------
//
// SHOOT TOWARD
//
// -----------------------------------------------------------------------------
package Actions
{
	import Animations.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_EXTSHOOTTOWARD extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) return;
	
			// Peut-on tirer?
			// ~~~~~~~~~~~~~~
//			if (pHo.roa.raAnimOn==CAnim.ANIMID_SHOOT) return;			//; Deja en train de tirer?
	
			// Cherche la position de creation
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			var pEvp:PARAM_SHOOT=PARAM_SHOOT(evtParams[0]);
			var pInfo:CPositionInfo=new CPositionInfo();
			if (pEvp.read_Position(rhPtr, 0x11, pInfo))
			{
				var pInfoDest:CPositionInfo=new CPositionInfo();
				if ((CPosition(evtParams[1])).read_Position(rhPtr, 0, pInfoDest))
				{
					// Trouve la bonne direction
					var x2:int=pInfoDest.x;
					var y2:int=pInfoDest.y;
					var dir:int=CRun.get_DirFromPente(x2-pInfo.x, y2-pInfo.y);				// Calcul des pentes
		
					// Va creer la balle
					pHo.shtCreate(pEvp, pInfo.x, pInfo.y, dir);
				}
			}        
		}
	}
}
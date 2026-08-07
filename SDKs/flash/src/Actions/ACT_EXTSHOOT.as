// -----------------------------------------------------------------------------
//
// SHOOT
//
// -----------------------------------------------------------------------------
package Actions
{
	import Animations.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_EXTSHOOT extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			// Peut-on tirer?
			// ~~~~~~~~~~~~~~
//			if (pHo.roa.raAnimOn==CAnim.ANIMID_SHOOT)					//; Deja en train de tirer? 
//				return;			
	
			// Cherche la position de creation
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			var pEvp:PARAM_SHOOT=PARAM_SHOOT(evtParams[0]);
			var pInfo:CPositionInfo=new CPositionInfo();
			if (pEvp.read_Position(rhPtr, 0x11, pInfo))
			{
				pHo.shtCreate(pEvp, pInfo.x, pInfo.y, pInfo.dir);		// Va tout creer
			}        
		}
	}
}
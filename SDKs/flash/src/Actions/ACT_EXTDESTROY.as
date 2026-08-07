// -----------------------------------------------------------------------------
//
// DESTROY
//
// -----------------------------------------------------------------------------
package Actions
{
	import OI.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	import Sprites.*;

	public class ACT_EXTDESTROY extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			if (pHo.hoType==3)	// OBJ_TEXT)
			{
				var pText:CText=CText(pHo);
				if ((pText.rsHidden&CRun.COF_FIRSTTEXT)!=0)				//; Le dernier objet texte?
				{
					pHo.ros.obHide();										//; Cache pour le moment
					pHo.ros.rsFlags&=~CRSpr.RSFLAG_VISIBLE;
					pHo.hoFlags|=CObject.HOF_NOCOLLISION;
				}
				else
				{
					pHo.hoFlags|=CObject.HOF_DESTROYED;						//; NON: on le detruit!
					rhPtr.destroy_Add(pHo.hoNumber);
				}
				return;
			}
			if ((pHo.hoFlags&CObject.HOF_DESTROYED)==0)
			{
				pHo.hoFlags|=CObject.HOF_DESTROYED;
				if ( (pHo.hoOEFlags&CObjectCommon.OEFLAG_ANIMATIONS)!=0 || (pHo.hoOEFlags&CObjectCommon.OEFLAG_SPRITES)!=0)
				{
					// Jouer l'anim disappear
					rhPtr.init_Disappear(pHo);
				}
				else
				{
					// Pas un objet avec animation : destroy
					pHo.hoCallRoutine=false;
					rhPtr.destroy_Add(pHo.hoNumber);
				}
			}
		}
	}
}
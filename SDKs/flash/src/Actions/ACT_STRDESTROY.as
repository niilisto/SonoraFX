// -----------------------------------------------------------------------------
//
// DETROY STRING
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import RunLoop.*;
	
	import Sprites.*;

	public class ACT_STRDESTROY extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo!=null)
			{
				var pText:CText=CText(pHo);
				if ((pText.rsHidden&CRun.COF_FIRSTTEXT)!=0)		//; Le dernier objet texte?
				{
					pHo.ros.obHide();				//; Cache pour le moment
					pHo.ros.rsFlags&=~CRSpr.RSFLAG_VISIBLE;
					pHo.hoFlags|=CObject.HOF_NOCOLLISION;
				}
				else
				{
					pHo.hoFlags|=CObject.HOF_DESTROYED;		//; NON: on le detruit!
					rhPtr.destroy_Add(pHo.hoNumber);
				}
			}
		}
	}
}
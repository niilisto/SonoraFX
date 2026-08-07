// -----------------------------------------------------------------------------
//
// ASK QUESTION
//
// -----------------------------------------------------------------------------
package Actions
{
	import Events.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_QASK extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			if ((evtOiList&0x8000)==0)
			{
				qstCreate(rhPtr, evtOi);
				return;
			}
	
			// Un qualifier: on explore les listes
			if ((evtOiList&0x7FFF)!=0x7FFF)
			{
				var qoil:CQualToOiList=rhPtr.rhEvtProg.qualToOiList[evtOiList&0x7FFF];	    
				var qoi:int;
				for (qoi=0; qoi<qoil.qoiList.length; qoi+=2)
				{
					qstCreate(rhPtr, qoil.qoiList[qoi]);
				}
			}        
		}
		public function qstCreate(rhPtr:CRun, oi:int):void
		{
			// Cherche la position de creation
			var c:CCreate=CCreate(evtParams[0]);
			var info:CPositionInfo=new CPositionInfo();
			
			if (c.read_Position(rhPtr, 0x10, info))
			{
				rhPtr.f_CreateObject(c.cdpHFII, oi, info.x, info.y, info.dir, 0, rhPtr.rhFrame.nLayers-1, -1);
			}
		}	    
	}
}
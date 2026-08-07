// -----------------------------------------------------------------------------
//
// SET POSITION
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_EXTSETPOS extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			var position:CPosition=CPosition(evtParams[0]);
			var pInfo:CPositionInfo=new CPositionInfo();
			if (position.read_Position(rhPtr, 1, pInfo))
			{			
				CRun.setXPosition(pHo, pInfo.x);
				CRun.setYPosition(pHo, pInfo.y);
				if (pInfo.dir!=-1)
				{
					var dir:int=pInfo.dir&=31;
					if (rhPtr.getDir(pHo)!=dir)
					{
						pHo.roc.rcDir=dir;
						pHo.roc.rcChanged=true;
						pHo.rom.rmMovement.setDir(dir);
						
						if (pHo.hoType==2)		// OBJ_SPR)
						{
							pHo.roa.animIn(0);
						}
					}			
				}
			}        
		}
	}
}
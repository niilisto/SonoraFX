// -----------------------------------------------------------------------------
//
// LOOK AT
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_EXTLOOKAT extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			var position:CPosition=CPosition(evtParams[0]);
			var pInfo:CPositionInfo=new CPositionInfo();
			if (position.read_Position(rhPtr, 0, pInfo))
			{
				var x:int=pInfo.x;
				var y:int=pInfo.y;
				x-=pHo.hoX;
				y-=pHo.hoY;
				var pMovement:CRunMBase= null;
				if(rhPtr.rh4Box2DObject)
					pMovement = rhPtr.GetMBase(pHo);
				if (pMovement == null)
				{
					var dir:int=CRun.get_DirFromPente(x, y);
					dir&=31;
					if (rhPtr.getDir(pHo)!=dir)
					{
						pHo.roc.rcDir=dir;
						pHo.roc.rcChanged=true;
						pHo.rom.rmMovement.setDir(dir);
					}
				}
				else
				{
					var angle:Number=(((Math.PI*2 - Math.atan2(y, x))%(Math.PI*2))*180/Math.PI);
					pMovement.setAngle(angle);
				}
			}        
		}
	}
}
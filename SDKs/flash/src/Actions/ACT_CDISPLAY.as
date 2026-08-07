// -----------------------------------------------------------------------------
//
// CENTER DISPLAY
//
// -----------------------------------------------------------------------------
package Actions
{
	import Params.*;
	
	import RunLoop.*;

	public class ACT_CDISPLAY extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var position:CPosition=CPosition(evtParams[0]);
			var pInfo:CPositionInfo=new CPositionInfo();
			position.read_Position(rhPtr, 0, pInfo);
			rhPtr.setDisplay(pInfo.x, pInfo.y, pInfo.layer, 3);
		}
	}
}
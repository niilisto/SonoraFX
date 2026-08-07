// -----------------------------------------------------------------------------
//
// SET SPEED
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_EXTSPEED extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			var s:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			if (pHo.rom!=null)
			{
				pHo.rom.rmMovement.setSpeed(s);
			}
		}
	}
}
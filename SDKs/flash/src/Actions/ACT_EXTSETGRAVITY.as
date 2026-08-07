// -----------------------------------------------------------------------------
//
// SET GRAVITY
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_EXTSETGRAVITY extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			var grav:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			pHo.rom.rmMovement.setGravity(grav);
		}
	}
}
// -----------------------------------------------------------------------------
//
// FORCE SPEED
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_EXTFORCESPEED extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			var speed:int;
			speed=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
	
			pHo.roa.animSpeed_Force(speed);
		}
	}
}
// -----------------------------------------------------------------------------
//
// SET DECELERATION
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Objects.*;
	import Params.*;

	public class ACT_EXTSETDECELERATION extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			var dec:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			pHo.rom.rmMovement.setDec(dec);
		}
	}
}
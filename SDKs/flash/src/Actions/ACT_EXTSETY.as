// -----------------------------------------------------------------------------
//
// SET Y POSITION
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_EXTSETY extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			var y:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			CRun.setYPosition(pHo, y);
		}
	}
}
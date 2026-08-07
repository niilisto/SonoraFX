// -----------------------------------------------------------------------------
//
// SELECT MOVE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Objects.*;
	import Params.*;

	public class ACT_EXTSELMOVE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;

			var n:int;
			if (evtParams[0].code==22)	    // PARAM_EXPRESSION)
			{
				n=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			}
			else
			{
				n=(PARAM_SHORT(evtParams[0])).value;
			}
			if (pHo.rom!=null)
			{
				pHo.rom.selectMovement(pHo, n);
			}
		}
	}
}
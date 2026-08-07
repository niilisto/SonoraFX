// -----------------------------------------------------------------------------
//
// SET SEMI TRANSPARENCY
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Sprites.*;

	public class ACT_EXTSETSEMITRANSPARENCY extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			if (pHo.ros!=null)
			{
				var val:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
				if (val<0) val=0;
				if (val>128) val=128;
	
				pHo.roc.rcChanged=true;
				pHo.ros.setSemiTransparency(val);
			}
		}
	}
}
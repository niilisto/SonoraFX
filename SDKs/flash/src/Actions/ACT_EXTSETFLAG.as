// -----------------------------------------------------------------------------
//
// SET FLAG
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Objects.*;
	import Params.*;

	public class ACT_EXTSETFLAG extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			if (pHo.rov!=null)
			{
				var number:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
				pHo.rov.rvValueFlags|=(1<<number);
			}	
		}
	}
}
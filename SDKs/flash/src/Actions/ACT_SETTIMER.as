// -----------------------------------------------------------------------------
//
// SET TIMER
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;
	import flash.system.*;
	import flash.utils.*;

	public class ACT_SETTIMER extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var newTime:int;
			if (evtParams[0].code==22)	    // PARAM_EXPRESSION
				newTime=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			else
				newTime=(PARAM_TIME(evtParams[0])).timer;
			
			var time:int=getTimer();
			rhPtr.rhTimer=newTime;
			rhPtr.rhTimerOld=time-rhPtr.rhTimer;
	
			// Reactive les evenements timer...
			rhPtr.rhEvtProg.restartTimerEvents();
		}
	}
}
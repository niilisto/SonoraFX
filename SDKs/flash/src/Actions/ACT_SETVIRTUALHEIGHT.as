// -----------------------------------------------------------------------------
//
// SET VIRTUAL HEIGHT
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_SETVIRTUALHEIGHT extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var newHeight:int = rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
	
			if ( newHeight < rhPtr.rhFrame.leHeight )
				newHeight = rhPtr.rhFrame.leHeight;
			if ( newHeight>0x7FFFF000 )
				newHeight = 0x7FFFF000;
	
			if ( rhPtr.rhFrame.leVirtualRect.bottom != newHeight )
				rhPtr.rhFrame.leVirtualRect.bottom = rhPtr.rhLevelSy = newHeight;
		}
	}
}
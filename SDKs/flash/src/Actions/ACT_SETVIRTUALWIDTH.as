// -----------------------------------------------------------------------------
//
// SET VIRTUAL WIDTH
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_SETVIRTUALWIDTH extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var newWidth:int = rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
	
			if ( newWidth < rhPtr.rhFrame.leWidth )
				newWidth = rhPtr.rhFrame.leWidth;
			if ( newWidth>0x7FFFF000 )
				newWidth = 0x7FFFF000;
	
			if ( rhPtr.rhFrame.leVirtualRect.right != newWidth )
				rhPtr.rhFrame.leVirtualRect.right = rhPtr.rhLevelSx = newWidth;
		}
	}
}
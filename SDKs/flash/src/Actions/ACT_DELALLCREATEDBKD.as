// -----------------------------------------------------------------------------
//
// DELETE ALL CREATED BACKGROUND
//
// -----------------------------------------------------------------------------
package Actions
{
	import Frame.CLayer;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_DELALLCREATEDBKD extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var layer:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]))-1;
			rhPtr.deleteAllBackdrop2(layer);
		}
	}
}
// -----------------------------------------------------------------------------
//
// DELETE CREATED BACKGROUND AT
//
// -----------------------------------------------------------------------------
package Actions
{
	import Params.*;
	
	import RunLoop.*;

	public class ACT_DELCREATEDBKDAT extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var layer:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]))-1;
			var x:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]));
			var y:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[2]));
			var bFineDetection:Boolean=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[3]))!=0;
		        
			rhPtr.deleteBackdropAt(layer, x, y, bFineDetection);
		}
	}
}
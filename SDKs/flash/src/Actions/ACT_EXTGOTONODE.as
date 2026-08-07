// -----------------------------------------------------------------------------
//
// GOTO NODE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Objects.*;
	import Params.*;
	import Movements.*;

	public class ACT_EXTGOTONODE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
			
			var pName:String=rhPtr.get_EventExpressionString(CParamExpression(evtParams[0]));
	
			if (pHo.roc.rcMovementType==CMoveDef.MVTYPE_TAPED)
			{    
				var pPath:CMovePath=CMovePath(pHo.rom.rmMovement);
				pPath.mtGotoNode(pName);
			}
		}
	}
}
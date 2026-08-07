// -----------------------------------------------------------------------------
//
// SET DIRECTION
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Objects.*;
	import Params.*;

	public class ACT_EXTSETDIR extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			var dir:int;
			if (evtParams[0].code==29)	// PARAM_NEWDIRECTION)
				dir=rhPtr.get_Direction((PARAM_INT(evtParams[0])).value);
			else
				dir=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
	
			dir&=31;
			if (rhPtr.getDir(pHo)!=dir)
			{
				pHo.roc.rcDir=dir;
				pHo.roc.rcChanged=true;
				pHo.rom.rmMovement.setDir(dir);
	
				if (pHo.hoType==2)		// OBJ_SPR)
				{
					pHo.roa.animIn(0);
				}
			}
		}
	}
}
// -----------------------------------------------------------------------------
//
// GOTO LEVEL
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_GOLEVEL extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var level:int;
			if (evtParams[0].code==26)  // PARAM_FRAME	    
			{
				level=(PARAM_SHORT(evtParams[0])).value;
				// Verifie la validite du level
				if (rhPtr.rhApp.HCellToNCell(level)==-1) 
				{
					return;
				}
			}
			else
			{
				// Avec un calcul
				level=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]))-1;		// Une expression
				if (level<0 || level>=4096) 
					return;			// Entre 0 et 4096
				if (rhPtr.rhApp.bShiftFrameNumber)
				{
					level++;
				}
				level|=0x8000;
			}
			rhPtr.rhQuit=CRun.LOOPEXIT_GOTOLEVEL;
			rhPtr.rhQuitParam=level;
		}
	}
}
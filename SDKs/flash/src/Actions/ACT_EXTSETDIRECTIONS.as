// -----------------------------------------------------------------------------
//
// SET DIRECTIONS
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_EXTSETDIRECTIONS extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
			
			var dirs:int=(PARAM_INT(evtParams[0])).value;
			pHo.rom.rmMovement.set8Dirs(dirs);        
		}
	}
}
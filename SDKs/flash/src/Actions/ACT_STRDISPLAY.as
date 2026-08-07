// -----------------------------------------------------------------------------
//
// DISPLAY STRING
//
// -----------------------------------------------------------------------------
package Actions
{
	import Params.*;
	
	import RunLoop.*;

	public class ACT_STRDISPLAY extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var p:PARAM_SHORT=PARAM_SHORT(evtParams[1]);
			rhPtr.txtDoDisplay(this, p.value);			// trouve le numero du texte        
		}
	}
}
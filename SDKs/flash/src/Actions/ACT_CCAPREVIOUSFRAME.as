// -----------------------------------------------------------------------------
//
// PREVIOUS FRAME
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import RunLoop.*;

	public class ACT_CCAPREVIOUSFRAME extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			(CCCA(pHo)).previousFrame();	
		}
	}
}
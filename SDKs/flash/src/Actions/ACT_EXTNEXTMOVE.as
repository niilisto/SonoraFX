// -----------------------------------------------------------------------------
//
// NEXT MOVE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import RunLoop.*;

	public class ACT_EXTNEXTMOVE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			if (pHo.rom!=null)
			{
				pHo.rom.nextMovement(pHo);
			}                
		}
	}
}
// -----------------------------------------------------------------------------
//
// REVERSE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Objects.*;

	public class ACT_EXTREVERSE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;

			if (pHo.rom!=null)
			{
				pHo.rom.rmMovement.reverse();
			}        
		}
	}
}
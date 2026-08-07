// -----------------------------------------------------------------------------
//
// SPRITE TO FRONT
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Objects.*;

	public class ACT_SPRFRONT extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null)
				return;
			var index:int=pHo.getChildMaxIndex();
			pHo.setChildIndex(index-1);
		}
	}
}
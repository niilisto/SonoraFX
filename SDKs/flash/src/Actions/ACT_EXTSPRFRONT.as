// -----------------------------------------------------------------------------
//
// SET SPRITE FRONT
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import RunLoop.*;

	public class ACT_EXTSPRFRONT extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
	 		var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) return;
			var index:int=pHo.getChildMaxIndex();
			pHo.setChildIndex(index);
		}
	}
}
// -----------------------------------------------------------------------------
//
// MOVE BEFORE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Sprites.*;

	public class ACT_EXTMOVEBEFORE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
	 		var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			if (pHo.ros!=null)
			{
				var pHo2:CObject=rhPtr.rhEvtProg.get_ParamActionObjects((PARAM_OBJECT(evtParams[0])).oiList, this);
				if ( pHo2 == null )
					return;
				var pos1:int=pHo2.getChildIndex();
				var pos2:int=pHo.getChildIndex();
				if (pos1<pos2)
				{
					pHo.setChildIndex(pos1);
				}	
			}
		}
	}
}
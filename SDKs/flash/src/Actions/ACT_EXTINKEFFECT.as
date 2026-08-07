// -----------------------------------------------------------------------------
//
// SET INK EFFECT
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Sprites.*;

	public class ACT_EXTINKEFFECT extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
			
			
			if (pHo.ros != null)
			{
				var p:PARAM_2SHORTS = PARAM_2SHORTS(evtParams[0]);
				var param1:int=p.value1;
				var param2:int=p.value2;
				if (param1==CRSpr.BOP_BLEND)
					param2=0;
				pHo.ros.modifSpriteEffect(param1, param2);
			}
		}	
	}
}
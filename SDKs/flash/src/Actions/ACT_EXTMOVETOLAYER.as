// -----------------------------------------------------------------------------
//
// MOVE TO LAYER
//
// -----------------------------------------------------------------------------
package Actions
{
	import Frame.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Sprites.*;

	public class ACT_EXTMOVETOLAYER extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
	 		var hoPtr:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (hoPtr==null) 
				return;
	
			if (hoPtr.ros!=null)
			{
				var nLayer:int = rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
	
				if ( nLayer > 0 && nLayer <= rhPtr.rhFrame.nLayers && hoPtr.hoLayer!=nLayer-1)
				{
					nLayer -= 1;
					
					var pLayer:CLayer=rhPtr.rhFrame.layers[nLayer];
					if (hoPtr.ros!=null)
					{
						hoPtr.hoLayer=nLayer;
						hoPtr.ros.rsLayer=nLayer;
						hoPtr.delSprite();
						hoPtr.ros.createSprite(false);
					}
				}
			}
		}
	}
}
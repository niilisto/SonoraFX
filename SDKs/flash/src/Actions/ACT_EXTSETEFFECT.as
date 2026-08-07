// -----------------------------------------------------------------------------
//
// SET EFFECT 
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Sprites.*;

	public class ACT_EXTSETEFFECT extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
			
			var effectName:String = (PARAM_STRING(evtParams[0])).string;
			var effect:int = CRSpr.BOP_COPY;
			if (effectName != null && effectName.length!= 0)
			{
				if (effectName == "Add")
					effect = CRSpr.BOP_ADD;
				else if (effectName == "Invert")
					effect = CRSpr.BOP_INVERT;
				else if (effectName == "Sub")
					effect = CRSpr.BOP_SUB;
				else if (effectName == "Mono")
					effect = CRSpr.BOP_MONO;
				else if (effectName == "Blend")
					effect = CRSpr.BOP_BLEND;
				else if (effectName == "XOR")
					effect = CRSpr.BOP_XOR;
				else if (effectName == "OR")
					effect = CRSpr.BOP_OR;
				else if (effectName == "AND")
					effect = CRSpr.BOP_AND;				
			}
			pHo.ros.modifSpriteEffect(effect, pHo.ros.rsEffectParam);
		}
	}
}
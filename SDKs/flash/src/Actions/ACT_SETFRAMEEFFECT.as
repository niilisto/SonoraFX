// -----------------------------------------------------------------------------
//
// SET FRAME EFFECT 
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Sprites.*;
	import Application.*;
	
	public class ACT_SETFRAMEEFFECT extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
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
			rhPtr.rhApp.effect &= ~CRSpr.BOP_MASK;
			rhPtr.rhApp.effect |= effect;
			rhPtr.rhApp.setEffect(rhPtr.rhApp.effect, rhPtr.rhApp.effectParam);
		}
	}
}
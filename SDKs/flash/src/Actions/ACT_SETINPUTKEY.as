// -----------------------------------------------------------------------------
//
// SET INPUT KEY
//
// -----------------------------------------------------------------------------
package Actions
{
	import Params.*;
	
	import RunLoop.*;
	import Application.*;

	public class ACT_SETINPUTKEY extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var touche:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));	//; Numero de la touche
			if (touche>=8)		// MAX_KEY
				return;
			var joueur:int=evtOi;
			if ( joueur >= 4 )	// MAX_PLAYER 
				return;
			var param:PARAM_KEY=evtParams[1];
			var key:int=param.key;
			rhPtr.rhApp.pcCtrlKeys[joueur*CRunApp.MAX_KEY+touche]=key;	// Nouvelle touche        
		}
	}
}
// -----------------------------------------------------------------------------
//
// SET INPUT
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;
	import Application.*;

	public class ACT_SETINPUT extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var input:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			if (input>CRunApp.CTRLTYPE_KEYBOARD)
				return;
			if (input==CRunApp.CTRLTYPE_MOUSE)
				input=CRunApp.CTRLTYPE_KEYBOARD;
			var joueur:int=evtOi;
			if ( joueur>=4 )	// MAX_PLAYER
				return;
			rhPtr.rhApp.getCtrlType()[joueur]=input;

	/*JOYSTICK
		// Ajout Yves build 242: initialize joystick if necessary
		if ( input >= CTRLTYPE_JOY1 && input <= CTRLTYPE_JOY4 )
			InitJoystick(joueur, input - CTRLTYPE_JOY1);
	*/
		}
	}
}
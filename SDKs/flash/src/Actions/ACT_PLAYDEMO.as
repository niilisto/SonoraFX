// -----------------------------------------------------------------------------
//
// PLAY DEMO
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_PLAYDEMO extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pFilename:String;
			if ( evtParams[0].code==63 )	    // PARAM_FILENAME2
				pFilename=(PARAM_STRING(evtParams[0])).string;
			else
				pFilename=rhPtr.get_EventExpressionString(CParamExpression(evtParams[0]));
	
			if (rhPtr.rh4Demo==null)
			{
//FRANCOIS:		rhPtr.rh4Demo=new CDemoRecord(rhPtr, pFilename);
				rhPtr.rh4Demo.startPlaying();
			}
		}
	}
}
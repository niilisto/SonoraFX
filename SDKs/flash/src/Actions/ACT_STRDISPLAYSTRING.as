// -----------------------------------------------------------------------------
//
// DISPLAY STRING
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import RunLoop.*;

	public class ACT_STRDISPLAYSTRING extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo!=null)
			{
				var pText:CText=CText(pHo);
				if (pText.txtChange(-1))
				{
					pHo.roc.rcChanged=true;
					pHo.display();
				}
			}        
		}
	}
}
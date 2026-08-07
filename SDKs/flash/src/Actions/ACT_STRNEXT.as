// -----------------------------------------------------------------------------
//
// NEXT STRING
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import RunLoop.*;

	public class ACT_STRNEXT extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo!=null)
			{
				var pText:CText=CText(pHo);
				var num:int=pText.rsMini+1;
				if (pText.txtChange(num))
				{
//					pHo.roc.rcChanged=true;
					pHo.modif();
				}
			}        
		}
	}
}
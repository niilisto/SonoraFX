//----------------------------------------------------------------------------------
//
// NUMBER OF OBJECTS
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Events.*;
	
	import Expressions.*;
	
	import RunLoop.*;

	public class EXP_EXTNOBJECTS extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			// Cherche dans la liste des oi
			var qoil:int=oiList;
			var poil:CObjInfo;
			if ((qoil&0x8000)==0)
			{
				// Un OI Normal
				poil=rhPtr.rhOiList[qoil];
				rhPtr.getCurrentResult().forceInt(poil.oilNObjects);
			}
			else
			{
				// Un qualifier
				var count:int=0;
				if (qoil!=-1)
				{
					var pqoi:CQualToOiList=rhPtr.rhEvtProg.qualToOiList[qoil&0x7FFF];
					var qoi:int;
					for (qoi=0; qoi<pqoi.qoiList.length; qoi+=2)
					{
						poil=rhPtr.rhOiList[pqoi.qoiList[qoi+1]];
						count+=poil.oilNObjects;
					}
				}
				rhPtr.getCurrentResult().forceInt(count);
			}
		}    
	}
}
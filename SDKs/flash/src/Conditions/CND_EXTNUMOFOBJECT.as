// ------------------------------------------------------------------------------
// 
// COMPARE TO NUMBER OF OBJECTS
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Events.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_EXTNUMOFOBJECT extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var count:int=0;
		
			var poil:CObjInfo;
			var oil:int=evtOiList;
			if ((oil&0x8000)==0)
			{
			    // Un objet normal
			    poil=rhPtr.rhOiList[oil];
			    count=poil.oilNObjects;
			}
			else
			{
			    // Un qualifier
			    if ((oil&0x7FFF)!=0x7FFF)
			    {
					var pqoi:CQualToOiList=rhPtr.rhEvtProg.qualToOiList[oil&0x7FFF];
					var qoi:int;
					for (qoi=0; qoi<pqoi.qoiList.length; qoi+=2)
					{
					    poil=rhPtr.rhOiList[pqoi.qoiList[qoi+1]];
					    count+=poil.oilNObjects;
					}
			    }
			}
		
			var value:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			return CRun.compareTer(count, value, (CParamExpression(evtParams[0])).comparaison);
	    }
	}
}
// ------------------------------------------------------------------------------
// 
// NO MORE OBJECTS
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Events.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_EXTNOMOREOBJECT extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			// Correction bug jeux K&P
			if (hoPtr==null)
			{
			    return eva2(rhPtr);
			}
			if (evtOi>=0)
			{
			    if (hoPtr.hoOi!=evtOi)
					return false;
			    return true;
			}
			return evaNoMoreObject(rhPtr, 1);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			return evaNoMoreObject(rhPtr, 0);
	    }
	    public function evaNoMoreObject(rhPtr:CRun, sub:int):Boolean
	    {
			var oil:int=evtOiList;
		
			var poil:CObjInfo;
			if ((oil&0x8000)==0)
			{
			    // Un objet normal
			    poil=rhPtr.rhOiList[oil];
			    if (poil.oilNObjects==0)
					return true;
			    return false;
			}
		
			// Un qualifier
			if ((oil&0x7FFF)==0x7FFF)
			    return false;
			var pqoi:CQualToOiList=rhPtr.rhEvtProg.qualToOiList[oil&0x7FFF];
			var count:int=0;
			var qoi:int;
			for (qoi=0; qoi<pqoi.qoiList.length; qoi+=2)
			{
			    poil=rhPtr.rhOiList[pqoi.qoiList[qoi+1]];
			    count+=poil.oilNObjects;
			}	 
			count-=sub;									//; Moins un si appel lors de killobject qualifier!
			if (count==0)
			    return true;
			return false;
	    }
	}
}
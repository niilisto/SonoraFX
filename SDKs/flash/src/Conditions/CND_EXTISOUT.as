// ------------------------------------------------------------------------------
// 
// IS OUT OF THE PLAYFIELD?
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_EXTISOUT extends CCnd implements IEvaObject
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return evaObject(rhPtr, this);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			return evaObject(rhPtr, this);
	    }
	    public function evaObjectRoutine(pHo:CObject):Boolean
	    {
			var x1:int=pHo.hoX-pHo.hoImgXSpot;
			var x2:int=x1+pHo.hoImgWidth;
			var y1:int=pHo.hoY-pHo.hoImgYSpot;
			var y2:int=y1+pHo.hoImgHeight;
			if (pHo.hoAdRunHeader.quadran_In(x1, y1, x2, y2)!=0) 
			{
			    return negaTRUE();
			}
			return negaFALSE();
	    }
	}
}
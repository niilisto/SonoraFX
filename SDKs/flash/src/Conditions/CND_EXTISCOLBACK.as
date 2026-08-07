// ------------------------------------------------------------------------------
// 
// OVERLAPPING A BACKGROUND?
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import RunLoop.*;
	
	import Sprites.*;
	
	public class CND_EXTISCOLBACK extends CCnd implements IEvaObject
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			return evaObject(rhPtr, this);
	    }
	    public function evaObjectRoutine(hoPtr:CObject):Boolean
	    {
			if (hoPtr.hoAdRunHeader.colMask_TestObject_IXY(hoPtr, hoPtr.roc.rcImage, hoPtr.roc.rcAngle, hoPtr.roc.rcScaleX, hoPtr.roc.rcScaleY, hoPtr.hoX, hoPtr.hoY, 0, CColMask.CM_TEST_OBSTACLE)) 
			    return negaTRUE();
			if (hoPtr.hoAdRunHeader.colMask_TestObject_IXY(hoPtr, hoPtr.roc.rcImage, hoPtr.roc.rcAngle, hoPtr.roc.rcScaleX, hoPtr.roc.rcScaleY, hoPtr.hoX, hoPtr.hoY, 0, CColMask.CM_TEST_PLATFORM)) 
			    return negaTRUE();
			return negaFALSE();
	    }
	}
}
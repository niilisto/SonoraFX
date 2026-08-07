//----------------------------------------------------------------------------------
//
// CRUNINANDOUTCONTROLLER
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Movements.*;
	
	import OI.*;
	
	import Objects.*;
	
	import Params.PARAM_ZONE;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	import Params.*;
	
	public class CRunInAndOutController extends CRunExtension
	{
		private static var ACT_SETOBJECT:int=0;
		private static var ACT_SETOBJECTFIXED:int=1;
		private static var ACT_POSITIONIN:int=2;
		private static var ACT_POSITIONOUT:int=3;
		private static var ACT_MOVEIN:int=4;
		private static var ACT_MOVEOUT:int=5;
		private static var DLL_INANDOUT:String = "InAndOut";
		private static var ACTION_POSITIONIN:int=0;
		private static var ACTION_POSITIONOUT:int=1;
		private static var ACTION_MOVEIN:int=2;
		private static var ACTION_MOVEOUT:int=3;
		
	    private var currentObject:CObject = null;
		
		public function CRunInAndOutController()
		{
		}
		
	    public override function getNumberOfConditions():int
	    {
	        return 0;
	    }

	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	        return true;
	    }

		public override function condition(num:int, cnd:CCndExtension):Boolean
		{
	        return false;
		}
		
	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
	            //*** Set Object
	            case ACT_SETOBJECT:
	                Action_SetObject_Object(act);
	                break;
	            case ACT_SETOBJECTFIXED:
	                Action_SetObject_FixedValue(act);
	                break;
	            case ACT_POSITIONIN:
	                RACT_POSITIONIN(act);
	                break;
	            case ACT_POSITIONOUT:
	                RACT_POSITIONOUT(act);
	                break;
	            case ACT_MOVEIN:
	                RACT_MOVEIN(act);
	                break;
	            case ACT_MOVEOUT:
	                RACT_MOVEOUT(act);
	                break;
	        }
	    }
	    public function getCurrentObject(dllName:String):CObject
	    {
	        // No need to search for the object if it's null
	        if (currentObject == null)
	        {
	            return null;
	        }
	
	        // Enumerate objects
	        var hoPtr:CObject;
	        for (hoPtr = ho.getFirstObject(); hoPtr != null; hoPtr = ho.getNextObject())
	        {
	            if (hoPtr == currentObject)
	            {
	                // Check if the object can have movements
	                if ((hoPtr.hoOEFlags & CObjectCommon.OEFLAG_MOVEMENTS) != 0)
	                {
	                    // Test if the object has a movement and this movement is an extension
	                    if (hoPtr.roc.rcMovementType == CMoveDef.MVTYPE_EXT)
	                    {
	                        if (dllName != null)
	                        {
	                            var ocPtr:CObjectCommon = hoPtr.hoCommon;
	                            var mvPtr:CMoveDefExtension = CMoveDefExtension(ocPtr.ocMovements.moveList[hoPtr.rom.rmMvtNum]);
	                            if (CServices.compareStringsIgnoreCase(dllName, mvPtr.moduleName))
	                            {
	                                return hoPtr;
	                            }
	                            else
	                            {
	                                return null;
	                            }
	                        }
	                        else
	                        {
	                            return hoPtr;
	                        }
	                    }
	                    return null;
	                }
	            }
	        }
	        currentObject = null;
	        return null;
	    }

	    //*** Set Object
	    private function Action_SetObject_Object(act:CActExtension):void
	    {
	        var hoPtr:CObject = act.getParamObject(rh, 0);
	        if ((hoPtr.hoOEFlags & CObjectCommon.OEFLAG_MOVEMENTS) != 0)
	        {
	            if (hoPtr.roc.rcMovementType == CMoveDef.MVTYPE_EXT)
	            {
	                currentObject = hoPtr;
	            }
	        }
	    }
	
	    private function Action_SetObject_FixedValue(act:CActExtension):void
	    {
	        var fixed:int = act.getParamExpression(rh, 0);
	        var hoPtr:CObject = ho.getObjectFromFixed(fixed);
	
	        if (hoPtr != null)
	        {
	            if ((hoPtr.hoOEFlags & CObjectCommon.OEFLAG_MOVEMENTS) != 0)
	            {
	                if (hoPtr.roc.rcMovementType == CMoveDef.MVTYPE_EXT)
	                {
	                    currentObject = hoPtr;
	                }
	            }
	        }
	    }
	    private function RACT_POSITIONIN(act:CActExtension):void
	    {
	        var object:CObject=getCurrentObject(DLL_INANDOUT);
	        if (object!=null)
	            ho.callMovement(object, ACTION_POSITIONIN, 0);
	    }
	    private function RACT_POSITIONOUT(act:CActExtension):void
	    {
	        var object:CObject=getCurrentObject(DLL_INANDOUT);
	        if (object!=null)
	            ho.callMovement(object, ACTION_POSITIONOUT, 0);
	    }
	    private function RACT_MOVEIN(act:CActExtension):void
	    {
	        var object:CObject=getCurrentObject(DLL_INANDOUT);
	        if (object!=null)
	            ho.callMovement(object, ACTION_MOVEIN, 0);
	    }
	    private function RACT_MOVEOUT(act:CActExtension):void
	    {
	        var object:CObject=getCurrentObject(DLL_INANDOUT);
	        if (object!=null)
	            ho.callMovement(object, ACTION_MOVEOUT, 0);
	    }

	    public override function expression(num:int):CValue
	    {
	        return new CValue(0);
	    }

	}
}
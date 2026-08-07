//----------------------------------------------------------------------------------
//
// CRUNOBJECTMOVER
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	public class CRunObjectMover extends CRunExtension
	{
	    public var enabled:int;
	    public var previousX:int;
	    public var previousY:int;
	
	    public override function getNumberOfConditions():int
	    {
	        return 1;
	    }

	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	        ho.hoImgWidth = file.readInt();
	        ho.hoImgHeight = file.readInt();
	        enabled = file.readShort();
	        previousX = ho.hoX;
	        previousY = ho.hoY;
	
	        return false;
	    }

	    public override function handleRunObject():int
	    {
	        if (ho.hoX != previousX || ho.hoY != previousY)
	        {
	            var deltaX:int = ho.hoX - previousX;
	            var deltaY:int = ho.hoY - previousY;
	            if (enabled != 0)
	            {
	                var n:int;
	                var x1:int = previousX;
	                var y1:int = previousY;
	                var x2:int = previousX + ho.hoImgWidth;
	                var y2:int = previousY + ho.hoImgHeight;
	                var rhPtr:CRun = ho.hoAdRunHeader;
	                var count:int = 0;
	                for (n = 0; n < rhPtr.rhNObjects; n++)
	                {
	                    while (rhPtr.rhObjectList[count] == null)
	                    {
	                        count++;
	                    }
	                    var pHo:CObject = rhPtr.rhObjectList[count];
	                    count++;
	                    if (pHo != ho)
	                    {
	                        if (pHo.hoX >= x1 && pHo.hoX + pHo.hoImgWidth < x2)
	                        {
	                            if (pHo.hoY >= y1 && pHo.hoY + pHo.hoImgHeight < y2)
	                            {
	                                setPosition(pHo, pHo.hoX + deltaX, pHo.hoY + deltaY);
	                            }
	                        }
	                    }
	                }
	            }
	            previousX = ho.hoX;
	            previousY = ho.hoY;
	        }
	        return 0;
	    }

	    public function setPosition(pHo:CObject, x:int, y:int):void
	    {
	        if (pHo.rom != null)
	        {
	            pHo.rom.rmMovement.setXPosition(x);
	            pHo.rom.rmMovement.setYPosition(y);
	        }
	        else
	        {
	            pHo.hoX = x;
	            pHo.hoY = y;
	            if (pHo.roc != null)
	            {
	                pHo.roc.rcChanged = true;
	                pHo.roc.rcCheckCollides = true;
	            }
	        }
	    }

	    // Conditions
	    // --------------------------------------------------
	    public override function condition(num:int, cnd:CCndExtension):Boolean
	    {
	        switch (num)
	        {
	            case 0:
	                return cndEnabled(cnd);
	        }
	        return false;
	    }
	
	    public function cndEnabled(cnd:CCndExtension):Boolean
	    {
	        return enabled != 0;
	    }

	    // Actions
	    // -------------------------------------------------
	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
	            case 0:
	                actSetWidth(act);
	                break;
	            case 1:
	                actSetHeight(act);
	                break;
	            case 2:
	                actEnable(act);
	                break;
	            case 3:
	                actDisable(act);
	                break;
	        }
	    }
	
	    public function actEnable(act:CActExtension):void
	    {
	        enabled = 1;
	    }
	
	    public function actDisable(act:CActExtension):void
	    {
	        enabled = 0;
	    }
	
	    public function actSetWidth(act:CActExtension):void
	    {
	        var width:int = act.getParamExpression(rh, 0);
	        if (width > 0)
	        {
	            ho.hoImgWidth = width;
	        }
	    }
	
	    public function actSetHeight(act:CActExtension):void
	    {
	        var height:int = act.getParamExpression(rh, 0);
	        if (height > 0)
	        {
	            ho.hoImgHeight = height;
	        }
	    }

	    // Expressions
	    // --------------------------------------------
	    public override function expression(num:int):CValue
	    {
	        switch (num)
	        {
	            case 0:
	                return expGetWidth();
	            case 1:
	                return expGetHeight();
	        }
	        return null;
	    }
	
	    public function expGetWidth():CValue
	    {
	        return new CValue(ho.hoImgWidth);
	    }
	
	    public function expGetHeight():CValue
	    {
	        return new CValue(ho.hoImgHeight);
	    }

	}
}
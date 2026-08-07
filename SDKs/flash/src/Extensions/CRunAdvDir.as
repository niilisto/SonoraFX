//----------------------------------------------------------------------------------
//
// CRunAdvDir: Advanced Direction object
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Objects.*;
	
	import Params.CPositionInfo;
	import Params.PARAM_POSITION;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	public class CRunAdvDir extends CRunExtension
	{	
	    public var CurrentObject:int;
	    public var EventCount:Number;
	    public var NumDir:int;
	    public var Distance:CArrayList;
	    public var Fixed:CArrayList;
	    public var Last:CPoint;

	    public static var CND_COMPDIST:int = 0;
	    public static var CND_COMPDIR:int = 1;
	    public static var ACT_SETNUMDIR:int = 0;
	    public static var ACT_GETOBJECTS:int = 1;
	    public static var ACT_ADDOBJECTS:int = 2;
	    public static var ACT_RESET:int = 3;
	    public static var EXP_GETNUMDIR:int = 0;
	    public static var EXP_DIRECTION:int = 1;
	    public static var EXP_DISTANCE:int = 2;
	    public static var EXP_DIRECTIONLONG:int = 3;
	    public static var EXP_DISTANCELONG:int = 4;
	    public static var EXP_ROTATE:int = 5;
	    public static var EXP_DIRDIFFABS:int = 6;
	    public static var EXP_DIRDIFF:int = 7;
	    public static var EXP_GETFIXEDOBJ:int = 8;
	    public static var EXP_GETDISTOBJ:int = 9;
	    public static var EXP_XMOV:int = 10;
	    public static var EXP_YMOV:int = 11;
	    public static var EXP_DIRBASE:int = 12;
	                
		public function CRunAdvDir()
		{
			Last=new CPoint();
			Distance=new CArrayList();
			Fixed=new CArrayList();
		}
		
	    public override function getNumberOfConditions():int
	    {
	        return 2;
	    }
		
	    public function fixString(input:String):String
	    {
	    	var i:int;
	        for (i = 0; i < input.length; i++)
	        {
	            if (input.charCodeAt(i) < 10)
	            {
	                return input.substring(0, i);
	            }
	        }
	        return input;
	    }

	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	    	file.setUnicode(false);
	        file.skipBytes(8);
	        EventCount = -1;
	        var temp:String=file.readStringSize(32);
	        temp=fixString(temp);
	        NumDir=parseInt(temp, 10);
	        return true;
	    }

	    public override function condition(num:int, cnd:CCndExtension):Boolean
	    {
	        switch (num)
	        {
	            case CND_COMPDIST:
	                return CompDist(cnd.getParamPosition(rh, 0), cnd.getParamPosition(rh, 1), cnd.getParamExpression(rh, 2));
	            case CND_COMPDIR:
	                return CompDir(cnd.getParamPosition(rh, 0), cnd.getParamPosition(rh, 1), cnd.getParamExpression(rh, 2), cnd.getParamExpression(rh, 3));
	        }
	        return false;
	    }

	    public function CompDist(p1:PARAM_POSITION, p2:PARAM_POSITION, v:int):Boolean
	    {
	        var x1:int = p1.posX;
	        var y1:int = p1.posY;
	        var x2:int = p2.posX;
	        var y2:int = p2.posY;
	
	        if (Math.sqrt(((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2))) <= v)
	        {
	            return true;
	        }
	        return false;
	    }
	
	    public function cndlMin(v1:int, v2:int, v3:int):int
	    {
	        return Math.min(v1, Math.min(v2, v3));
	    }
	
	    public function CompDir(p1:PARAM_POSITION, p2:PARAM_POSITION, dir:int, offset:int):Boolean
	    {
	        var x1:int = p1.posX;
	        var y1:int = p1.posY;
	        var x2:int = p2.posX;
	        var y2:int = p2.posY;
	
	        while (dir >= NumDir)
	        {
	            dir -= NumDir;
	        }
	        while (dir < 0)
	        {
	            dir += NumDir;
	        }
	
	        var dir2:int = (((((Math.atan2(y2 - y1, x2 - x1) * 180) / Math.PI) * -1) / 360) * NumDir);
	
	        while (dir2 >= NumDir)
	        {
	            dir2 -= NumDir;
	        }
	        while (dir2 < 0)
	        {
	            dir2 += NumDir;
	        }
	
	        if (cndlMin(Math.abs(dir - dir2), Math.abs(dir - dir2 - NumDir), Math.abs(dir - dir2 + NumDir)) < offset)
	        {
	            return true;
	        }
	        return false;
	    }

	    public override function action(num:int, act:CActExtension):void
	    {   
	        switch (num)
	        {        
	            case ACT_SETNUMDIR:
	                SetNumDir(act.getParamExpression(rh, 0));
	                break;        
	            case ACT_GETOBJECTS:       
	                GetObjects(act.getParamObject(rh, 0), act.getParamPosition(rh, 1));
	                break;
	            case ACT_ADDOBJECTS:       
	                AddObjects(act.getParamObject(rh, 0));
	                break;
	            case ACT_RESET:
	                CurrentObject = 0;
	                break;
	        }
	    }

	    public function SetNumDir(n:int):void
	    {
	        NumDir = n;
	    }
	
	    public function GetObjects(object:CObject, position:CPositionInfo):void
	    {
	        var rhPtr:CRun = ho.hoAdRunHeader;
	        
	        //resetting if another event
	        if (EventCount != rhPtr.rh4EventCount)
	        {
	            CurrentObject = 0;
	            EventCount = rhPtr.rh4EventCount;
	        }
	        var x1:int = position.x;
	        var y1:int = position.y;
	        Last.x = position.x;
	        Last.y = position.y;
	        var x2:int = object.hoX;
	        var y2:int = object.hoY;
	        while (CurrentObject >= Distance.size())
	        {
	            Distance.add(null);
	            Fixed.add(null);
	        }
	        Distance.set(CurrentObject, Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)) );
	        Fixed.set(CurrentObject, int((object.hoCreationId << 16) + object.hoNumber));
	        CurrentObject++;
	    }
	
	    public function AddObjects(object:CObject):void
	    {
	        var x1:int = Last.x;
	        var y1:int = Last.y;
	        var x2:int = object.hoX;
	        var y2:int = object.hoY;
	        while (CurrentObject >= Distance.size())
	        {
	            Distance.add(null);
	            Fixed.add(null);
	        }
	        Distance.set(CurrentObject, Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)) );
	        Fixed.set(CurrentObject, (object.hoCreationId << 16) + object.hoNumber );
	        CurrentObject++;
	    }

	    public override function expression(num:int):CValue
	    {
	        switch (num)
	        {
	            case EXP_GETNUMDIR:
	                return new CValue(NumDir);
	            case EXP_DIRECTION:
	                return Direction(ho.getExpParam().getInt(), ho.getExpParam().getInt(), ho.getExpParam().getInt(), ho.getExpParam().getInt());
	            case EXP_DISTANCE:
	                return getDistance(ho.getExpParam().getInt(), ho.getExpParam().getInt(), ho.getExpParam().getInt(), ho.getExpParam().getInt());
	            case EXP_DIRECTIONLONG:
	                return LongDir(ho.getExpParam().getInt(), ho.getExpParam().getInt(), ho.getExpParam().getInt(), ho.getExpParam().getInt());
	            case EXP_DISTANCELONG:
	                return LongDist(ho.getExpParam().getInt(), ho.getExpParam().getInt(), ho.getExpParam().getInt(), ho.getExpParam().getInt());
	            case EXP_ROTATE:
	                return Rotate(ho.getExpParam().getInt(), ho.getExpParam().getInt(), ho.getExpParam().getInt());
	            case EXP_DIRDIFFABS:
	                return DirDiffAbs(ho.getExpParam().getInt(), ho.getExpParam().getInt());
	            case EXP_DIRDIFF:
	                return DirDiff(ho.getExpParam().getInt(), ho.getExpParam().getInt());
	            case EXP_GETFIXEDOBJ:
	                return GetFixedObj(ho.getExpParam().getInt());
	            case EXP_GETDISTOBJ:
	                return GetDistObj(ho.getExpParam().getInt());
	            case EXP_XMOV:
	                return XMov(ho.getExpParam().getInt(), ho.getExpParam().getInt());
	            case EXP_YMOV:
	                return YMov(ho.getExpParam().getInt(), ho.getExpParam().getInt());
	            case EXP_DIRBASE:
	                return DirBase(ho.getExpParam().getInt(), ho.getExpParam().getInt());
	        }
	        return new CValue(0);//won't be used
	    }

	    public function Direction(x1:int, y1:int, x2:int, y2:int):CValue
	    {
	        //Just doing simple math now.
	        var r:Number = Number(((((Math.atan2(y2 - y1, x2 - x1) * 180) / Math.PI) * -1) / 360) * NumDir);
	
	        while (r >= NumDir)
	        {
	            r -= NumDir;
	        }
	        while (r < 0)
	        {
	            r += NumDir;
	        }
	
	        var val:CValue=new CValue(0);
	        val.forceDouble(r);
	        return val;
	    }
	
	    public function getDistance(x1:int, y1:int, x2:int, y2:int):CValue
	    {
	        var r:Number = Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
	        var val:CValue=new CValue(0);
	        val.forceDouble(r);
	        return val;
	    }
	
	    public function LongDir(x1:int, y1:int, x2:int, y2:int):CValue
	    {
	        //Just doing simple math now.
	        var r:Number = (((((Math.atan2(y2 - y1, x2 - x1) * 180) / Math.PI) * -1) / 360) * NumDir);
	        if (r < NumDir / 2)
	        {
	            r += 0.5;
	        }
	        if (r > NumDir / 2)
	        {
	            r -= 0.5;
	        }
	        while (r >= NumDir)
	        {
	            r -= NumDir;
	        }
	        while (r < 0)
	        {
	            r += NumDir;
	        }
	
	        return new CValue(int(r));
	    }
	
	    public function LongDist(x1:int, y1:int, x2:int, y2:int):CValue
	    {
	        return new CValue(int(Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))));
	    }
	
	    public function Rotate(angle:int, angletgt:int, rotation:int):CValue
	    {
	        if (rotation < 0)
	        {
	            rotation *= -1;
	            angletgt += NumDir / 2;
	        }
	
	        while (angletgt < 0)
	        {
	            angletgt += NumDir;
	        }
	        while (angletgt >= NumDir)
	        {
	            angletgt -= NumDir;
	        }
	
	        if (Math.abs(int(angle - angletgt)) <= rotation)
	        {
	            angle = angletgt;
	        }
	        if (Math.abs(int(angle - angletgt - NumDir)) <= rotation)
	        {
	            angle = angletgt;
	        }
	        if (Math.abs(int(angle - angletgt + NumDir)) <= rotation)
	        {
	            angle = angletgt;
	        }
	
	        if (angletgt != angle)
	        {
	            if (angle - angletgt >= 0 && angle - angletgt < NumDir / 2)
	            {
	                angle -= rotation;
	            }
	            if (angle - angletgt >= NumDir / 2)
	            {
	                angle += rotation;
	            }
	            if (angle - angletgt <= 0 && angle - angletgt > NumDir / -2)
	            {
	                angle += rotation;
	            }
	            if (angle - angletgt <= NumDir / -2)
	            {
	                angle -= rotation;
	            }
	        }
	
	        while (angle >= NumDir)
	        {
	            angle -= NumDir;
	        }
	        while (angle < 0)
	        {
	            angle += NumDir;
	        }
	
	        return new CValue(angle);
	    }
	
	    public function explMin(v1:int, v2:int, v3:int):int
	    {
	        return Math.min(v1, Math.min(v2, v3));
	    }
	
	    public function lSMin(v1:int, v2:int, v3:int):int
	    {
	        if (Math.abs(v1) <= Math.abs(v2) && Math.abs(v1) <= Math.abs(v3))
	        {
	            return v1;
	        }
	        if (Math.abs(v2) <= Math.abs(v1) && Math.abs(v2) <= Math.abs(v3))
	        {
	            return v2;
	        }
	        if (Math.abs(v3) <= Math.abs(v1) && Math.abs(v3) <= Math.abs(v2))
	        {
	            return v3;
	        }
	        return 0;
	    }
	
	    public function DirDiffAbs(p1:int, p2:int):CValue
	    {
	        return new CValue(explMin(Math.abs(p1 - p2), Math.abs(p1 - p2 - NumDir), Math.abs(p1 - p2 + NumDir)));
	    }
	
	    public function DirDiff(p1:int, p2:int):CValue
	    {
	        return new CValue(lSMin(p1 - p2, p1 - p2 - NumDir, p1 - p2 + NumDir));
	    }
	
	    public function GetFixedObj(p1:int):CValue
	    {
	        if (p1 >= CurrentObject || p1 < 0)
	        {
	            p1 = CurrentObject - 1;
	        }
	        var r:int = 0;
	        if (CurrentObject > 0)
	        {
	            var Fixes:CArrayList = new CArrayList();// = (long *)malloc(sizeof(long) * rdPtr->CurrentObject);
	            var i:int;
	            for (i = 0; i < CurrentObject; i++)
	            {
	                Fixes.add(Fixed.get(i));
	            }
	            for (i = 0; i <= p1; i++)
	            {
	                var ClosestID:int = -1;
	                var k:int;
	                for (k = 0; k < CurrentObject; k++)
	                {
	                    if (Fixes.get(k) != null)
	                    {
	                        if (ClosestID == -1)
	                        {
	                            ClosestID = k;
	                        }
	                        else
	                        {
	                            var dAtK:Number = Number(Distance.get(k));
	                            var dAtClosestID:Number = Number(Distance.get(ClosestID));
	                            if (dAtK < dAtClosestID)
	                            {
	                                ClosestID = k;
	                            }
	                        }
	                    }
	                }
	                if (ClosestID != -1)
	                {
	                    Fixes.set(ClosestID, null);
	                    r = int(Fixed.get(ClosestID));
	                }
	            }
	        }
	        return new CValue(r);
	    }
	
	    public function GetDistObj(p1:int):CValue
	    {
	        if (p1 >= CurrentObject || p1 < 0)
	        {
	            p1 = CurrentObject - 1;
	        }
	        var r:int = 0;
	        if (CurrentObject > 0)
	        {
	            var Fixes:CArrayList = new CArrayList();// = (long *)malloc(sizeof(long) * rdPtr->CurrentObject);
	            var i:int;
	            for (i = 0; i < CurrentObject; i++)
	            {
	                Fixes.add(Fixed.get(i));
	            }
	            for (i = 0; i <= p1; i++)
	            {
	                var ClosestID:int = -1;
	                var k:int;
	                for (k = 0; k < CurrentObject; k++)
	                {
	                    if (Fixes.get(k) != null)
	                    {
	                        if (ClosestID == -1)
	                        {
	                            ClosestID = k;
	                        }
	                        else
	                        {
	                            var dAtK:Number = Number(Distance.get(k));
	                            var dAtClosestID:Number = Number(Distance.get(ClosestID));
	                            if (dAtK < dAtClosestID)
	                            {
	                                ClosestID = k;
	                            }
	                        }
	                    }
	                }
	                if (ClosestID != -1)
	                {
	                    Fixes.set(ClosestID, null);
	                    r = int(Distance.get(ClosestID));
	                }
	            }
	        }
	        return new CValue(r);
	    }
	
	    public function XMov(dir:int, speed:int):CValue
	    {
	        var r:Number;
	        dir = ((dir * 360) / NumDir);
	        if (dir == 270 || dir == 90)
	        {
	            r = 0;
	        }
	        else
	        {
	            var angle:Number = Number((dir * Math.PI * 2) / 360);
	            r = Number(Math.cos(angle * -1) * speed);
	        }
			var val:CValue=new CValue(0);
			val.forceDouble(r)	        
	        return val;
	    }
	
	    public function YMov(dir:int, speed:int):CValue
	    {
	        var r:Number;
	        dir = ((dir * 360) / NumDir);
	        if (dir == 180 || dir == 0)
	        {
	            r = 0;
	        }
	        else
	        {
	            var angle:Number = Number((dir * Math.PI * 2) / 360);
	            r = Number(Math.sin(angle * -1) * speed);
	        }
			var val:CValue=new CValue(0);
			val.forceDouble(r)	        
	        return val;
	    }
	
	    public function DirBase(p1:int, p2:int):CValue
	    {
	        var r:Number = Number((p1 * p2) / NumDir);
			var val:CValue=new CValue(0);
			val.forceDouble(r)	        
	        return val;
	    }

	}
}
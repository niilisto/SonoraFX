//----------------------------------------------------------------------------------
//
// CRunPlatform: Platform Movement object
// 
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Objects.CObject;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	public class CRunPlatform extends CRunExtension
	{
		public static var AID_ColObstacle:int = 0;
		public static var AID_ColJumpThrough:int = 1;
		public static var AID_SetObject:int = 2;
		public static var AID_MoveRight:int = 3;
		public static var AID_MoveLeft:int = 4;
		public static var AID_Jump:int = 5;
		public static var AID_SetXVelocity:int = 6;
		public static var AID_SetYVelocity:int = 7;
		public static var AID_SetMaxXVelocity:int = 8;
		public static var AID_SetMaxYVelocity:int = 9;
		public static var AID_SetXAccel:int = 10;
		public static var AID_SetXDecel:int = 11;
		public static var AID_SetGravity:int = 12;
		public static var AID_SetJumpStrength:int = 13;
		public static var AID_SetJumpHoldHeight:int = 14;
		public static var AID_SetStepUp:int = 15;
		public static var AID_JumpHold:int = 16;
		public static var AID_Pause:int = 17;
		public static var AID_UnPause:int = 18;
		public static var AID_SetSlopeCorrection:int = 19;
		public static var AID_SetAddXVelocity:int = 20;
		public static var AID_SetAddYVelocity:int = 21;
		public static var CID_ObstacleTest:int = 0;
		public static var CID_JumpThroughTest:int = 1;
		public static var CID_IsOnGround:int = 2;
		public static var CID_IsJumping:int = 3;
		public static var CID_IsFalling:int = 4;
		public static var CID_IsPaused:int = 5;
		public static var CID_IsMoving:int = 6;
		public static var EID_GetXVelocity:int = 0;
		public static var EID_GetYVelocity:int = 1;
		public static var EID_GetMaxXVelocity:int = 2;
		public static var EID_GetMaxYVelocity:int = 3;
		public static var EID_GetXAccel:int = 4;
		public static var EID_GetXDecel:int = 5;
		public static var EID_GetGravity:int = 6;
		public static var EID_GetJumpStrength:int = 7;
		public static var EID_GetJumpHoldHeight:int = 8;
		public static var EID_GetStepUp:int = 9;
		public static var EID_GetSlopeCorrection:int = 10;
		public static var EID_GetAddXVelocity:int = 11;
		public static var EID_GetAddYVelocity:int = 12;
		
	    public var ObjFixed:int;
	    public var ObjShortCut:int;
	    public var Col:CRunPlatformCOL;
	    public var PFMove:CRunPlatformMove;

		public function CRunPlatform()
		{
		}

	    public override function getNumberOfConditions():int
	    {
	        return 7;
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
	        PFMove = new CRunPlatformMove();
	        PFMove.MaxXVelocity = int(Number(fixString(file.readStringSize(16))));
            PFMove.MaxYVelocity = int(Number(fixString(file.readStringSize(16))));
            PFMove.XAccel = int(Number(fixString(file.readStringSize(16))));
            PFMove.XDecel = int(Number(fixString(file.readStringSize(16))));
            PFMove.Gravity = int(Number(fixString(file.readStringSize(16))));
            PFMove.JumpStrength = int(Number(fixString(file.readStringSize(16))));
            PFMove.JumpHoldHeight = int(Number(fixString(file.readStringSize(16))));
            PFMove.StepUp = int(Number(fixString(file.readStringSize(16))));
            PFMove.SlopeCorrection = int(Number(fixString(file.readStringSize(16))));
	        Col = new CRunPlatformCOL();
	        Col.JumpThroughColTop = file.readByte() == 1 ? true : false;
	        Col.EnableJumpThrough = file.readByte() == 1 ? true : false;
	        return true;
	    }

	    public function GetCObject(Fixed:int):CObject
	    {
	    	var pHo:CObject;
	    	for (pHo=ho.getFirstObject(); pHo!=null; pHo=ho.getNextObject())
	    	{
                if (((pHo.hoCreationId << 16) + pHo.hoNumber) == Fixed)
                {
                    return pHo;
                }
	    	}
	        return null;
	    }

	    public function IsOverObstacle():Boolean
	    {
	        Col.Obstacle = false;
	        ho.generateEvent(CID_ObstacleTest, ho.getEventParam());
	        return Col.Obstacle;
	    }
	
	    public function IsOverJumpThrough():Boolean
	    {
	        if (!Col.EnableJumpThrough)
	        {
	            return false;
	        }
	        Col.JumpThrough = false;
	        ho.generateEvent(CID_JumpThroughTest, ho.getEventParam());
	        return Col.JumpThrough;
	    }

	    public override function handleRunObject():int
	    {
	        var Object:CObject = GetCObject(ObjFixed);
	        // If Object is valid, do movement
	        if (!this.PFMove.Paused && Object != null)
	        {
	            if (PFMove.RightKey && !PFMove.LeftKey)
	            {
	                PFMove.XVelocity += PFMove.XAccel; // add to x velocity when pressing right
	            }
	            if (PFMove.LeftKey && !PFMove.RightKey)
	            {
	                PFMove.XVelocity -= PFMove.XAccel; // sub from x velocity when pressing left
	            }
	            if (PFMove.XVelocity != 0 && ((!PFMove.LeftKey && !PFMove.RightKey) || (PFMove.LeftKey && PFMove.RightKey)))
	            {
	                // slow the object down when not pressing right or left
	                PFMove.XVelocity -= PFMove.XVelocity / Math.abs(PFMove.XVelocity) * PFMove.XDecel;
	                if (PFMove.XVelocity <= PFMove.XDecel && PFMove.XVelocity >= 0 - PFMove.XDecel)
	                {
	                    PFMove.XVelocity = 0; // set x velocity to 0 when it's close to 0
	                }
	            }
	            /////////////////////////////////////////////////////////////////////////
	            // MOVEMENT LOOPS
	            // set velocitities to max and min
	            PFMove.XVelocity = Math.min(Math.max(PFMove.XVelocity, 0 - PFMove.MaxXVelocity), PFMove.MaxXVelocity);
	            PFMove.YVelocity = Math.min(Math.max(PFMove.YVelocity + PFMove.Gravity, 0 - PFMove.MaxYVelocity), PFMove.MaxYVelocity);
	            var tmpXVelocity:int = PFMove.XVelocity + PFMove.AddXVelocity;
	            var tmpYVelocity:int = PFMove.YVelocity + PFMove.AddYVelocity;
	            PFMove.XMoveCount += Math.abs(tmpXVelocity);
	            PFMove.YMoveCount += Math.abs(tmpYVelocity);
	
	            // X MOVEMENT LOOP
	            while (PFMove.XMoveCount > 100)
	            {
	                if (!IsOverObstacle())
	                {
	                    Object.hoX += tmpXVelocity / Math.abs(tmpXVelocity);
	                }
	
	                if (IsOverObstacle())
	                {
	                	var up:int;
	                    for (up = 0; up < PFMove.StepUp; up++) // Step up (slopes)
	                    {
	                        Object.hoY--;
	                        if (!IsOverObstacle())
	                        {
	                            break;
	                        }
	                    }
	                    if (IsOverObstacle())
	                    {
	                        Object.hoY += PFMove.StepUp;
	                        Object.hoX -= tmpXVelocity / Math.abs(tmpXVelocity);
	                        PFMove.XVelocity = PFMove.XMoveCount = 0;
	                    }
	                }
	                PFMove.XMoveCount -= 100;
	                Object.roc.rcChanged = true;
	            }
	
	            // Y MOVEMENT LOOP
	            while (PFMove.YMoveCount > 100)
	            {
	                if (!IsOverObstacle())
	                {
	                    Object.hoY += tmpYVelocity / Math.abs(tmpYVelocity);
	                    PFMove.OnGround = false;
	                }
	
	                if (IsOverObstacle())
	                {
	                    Object.hoY -= tmpYVelocity / Math.abs(tmpYVelocity);
	                    if (tmpYVelocity > 0)
	                    {
	                        PFMove.OnGround = true;
	                    }
	                    PFMove.YVelocity = PFMove.YMoveCount = 0;
	                }
	
	                if (IsOverJumpThrough() && tmpYVelocity > 0)
	                {
	                    if (Col.JumpThroughColTop)
	                    {
	                        Object.hoY--;
	                        if (!IsOverJumpThrough())
	                        {
	                            Object.hoY -= tmpYVelocity / Math.abs(tmpYVelocity);
	                            PFMove.YVelocity = PFMove.YMoveCount = 0;
	                            PFMove.OnGround = true;
	                        }
	                        Object.hoY++;
	                    }
	                    else
	                    {
	                        Object.hoY -= tmpYVelocity / Math.abs(tmpYVelocity);
	                        PFMove.YVelocity = PFMove.YMoveCount = 0;
	                        PFMove.OnGround = true;
	                    }
	                }
	                PFMove.YMoveCount -= 100;
	                Object.roc.rcChanged = true;
	
	            }
	            if (PFMove.SlopeCorrection > 0 && tmpYVelocity >= 0)
	            {
	                var tmp:Boolean = false;
	                // Slope correction
	                var sc:int;
	                for (sc = 0; sc < PFMove.SlopeCorrection; sc++)
	                {
	                    Object.hoY++;
	                    if (IsOverObstacle())
	                    {
	                        Object.hoY--;
	                        PFMove.OnGround = true;
	                        tmp = true;
	                        break;
	                    }
	                }
	                if (tmp == false)
	                {
	                    Object.hoY -= PFMove.SlopeCorrection;
	                }
	            }
	        }
	        // Reset values
	        PFMove.RightKey = false;
	        PFMove.LeftKey = false;
	        return 0;
	    }

	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
	            case AID_ColObstacle:
	                Col.Obstacle = true;
	                break;
	            case AID_ColJumpThrough:
	                Col.JumpThrough = true;
	                break;
	            case AID_SetObject:
	                SetObject(act.getParamObject(rh, 0));
	                break;
	            case AID_MoveRight:
	                PFMove.RightKey = true;
	                break;
	            case AID_MoveLeft:
	                PFMove.LeftKey = true;
	                break;
	            case AID_Jump:
	                PFMove.YVelocity = 0 - PFMove.JumpStrength;
	                break;
	            case AID_SetXVelocity:
	                PFMove.XVelocity = act.getParamExpression(rh, 0);
	                break;
	            case AID_SetYVelocity:
	                PFMove.YVelocity = act.getParamExpression(rh, 0);
	                break;
	            case AID_SetMaxXVelocity:
	                PFMove.MaxXVelocity = act.getParamExpression(rh, 0);
	                break;
	            case AID_SetMaxYVelocity:
	                PFMove.MaxYVelocity = act.getParamExpression(rh, 0);
	                break;
	            case AID_SetXAccel:
	                PFMove.XAccel = act.getParamExpression(rh, 0);
	                break;
	            case AID_SetXDecel:
	                PFMove.XDecel = act.getParamExpression(rh, 0);
	                break;
	            case AID_SetGravity:
	                PFMove.Gravity = act.getParamExpression(rh, 0);
	                break;
	            case AID_SetJumpStrength:
	                PFMove.JumpStrength = act.getParamExpression(rh, 0);
	                break;
	            case AID_SetJumpHoldHeight:
	                PFMove.JumpHoldHeight = act.getParamExpression(rh, 0);
	                break;
	            case AID_SetStepUp:
	                PFMove.StepUp = act.getParamExpression(rh, 0);
	                break;
	            case AID_JumpHold:
	                PFMove.YVelocity -= PFMove.JumpHoldHeight;
	                break;
	            case AID_Pause:
	                PFMove.Paused = true;
	                break;
	            case AID_UnPause:
	                PFMove.Paused = false;
	                break;
	            case AID_SetSlopeCorrection:
	                PFMove.SlopeCorrection = act.getParamExpression(rh, 0);
	                break;
	            case AID_SetAddXVelocity:
	                PFMove.AddXVelocity = act.getParamExpression(rh, 0);
	                break;
	            case AID_SetAddYVelocity:
	                PFMove.AddYVelocity = act.getParamExpression(rh, 0);
	                break;
	        }
	    }
	    
	    public function SetObject(object:CObject):void
	    {
	    	if (object!=null)
	    	{
	        	ObjFixed = (object.hoCreationId << 16) + object.hoNumber;
	    	}
	    	else
	    	{
	    		ObjFixed=0;
	    	}
	    }

	    public override function condition(num:int, cnd:CCndExtension):Boolean
	    {
	        switch (num)
	        {
	            case CID_ObstacleTest:
	                return true;
	            case CID_JumpThroughTest:
	                return true;
	            case CID_IsOnGround:
	                return PFMove.OnGround;
	            case CID_IsJumping:
	                return (!PFMove.OnGround && PFMove.YVelocity <= 0);
	            case CID_IsFalling:
	                return (!PFMove.OnGround && PFMove.YVelocity > 0);
	            case CID_IsPaused:
	                return PFMove.Paused;
	            case CID_IsMoving:
	                return (Math.abs(PFMove.XVelocity) > 0);
	        }
	        return false;
 	   }
	    
	    public override function expression(num:int):CValue
	    {
	        switch (num)
	        {
	            case EID_GetXVelocity:
	                return new CValue(PFMove.XVelocity);
	            case EID_GetYVelocity:
	                return new CValue(PFMove.YVelocity);
	            case EID_GetMaxXVelocity:
	                return new CValue(PFMove.MaxXVelocity);
	            case EID_GetMaxYVelocity:
	                return new CValue(PFMove.MaxYVelocity);
	            case EID_GetXAccel:
	                return new CValue(PFMove.XAccel);
	            case EID_GetXDecel:
	                return new CValue(PFMove.XDecel);
	            case EID_GetGravity:
	                return new CValue(PFMove.Gravity);
	            case EID_GetJumpStrength:
	                return new CValue(PFMove.JumpStrength);
	            case EID_GetJumpHoldHeight:
	                return new CValue(PFMove.JumpHoldHeight);
	            case EID_GetStepUp:
	                return new CValue(PFMove.StepUp);
	            case EID_GetSlopeCorrection:
	                return new CValue(PFMove.SlopeCorrection);
	            case EID_GetAddXVelocity:
	                return new CValue(PFMove.AddXVelocity);
	            case EID_GetAddYVelocity:
	                return new CValue(PFMove.AddYVelocity);
	        }
	        return new CValue(0);//won't be used
	    }
	    
	      
	}
}
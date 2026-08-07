//----------------------------------------------------------------------------------
//
// CRunkcdirect: Direction Calculator object
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Objects.CObject;
	
	import Params.CPositionInfo;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	public class CRunkcdirect extends CRunExtension
	{
	    public static var ACT_SET_TURN:int = 0;
	    public static var ACT_TURN_DIRECTIONS:int = 1;
	    public static var ACT_TURN_POS:int = 2;
	    public static var ACT_ADD_DIR:int = 3;
	    public static var ACT_DIR_SET:int = 4;
	    public static var EXP_XY_TO_DIR:int = 0;
	    public static var EXP_XY_TO_SPD:int = 1;
	    public static var EXP_DIR_TO_X:int = 2;
	    public static var EXP_DIR_TO_Y:int = 3;
	    public static var EXP_TURN_TOWARD:int = 4;
		
	    public var angle_to_turn:int = 1;
	    public var speed1:int = 20;
	    public var speed2:int = 20;
	    public var dir_to_add:int = 16;
	
		public function CRunkcdirect()
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
	

	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
	            case ACT_SET_TURN: //"Set the amount to rotate"
	                SetTurn(act.getParamExpression(rh, 0));
	                break;
	            case ACT_TURN_DIRECTIONS: //"Rotate object toward a direction"
	                TurnToDirection(act.getParamExpression(rh, 0), act.getParamObject(rh, 1));
	                break;
	            case ACT_TURN_POS: //"Rotate object toward a position"
	                TurnToPosition(act.getParamObject(rh, 0), act.getParamPosition(rh, 1));
	                break;
	            case ACT_ADD_DIR: //"Add a directional speed to an object"
	                AddDir_act(act.getParamExpression(rh, 0), act.getParamObject(rh, 1));
	                break;
	            case ACT_DIR_SET: //"Set the direction to add"
	                AngleSet(act.getParamExpression(rh, 0));
	                break;
	        }
	    }
	
	    public function SetTurn(v:int):void
	    {
	        angle_to_turn = v;
	    }
	
	    public function TurnToDirection(dir:int, object:CObject):void
	    {
	    	if (object==null)
	    	{
	    		return;
	    	}

	        var goal_angle:int, direction:int;
	        var cc:int;
	        var cl:int;
	        var angle:int;
	
	        direction = object.roc.rcDir;
	        goal_angle = dir;
	
	        goal_angle = goal_angle % 32;
	        if (goal_angle < 0)
	        {
	            goal_angle += 32;
	        }
	
	        cc = goal_angle - direction;
	        if (cc < 0)
	        {
	            cc += 32;
	        }
	        cl = direction - goal_angle;
	        if (cl < 0)
	        {
	            cl += 32;
	        }
	        if (cc < cl)
	        {
	            angle = cc;
	        }
	        else
	        {
	            angle = cl;
	        }
	        if (angle > angle_to_turn)
	        {
	            angle = angle_to_turn;
	        }
	        if (cl < cc)
	        {
	            angle = -angle;
	        }
	
	        direction += angle;
	        if (direction >= 32)
	        {
	            direction -= 32;
	        }
	        if (direction <= -1)
	        {
	            direction += 32;
	        }
	        object.roc.rcDir = direction;
	
	        object.roc.rcChanged = true;
	        object.roc.rcCheckCollides = true;
	    }
	
	    public function TurnToPosition(object:CObject, position:CPositionInfo):void
	    {
	    	if (object==null)
	    	{
	    		return;
	    	}
	    	
	        var goal_angle:int, direction:int;
	        var cc:int;
	        var cl:int;
	        var angle:int;
	        var look_angle:Number;
	        var l1:int, l2:int;
	        direction = object.roc.rcDir;
	
	        l1 = position.x;
	        l2 = position.y;
	
	        l1 -= object.hoX;
	        l2 -= object.hoY;
	
	        look_angle = Math.atan2((-l2), l1);
	        if (look_angle < 0.0)
	        {
	            look_angle = look_angle + 2.0 * 3.1416;
	        }
	
	        goal_angle = (look_angle * 32.0 / (2.0 * 3.1416) + 0.5);
	
	        cc = goal_angle - direction;
	        if (cc < 0)
	        {
	            cc += 32;
	        }
	        cl = direction - goal_angle;
	        if (cl < 0)
	        {
	            cl += 32;
	        }
	        if (cc < cl)
	        {
	            angle = cc;
	        }
	        else
	        {
	            angle = cl;
	        }
	        if (angle > angle_to_turn)
	        {
	            angle = angle_to_turn;
	        }
	        if (cl < cc)
	        {
	            angle = -angle;
	        }
	
	        direction += angle;
	        if (direction > 31)
	        {
	            direction -= 32;
	        }
	        if (direction < 0)
	        {
	            direction += 32;
	        }
	        object.roc.rcDir = direction;
	        object.roc.rcChanged = true;
	        object.roc.rcCheckCollides = true;
	    }
	
	    public function AddDir_act(speed:int, object:CObject):void
	    {
	    	if (object==null)
	    	{
	    		return;
	    	}

	        var angle1:Number, angle2:Number;
	        var x1:Number, y1:Number;
	        var x2:Number, y2:Number;
	        var x2_delta:Number, y2_delta:Number;
	        var look_angle:Number;
	        var diff_ang:Number;
	        var final_dir:int;
	        var final_speed:int;
	        var direction1:int;
	        var object_speed:int;
	        var add_speed:int;
	        add_speed = speed;
	
	        object_speed = object.roc.rcSpeed;
	        direction1 = object.roc.rcDir;
	        angle1 = (direction1 * 2 * 3.1416 / 32);
	        angle2 = (dir_to_add * 2 * 3.1416 / 32);
	
	        x1 = object_speed * Math.cos(angle1);
	        y1 = object_speed * Math.sin(angle1);
	
	        x2_delta = add_speed * Math.cos(angle2);
	        y2_delta = add_speed * Math.sin(angle2);
	        x2 = x1 + x2_delta;
	        y2 = y1 + y2_delta;
	
	        if (Math.abs((dir_to_add - direction1) % 32) != 16)
	        {
	            // Round the original angle of the object in the direction we are trying to
	            //  move it.
	            look_angle = Math.atan2(y2, x2);
	            diff_ang = look_angle - angle1;
	            if (diff_ang > 3.1416)
	            {
	                diff_ang -= 2 * 3.1416;
	            }
	            else if (diff_ang < -3.1416)
	            {
	                diff_ang += 2 * 3.1416;
	            }
	            if (diff_ang < 0.0)
	            {
	                angle1 -= 3.1416 / 32;
	            }
	            else
	            {
	                angle1 += 3.1416 / 32;
	            }
	
	            x1 = object_speed * Math.cos(angle1);
	            y1 = object_speed * Math.sin(angle1);
	
	            x2 = x1 + x2_delta;
	            y2 = y1 + y2_delta;
	        }
	        look_angle = Math.atan2(y2, x2);
	        if (look_angle < 0.0)
	        {
	            look_angle = look_angle + 2.0 * 3.1416;
	        }
	        final_dir = (look_angle * 32.0 / (2.0 * 3.1416) + 0.5);
	        if (final_dir >= 32)
	        {
	            final_dir -= 32;
	        }
	        object.roc.rcDir = final_dir;
	        final_speed = (int) (Math.sqrt(x2 * x2 + y2 * y2) + .5);
	        if (final_speed > 100)
	        {
	            final_speed = 100;
	        }
	        object.roc.rcSpeed = final_speed;
	        object.roc.rcChanged = true;
	        object.roc.rcCheckCollides = true;
	    }
	
	    public function AngleSet(angle:int):void
	    {
	        dir_to_add = angle;
	        dir_to_add = dir_to_add % 32;
	        if (dir_to_add < 0)
	        {
	            dir_to_add += 32;
	        }
	    }

	    public override function expression(num:int):CValue
	    {
	        switch (num)
	        {
	            case EXP_XY_TO_DIR:
	                return XYtoDir(ho.getExpParam().getInt(), ho.getExpParam().getInt());
	            case EXP_XY_TO_SPD:
	                return XyToSpeed(ho.getExpParam().getInt(), ho.getExpParam().getInt());
	            case EXP_DIR_TO_X:
	                return DirectionToX(ho.getExpParam().getInt(), ho.getExpParam().getInt());
	            case EXP_DIR_TO_Y:
	                return DirectionToY(ho.getExpParam().getInt(), ho.getExpParam().getInt());
	            case EXP_TURN_TOWARD:
	                return TurnToward(ho.getExpParam().getInt(), ho.getExpParam().getInt());
	        }
	        return new CValue(0);//won't be used
	    }
	
	    public function XYtoDir(x:int, y:int):CValue
	    {
	        var angle:Number;
	        var iang:int;
	        angle = Math.atan2((-y), x);
	        if (angle < 0.0)
	        {
	            angle = angle + 2.0 * 3.1416;
	        }
	        iang = (angle * 32.0 / (2.0 * 3.1416) + 0.5);
	        return new CValue(iang);
	    }
	
	    public function XyToSpeed(x:int, y:int):CValue
	    {
	        var ispeed:int;
	        var speed:Number;
	
	        speed = Math.sqrt(x * x + y * y);
	        ispeed = (speed + (speed < 0.0 ? -.5 : .5));
	
	        return new CValue(ispeed);
	    }
	
	    public function DirectionToX(dir:int, speed:int):CValue
	    {
	        var x:int;
	        var xval:Number;
	
	        dir = dir % 32;
	        if (dir < 0)
	        {
	            dir += 32;
	        }
	
	        xval = speed * Math.cos(dir * 2 * 3.1416 / 32);
	        x = (xval + (speed < 0 ? -.5 : .5));
	        return new CValue(x);
	    }
	
	    public function DirectionToY(dir:int, speed:int):CValue
	    {
	        var y:int;
	        var yval:Number;
	
	        dir = dir % 32;
	        if (dir < 0)
	        {
	            dir += 32;
	        }
	
	        yval = speed * Math.sin(dir * 2 * 3.1416 / 32);
	        y = (yval + (speed < 0 ? -.5 : .5));
	
	        return new CValue(-y);
	    }
	
	    public function TurnToward(direction:int, goal_angle:int):CValue
	    {
	        var cc:int;
	        var cl:int;
	        var angle:int;
	
	        goal_angle = goal_angle % 32;
	        if (goal_angle < 0)
	        {
	            goal_angle += 32;
	        }
	
	        direction = direction % 32;
	        if (direction < 0)
	        {
	            direction += 32;
	        }
	
	        cc = goal_angle - direction;
	        if (cc < 0)
	        {
	            cc += 32;
	        }
	        cl = direction - goal_angle;
	        if (cl < 0)
	        {
	            cl += 32;
	        }
	        if (cc < cl)
	        {
	            angle = cc;
	        }
	        else
	        {
	            angle = cl;
	        }
	        if (angle > angle_to_turn)
	        {
	            angle = angle_to_turn;
	        }
	        if (cl < cc)
	        {
	            angle = -angle;
	        }
	        direction += angle;
	        return new CValue(direction);
	    }
	}
}
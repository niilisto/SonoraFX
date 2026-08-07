/* Copyright (c) 1996-2013 Clickteam
 *
 * This source code is part of the Android exporter for Clickteam Multimedia Fusion 2.
 * 
 * Permission is hereby granted to any person obtaining a legal copy 
 * of Clickteam Multimedia Fusion 2 to use or modify this source code for 
 * debugging, optimizing, or customizing applications created with 
 * Clickteam Multimedia Fusion 2.  Any other use of this source code is prohibited.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */
//----------------------------------------------------------------------------------
//
// CRunkcdirect: Direction Calculator object
// fin 26/03/09
//greyhill
//----------------------------------------------------------------------------------
package Extensions;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import Objects.CObject;
import Params.CPositionInfo;
import RunLoop.CCreateObjectInfo;
import Services.CBinaryFile;
import Services.CFontInfo;
import Services.CRect;
import Sprites.CMask;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;

public class CRunkcdirect extends CRunExtension
{
    static final int ACT_SET_TURN = 0;
    static final int ACT_TURN_DIRECTIONS = 1;
    static final int ACT_TURN_POS = 2;
    static final int ACT_ADD_DIR = 3;
    static final int ACT_DIR_SET = 4;
    static final int EXP_XY_TO_DIR = 0;
    static final int EXP_XY_TO_SPD = 1;
    static final int EXP_DIR_TO_X = 2;
    static final int EXP_DIR_TO_Y = 3;
    static final int EXP_TURN_TOWARD = 4;

    int angle_to_turn = 1;
    int speed1 = 20;
    int speed2 = 20;
    int dir_to_add = 16;

    public CRunkcdirect()
    {
    }

    @Override
	public int getNumberOfConditions()
    {
        return 0;
    }

    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        return true;
    }

    @Override
	public void destroyRunObject(boolean bFast)
    {
    }

    @Override
	public int handleRunObject()
    {
        return REFLAG_ONESHOT;
    }

    public void displayRunObject(Canvas c, Paint p)
    {
    }

    @Override
	public void pauseRunObject()
    {
    }

    @Override
	public void continueRunObject()
    {
    }

    public void saveBackground(Bitmap b)
    {
    }

    public void restoreBackground(Canvas c, Paint p)
    {
    }

    public void killBackground()
    {
    }

    @Override
	public CFontInfo getRunObjectFont()
    {
        return null;
    }

    @Override
	public void setRunObjectFont(CFontInfo fi, CRect rc)
    {
    }

    @Override
	public int getRunObjectTextColor()
    {
        return 0;
    }

    @Override
	public void setRunObjectTextColor(int rgb)
    {
    }

    @Override
	public CMask getRunObjectCollisionMask(int flags)
    {
        return null;
    }

    public Bitmap getRunObjectSurface()
    {
        return null;
    }

    @Override
	public void getZoneInfos()
    {
    }

    // Conditions
    // --------------------------------------------------
    @Override
	public boolean condition(int num, CCndExtension cnd)
    {
        return false;
    }

    // Actions
    // -------------------------------------------------
    @Override
	public void action(int num, CActExtension act)
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

    private void SetTurn(int v)
    {
        angle_to_turn = v;
    }

    private void TurnToDirection(int dir, CObject object)
    {
        int goal_angle, direction;
        int cc;
        int cl;
        int angle;

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
        object.roc.rcDir = (short) direction;

        object.roc.rcChanged = true;
        object.roc.rcCheckCollides = true;
    }

    private void TurnToPosition(CObject object, CPositionInfo position)
    {
        int goal_angle, direction;
        int cc;
        int cl;
        int angle;
        double look_angle;
        int l1, l2;
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

        goal_angle = (int) (look_angle * 32.0 / (2.0 * 3.1416) + 0.5);

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
        object.roc.rcDir = (short) direction;
        object.roc.rcChanged = true;
        object.roc.rcCheckCollides = true;
    }

    private void AddDir_act(int speed, CObject object)
    {
        double angle1, angle2;
        double x1, y1;
        double x2, y2;
        double x2_delta, y2_delta;
        double look_angle;
        double diff_ang;
        int final_dir;
        int final_speed;
        int direction1;
        int object_speed;
        int add_speed;
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
        final_dir = (int) (look_angle * 32.0 / (2.0 * 3.1416) + 0.5);
        if (final_dir >= 32)
        {
            final_dir -= 32;
        }
        object.roc.rcDir = (short) final_dir;
        final_speed = (int) (Math.sqrt(x2 * x2 + y2 * y2) + .5);
        if (final_speed > 100)
        {
            final_speed = 100;
        }
        object.roc.rcSpeed = (short) final_speed;
        object.roc.rcChanged = true;
        object.roc.rcCheckCollides = true;
    }

    private void AngleSet(int angle)
    {
        dir_to_add = angle;
        dir_to_add = dir_to_add % 32;
        if (dir_to_add < 0)
        {
            dir_to_add += 32;
        }
    }
    
    // Expressions
    // --------------------------------------------
    @Override
	public CValue expression(int num)
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

    private CValue XYtoDir(int x, int y)
    {
        double angle;
        int iang;
        angle = Math.atan2((-y), x);
        if (angle < 0.0)
        {
            angle = angle + 2.0 * 3.1416;
        }
        iang = (int) (angle * 32.0 / (2.0 * 3.1416) + 0.5);
        return new CValue(iang);
    }

    private CValue XyToSpeed(int x, int y)
    {
        int ispeed;
        double speed;

        speed = Math.sqrt(x * x + y * y);
        ispeed = (int) (speed + (speed < 0.0 ? -.5 : .5));

        return new CValue(ispeed);
    }

    private CValue DirectionToX(int dir, int speed)
    {
        int x;
        double xval;

        dir = dir % 32;
        if (dir < 0)
        {
            dir += 32;
        }

        xval = speed * Math.cos(dir * 2 * 3.1416 / 32);
        x = (int) (xval + (speed < 0 ? -.5 : .5));
        return new CValue(x);
    }

    private CValue DirectionToY(int dir, int speed)
    {
        int y;
        double yval;

        dir = dir % 32;
        if (dir < 0)
        {
            dir += 32;
        }

        yval = speed * Math.sin(dir * 2 * 3.1416 / 32);
        y = (int) (yval + (speed < 0 ? -.5 : .5));

        return new CValue(-y);
    }

    private CValue TurnToward(int direction, int goal_angle)
    {
        int cc;
        int cl;
        int angle;

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

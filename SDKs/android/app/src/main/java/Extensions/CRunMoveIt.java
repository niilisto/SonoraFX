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
// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   CRunMoveIt.java

package Extensions;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import Objects.CObject;
import RunLoop.CCreateObjectInfo;
import Services.CBinaryFile;

public class CRunMoveIt extends CRunExtension
{
    private class MoveItItem
    {

        public int getCycles()
        {
            return cycles;
        }

        public void setCycles(int cycles)
        {
            this.cycles = cycles;
        }

        public int getDestX()
        {
            return destX;
        }

        public void setDestX(int destX)
        {
            this.destX = destX;
        }

        public int getDestY()
        {
            return destY;
        }

        public void setDestY(int destY)
        {
            this.destY = destY;
        }

        public CObject getMmfObject()
        {
            return object;
        }

        public void setMmfObject(CObject object)
        {
            this.object = object;
        }

        public int getSourceX()
        {
            return sourceX;
        }

        public void setSourceX(int sourceX)
        {
            this.sourceX = sourceX;
        }

        public int getSourceY()
        {
            return sourceY;
        }

        public void setSourceY(int sourceY)
        {
            this.sourceY = sourceY;
        }

        public int getStep()
        {
            return step;
        }

        public void setStep(int step)
        {
            this.step = step;
        }

        private CObject object;
        private int sourceX;
        private int sourceY;
        private int destX;
        private int destY;
        private int cycles;
        private int step;

        public MoveItItem(CObject object, int sourceX, int sourceY, int destX, int destY)
        {
            this.object = object;
            this.sourceX = sourceX;
            this.sourceY = sourceY;
            this.destX = destX;
            this.destY = destY;
            cycles = 0;
            step = 0;
        }
    }


    public CRunMoveIt()
    {
        movingObjects = new ArrayList<MoveItItem>();
        queue = new ArrayList<CObject>();
    }

    @Override
	public int getNumberOfConditions()
    {
        return 1;
    }

    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        return false;
    }

    @Override
	public void destroyRunObject(boolean bFast)
    {
        queue.clear();
    }

    @Override
	public int handleRunObject()
    {
        doMoveStep();
        return 0;
    }

    public boolean saveRunObject(DataOutputStream stream)
    {
        return true;
    }

    public boolean loadRunObject(DataInputStream stream)
    {
        return true;
    }

    @Override
	public boolean condition(int num, CCndExtension cnd)
    {
        return num == 0;
    }

    @Override
	public void action(int num, CActExtension act)
    {
        switch(num)
        {
        case 0: // '\0'
            act_moveObjectsWithSpeed(act);
            break;

        case 1: // '\001'
            act_moveObjectsWithTime(act);
            break;

        case 2: // '\002'
            act_stopByFixedValue(act);
            break;

        case 3: // '\003'
            act_stopByIndex(act);
            break;

        case 4: // '\004'
            act_stopByObjectSelector(act);
            break;

        case 5: // '\005'
            act_addObjectToQueue(act);
            break;

        case 6: // '\006'
            act_clearQueue();
            break;

        case 7: // '\007'
            act_stopAll();
            break;

        case 8: // '\b'
            act_doMoveStep();
            break;
        }
    }

    @Override
	public CValue expression(int num)
    {
        switch(num)
        {
        case 0: // '\0'
            return exp_getNumberOfObjectsMoving();

        case 1: // '\001'
            return exp_fromFixedGetIndex();

        case 2: // '\002'
            return exp_fromFixedGetTotalDistance();

        case 3: // '\003'
            return exp_fromFixedGetRemainingDistance();

        case 4: // '\004'
            return exp_fromFixedGetAngle();

        case 5: // '\005'
            return exp_fromFixedGetDirection();

        case 6: // '\006'
            return exp_fromIndexGetFixed();

        case 7: // '\007'
            return exp_fromIndexGetTotalDistance();

        case 8: // '\b'
            return exp_fromIndexGetRemainingDistance();

        case 9: // '\t'
            return exp_fromIndexGetAngle();

        case 10: // '\n'
            return exp_fromIndexGetDirection();

        case 11: // '\013'
            return exp_onObjectFinnishedGetFixed();
        }
        return null;
    }

    public void act_addObjectToQueue(CActExtension act)
    {
        CObject obj = act.getParamObject(rh, 0);

        if (obj == null)
            return;

        queue.add(obj);
    }

    public void act_clearQueue()
    {
        queue.clear();
    }

    private void moveObject(CObject object, int destX, int destY, int cycles)
    {
        boolean foundObject = false;
        Iterator<MoveItItem> i$ = movingObjects.iterator();
        do
        {
            if(!i$.hasNext())
                break;
            MoveItItem item = i$.next();
            if(object == item.getMmfObject())
            {
                foundObject = true;
                item.setSourceX(object.hoX);
                item.setSourceY(object.hoY);
                item.setDestX(destX);
                item.setDestY(destY);
                item.setStep(0);
                item.setCycles(Math.max(cycles, 1));
            }
        } while(true);
        if(!foundObject)
        {
            MoveItItem item = new MoveItItem(object, object.hoX, object.hoY, destX, destY);
            item.setCycles(Math.max(cycles, 1));
            movingObjects.add(item);
        }
    }

    public void act_moveObjectsWithSpeed(CActExtension act)
    {
        int destX = act.getParamExpression(rh, 0);
        int destY = act.getParamExpression(rh, 1);
        double speed = act.getParamExpression(rh, 2) / 10D;
        if(speed <= 0.0D)
            return;
        CObject object;
        int cycles;
        for(Iterator<CObject> i$ = queue.iterator(); i$.hasNext(); moveObject(object, destX, destY, cycles))
        {
            object = i$.next();
            double distance = Math.sqrt(Math.pow(object.hoX - destX, 2D) + Math.pow(object.hoY - destY, 2D));
            cycles = (int)(distance / speed);
        }

        queue.clear();
    }

    public void act_moveObjectsWithTime(CActExtension act)
    {
        int destX = act.getParamExpression(rh, 0);
        int destY = act.getParamExpression(rh, 1);
        int time = act.getParamExpression(rh, 2);
        CObject object;
        for(Iterator<CObject> i$ = queue.iterator(); i$.hasNext(); moveObject(object, destX, destY, time))
            object = i$.next();

        queue.clear();
    }

    public void act_stopAll()
    {
        movingObjects.clear();
    }

    public void act_stopByFixedValue(CActExtension act)
    {
        long fixedValue = act.getParamExpression(rh, 0);
        int i = 0;
        int moving_size = movingObjects.size();
        do
        {
            if(i >= moving_size)
                break;
            MoveItItem item = movingObjects.get(i);
            if(fixedValue == getFixedValue(item.getMmfObject()))
            {
                movingObjects.remove(i);
                moving_size = movingObjects.size();
                i--;
                break;
            }
            i++;
        } while(true);
    }

    public void act_stopByIndex(CActExtension act)
    {
        long index = act.getParamExpression(rh, 0);
        movingObjects.remove((int)index);
    }

    public void act_stopByObjectSelector(CActExtension act)
    {
        CObject object = act.getParamObject(rh, 0);
        int i = 0;
        int moving_size = movingObjects.size();
        do
        {
            if(i >= moving_size)
                break;
            MoveItItem item = movingObjects.get(i);
            if(object == item.getMmfObject())
            {
                movingObjects.remove(i);
                moving_size = movingObjects.size();
                break;
            }
            i++;
        } while(true);
    }

    public void act_doMoveStep()
    {
        doMoveStep();
    }

    private void doMoveStep()
    {
    	int moving_size = movingObjects.size();
    	for(int i = 0; i < moving_size; i++)
        {
            MoveItItem item = movingObjects.get(i);
            CObject obj = item.getMmfObject();
            if((obj.hoFlags & 1) != 0)
            {
                movingObjects.remove(i);
                moving_size = movingObjects.size();
                i--;
                continue;
            }
            int startX = item.getSourceX();
            int startY = item.getSourceY();
            int destX = item.getDestX();
            int destY = item.getDestY();
            item.setStep(item.getStep() + 1);
            int step = item.getStep();
            int cycles = item.getCycles();
            obj.hoX = ((destX - startX) * step) / cycles + startX;
            obj.hoY = ((destY - startY) * step) / cycles + startY;
            obj.roc.rcChanged = true;
            if(step >= cycles)
            {
                triggeredObject = obj;
                movingObjects.remove(i);
                moving_size = movingObjects.size();
                i--;
                ho.generateEvent(0, 0);
            }
        }

    }

    public CValue exp_getNumberOfObjectsMoving()
    {
        return new CValue(movingObjects.size());
    }

    private MoveItItem getItemFromFixed(int fixed)
    {
        for(Iterator<MoveItItem> i$ = movingObjects.iterator(); i$.hasNext();)
        {
            MoveItItem item = i$.next();
            if(getFixedValue(item.getMmfObject()) == fixed)
                return item;
        }

        return null;
    }

    public CValue exp_fromFixedGetIndex()
    {
        long fixed = ho.getExpParam().getInt();
        int movingObjects_size = movingObjects.size();
    	for(int i = 0; i < movingObjects_size; i++)
            if(getFixedValue(movingObjects.get(i).getMmfObject()) == fixed)
                return new CValue(i);

        return new CValue(-1);
    }

    public CValue exp_fromFixedGetTotalDistance()
    {
        int fixed = ho.getExpParam().getInt();
        MoveItItem item = getItemFromFixed(fixed);
        return new CValue((int)Math.sqrt(Math.pow(item.getDestX() - item.getDestX(), 2D) + Math.pow(item.getDestY() - item.getDestY(), 2D)));
    }

    public CValue exp_fromFixedGetRemainingDistance()
    {
        int fixed = ho.getExpParam().getInt();
        MoveItItem item = getItemFromFixed(fixed);
        CObject obj = item.getMmfObject();
        return new CValue((int)Math.sqrt(Math.pow(obj.hoX - item.getDestX(), 2D) + Math.pow(obj.hoY - item.getDestY(), 2D)));
    }

    public CValue exp_fromFixedGetAngle()
    {
        int fixed = ho.getExpParam().getInt();
        MoveItItem item = getItemFromFixed(fixed);
        return new CValue((int)((Math.atan2(item.getDestX() - item.getSourceX(), item.getDestY() - item.getSourceY()) * 180D) / 3.1415926535897931D + 270D));
    }

    public CValue exp_fromFixedGetDirection()
    {
        int fixed = ho.getExpParam().getInt();
        MoveItItem item = getItemFromFixed(fixed);
        return new CValue((int)((Math.atan2(item.getDestX() - item.getSourceX(), item.getDestY() - item.getSourceY()) * 16D) / 3.1415926535897931D + 24D));
    }

    public CValue exp_fromIndexGetFixed()
    {
        int index = ho.getExpParam().getInt();
        return new CValue(getFixedValue(movingObjects.get(index).getMmfObject()));
    }

    public CValue exp_fromIndexGetTotalDistance()
    {
        int index = ho.getExpParam().getInt();
        MoveItItem item = movingObjects.get(index);
        return new CValue((int)Math.sqrt(Math.pow(item.getDestX() - item.getDestX(), 2D) + Math.pow(item.getDestY() - item.getDestY(), 2D)));
    }

    public CValue exp_fromIndexGetRemainingDistance()
    {
        int index = ho.getExpParam().getInt();
        MoveItItem item = movingObjects.get(index);
        CObject obj = item.getMmfObject();
        return new CValue((int)Math.sqrt(Math.pow(obj.hoX - item.getDestX(), 2D) + Math.pow(obj.hoY - item.getDestY(), 2D)));
    }

    public CValue exp_fromIndexGetAngle()
    {
        int index = ho.getExpParam().getInt();
        MoveItItem item = movingObjects.get(index);
        return new CValue((int)((Math.atan2(item.getDestX() - item.getSourceX(), item.getDestY() - item.getSourceY()) * 180D) / 3.1415926535897931D + 270D));
    }

    public CValue exp_fromIndexGetDirection()
    {
        int index = ho.getExpParam().getInt();
        MoveItItem item = movingObjects.get(index);
        return new CValue((int)((Math.atan2(item.getDestX() - item.getSourceX(), item.getDestY() - item.getSourceY()) * 16D) / 3.1415926535897931D + 24D));
    }

    public CValue exp_onObjectFinnishedGetFixed()
    {
        if(triggeredObject != null)
            return new CValue(getFixedValue(triggeredObject));
        else
            return new CValue(-1);
    }

    private int getFixedValue(CObject obj)
    {
        return (obj.hoCreationId << 16) + (obj.hoNumber & 0xffff);
    }

    public static final int CND_ONFINNISHEDMOVING = 0;
    public static final int CND_LAST = 1;
    public static final int ACT_MOVEWITHSPEED = 0;
    public static final int ACT_MOVEWITHTIME = 1;
    public static final int ACT_STOPMOVEMENTFIXED = 2;
    public static final int ACT_STOPMOVEMENTINDEX = 3;
    public static final int ACT_STOPMOVEMENTSELECTOR = 4;
    public static final int ACT_ADDOBJECTS = 5;
    public static final int ACT_CLEARQUEUE = 6;
    public static final int ACT_STOPALL = 7;
    public static final int ACT_FORCEMOVE = 8;
    public static final int ACT_LAST = 9;
    public static final int EXP_GETNUMMOVING = 0;
    public static final int EXP_GETFIXED_INDEXVALUE = 1;
    public static final int EXP_GETFIXED_TOTALDISTANCE = 2;
    public static final int EXP_GETFIXED_REMAINING = 3;
    public static final int EXP_GETFIXED_ANGLE = 4;
    public static final int EXP_GETFIXED_DIRECTION = 5;
    public static final int EXP_GETINDEX_FIXEDVALUE = 6;
    public static final int EXP_GETINDEX_TOTALDISTANCE = 7;
    public static final int EXP_GETINDEX_REMAINING = 8;
    public static final int EXP_GETINDEX_ANGLE = 9;
    public static final int EXP_GETINDEX_DIRECTION = 10;
    public static final int EXP_GETONSTOPPEDFIXED = 11;
    public static final int EXP_LAST = 12;
    private List<MoveItItem> movingObjects;
    private List<CObject> queue;
    private CObject triggeredObject;
}

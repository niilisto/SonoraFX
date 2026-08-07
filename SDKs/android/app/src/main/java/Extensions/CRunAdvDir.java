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
// CRunAdvDir: Advanced Direction object
// fin 
//greyhill
//----------------------------------------------------------------------------------
package Extensions;

import java.util.ArrayList;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import Objects.CObject;
import Params.CPositionInfo;
import RunLoop.CCreateObjectInfo;
import RunLoop.CRun;
import Services.CBinaryFile;
import Services.CPoint;
import android.graphics.Canvas;
import android.graphics.Paint;

public class CRunAdvDir extends CRunExtension
{
    static final int CND_COMPDIST = 0;
    static final int CND_COMPDIR = 1;
    static final int ACT_SETNUMDIR = 0;
    static final int ACT_GETOBJECTS = 1;
    static final int ACT_ADDOBJECTS = 2;
    static final int ACT_RESET = 3;
    static final int EXP_GETNUMDIR = 0;
    static final int EXP_DIRECTION = 1;
    static final int EXP_DISTANCE = 2;
    static final int EXP_DIRECTIONLONG = 3;
    static final int EXP_DISTANCELONG = 4;
    static final int EXP_ROTATE = 5;
    static final int EXP_DIRDIFFABS = 6;
    static final int EXP_DIRDIFF = 7;
    static final int EXP_GETFIXEDOBJ = 8;
    static final int EXP_GETDISTOBJ = 9;
    static final int EXP_XMOV = 10;
    static final int EXP_YMOV = 11;
    static final int EXP_DIRBASE = 12;

    int CurrentObject;
    double EventCount;
    int NumDir;
    ArrayList<Double> Distance = new ArrayList<Double>(); //Float
    ArrayList<Integer> Fixed = new ArrayList<Integer>(); //Integer
    CPoint Last=new CPoint();
    CValue expRet;
    
    public CRunAdvDir()
    {
    	expRet = new CValue(0);
    }

    @Override
	public int getNumberOfConditions()
    {
        return 2;
    }

    private String fixString(String input)
    {
    	for (int i = 0; i < input.length(); i++)
        {
            if (input.charAt(i) < 10)
            {
                return input.substring(0, i);
            }
        }
        return input;
    }

    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        file.setUnicode(false);
        file.skipBytes(8);
        this.EventCount = -1;
        try
        {
            this.NumDir = Integer.parseInt(fixString(file.readString(32)), 10);
        }
        catch (Exception e)
        {
        }
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

    // Conditions
    // --------------------------------------------------
    @Override
	public boolean condition(int num, CCndExtension cnd)
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
    private boolean CompDist(CPositionInfo p1, CPositionInfo p2, int v)
    {
        int x1 = p1.x;
        int y1 = p1.y;
        int x2 = p2.x;
        int y2 = p2.y;

        if ((int) Math.sqrt(((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2))) <= v)
        {
            return true;
        }
        return false;
    }

    private int lMin(int v1, int v2, int v3)
    {
        return Math.min(v1, Math.min(v2, v3));
    /*	if(v1 <= v2 && v1 <= v3)	return v1;
    if(v2 <= v1 && v2 <= v3)	return v2;
    if(v3 <= v1 && v3 <= v2)	return v3;*/
    //return 0;
    }

    private boolean CompDir(CPositionInfo p1, CPositionInfo p2, int dir, int offset)
    {
        int x1 = p1.x;
        int y1 = p1.y;
        int x2 = p2.x;
        int y2 = p2.y;

        while (dir >= NumDir)
        {
            dir -= NumDir;
        }
        while (dir < 0)
        {
            dir += NumDir;
        }

        int dir2 = (int) (((((Math.atan2(y2 - y1, x2 - x1) * 180) / Math.PI) * -1) / 360) * NumDir);

        while (dir2 >= NumDir)
        {
            dir2 -= NumDir;
        }
        while (dir2 < 0)
        {
            dir2 += NumDir;
        }

        if (lMin(Math.abs(dir - dir2), Math.abs(dir - dir2 - NumDir), Math.abs(dir - dir2 + NumDir)) <
                offset)
        {
            return true;
        }
        return false;
    }

    // Actions
    // -------------------------------------------------
    @Override
	public void action(int num, CActExtension act)
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

    private void SetNumDir(int n)
    {
        NumDir = n;
    }

    private void GetObjects(CObject object, CPositionInfo position)
    {
        if(object == null)
        	return;
        CRun rhPtr = ho.hoAdRunHeader;        
        //resetting if another event
        if (EventCount != rhPtr.rh4EventCount)
        {
            CurrentObject = 0;
            EventCount = rhPtr.rh4EventCount;
        }
        int x1 = position.x;
        int y1 = position.y;
        Last.x = position.x;
        Last.y = position.y;
        int x2 = object.hoX;
        int y2 = object.hoY;
        
        while (CurrentObject >= Distance.size())
        {
            Distance.add(null);
            Fixed.add(null);
        }
        Distance.set(CurrentObject, Double.valueOf(Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))));
        Fixed.set(CurrentObject, Integer.valueOf((object.hoCreationId << 16) + object.hoNumber));
        CurrentObject++;
    }

    private void AddObjects(CObject object)
    {
        if(object == null)
        	return;
        int x1 = Last.x;
        int y1 = Last.y;
        int x2 = object.hoX;
        int y2 = object.hoY;
        
        while (CurrentObject >= Distance.size())
        {
            Distance.add(null);
            Fixed.add(null);
        }
        Distance.set(CurrentObject, Double.valueOf(Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))));
        Fixed.set(CurrentObject, Integer.valueOf((object.hoCreationId << 16) + object.hoNumber));
        CurrentObject++;
    }
    
    // Expressions
    // --------------------------------------------
    @Override
	public CValue expression(int num)
    {
        switch (num)
        {
            case EXP_GETNUMDIR:
                return new CValue(NumDir);
            case EXP_DIRECTION:
                return Direction(ho.getExpParam().getInt(), ho.getExpParam().getInt(), ho.getExpParam().getInt(), ho.getExpParam().getInt());
            case EXP_DISTANCE:
                return Distance(ho.getExpParam().getInt(), ho.getExpParam().getInt(), ho.getExpParam().getInt(), ho.getExpParam().getInt());
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

    private CValue Direction(int x1, int y1, int x2, int y2)
    {
        //Just doing simple math now.
        double r = (((((Math.atan2(y2 - y1, x2 - x1) * 180) / Math.PI) * -1) / 360) * NumDir);

        while (r >= NumDir)
        {
            r -= NumDir;
        }
        while (r < 0)
        {
            r += NumDir;
        }

        expRet.forceDouble(r); 
        return expRet;
    }

    private CValue Distance(int x1, int y1, int x2, int y2)
    {
        double r = Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
        expRet.forceDouble(r); 
        return expRet;
    }

    private CValue LongDir(int x1, int y1, int x2, int y2)
    {
        //Just doing simple math now.
        double r = (((((Math.atan2(y2 - y1, x2 - x1) * 180) / Math.PI) * -1) / 360) * NumDir);
        if ((int) r < NumDir / 2)
        {
            r += 0.5;
        }
        if ((int) r > NumDir / 2)
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

        expRet.forceInt((int) r); 
        return expRet;
    }

    private CValue LongDist(int x1, int y1, int x2, int y2)
    {
        expRet.forceInt((int) Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))); 
        return expRet;
    }

    private CValue Rotate(int angle, int angletgt, int rotation)
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

        if (Math.abs(angle - angletgt) <= rotation)
        {
            angle = angletgt;
        }
        if (Math.abs(angle - angletgt - NumDir) <= rotation)
        {
            angle = angletgt;
        }
        if (Math.abs(angle - angletgt + NumDir) <= rotation)
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

        expRet.forceInt(angle); 
        return expRet;
    }

    int lSMin(int v1, int v2, int v3)
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

    private CValue DirDiffAbs(int p1, int p2)
    {
        expRet.forceInt(lMin(Math.abs(p1 - p2), Math.abs(p1 - p2 - NumDir), Math.abs(p1 - p2 + NumDir))); 
        return expRet;
    }

    private CValue DirDiff(int p1, int p2)
    {
        expRet.forceInt(lSMin(p1 - p2, p1 - p2 - NumDir, p1 - p2 + NumDir)); 
        return expRet;
   }

    private CValue GetFixedObj(int p1)
    {
        if (p1 >= CurrentObject || p1 < 0)
        {
            p1 = CurrentObject - 1;
        }
        int r = 0;
        if (CurrentObject > 0)
        {
            ArrayList<Integer> Fixes = new ArrayList<Integer>();// = (long *)malloc(sizeof(long) * rdPtr->CurrentObject);
            for (int i = 0; i < CurrentObject; i++)
            {
                Fixes.add(Fixed.get(i));
            }
            for (int i = 0; i <= p1; i++)
            {
                int ClosestID = -1;
                for (int k = 0; k < CurrentObject; k++)
                {
                    if (Fixes.get(k) != null)
                    {
                        if (ClosestID == -1)
                        {
                            ClosestID = k;
                        }
                        else
                        {
                            double dAtK = Distance.get(k).floatValue();
                            double dAtClosestID = (Distance.get(ClosestID)).floatValue();
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
                    r = Fixed.get(ClosestID).intValue();
                }
            }
        }
        expRet.forceDouble(r); 
        return expRet;
    }

    private CValue GetDistObj(int p1)
    {
        if (p1 >= CurrentObject || p1 < 0)
        {
            p1 = CurrentObject - 1;
        }
        long r = 0;
        if (CurrentObject > 0)
        {
            ArrayList<Integer> Fixes = new ArrayList<Integer>();// = (long *)malloc(sizeof(long) * rdPtr->CurrentObject);
            for (int i = 0; i < CurrentObject; i++)
            {
                Fixes.add(Fixed.get(i));
            }
            for (int i = 0; i <= p1; i++)
            {
                int ClosestID = -1;
                for (int k = 0; k < CurrentObject; k++)
                {
                    if (Fixes.get(k) != null)
                    {
                        if (ClosestID == -1)
                        {
                            ClosestID = k;
                        }
                        else
                        {
                            double dAtK = Distance.get(k).floatValue();
                            double dAtClosestID = Distance.get(ClosestID).floatValue();
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
                    r = (int) Distance.get(ClosestID).floatValue();
                }
            }
        }
        expRet.forceDouble(r); 
        return expRet;
    }

    private CValue XMov(int dir, int speed)
    {
        float r;
        dir = ((dir * 360) / NumDir);
        if (dir == 270 || dir == 90)
        {
            r = 0;
        }
        else
        {
            float angle = (float) ((dir * Math.PI * 2) / 360);
            r = (float) (Math.cos(angle * -1) * speed);
        }
        expRet.forceDouble(r); 
        return expRet;
    }

    private CValue YMov(int dir, int speed)
    {
        float r;
        dir = ((dir * 360) / NumDir);
        if (dir == 180 || dir == 0)
        {
            r = 0;
        }
        else
        {
            float angle = (float) ((dir * Math.PI * 2) / 360);
            r = (float) (Math.sin(angle * -1) * speed);
        }
        expRet.forceDouble(r); 
        return expRet;
    }

    private CValue DirBase(int p1, int p2)
    {
        float r = (p1 * p2) / NumDir;
        expRet.forceDouble(r); 
        return expRet;
    }
    
}

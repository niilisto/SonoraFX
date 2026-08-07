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

/**
 * by Greyhill
 * @author Admin
 */
package Extensions;

import Expressions.CValue;

public class WargameMapExpr
{
    static final int EXP_GETWIDTH = 0;
    static final int EXP_GETHEIGHT = 1;
    static final int EXP_GETTILECOST = 2;
    static final int EXP_GETPATHCOST = 3;
    static final int EXP_GETPATHLENGTH = 4;
    static final int EXP_GETCOSTTOPOINT = 5;
    static final int EXP_GETPOINTDIRECTION = 6;
    static final int EXP_GETPOINTX = 7;
    static final int EXP_GETPOINTY = 8;
    static final int EXP_GETSTARTX = 9;
    static final int EXP_GETSTARTY = 10;
    static final int EXP_GETDESTX = 11;
    static final int EXP_GETDESTY = 12;
    static final int EXP_GETCURRENTINDEX = 13;
    static final int EXP_GETCOSTTOCURRENT = 14;
    static final int EXP_GETCURRENTDIRECTION = 15;
    static final int EXP_GETCURRENTX = 16;
    static final int EXP_GETCURRENTY = 17;
    static final int EXP_GETCOSTATPOINT = 18;
    static final int EXP_GETCOSTATCURRENT = 19;
    CRunWargameMap thisObject;

    public WargameMapExpr(CRunWargameMap object)
    {
        thisObject = object;
    }

    public CValue get(int num)
    {
        switch (num)
        {
            case EXP_GETWIDTH:
                return new CValue(thisObject.mapWidth);
            case EXP_GETHEIGHT:
                return new CValue(thisObject.mapHeight);
            case EXP_GETTILECOST:
                return eGetTileCost(thisObject.ho.getExpParam().getInt(), thisObject.ho.getExpParam().getInt());
            case EXP_GETPATHCOST:
                return eGetPathCost();
            case EXP_GETPATHLENGTH:
                return eGetPathLength();
            case EXP_GETCOSTTOPOINT:
                return eGetCostToPoint(thisObject.ho.getExpParam().getInt());
            case EXP_GETPOINTDIRECTION:
                return eGetPointDirection(thisObject.ho.getExpParam().getInt());
            case EXP_GETPOINTX:
                return eGetPointX(thisObject.ho.getExpParam().getInt());
            case EXP_GETPOINTY:
                return eGetPointY(thisObject.ho.getExpParam().getInt());
            case EXP_GETSTARTX:
                return new CValue(thisObject.startX);
            case EXP_GETSTARTY:
                return new CValue(thisObject.startY);
            case EXP_GETDESTX:
                return new CValue(thisObject.destX);
            case EXP_GETDESTY:
                return new CValue(thisObject.destY);
            case EXP_GETCURRENTINDEX:
                return new CValue(thisObject.iterator);
            case EXP_GETCOSTTOCURRENT:
                return eGetCostToCurrent();
            case EXP_GETCURRENTDIRECTION:
                return eGetCurrentDirection();
            case EXP_GETCURRENTX:
                return eGetCurrentX();
            case EXP_GETCURRENTY:
                return eGetCurrentY();
            case EXP_GETCOSTATPOINT:
                return eGetCostAtPoint(thisObject.ho.getExpParam().getInt());
            case EXP_GETCOSTATCURRENT:
                return eGetCostAtCurrent();
        }
        return new CValue(0);//won't be used
    }

    private CValue eGetTileCost(int x, int y)
    {
        if (thisObject.map == null)
        {
            return new CValue(0);
        }
        if (!thisObject.WithinBounds(x, y))
        {
            return new CValue(0);
        }
        return new CValue(thisObject.GetTileFromArray(x - 1, y - 1));
    }

    private CValue eGetPathCost()
    {
        if (thisObject.path == null)
        {
            return new CValue(0);
        }
        return new CValue(thisObject.path.get(thisObject.path.size() - 1).cumulativeCost);
    }

    private CValue eGetPathLength()
    {
        if (thisObject.path == null)
        {
            return new CValue(0);
        }
        return new CValue(thisObject.path.size() - 1);
    }

    private CValue eGetCostToPoint(int pointIndex)
    {
        if (thisObject.path == null)
        {
            return new CValue(0);
        }
        if (!thisObject.PointWithinBounds(pointIndex))
        {
            return new CValue(0);
        }
        return new CValue(thisObject.path.get(pointIndex).cumulativeCost);
    }

    private CValue eGetPointDirection(int pointIndex)
    {
        if (thisObject.path == null)
        {
            return new CValue(0);
        }
        if (!thisObject.PointWithinBounds(pointIndex))
        {
            return new CValue(0);
        }
        return new CValue(thisObject.GetKeypadStyleDirection(pointIndex));
    }

    private CValue eGetPointX(int pointIndex)
    {
        if (thisObject.path == null)
        {
            return new CValue(0);
        }
        if (!thisObject.PointWithinBounds(pointIndex))
        {
            return new CValue(0);
        }
        return new CValue(thisObject.path.get(pointIndex).x + 1);
    }

    private CValue eGetPointY(int pointIndex)
    {
        if (thisObject.path == null)
        {
            return new CValue(0);
        }
        if (!thisObject.PointWithinBounds(pointIndex))
        {
            return new CValue(0);
        }
        return new CValue(thisObject.path.get(pointIndex).y + 1);
    }

    private CValue eGetCostToCurrent()
    {
        if (thisObject.path == null)
        {
            return new CValue(0);
        }
        return new CValue(thisObject.path.get(thisObject.iterator).cumulativeCost);
    }

    private CValue eGetCurrentDirection()
    {
        if (thisObject.path == null)
        {
            return new CValue(0);
        }
        if (thisObject.iterator == 0)
        {
            return new CValue(0);
        }
        return new CValue(thisObject.GetKeypadStyleDirection(thisObject.iterator));
    }

    private CValue eGetCurrentX()
    {
        if (thisObject.path == null)
        {
            return new CValue(0);
        }
        return new CValue(thisObject.path.get(thisObject.iterator).x + 1);
    }

    private CValue eGetCurrentY()
    {
        if (thisObject.path == null)
        {
            return new CValue(0);
        }
        return new CValue(thisObject.path.get(thisObject.iterator).y + 1);
    }

    private CValue eGetCostAtPoint(int pointIndex)
    {
        if (thisObject.path == null)
        {
            return new CValue(0);
        }
        if (!thisObject.PointWithinBounds(pointIndex))
        {
            return new CValue(0);
        }
        WargameMapPathPoint p = thisObject.path.get(pointIndex);
        return new CValue(thisObject.GetTileFromArray(p.x, p.y));
    }

    private CValue eGetCostAtCurrent()
    {
        if (thisObject.path == null)
        {
            return new CValue(0);
        }
        WargameMapPathPoint p = thisObject.path.get(thisObject.iterator);
        return new CValue(thisObject.GetTileFromArray(p.x, p.y));
    }
}


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

import Conditions.CCndExtension;
import Expressions.CValue;

public class WargameMapCnds
{
    static final int CND_COMPARETILECOST = 0;
    static final int CND_TILEIMPASSABLE = 1;
    static final int CND_PATHEXISTS = 2;
    static final int CND_COMPAREPATHCOST = 3;
    static final int CND_COMPAREPATHLENGTH = 4;
    static final int CND_COMPARECOSTTOPOINT = 5;
    static final int CND_COMPAREPOINTDIRECTION = 6;
    static final int CND_COMPARECOSTTOCURRENT = 7;
    static final int CND_COMPARECURRENTDIRECTION = 8;
    static final int CND_ENDOFPATH = 9;
    CRunWargameMap thisObject;

    public WargameMapCnds(CRunWargameMap object)
    {
        thisObject = object;
    }

    public boolean get(int num, CCndExtension cnd)
    {
        switch (num)
        {
            case CND_COMPARETILECOST:
                return cCompareTileCost(cnd.getParamExpression(thisObject.rh, 0), cnd.getParamExpression(thisObject.rh, 1), cnd);
            case CND_TILEIMPASSABLE:
                return cTileImpassable(cnd.getParamExpression(thisObject.rh, 0), cnd.getParamExpression(thisObject.rh, 1));
            case CND_PATHEXISTS:
                return cPathExists();
            case CND_COMPAREPATHCOST:
                return cComparePathCost(cnd);
            case CND_COMPAREPATHLENGTH:
                return cComparePathLength(cnd);
            case CND_COMPARECOSTTOPOINT:
                return cCompareCostToPoint(cnd.getParamExpression(thisObject.rh, 0), cnd);
            case CND_COMPAREPOINTDIRECTION:
                return cComparePointDirection(cnd.getParamExpression(thisObject.rh, 0), cnd);
            case CND_COMPARECOSTTOCURRENT:
                return cCompareCostToCurrent(cnd);
            case CND_COMPARECURRENTDIRECTION:
                return cCompareCurrentDirection(cnd);
            case CND_ENDOFPATH:
                return cEndOfPath();
        }
        return false;
    }

    private boolean cCompareTileCost(int x, int y, CCndExtension cnd)
    {
        if (thisObject.WithinBounds(x, y))
        {
            return cnd.compareValues(thisObject.rh, 2, new CValue(thisObject.GetTileFromArray(x - 1, y - 1)));
        }
        return cnd.compareValues(thisObject.rh, 2, new CValue(CRunWargameMap.INF_TILE_COST));
    }

    private boolean cTileImpassable(int x, int y)
    {
        if (thisObject.WithinBounds(x, y))
        {
            return (thisObject.GetTileFromArray(x - 1, y - 1) >= CRunWargameMap.INF_TILE_COST) ? true : false;
        }
        return true;
    }

    private boolean cPathExists()
    {
        if (thisObject.path != null)
        {
            return true;
        }
        return false;
    }

    private boolean cComparePathCost(CCndExtension cnd)
    {
        if (thisObject.path == null)
        {
            return cnd.compareValues(thisObject.rh, 0, new CValue(0));
        }
        return cnd.compareValues(thisObject.rh, 0,
                new CValue(thisObject.path.get(thisObject.path.size() - 1).cumulativeCost));
    }

    private boolean cComparePathLength(CCndExtension cnd)
    {
        if (thisObject.path == null)
        {
            return cnd.compareValues(thisObject.rh, 0, new CValue(0));
        }
        return cnd.compareValues(thisObject.rh, 0,
                new CValue(thisObject.path.size() - 1));
    }

    private boolean cCompareCostToPoint(int pointIndex, CCndExtension cnd)
    {
        if (thisObject.path == null)
        {
            return cnd.compareValues(thisObject.rh, 1, new CValue(0));
        }
        if (!thisObject.PointWithinBounds(pointIndex))
        {
            return cnd.compareValues(thisObject.rh, 1, new CValue(0));
        }
        return cnd.compareValues(thisObject.rh, 1,
                new CValue(thisObject.path.get(pointIndex).cumulativeCost));
    }

    private boolean cComparePointDirection(int pointIndex, CCndExtension cnd)
    {
        if (thisObject.path == null)
        {
            return cnd.compareValues(thisObject.rh, 1, new CValue(0));
        }
        if (!thisObject.PointWithinBounds(pointIndex))
        {
            return cnd.compareValues(thisObject.rh, 1, new CValue(0));
        }
        return cnd.compareValues(thisObject.rh, 1, new CValue(thisObject.GetKeypadStyleDirection(pointIndex)));
    }

    private boolean cCompareCostToCurrent(CCndExtension cnd)
    {
        if (thisObject.path == null)
        {
            return cnd.compareValues(thisObject.rh, 0, new CValue(0));
        }
        return cnd.compareValues(thisObject.rh, 0,
                new CValue(thisObject.path.get(thisObject.iterator).cumulativeCost));
    }

    private boolean cCompareCurrentDirection(CCndExtension cnd)
    {
        if (thisObject.path == null)
        {
            return cnd.compareValues(thisObject.rh, 0, new CValue(0));
        }
        if (!thisObject.PointWithinBounds(thisObject.iterator))
        {
            return cnd.compareValues(thisObject.rh, 0, new CValue(0));
        }
        return cnd.compareValues(thisObject.rh, 0, new CValue(thisObject.GetKeypadStyleDirection(thisObject.iterator)));
    }

    private boolean cEndOfPath()
    {
        if (thisObject.path == null)
        {
            return true;
        }
        if (thisObject.iterator >= thisObject.path.size() - 1)
        {
            return true;
        }
        return false;
    }
}

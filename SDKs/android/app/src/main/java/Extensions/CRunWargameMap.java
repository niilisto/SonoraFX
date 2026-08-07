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
// CRunWargameMap: Wargame Map object
// fin 29/01/09
//greyhill
//----------------------------------------------------------------------------------

package Extensions;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.util.ArrayList;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import RunLoop.CCreateObjectInfo;
import Services.CBinaryFile;
import Services.CFontInfo;
import Services.CRect;
import Sprites.CMask;

public class CRunWargameMap extends CRunExtension
{
    static final byte SETS_OPEN_SET = 1;
    static final byte SETS_CLOSED_SET = 2;
    static final byte INF_TILE_COST = 99;
//typedef struct tagEDATA_V1
//{
//	// Header - required
//	extHeader		eHeader;
//
//	// Object's data
//	DWORD			mapWidth;
//	DWORD			mapHeight;
//	bool			oddColumnsHigh;
//
//} EDITDATA;
//typedef EDITDATA *			LPEDATA;
    int mapWidth, mapHeight;
    boolean oddColumnsHigh;
    byte map[];
    ArrayList<WargameMapPathPoint> path; //WargameMapPathPoint
    int iterator;
    int startX, startY, destX, destY;
    WargameMapActs actions = new WargameMapActs(this);
    WargameMapCnds conditions = new WargameMapCnds(this);
    WargameMapExpr expressions = new WargameMapExpr(this);

    public CRunWargameMap()
    {
    }

    @Override
	public int getNumberOfConditions()
    {
        return 10;
    }

    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        file.setUnicode(false);
        ho.hoX = cob.cobX;
        ho.hoY = cob.cobY;
        ho.hoImgWidth = 32;
        ho.hoImgHeight = 32;
        this.mapWidth = file.readInt();
        this.mapHeight = file.readInt();
        this.oddColumnsHigh = (file.readByte() == 0) ? false : true;
        this.map = new byte[this.mapWidth * this.mapHeight];
        fillMap((byte) 1);
        return true;
    }

    public void fillMap(byte v)
    {
        int map_length = this.map.length;
    	for (int i = 0; i < map_length; i++)
        {
            this.map[i] = v;
        }
    }

    private int heuristic(int x1, int y1, int x2, int y2, int oddColumnConstant)
    {
        int xdist = Math.abs(x1 - x2);
        int ydist = Math.abs(y1 - y2);
        int additional;	// This is the number of steps we must move vertically.
        // The principle of the heuristic is that for every two columns we move across,
        // we can move one row down simultaneously. This means we can remove the number of rows
        // calculated from the absolute difference between rows.
        // The result is that we have an efficient and correct heuristic for the quickest path.

        // If we're in a low column, we move down a row on every odd column rather than even columns.
        if (((x1 % 2) ^ oddColumnConstant) == 1)
        {
            additional = ydist - ((xdist + 1) / 2);
        }
        else
        {
            additional = ydist - (xdist / 2);
        }
        if (additional > 0)
        {
            return xdist + additional;
        }
        return xdist;
    }

    private ArrayList<Integer> resort(ArrayList<Integer> openHeap, int fCost[])
    {
        ArrayList<Integer> r = new ArrayList<Integer>();
        int openHeap_size = openHeap.size();
        for (int i = 0; i < openHeap_size; i++)
        {
            if (r.size() == 0)
            {
                r.add(openHeap.get(i));
            }
            else
            {
                int insertAt = r.size();
                for (int j = r.size() - 1; j >= 0; j--)
                {
                    if (fCost[openHeap.get(i).intValue()] < fCost[r.get(j).intValue()])
                    {
                        insertAt = j;
                    }
                }
                r.add(insertAt, openHeap.get(i));
            }
        }
        return r;
    }

    private ArrayList<WargameMapPathPoint> ConstructPath(int gCost[], int parent[], int x1, int y1, int x2, int y2)
    {
        ArrayList<WargameMapPathPoint> rPath = new ArrayList<WargameMapPathPoint>();
        int pos = x2 + y2 * this.mapWidth;
        int finishPos = x1 + y1 * this.mapWidth;
        // Add the current (destination) point
        WargameMapPathPoint point = new WargameMapPathPoint(x2, y2, gCost[pos]);
        rPath.add(point);
        // Go backwards through the path
        while (pos != finishPos)
        {
            pos = parent[pos];
            point = new WargameMapPathPoint(pos % this.mapWidth, pos / this.mapWidth, gCost[pos]);
            rPath.add(0, point);
        }
        return rPath;
    }

    public ArrayList<WargameMapPathPoint> Pathfinder(int x1, int y1, int x2, int y2)
    {
        class pair
        {
            int first;
            int second;

            public pair(int first, int second)
            {
                this.first = first;
                this.second = second;
            }
        }
        int oddColumnConstant = this.oddColumnsHigh ? 1 : 0;
        byte sets[] = new byte[this.mapWidth * this.mapHeight];
        int fCost[] = new int[this.mapWidth * this.mapHeight];
        int gCost[] = new int[this.mapWidth * this.mapHeight];
        int hCost[] = new int[this.mapWidth * this.mapHeight];
        int parent[] = new int[this.mapWidth * this.mapHeight];
        ArrayList<Integer>  openHeap = new ArrayList<Integer> (); //Integer
        sets[x1 + y1 * this.mapWidth] = SETS_OPEN_SET;
        openHeap.add(Integer.valueOf(x1 + y1 * this.mapWidth));
       while (!openHeap.isEmpty())
        {
            // Grab the cheapest 
            int current = openHeap.get(0).intValue(); //0 is the top
            int currentX = current % this.mapWidth;
            int currentY = (int) Math.floor(current / this.mapWidth);
            if ((currentX == x2) && (currentY == y2))
            {
                // We're done!
                return ConstructPath(gCost, parent, x1, y1, x2, y2);
            }
            // Remove from open set and add to closed set
            openHeap.remove(0);
            sets[current] = SETS_CLOSED_SET;
            // Is this column high? 1 if high, -1 if not.
            int sideColumnConstant = ((currentX % 2) ^ oddColumnConstant) * 2 - 1;
            // Get the neighbouring coordinates
            pair neighbours[] =
            {
                new pair(currentX - 1, currentY), new pair(currentX - 1, currentY + sideColumnConstant),
                new pair(currentX, currentY - 1), new pair(currentX, currentY + 1),
                new pair(currentX + 1, currentY), new pair(currentX + 1, currentY + sideColumnConstant),
            };
            // and walk through them
            for (int i = 0; i < 6; i++)
            {
                // Out of bounds?
                if ((neighbours[i].first >= this.mapWidth) || (neighbours[i].first < 0) ||
                        (neighbours[i].second >= this.mapHeight) || (neighbours[i].second < 0))
                {
                    continue;
                }
                int next = neighbours[i].first + neighbours[i].second * this.mapWidth;
                // In closed set?
                if (sets[next] == SETS_CLOSED_SET)
                {
                    continue;
                }
                // Impassable?
                if (this.map[next] >= INF_TILE_COST)
                {
                    continue;
                }
                // Calculate the cost to travel to this tile
                int g = gCost[current] + this.map[next];
                // Is this not in the open set?
                if (sets[next] != SETS_OPEN_SET)
                {
                    // Add to open set
                    sets[next] = SETS_OPEN_SET;
                    hCost[next] = heuristic(neighbours[i].first, neighbours[i].second, x2, y2, oddColumnConstant);
                    parent[next] = current;
                    gCost[next] = g;
                    fCost[next] = g + hCost[next];
                    // Add to heap
                    openHeap.add(0, Integer.valueOf(next));
                    openHeap = resort(openHeap, fCost);
                }
                // Did we find a quicker path to this tile?
                else if (g < gCost[current])
                {
                    parent[next] = current;
                    gCost[next] = g;
                    fCost[next] = g + hCost[next];
                    // We need to resort the queue now it's been updated
                    openHeap = resort(openHeap, fCost);
                }
            }
        }
        return null;
    }

    private int my_max(int x, int y)
    {
        return (x < y) ? y : x;
    }

    public boolean WithinBounds(int x, int y)
    { //1-based
        if ((x > 0) && (x <= this.mapWidth) && (y > 0) && (y <= this.mapHeight))
        {
            return true;
        }
        return false;
    }

    public boolean PointWithinBounds(int x)
    { //1-based
        if (this.path == null)
        {
            return false;
        }
        return (x <= this.path.size() - 1);
    }

    public byte GetTileFromArray(int x, int y)
    {
        return this.map[x + (y * this.mapWidth)];
    }

    public void SetTileInArray(int x, int y, byte value)
    {
        this.map[x + (y * this.mapWidth)] = value;
    }

    public ArrayList<WargameMapPathPoint> GetStraightLinePath(int x1, int y1, int x2, int y2)
    {
        int cost = 0, cumulativeCost = 0;
        int xstep = (x1 < x2) ? 1 : -1;
        int ystep = (y1 < y2) ? 1 : -1;
        ArrayList<WargameMapPathPoint> rPath = new ArrayList<WargameMapPathPoint>();
        // If the X coordinates are the same, our path is simple.
        if (x1 == x2)
        {
            while (true)
            {
                WargameMapPathPoint point;
                cost = GetTileFromArray(x1, y1);
                if (cost >= INF_TILE_COST)
                {
                    // Fail...
                    return null;
                }
                cumulativeCost += cost;
                point = new WargameMapPathPoint(x1, y1, cumulativeCost);
                rPath.add(rPath.size(), point);
                if (y1 == y2)
                {
                    // Finished!
                    return rPath;
                }
                y1 += ystep;
            }
        }
        int verticalMovement = 0, adjustedWidth = 0;
        int incrementColumn = this.oddColumnsHigh ? 1 : 0;

        // Calculate the vertical distance we should be travelling.
        // Are we going in the / direction?
        if (((x1 < x2) && (y1 > y2)) || ((x1 > x2) && (y1 < y2)))
        {
            // Reverse the columns that we increment on.
            incrementColumn = 1 - incrementColumn;
        }
        // When the Y position is equal, the rightmost column must be high.
        else if ((y1 == y2) && ((my_max(x1, x2) & 1) == incrementColumn))
        {
            incrementColumn = 1 - incrementColumn;
        }

        // Move the X coordinates left so that they lie on low columns.
        adjustedWidth = x2 - (((x2 & 1) != incrementColumn) ? 1 : 0);
        adjustedWidth -= x1 - (((x1 & 1) != incrementColumn) ? 1 : 0);
        verticalMovement = Math.abs(adjustedWidth) / 2;
        if (Math.abs(y2 - y1) != verticalMovement)
        {
            // Not a straight line. For shame.
            return null;
        }
        // If we're going backwards, reverse the columns we increment on. (Maybe for the second time!)
        if (x1 > x2)
        {
            incrementColumn = 1 - incrementColumn;
        }
        // Move in the X dimension.
        while (true)
        {
            WargameMapPathPoint point;
            cost = GetTileFromArray(x1, y1);
            if (cost >= INF_TILE_COST)
            {
                // Fail...
                return null;
            }
            cumulativeCost += cost;
            point = new WargameMapPathPoint(x1, y1, cumulativeCost);
            rPath.add(rPath.size(), point);
            if (x1 == x2)
            {
                // Finished!
                return rPath;
            }
            x1 += xstep;
            // Do we need to change the Y position?
            if ((x1 & 1) == incrementColumn)
            {
                y1 += ystep;
            }
        }
    }

    private boolean IsHighColumn(int column, boolean oddColumnsHigh)
    {
        return ((oddColumnsHigh && ((column % 2) == 1)) || (!oddColumnsHigh && ((column % 2) == 0)));
    }

    public int GetKeypadStyleDirection(int pointIndex)
    {
        if (pointIndex == 0)
        {
            return 0;
        }
        WargameMapPathPoint current = this.path.get(pointIndex);
        WargameMapPathPoint last = this.path.get(pointIndex - 1);

        switch (current.x - last.x)
        {
            case 0:
                // Same column. This means either north or south - simple.
                return (current.y < last.y) ? 8 : 2;

            case -1:
                // We've moved a column west.
                // In high columns, at the south-east Y positions are not equal.
                // but in low columns, at the south-east Y positions are equal.
                // Use XOR to negate the equality for high columns.
                return ((current.y == last.y) ^ IsHighColumn(current.x, this.oddColumnsHigh)) ? 1 : 7;

            case 1:
                // We've moved a column east.
                return ((current.y == last.y) ^ IsHighColumn(current.x, this.oddColumnsHigh)) ? 3 : 9;
        }
        // If we reached here something went wrong somewhere (how helpful)
        return 0;
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

    @Override
	public void pauseRunObject()
    {
    }

    @Override
	public void continueRunObject()
    {
    }

    public boolean saveRunObject(DataOutputStream stream)
    {
        return true;
    }

    public boolean loadRunObject(DataInputStream stream)
    {
        return true;
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

    @Override
	public void getZoneInfos()
    {
    }

    // Conditions
    // --------------------------------------------------
    @Override
	public boolean condition(int num, CCndExtension cnd)
    {
        return this.conditions.get(num, cnd);
    }

    // Actions
    // -------------------------------------------------
    @Override
	public void action(int num, CActExtension act)
    {
        this.actions.action(num, act);
    }

    // Expressions
    // --------------------------------------------
    @Override
	public CValue expression(int num)
    {
        return this.expressions.get(num);
    }
}

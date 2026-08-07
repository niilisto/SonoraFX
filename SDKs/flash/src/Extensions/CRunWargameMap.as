//----------------------------------------------------------------------------------
//
// CRunWargameMap: Wargame Map object
// fin 29/01/09
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	public class CRunWargameMap extends CRunExtension
	{
	    public static var SETS_OPEN_SET:int = 1;
	    public static var SETS_CLOSED_SET:int = 2;
	    public static var INF_TILE_COST:int = 99;

	    private static var CND_COMPARETILECOST:int = 0;
	    private static var CND_TILEIMPASSABLE:int	= 1;
	    private static var CND_PATHEXISTS:int = 2;
	    private static var CND_COMPAREPATHCOST:int = 3;
	    private static var CND_COMPAREPATHLENGTH:int = 4;
	    private static var CND_COMPARECOSTTOPOINT:int = 5;
	    private static var CND_COMPAREPOINTDIRECTION:int = 6;
	    private static var CND_COMPARECOSTTOCURRENT:int = 7;
	    private static var CND_COMPARECURRENTDIRECTION:int = 8;
	    private static var CND_ENDOFPATH:int = 9;

	    private static var ACT_SETWIDTH:int = 0;
	    private static var ACT_SETHEIGHT:int = 1;
	    private static var ACT_SETCOST:int = 2;
	    private static var ACT_CALCULATEPATH:int = 3;
	    private static var ACT_NEXTPOINT:int = 4;
	    private static var ACT_PREVPOINT:int = 5;
	    private static var ACT_RESETPOINT:int = 6;
	    private static var ACT_CALCULATELOS:int = 7;

	    private static var EXP_GETWIDTH:int = 0;
	    private static var EXP_GETHEIGHT:int = 1;
	    private static var EXP_GETTILECOST:int = 2;
	    private static var EXP_GETPATHCOST:int = 3;
	    private static var EXP_GETPATHLENGTH:int = 4;
	    private static var EXP_GETCOSTTOPOINT:int	= 5;
	    private static var EXP_GETPOINTDIRECTION:int = 6;
	    private static var EXP_GETPOINTX:int = 7;
	    private static var EXP_GETPOINTY:int = 8;
	    private static var EXP_GETSTARTX:int = 9;
	    private static var EXP_GETSTARTY:int = 10;
	    private static var EXP_GETDESTX:int = 11;
	    private static var EXP_GETDESTY:int = 12;
	    private static var EXP_GETCURRENTINDEX:int = 13;
	    private static var EXP_GETCOSTTOCURRENT:int = 14;
	    private static var EXP_GETCURRENTDIRECTION:int = 15;
	    private static var EXP_GETCURRENTX:int = 16;
	    private static var EXP_GETCURRENTY:int = 17;
	    private static var EXP_GETCOSTATPOINT:int	= 18;
	    private static var EXP_GETCOSTATCURRENT:int = 19;

	    public var mapWidth:int, mapHeight:int;
    	public var oddColumnsHigh:Boolean;
    	public var map:Array;
    	public var path:CArrayList; //WargameMapPathPoint
    	public var iterator:int;
    	public var startX:int, startY:int, destX:int, destY:int;
	    
		public function CRunWargameMap()
		{
		}

	    public override function getNumberOfConditions():int
	    {
	        return 10;
	    }

	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	        file.setUnicode(false);
	        ho.hoX = cob.cobX;
	        ho.hoY = cob.cobY;
	        ho.hoImgWidth = 32;
	        ho.hoImgHeight = 32;
	        this.mapWidth = file.readInt();
	        this.mapHeight = file.readInt();
	        this.oddColumnsHigh = (file.readByte() == 0) ? false : true;
	        this.map = new Array(this.mapWidth * this.mapHeight);
	        fillMap(1);
			return true;
	    }
	    
	    private function fillMap(v:int):void
	    {
	    	var i:int;
	        for (i = 0; i < this.map.length; i++)
	        {
	            this.map[i] = v;
	        }
	    }
	    private function heuristic(x1:int, y1:int, x2:int, y2:int, oddColumnConstant:int):int
	    {
	        var xdist:int = Math.abs(x1 - x2);
	        var ydist:int = Math.abs(y1 - y2);
	        var additional:int;	// This is the number of steps we must move vertically.
	        // The principle of the heuristic is that for every two columns we move across,
	        // we can move one row down simultaneously. This means we can remove the number of rows
	        // calculated from the absolute difference between rows.
	        // The result is that we have an efficient and correct heuristic for the quickest path.
	
	        // If we're in a low column, we move down a row on every odd column rather than even columns.
	        if (((x1 % 2) ^ oddColumnConstant) == 1)
	            additional = ydist - ((xdist + 1) / 2);
	        else
	            additional = ydist - (xdist / 2);
	        if (additional > 0)
	            return xdist + additional;
	        return xdist;
	    }
	    private function resort(openHeap:CArrayList, fCost:Array):CArrayList
	    {
	        var r:CArrayList = new CArrayList();
	        var i:int, j:int;
	        for (i = 0; i < openHeap.size(); i++)
	        {
	            if (r.size() == 0)
	            {
	                r.add(openHeap.get(i));
	            } 
	            else 
	            {
	                var insertAt:int = r.size();
	                for (j = r.size() - 1; j >= 0; j--)
	                {
	                    if (fCost[int(openHeap.get(i))] < fCost[int(r.get(j))])
	                    {
	                        insertAt = j;
	                    }
	                }
	                r.insert(insertAt, openHeap.get(i));
	            }
	        }
	        return r;
	    }
	    private function ConstructPath(gCost:Array, parent:Array, x1:int, y1:int, x2:int, y2:int):CArrayList
	    {
	        var rPath:CArrayList = new CArrayList();
	        var pos:int = x2 + y2 * this.mapWidth;
	        var finishPos:int = x1 + y1 * this.mapWidth;
	        // Add the current (destination) point
	        var point:CRunWargameMapPathPoint = new CRunWargameMapPathPoint(x2, y2, gCost[pos]);
	        rPath.add(point);
	        // Go backwards through the path
	        while (pos != finishPos)
	        {
	            pos = parent[pos];
	            point = new CRunWargameMapPathPoint(pos % this.mapWidth, pos / this.mapWidth, gCost[pos]);
	            rPath.insert(0, point);
	        }
	        return rPath;
	    }
	    public function Pathfinder(x1:int, y1:int, x2:int, y2:int):CArrayList
	    {
	        var oddColumnConstant:int = this.oddColumnsHigh ? 1 : 0;
	        var sets:Array = new Array(this.mapWidth * this.mapHeight);
	        var fCost:Array = new Array(this.mapWidth * this.mapHeight);
	        var gCost:Array = new Array(this.mapWidth * this.mapHeight);
	        var hCost:Array = new Array(this.mapWidth * this.mapHeight);
	        var parent:Array = new Array(this.mapWidth * this.mapHeight);
	        var openHeap:CArrayList = new CArrayList(); //Integer
	        sets[x1 + y1 * this.mapWidth] = SETS_OPEN_SET;
	        openHeap.add(int(x1 + y1 * this.mapWidth));
	        while (!openHeap.isEmpty())
	        {
	            // Grab the cheapest 
	            var current:int = (int(openHeap.get(0))); //0 is the top
	            var currentX:int = current % this.mapWidth;
	            var currentY:int = int(Math.floor(current / this.mapWidth));
	            if ((currentX == x2) && (currentY == y2))
	            {
	                // We're done!
	                return ConstructPath(gCost, parent, x1, y1, x2, y2);
	            }
	            // Remove from open set and add to closed set
	            openHeap.removeIndex(0);
	            sets[current] = SETS_CLOSED_SET;
	            // Is this column high? 1 if high, -1 if not.
	            var sideColumnConstant:int = ((currentX % 2) ^ oddColumnConstant) * 2 - 1;
	            // Get the neighbouring coordinates
	            var neighbours:Array=new Array(6);
	            neighbours[0]=new CRunWargameMapPair(currentX - 1, currentY);
	            neighbours[1]=new CRunWargameMapPair(currentX - 1, currentY + sideColumnConstant);
	            neighbours[2]=new CRunWargameMapPair(currentX, currentY - 1);
	            neighbours[3]=new CRunWargameMapPair(currentX, currentY + 1);
	            neighbours[4]=new CRunWargameMapPair(currentX + 1, currentY);
	            neighbours[5]=new CRunWargameMapPair(currentX + 1, currentY + sideColumnConstant);

	            // and walk through them
	            var i:int;
	            for (i = 0; i < 6; i++)
	            {
	                // Out of bounds?
	                if ((neighbours[i].first >= this.mapWidth) || (neighbours[i].first < 0) || 
	                    (neighbours[i].second >= this.mapHeight) || (neighbours[i].second < 0))
	                    continue;
	                var next:int = neighbours[i].first + neighbours[i].second * this.mapWidth;
	                // In closed set?
	                if (sets[next] == SETS_CLOSED_SET)
	                    continue;
	                // Impassable?
	                if (this.map[next] >= INF_TILE_COST)
	                    continue;
	                // Calculate the cost to travel to this tile
	                var g:int = gCost[current] + this.map[next];
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
	                    openHeap.insert(0, next);
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
	    private function my_max(x:int, y:int):int
	    {
	        return (x < y) ? y : x;
	    }
	    public function WithinBounds(x:int, y:int):Boolean
	    { //1-based
	        if ((x > 0) && (x <= this.mapWidth) && (y > 0) && (y <= this.mapHeight))
	        {
	            return true;
	        }
	        return false;
	    }
	    public function PointWithinBounds(x:int):Boolean
	    { //1-based
	        if (this.path == null)
	            return false;
	        return (x <= this.path.size() - 1);
	    }
	    public function GetTileFromArray(x:int, y:int):int
	    {
	        return this.map[x + (y * this.mapWidth)];
	    }
	    public function SetTileInArray(x:int, y:int, value:int):void
	    {
	        this.map[x + (y * this.mapWidth)] = value;
	    }
	    public function GetStraightLinePath(x1:int, y1:int, x2:int, y2:int):CArrayList
	    {
	        var cost:int = 0, cumulativeCost:int = 0;
	        var xstep:int = (x1 < x2) ? 1 : -1;
	        var ystep:int = (y1 < y2) ? 1 : -1;
	        var rPath:CArrayList = new CArrayList();
                var point:CRunWargameMapPathPoint;
	        // If the X coordinates are the same, our path is simple.
	        if (x1 == x2)
	        {
	            while (true)
	            {
	                cost = GetTileFromArray(x1, y1);
	                if (cost >= INF_TILE_COST)
	                {
	                    // Fail...
	                    return null;
	                }
	                cumulativeCost += cost;
	                point = new CRunWargameMapPathPoint(x1, y1, cumulativeCost);
	                rPath.insert(rPath.size(), point);
	                if (y1 == y2)
	                {
	                    // Finished!
	                    return rPath;
	                }
	                y1 += ystep;
	            }
	        }
	        var verticalMovement:int = 0, adjustedWidth:int = 0;
	        var incrementColumn:int = this.oddColumnsHigh ? 1 : 0;
	
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
	            cost = GetTileFromArray(x1, y1);
	            if (cost >= INF_TILE_COST)
	            {
	                // Fail...
	                return null;
	            }
	            cumulativeCost += cost;
	            point = new CRunWargameMapPathPoint(x1, y1, cumulativeCost);
	            rPath.insert(rPath.size(), point);
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
	        return null;
	    }

		private function xor(a:Boolean, b:Boolean):Boolean
		{
			if (a==false)
			{
				return b;
			}
			if (b==false)
			{
				return true;
			}
			return false;
		}
		
	    private function IsHighColumn(column:int, oddColumnsHigh:Boolean):Boolean
	    {
	        return ((oddColumnsHigh && ((column % 2) == 1)) || (!oddColumnsHigh && ((column % 2) == 0)));
	    }
	
	    public function GetKeypadStyleDirection(pointIndex:int):int
	    {
	        if (pointIndex == 0)
	        {
	            return 0;
	        }
	        var current:CRunWargameMapPathPoint = CRunWargameMapPathPoint(this.path.get(pointIndex));
	        var last:CRunWargameMapPathPoint = CRunWargameMapPathPoint(this.path.get(pointIndex - 1));
	
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
	                return xor(current.y == last.y, IsHighColumn(current.x, this.oddColumnsHigh)) ? 1 : 7;
	
	            case 1:
	                // We've moved a column east.
	                return xor(current.y == last.y, IsHighColumn(current.x, this.oddColumnsHigh)) ? 3 : 9;
	        }
	        // If we reached here something went wrong somewhere (how helpful)
	        return 0;
	    }

		public override function condition(num:int, cnd:CCndExtension):Boolean
		{
	        switch (num)
	        {
	            case CND_COMPARETILECOST:
	                return cCompareTileCost(cnd.getParamExpression(rh, 0), cnd.getParamExpression(rh, 1), cnd);
	            case CND_TILEIMPASSABLE:
	                return cTileImpassable(cnd.getParamExpression(rh, 0), cnd.getParamExpression(rh, 1));
	            case CND_PATHEXISTS:
	                return cPathExists();
	            case CND_COMPAREPATHCOST:
	                return cComparePathCost(cnd);
	            case CND_COMPAREPATHLENGTH:
	                return cComparePathLength(cnd);
	            case CND_COMPARECOSTTOPOINT:
	                return cCompareCostToPoint(cnd.getParamExpression(rh, 0), cnd);
	            case CND_COMPAREPOINTDIRECTION:
	                return cComparePointDirection(cnd.getParamExpression(rh, 0), cnd);
	            case CND_COMPARECOSTTOCURRENT:
	                return cCompareCostToCurrent(cnd);
	            case CND_COMPARECURRENTDIRECTION:
	                return cCompareCurrentDirection(cnd);
	            case CND_ENDOFPATH:
	                return cEndOfPath();
	        }
	        return false;//won't happen
		}

	    private function cCompareTileCost(x:int, y:int, cnd:CCndExtension):Boolean
	    {
	        if (WithinBounds(x, y))
	        {
	            return cnd.compareValues(rh, 2, new CValue(GetTileFromArray(x - 1, y - 1)));
	        }
	        return cnd.compareValues(rh, 2, new CValue(INF_TILE_COST));
	    }
	
	    private function cTileImpassable(x:int, y:int):Boolean
	    {
	        if (WithinBounds(x, y))
	        {
	            return (GetTileFromArray(x - 1, y - 1) >= INF_TILE_COST) ? true : false;
	        }
	        return true;
	    }
	
	    private function cPathExists():Boolean
	    {
	        if (path != null)
	        {
	            return true;
	        }
	        return false;
	    }
	
	    private function cComparePathCost(cnd:CCndExtension):Boolean
	    {
	        if (path == null)
	        {
	            return cnd.compareValues(rh, 0, new CValue(0));
	        }
	        return cnd.compareValues(rh, 0, new CValue((CRunWargameMapPathPoint(path.get(path.size() - 1))).cumulativeCost));
	    }
	
	    private function cComparePathLength(cnd:CCndExtension):Boolean
	    {
	        if (path == null)
	        {
	            return cnd.compareValues(rh, 0, new CValue(0));
	        }
	        return cnd.compareValues(rh, 0, new CValue(path.size() - 1));
	    }
	
	    private function cCompareCostToPoint(pointIndex:int, cnd:CCndExtension):Boolean
	    {
	        if (path == null)
	        {
	            return cnd.compareValues(rh, 1, new CValue(0));
	        }
	        if (!PointWithinBounds(pointIndex))
	        {
	            return cnd.compareValues(rh, 1, new CValue(0));
	        }
	        return cnd.compareValues(rh, 1, new CValue((CRunWargameMapPathPoint(path.get(pointIndex))).cumulativeCost));
	    }
	
	    private function cComparePointDirection(pointIndex:int, cnd:CCndExtension):Boolean
	    {
	        if (path == null)
	        {
	            return cnd.compareValues(rh, 1, new CValue(0));
	        }
	        if (!PointWithinBounds(pointIndex))
	        {
	            return cnd.compareValues(rh, 1, new CValue(0));
	        }
	        return cnd.compareValues(rh, 1, new CValue(GetKeypadStyleDirection(pointIndex)));
	    }
	
	    private function cCompareCostToCurrent(cnd:CCndExtension):Boolean
	    {
	        if (path == null)
	        {
	            return cnd.compareValues(rh, 0, new CValue(0));
	        }
	        return cnd.compareValues(rh, 0, new CValue((CRunWargameMapPathPoint(path.get(iterator))).cumulativeCost));
	    }
	
	    private function cCompareCurrentDirection(cnd:CCndExtension):Boolean
	    {
	        if (path == null)
	        {
	            return cnd.compareValues(rh, 0, new CValue(0));
	        }
	        if (!PointWithinBounds(iterator))
	        {
	            return cnd.compareValues(rh, 0, new CValue(0));
	        }
	        return cnd.compareValues(rh, 0, new CValue(GetKeypadStyleDirection(iterator)));
	    }
	
	    private function cEndOfPath():Boolean
	    {
	        if (path == null)
	        {
	            return true;
	        }
	        if (iterator >= path.size() - 1)
	        {
	            return true;
	        }
	        return false;
	    }


	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
	            case ACT_SETWIDTH:
	                aSetWidth(act.getParamExpression(rh, 0));
	                break;        
	            case ACT_SETHEIGHT:       
	                aSetHeight(act.getParamExpression(rh, 0));
	                break;
	            case ACT_SETCOST:       
	                aSetCost(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1), act.getParamExpression(rh, 2));
	                break;
	            case ACT_CALCULATEPATH:
	                aCalculatePath(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1), act.getParamExpression(rh, 2), act.getParamExpression(rh, 3));
	                break;
	            case ACT_NEXTPOINT:
	                aNextPoint();
	                break;
	            case ACT_PREVPOINT:
	                aPrevPoint();
	                break;
	            case ACT_RESETPOINT:
	                aResetPoint();
	                break;
	            case ACT_CALCULATELOS:
	                aCalculateLOS(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1), act.getParamExpression(rh, 2), act.getParamExpression(rh, 3));
	                break;
	        }
	    }

	    private function aSetWidth(w:int):void
	    {
	        mapWidth = w;
	        map = new Array(w * mapHeight);
	        fillMap(0);
	    }
	
	    private function aSetHeight(h:int):void
	    {
	        mapHeight = h;
	        map = new Array(h * mapWidth);
	        fillMap(0);
	    }
	
	    private function aSetCost(x:int, y:int, cost:int):void
	    {
	        if (WithinBounds(x, y))
	        {
	            if (cost > 255)
	            {
	                cost = 255;
	            }
	            SetTileInArray(x - 1, y - 1, cost);
	        }
	    }
	
	    private function aCalculatePath(startX:int, startY:int, destX:int, destY:int):void
	    {
	        startX = startX;
	        startY = startY;
	        destX = destX;
	        destY = destY;
	        path = Pathfinder(startX - 1, startY - 1, destX - 1, destY - 1);
	        iterator = 0;
	    }
	
	    private function aNextPoint():void
	    {
	        if ((path != null) && (iterator < path.size() - 1))
	        {
	            iterator++;
	        }
	    }
	
	    private function aPrevPoint():void
	    {
	        if (iterator > 0)
	        {
	            iterator--;
	        }
	    }
	
	    private function aResetPoint():void
	    {
	        iterator = 0;
	    }
	
	    private function aCalculateLOS(startX:int, startY:int, destX:int, destY:int):void
	    {
	        startX = startX;
	        startY = startY;
	        destX = destX;
	        destY = destY;
	        path = GetStraightLinePath(startX - 1, startY - 1, destX - 1, destY - 1);
	        iterator = 0;
	    }
		
	    public override function expression(num:int):CValue
	    {
	    	var ret:CValue;
	        switch (num)
	        {
	            case EXP_GETWIDTH:
	                return new CValue(mapWidth);
	            case EXP_GETHEIGHT:
	                return new CValue(mapHeight);
	            case EXP_GETTILECOST:
	                return eGetTileCost(ho.getExpParam().getInt(), ho.getExpParam().getInt());
	            case EXP_GETPATHCOST:
	                return eGetPathCost();
	            case EXP_GETPATHLENGTH:
	                return eGetPathLength();
	            case EXP_GETCOSTTOPOINT:
	                return eGetCostToPoint(ho.getExpParam().getInt());
	            case EXP_GETPOINTDIRECTION:
	                return eGetPointDirection(ho.getExpParam().getInt());
	            case EXP_GETPOINTX:
	                return eGetPointX(ho.getExpParam().getInt());
	            case EXP_GETPOINTY:
	                return eGetPointY(ho.getExpParam().getInt());
	            case EXP_GETSTARTX:
	                return new CValue(startX);
	            case EXP_GETSTARTY:
	                return new CValue(startY);
	            case EXP_GETDESTX:
	                return new CValue(destX);
	            case EXP_GETDESTY:
	                return new CValue(destY);
	            case EXP_GETCURRENTINDEX:
	                return new CValue(iterator);
	            case EXP_GETCOSTTOCURRENT:
	                return eGetCostToCurrent();
	            case EXP_GETCURRENTDIRECTION:
	                return eGetCurrentDirection();
	            case EXP_GETCURRENTX:
	                return eGetCurrentX();
	            case EXP_GETCURRENTY:
	                return eGetCurrentY();
	            case EXP_GETCOSTATPOINT:
	                return eGetCostAtPoint(ho.getExpParam().getInt());
	            case EXP_GETCOSTATCURRENT:
	                return eGetCostAtCurrent();
	        }
	        return new CValue(0);//won't be used
	    }
	    
	    private function eGetTileCost(x:int, y:int):CValue
	    {
	        if (map == null)
	        {
	            return new CValue(0);
	        }
	        if (!WithinBounds(x, y))
	        {
	            return new CValue(0);
	        }
	        return new CValue(GetTileFromArray(x - 1, y - 1));
	    }
	
	    private function eGetPathCost():CValue
	    {
	        if (path == null)
	        {
	            return new CValue(0);
	        }
	        return new CValue((CRunWargameMapPathPoint(path.get(path.size() - 1))).cumulativeCost);
	    }
	
	    private function eGetPathLength():CValue
	    {
	        if (path == null)
	        {
	            return new CValue(0);
	        }
	        return new CValue(path.size() - 1);
	    }
	
	    private function eGetCostToPoint(pointIndex:int):CValue
	    {
	        if (path == null)
	        {
	            return new CValue(0);
	        }
	        if (!PointWithinBounds(pointIndex))
	        {
	            return new CValue(0);
	        }
	        return new CValue((CRunWargameMapPathPoint(path.get(pointIndex))).cumulativeCost);
	    }
	
	    private function eGetPointDirection(pointIndex:int):CValue
	    {
	        if (path == null)
	        {
	            return new CValue(0);
	        }
	        if (!PointWithinBounds(pointIndex))
	        {
	            return new CValue(0);
	        }
	        return new CValue(GetKeypadStyleDirection(pointIndex));
	    }
	
	    private function eGetPointX(pointIndex:int):CValue
	    {
	        if (path == null)
	        {
	            return new CValue(0);
	        }
	        if (!PointWithinBounds(pointIndex))
	        {
	            return new CValue(0);
	        }
	        return new CValue((CRunWargameMapPathPoint(path.get(pointIndex))).x + 1);
	    }
	
	    private function eGetPointY(pointIndex:int):CValue
	    {
	        if (path == null)
	        {
	            return new CValue(0);
	        }
	        if (!PointWithinBounds(pointIndex))
	        {
	            return new CValue(0);
	        }
	        return new CValue((CRunWargameMapPathPoint(path.get(pointIndex))).y + 1);
	    }
	
	    private function eGetCostToCurrent():CValue
	    {
	        if (path == null)
	        {
	            return new CValue(0);
	        }
	        return new CValue((CRunWargameMapPathPoint(path.get(iterator))).cumulativeCost);
	    }
	
	    private function eGetCurrentDirection():CValue
	    {
	        if (path == null)
	        {
	            return new CValue(0);
	        }
	        if (iterator == 0)
	        {
	            return new CValue(0);
	        }
	        return new CValue(GetKeypadStyleDirection(iterator));
	    }
	
	    private function eGetCurrentX():CValue
	    {
	        if (path == null)
	        {
	            return new CValue(0);
	        }
	        return new CValue((CRunWargameMapPathPoint(path.get(iterator))).x + 1);
	    }
	
	    private function eGetCurrentY():CValue
	    {
	        if (path == null)
	        {
	            return new CValue(0);
	        }
	        return new CValue((CRunWargameMapPathPoint(path.get(iterator))).y + 1);
	    }
	
	    private function eGetCostAtPoint(pointIndex:int):CValue
	    {
	        if (path == null)
	        {
	            return new CValue(0);
	        }
	        if (!PointWithinBounds(pointIndex))
	        {
	            return new CValue(0);
	        }
	        var p:CRunWargameMapPathPoint = CRunWargameMapPathPoint(path.get(pointIndex));
	        return new CValue(GetTileFromArray(p.x, p.y));
	    }
	
	    private function eGetCostAtCurrent():CValue
	    {
	        if (path == null)
	        {
	            return new CValue(0);
	        }
	        var p:CRunWargameMapPathPoint = CRunWargameMapPathPoint(path.get(iterator));
	        return new CValue(GetTileFromArray(p.x, p.y));
	    }
	    
	}
}
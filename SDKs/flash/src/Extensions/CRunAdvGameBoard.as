//----------------------------------------------------------------------------------
//
// CRunAdvGameBoard : Advanced Game Board object
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
	
	public class CRunAdvGameBoard extends CRunExtension
	{
    	private static var MOORECEPIENT_CHANNEL:int = -1;

    	private static var CID_conOnFoundConnected:int = 0;
    	private static var CID_conOnFoundBrick:int = 1;
    	private static var CID_conOnFoundLooped:int = 2;
    	private static var CID_conOnNoFoundConnected:int = 3;
    	private static var CID_conBrickCanFallUp:int = 4;
    	private static var CID_conBrickCanFallDown:int = 5;
    	private static var CID_conBrickCanFallLeft:int = 6;
    	private static var CID_conBrickCanFallRight:int = 7;
    	private static var CID_conOnBrickMoved:int = 8;
    	private static var CID_conOnBrickDeleted:int = 9;
    	private static var CID_conIsEmpty:int = 10;

    	private static var AID_actSetBrick:int = 0;
    	private static var AID_actClear:int = 1;
    	private static var AID_actSetBoadSize:int = 2;
    	private static var AID_actSetMinConnected:int = 3;
    	private static var AID_actSearchHorizontal:int = 4;
    	private static var AID_actSearchVertical:int = 5;
    	private static var AID_actSearchDiagonalsLR:int = 6;
    	private static var AID_actSearchConnected:int = 7;
    	private static var AID_actDeleteHorizonal:int = 8;
    	private static var AID_actDeleteVertical:int = 9;
    	private static var AID_actSwap:int = 10;
    	private static var AID_actDropX:int = 11;
    	private static var AID_actDropOne:int = 12;
    	private static var AID_actMarkUsed:int = 13;
    	private static var AID_actDeleteMarked:int = 14;
    	private static var AID_actUndoSwap:int = 15;
    	private static var AID_actSearchDiagonalsRL:int = 16;
    	private static var AID_actLoopFoundBricks:int = 17;
    	private static var AID_actSetFixedOfBrick:int = 18;
    	private static var AID_actImportActives:int = 19;
    	private static var AID_actMarkCurrentSystem:int = 20;
    	private static var AID_actMarkCurrentBrick:int = 21;
    	private static var AID_actLoopEntireBoard:int = 22;
    	private static var AID_actLoopBoardOfType:int = 23;
    	private static var AID_actLoopSorrounding:int = 24;
    	private static var AID_actLoopHozLine:int = 25;
    	private static var AID_actLoopVerLine:int = 26;
    	private static var AID_actClearWithType:int = 27;
    	private static var AID_actInsertBrick:int = 28;
    	private static var AID_actSetOrigin:int = 29;
    	private static var AID_actSetCellDimensions:int = 30;
    	private static var AID_actMoveFixedON:int = 31;
    	private static var AID_actMoveFixedOFF:int = 32;
    	private static var AID_actMoveBrick:int = 33;
    	private static var AID_actDropOneUp:int = 34;
    	private static var AID_actDropOneLeft:int = 35;
    	private static var AID_actDropOneRight:int = 36;
    	private static var AID_actDropXUp:int = 37;
    	private static var AID_actDropXLeft:int = 38;
    	private static var AID_actDropXRight:int = 39;
    	private static var AID_actSetCellValue:int = 40;
    	private static var AID_actDeleteBrick:int = 41;
    	private static var AID_actShiftHosLine:int = 42;
    	private static var AID_actShiftVerLine:int = 43;
    	private static var AID_actPositionBricks:int = 44;

    	private static var EID_expGetBrickAt:int = 0;
    	private static var EID_expGetXSize:int = 1;
    	private static var EID_expGetYSize:int = 2;
    	private static var EID_expGetNumBricksInSystem:int = 3;
    	private static var EID_expGetXofBrick:int = 4;
    	private static var EID_expGetYofBrick:int = 5;
    	private static var EID_expGetFoundBrickType:int = 6;
    	private static var EID_expGetNumBricksInHozLine:int = 7;
    	private static var EID_expGetNumBricksInVerLine:int = 8;
    	private static var EID_expCountSorrounding:int = 9;
    	private static var EID_expCountTotal:int = 10;
    	private static var EID_expGetFoundBrickFixed:int = 11;
    	private static var EID_expGetFoundXofBrick:int = 12;
    	private static var EID_expGetFoundYofBrick:int = 13;
    	private static var EID_expGetTypeofBrick:int = 14;
    	private static var EID_expGetFixedOfBrick:int = 15;
    	private static var EID_expGetFixedAt:int = 16;
    	private static var EID_expLoopIndex:int = 17;
    	private static var EID_expFindXfromFixed:int = 18;
    	private static var EID_expFindYfromFixed:int = 19;
    	private static var EID_expFindBrickfromFixed:int = 20;
    	private static var EID_expGetLoopFoundXofBrick:int = 21;
    	private static var EID_expGetLoopFoundYofBrick:int = 22;
    	private static var EID_expGetLoopTypeofBrick:int = 23;
    	private static var EID_expGetLoopFoundBrickFixed:int = 24;
    	private static var EID_expLoopLoopIndex:int = 25;
        private static var EID_expGetXBrickFromX:int = 26;
    	private static var EID_expGetYBrickFromY:int = 27;
    	private static var EID_expSnapXtoGrid:int = 28;
    	private static var EID_expSnapYtoGrid:int = 29;
    	private static var EID_expGetOriginX:int = 30;
    	private static var EID_expGetOriginY:int = 31;
    	private static var EID_expGetCellWidth:int = 32;
    	private static var EID_expGetCellHeight:int = 33;
    	private static var EID_expGetCellValue:int = 34;
    	private static var EID_expGetXofCell:int = 35;
    	private static var EID_expGetYofCell:int = 36;
    	private static var EID_expMovedFixed:int = 37;
    	private static var EID_expMovedNewX:int = 38;
    	private static var EID_expMovedNewY:int = 39;
    	private static var EID_expMovedOldX:int = 40;
    	private static var EID_expMovedOldY:int = 41;
    	private static var EID_expDeletedFixed:int = 42;
    	private static var EID_expDeletedX:int = 43;
    	private static var EID_expDeletedY:int = 44;

	    public var BSizeX:int, BSizeY:int, MinConnected:int, SwapBrick1:int, SwapBrick2:int, LoopIndex:int, LoopedIndex:int, OriginX:int, OriginY:int, CellWidth:int, CellHeight:int;
	    public var Board:Array, StateBoard:Array, FixedBoard:Array, CellValues:Array;
	    public var MoveFixed:Boolean, TriggerMoved:Boolean, TriggerDeleted:Boolean;
	    public var DeletedFixed:int, DeletedX:int, DeletedY:int, MovedFixed:int, MovedNewX:int, MovedNewY:int, MovedOldX:int, MovedOldY:int;
	    public var AddIncrement:int, SearchBrickType:int;
	    public var Bricks:CArrayList = new CArrayList(); //<Integer>
	    public var Looped:CArrayList = new CArrayList(); //<Integer>

		public function CRunAdvGameBoard()
		{
		}

	    public override function getNumberOfConditions():int
	    {
	        return 11;
	    }

	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	        file.skipBytes(8);
	        this.BSizeX = file.readInt();
	        this.BSizeY = file.readInt();
	        this.MinConnected = file.readInt();
	        this.SwapBrick1 = 0;
	        this.SwapBrick2 = 0;
	        this.LoopIndex = 0;
	        this.LoopedIndex = 0;
	
	        var size:int = this.BSizeX * this.BSizeY;
	        this.Board = new Array(size);
	        this.StateBoard = new Array(size);
	        this.FixedBoard = new Array(size);
	        this.CellValues = new Array(size);
	        var i:int;
	        for (i=0; i<size; i++)
	        {
	        	Board[i]=0;
	        	StateBoard[i]=0;
	        	FixedBoard[i]=0;
	        	CellValues[i]=0;
	        }
	
	        this.OriginX = file.readInt();
	        this.OriginY = file.readInt();
	        this.CellWidth = file.readInt();
	        this.CellHeight = file.readInt();
	        this.MoveFixed = (file.readByte() != 0) ? true : false;
	        this.TriggerMoved = (file.readByte() != 0) ? true : false;
	        this.TriggerDeleted = (file.readByte() != 0) ? true : false;
	
	        this.DeletedFixed = -1;
	        this.DeletedX = -1;
	        this.DeletedY = -1;
	
	        this.MovedFixed = -1;
	        this.MovedNewX = -1;
	        this.MovedNewY = -1;
	
	        this.MovedOldX = -1;
	        this.MovedOldY = -1;
	
	        return true;
	    }

	    public function getBrick(x:int, y:int):int
	    {
	        if ((x < this.BSizeX) && (x >= 0) && (y < this.BSizeY) && (y >= 0))
	        {
	            return this.Board[this.BSizeX * y + x];
	        }
	        else
	        {
	            return -1;
	        }
	    }
	
	    public function getBrickAtPos(pos:int):int
	    {
	        if (CHECKPOS(pos))
	        {
	            return this.Board[pos];
	        }
	        return 0;
	    }
	
	    public function CHECKPOS(nPos:int):Boolean
	    {
	        if (nPos >= 0 && nPos < this.BSizeX * this.BSizeY)
	        {
	            return true;
	        }
	        return false;
	    }
	
	    public function getPos(x:int, y:int):int
	    {
	        if ((x < this.BSizeX) && (x >= 0) && (y < this.BSizeY) && (y >= 0))
	        {
	            return this.BSizeX * y + x;
	        }
	        else
	        {
	            return -1;
	        }
	    }
	
	    public function getXbrick(pos:int):int
	    {
	        return pos % this.BSizeX;
	    }
	
	    public function getYbrick(pos:int):int
	    {
	        return pos / this.BSizeX;
	    }
	
	    public function setBrick(x:int, y:int, value:int):void
	    {
	        if (CHECKPOS(getPos(x, y)))
	        {
	            this.Board[getPos(x, y)] = value;
	        }
	    }
	
	    public function getFixed(x:int, y:int):int
	    {
	        if ((x < this.BSizeX) && (x >= 0) && (y < this.BSizeY) && (y >= 0))
	        {
	            return this.FixedBoard[this.BSizeX * y + x];
	        }
	        else
	        {
	            return -1;
	        }
	    }
	
	    private function setFixed(x:int, y:int, value:int):void
	    {
	        if (CHECKPOS(getPos(x, y)))
	        {
	            this.FixedBoard[getPos(x, y)] = value;
	        }
	    }
	
	    public function wrapX(shift:int):int
	    {
	        return (shift >= 0) ? (shift % this.BSizeX) : this.BSizeX + (shift % this.BSizeX);
	    }
	
	    public function wrapY(shift:int):int
	    {
	        return (shift >= 0) ? (shift % this.BSizeY) : this.BSizeY + (shift % this.BSizeY);
	    }
	
	    public function MoveBrick(sourceX:int, sourceY:int, destX:int, destY:int):void
	    {
	
	        if ((getPos(destX, destY) != -1) && (getPos(sourceX, sourceY) != -1))
	        {
	            var triggerdeletedflag:Boolean = false;
	            var triggermovedflag:Boolean = false;
	
	            if (this.TriggerMoved)
	            {
	                this.MovedFixed = getFixed(sourceX, sourceY);
	                this.MovedNewX = destX;
	                this.MovedNewY = destY;
	                this.MovedOldX = sourceX;
	                this.MovedOldY = sourceY;
	                triggermovedflag = true;
	            }
	
	            if (this.TriggerDeleted && getBrick(destX, destY) != 0)
	            {
	                this.DeletedFixed = getFixed(destX, destY);
	                this.DeletedX = destX;
	                this.DeletedY = destY;
	                triggerdeletedflag = true;
	            }
	
	            // Move the brick
	            if (CHECKPOS(getPos(destX, destY)) && CHECKPOS(getPos(sourceX, sourceY)))
	            {
	                this.Board[getPos(destX, destY)] = Board[getPos(sourceX, sourceY)];
	                this.Board[getPos(sourceX, sourceY)] = 0;
	
	                if (this.MoveFixed)
	                {
	                    this.FixedBoard[getPos(destX, destY)] = this.FixedBoard[getPos(sourceX, sourceY)];
	                    this.FixedBoard[getPos(sourceX, sourceY)] = 0;
	                }
	            }
	            if (triggermovedflag)
	            {
	                ho.generateEvent(CID_conOnBrickMoved, ho.getEventParam());
	            }
	            if (triggerdeletedflag)
	            {
	                ho.generateEvent(CID_conOnBrickDeleted, ho.getEventParam());
	            }
	        }
	    }
	
	    public function fall():void
	    {
	    	var x:int, y:int;
	        for (x = 0; x < BSizeX; x++)
	        {
	            for (y = BSizeY - 2; y >= 0; y--)
	            {
	                if (getBrick(x, y + 1) == 0)
	                {
	                    MoveBrick(x, y, x, y + 1);
	                }
	            }
	        }
	    }
	
	    public function fallUP():void
	    {
	    	var x:int, y:int;
	        for (x = 0; x < BSizeX; x++)
	        {
	            for (y = 1; y <= BSizeY - 1; y++)
	            {
	                if (getBrick(x, y - 1) == 0)
	                {
	                    MoveBrick(x, y, x, y - 1);
	                }
	            }
	        }
	    }
	
	    public function fallLEFT():void
	    {
	    	var x:int, y:int;
	        for (y = 0; y <= BSizeY; y++)
	        {
	            for (x = 1; x < BSizeX; x++)
	            {
	                if (getBrick(x - 1, y) == 0)
	                {
	                    MoveBrick(x, y, x - 1, y);
	                }
	            }
	        }
	    }
	
	    public function fallRIGHT():void
	    {
	    	var x:int, y:int;
	        for (y = 0; y <= BSizeY; y++)
	        {
	            for (x = BSizeX - 2; x >= 0; x--)
	            {
	                if (getBrick(x + 1, y) == 0)
	                {
	                    MoveBrick(x, y, x + 1, y);
	                }
	            }
	        }
	    }

		public override function handleRunObject():int
		{
	        this.AddIncrement = 0;
	        return 0;
		}
		
		public override function condition(num:int, cnd:CCndExtension):Boolean
		{
	        switch (num)
	        {
	            case CID_conOnFoundConnected:
	                return true;
	            case CID_conOnFoundBrick:
	                return true;
	            case CID_conOnFoundLooped:
	                return true;
	            case CID_conOnNoFoundConnected:
	                return true;
	            case CID_conBrickCanFallUp:
	                return conBrickCanFallUp(cnd.getParamExpression(rh, 0), cnd.getParamExpression(rh, 1));
	            case CID_conBrickCanFallDown:
	                return conBrickCanFallDown(cnd.getParamExpression(rh, 0), cnd.getParamExpression(rh, 1));
	            case CID_conBrickCanFallLeft:
	                return conBrickCanFallLeft(cnd.getParamExpression(rh, 0), cnd.getParamExpression(rh, 1));
	            case CID_conBrickCanFallRight:
	                return conBrickCanFallRight(cnd.getParamExpression(rh, 0), cnd.getParamExpression(rh, 1));
	            case CID_conOnBrickMoved:
	                return true;
	            case CID_conOnBrickDeleted:
	                return true;
	            case CID_conIsEmpty:
	                return conIsEmpty(cnd.getParamExpression(rh, 0), cnd.getParamExpression(rh, 1));
	        }
	        return false;//won't happen
		}

	    private function conBrickCanFallUp(x:int, y:int):Boolean
	    {
	        var tempbrick:int = 0;
	        var currentbrick:int = getBrick(x, y);
	        var belowbrick:int = getBrick(x, y + 1);
	
	        if (belowbrick == -1 || currentbrick == 0 || currentbrick == -1)
	        {
	            return false;
	        }
	        
			var i:int;
	        for (i = y; i >= 0; i--)
	        {
	            tempbrick = getBrick(x, i);
	
	            if (tempbrick == 0)
	            {
	                return true;
	            }
	        }
	        return false;
	    }
	
	    private function conBrickCanFallDown(x:int, y:int):Boolean
	    {
	        var tempbrick:int = 0;
	        var currentbrick:int = getBrick(x, y);
	        var belowbrick:int = getBrick(x, y + 1);
	
	        if (belowbrick == -1 || currentbrick == 0 || currentbrick == -1)
	        {
	            return false;
	        }
	
			var i:int;
	        for (i = y; i <= BSizeY - 1; i++)
	        {
	            tempbrick = getBrick(x, i);
	
	            if (tempbrick == 0)
	            {
	                return true;
	            }
	        }
	        return false;
	    }
	
	    private function conBrickCanFallLeft(x:int, y:int):Boolean
	    {
	        var tempbrick:int = 0;
	        var currentbrick:int = getBrick(x, y);
	        var belowbrick:int = getBrick(x - 1, y);
	
	        if (belowbrick == -1 || currentbrick == 0 || currentbrick == -1)
	        {
	            return false;
	        }
	
			var i:int;
	        for (i = x; i >= 0; i--)
	        {
	            tempbrick = getBrick(i, y);
	
	            if (tempbrick == 0)
	            {
	                return true;
	            }
	        }
	        return false;
	    }
	
	    private function conBrickCanFallRight(x:int, y:int):Boolean
	    {
	        var tempbrick:int = 0;
	        var currentbrick:int = getBrick(x, y);
	        var belowbrick:int = getBrick(x + 1, y);
	
	        if (belowbrick == -1 || currentbrick == 0 || currentbrick == -1)
	        {
	            return false;
	        }
	
			var i:int;
	        for (i = x; i <= BSizeX - 1; i++)
	        {
	            tempbrick = getBrick(i, y);
	
	            if (tempbrick == 0)
	            {
	                return true;
	            }
	        }
	        return false;
	    }
	
	    private function conIsEmpty(x:int, y:int):Boolean
	    {
	        if (getBrick(x, y) == 0)
	        {
	            return true;
	        }
	        else
	        {
	            return false;
	        }
	    }



		
	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
	            case AID_actSetBrick:
	                actSetBrick(act.getParamExpression(rh, 0),
	                        act.getParamExpression(rh, 1),
	                        act.getParamExpression(rh, 2));
	                break;
	            case AID_actClear:
	                actClear();
	                break;
	            case AID_actSetBoadSize:
	                actSetBoadSize(act.getParamExpression(rh, 0),
	                        act.getParamExpression(rh, 1));
	                break;
	            case AID_actSetMinConnected:
	                MinConnected = act.getParamExpression(rh, 0);
	                break;
	            case AID_actSearchHorizontal:
	                actSearchHorizontal(act.getParamExpression(rh, 0));
	                break;
	            case AID_actSearchVertical:
	                actSearchVertical(act.getParamExpression(rh, 0));
	                break;
	            case AID_actSearchDiagonalsLR:
	                actSearchDiagonalsLR(act.getParamExpression(rh, 0));
	                break;
	            case AID_actSearchConnected:
	                actSearchConnected(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1));
	                break;
	            case AID_actDeleteHorizonal:
	                actDeleteHorizonal(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1));
	                break;
	            case AID_actDeleteVertical:
	                actDeleteVertical(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1));
	                break;
	            case AID_actSwap:
	                actSwap(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1),
	                        act.getParamExpression(rh, 2), act.getParamExpression(rh, 3));
	                break;
	            case AID_actDropX:
	                actDropX(act.getParamExpression(rh, 0));
	                break;
	            case AID_actDropOne:
	                fall();
	                break;
	            case AID_actMarkUsed:
	                actMarkUsed(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1));
	                break;
	            case AID_actDeleteMarked:
	                actDeleteMarked();
	                break;
	            case AID_actUndoSwap:
	                actUndoSwap();
	                break;
	            case AID_actSearchDiagonalsRL:
	                actSearchDiagonalsRL(act.getParamExpression(rh, 0));
	                break;
	            case AID_actLoopFoundBricks:
	                actLoopFoundBricks();
	                break;
	            case AID_actSetFixedOfBrick:
	                actSetFixedOfBrick(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1), act.getParamExpression(rh, 2));
	                break;
	            case AID_actImportActives:
	                actImportActives(act.getParamObject(rh, 0));
	                break;
	            case AID_actMarkCurrentSystem:
	                actMarkCurrentSystem();
	                break;
	            case AID_actMarkCurrentBrick:
	                actMarkCurrentBrick();
	                break;
	            case AID_actLoopEntireBoard:
	                actLoopEntireBoard();
	                break;
	            case AID_actLoopBoardOfType:
	                actLoopBoardOfType(act.getParamExpression(rh, 0));
	                break;
	            case AID_actLoopSorrounding:
	                actLoopSorrounding(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1));
	                break;
	            case AID_actLoopHozLine:
	                actLoopHozLine(act.getParamExpression(rh, 0));
	                break;
	            case AID_actLoopVerLine:
	                actLoopVerLine(act.getParamExpression(rh, 0));
	                break;
	            case AID_actClearWithType:
	                actClearWithType(act.getParamExpression(rh, 0));
	                break;
	            case AID_actInsertBrick:
	                actInsertBrick(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1), act.getParamExpression(rh, 2));
	                break;
	            case AID_actSetOrigin:
	                OriginX = act.getParamExpression(rh, 0);
	                OriginY = act.getParamExpression(rh, 1);
	                break;
	            case AID_actSetCellDimensions:
	                actSetCellDimensions(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1));
	                break;
	            case AID_actMoveFixedON:
	                MoveFixed = true;
	                break;
	            case AID_actMoveFixedOFF:
	                MoveFixed = false;
	                break;
	            case AID_actMoveBrick:
	                MoveBrick(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1),
	                        act.getParamExpression(rh, 2), act.getParamExpression(rh, 3));
	                break;
	            case AID_actDropOneUp:
	                fallUP();
	                break;
	            case AID_actDropOneLeft:
	                fallLEFT();
	                break;
	            case AID_actDropOneRight:
	                fallRIGHT();
	                break;
	            case AID_actDropXUp:
	                actDropXUp(act.getParamExpression(rh, 0));
	                break;
	            case AID_actDropXLeft:
	                actDropXLeft(act.getParamExpression(rh, 0));
	                break;
	            case AID_actDropXRight:
	                actDropXRight(act.getParamExpression(rh, 0));
	                break;
	            case AID_actSetCellValue:
	                actSetCellValue(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1), act.getParamExpression(rh, 2));
	                break;
	            case AID_actDeleteBrick:
	                actDeleteBrick(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1));
	                break;
	            case AID_actShiftHosLine:
	                actShiftHosLine(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1));
	                break;
	            case AID_actShiftVerLine:
	                actShiftVerLine(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1));
	                break;
	            case AID_actPositionBricks:
	                actPositionBricks();
	                break;
	        }
	    }
		
	    private function actSetBrick(x:int, y:int, brickType:int):void
	    {
	        setBrick(x, y, brickType);
	    }
	
	    private function actClear():void
	    {
	        var size:int = BSizeX * BSizeY;
	        var i:int;
	        for (i = 0; i < size; i++)
	        {
	            Board[i] = 0;
	        }
	    }
	
	    private function actSetBoadSize(x:int, y:int):void
	    {
	        BSizeX = x; //Update size
	        BSizeY = y;
	        var size:int = BSizeX * BSizeY;
	        Board = new Array(size);  //Create new array
	        StateBoard = new Array(size);
	        FixedBoard = new Array(size);
	        CellValues = new Array(size);
	        var i:int;
	        for (i=0; i<size; i++)
	        {
	        	Board[i]=0;
	        	StateBoard[i]=0;
	        	FixedBoard[i]=0;
	        	CellValues[i]=0;
	        }
	    }
	
	    private function actSearchHorizontal(brickType:int):void
	    {
	        var MinConnected:int = MinConnected;
	        SearchBrickType = brickType;
	        var SizeX:int = BSizeX;
	        var SizeY:int = BSizeY;
	        var Found:int = 0;
	        Bricks.clear();
	        var FoundTotal:int = 0;
	
			var y:int;
	        for (y = 0; y < SizeY; y++)
	        {
	            Found = 0;
	            Bricks.clear();
	
	         	var x:int;
	            for (x = 0; x < SizeX; x++)
	            {
	                if (getBrick(x, y) == brickType)
	                {
	                    Found++;
	                    if (CHECKPOS(getPos(x, y)))
	                    {
	                        if (StateBoard[getPos(x, y)] == 0)
	                        {
	                            Bricks.add(new int(getPos(x, y)));
	                        }
	                    }
	                }
	                else
	                {
	                    if (Found >= MinConnected)
	                    {
	                        ho.generateEvent(CID_conOnFoundConnected, ho.getEventParam());
	                        FoundTotal++;
	                    }
	                    Found = 0;
	                    Bricks.clear();
	                }
	
	            }
	            if (Found >= MinConnected)
	            {
	                ho.generateEvent(CID_conOnFoundConnected, ho.getEventParam());
	                FoundTotal++;
	            }
	            Found = 0;
	            Bricks.clear();
	        }
	
	        if (FoundTotal == 0)
	        {
	            ho.generateEvent(CID_conOnNoFoundConnected, ho.getEventParam());
	        }
	    }
	
	    private function actSearchVertical(brickType:int):void
	    {
	        var MinConnected:int = MinConnected;
	        SearchBrickType = brickType;
	        var SizeX:int = BSizeX;
	        var SizeY:int = BSizeY;
	        var Found:int = 0;
	        Bricks.clear();
	        var FoundTotal:int = 0;
	
			var x:int;
	        for (x = 0; x < SizeX; x++)
	        {
	            Found = 0;
	            Bricks.clear();
	
				var y:int;
	            for (y = 0; y < SizeY; y++)
	            {
	                if (getBrick(x, y) == brickType)
	                {
	                    Found++;
	                    if (CHECKPOS(getPos(x, y)))
	                    {
	                        if (StateBoard[getPos(x, y)] == 0)
	                        {
	                            Bricks.add(new int(getPos(x, y)));
	                        }
	                    }
	                }
	                else
	                {	//Trigger condition
	                    if (Found >= MinConnected)
	                    {
	                        ho.generateEvent(CID_conOnFoundConnected, ho.getEventParam());
	                        FoundTotal++;
	                    }
	                    Found = 0;
	                    Bricks.clear();
	                }
	
	            } // Trigger condition
	            if (Found >= MinConnected)
	            {
	                ho.generateEvent(CID_conOnFoundConnected, ho.getEventParam());
	                FoundTotal++;
	            }
	            Found = 0;
	            Bricks.clear();
	        }
	        if (FoundTotal == 0)
	        {
	            ho.generateEvent(CID_conOnNoFoundConnected, ho.getEventParam());
	        }
	    }
	
	    private function actSearchDiagonalsLR(brickType:int):void
	    {
	        var around:int = BSizeY + BSizeX + 2;
	        var startoffX:int = 0;
	        var startoffY:int = BSizeY;
	        var loopindex:int = 0;
	        var foundtotal:int = 0;
	        var foundbricks:int = 0;
	
			var i:int;
	        for (i = 0; i < around; i++)
	        {
	            if (startoffY == 0)
	            {
	                startoffX++;
	            }
	
	            if (startoffY > 0)
	            {
	                startoffY--;
	            }
	
	            loopindex = 0;
	            Bricks.clear();
	            foundbricks = 0;
	
	            while ((getPos(startoffX + loopindex, startoffY + loopindex) != -1))
	            {
	                if (getBrick(startoffX + loopindex, startoffY + loopindex) == brickType)
	                {
	                    foundbricks++;
	
	                    if (CHECKPOS(getPos(startoffX + loopindex, startoffY + loopindex)))
	                    {
	                        if (StateBoard[getPos(startoffX + loopindex, startoffY + loopindex)] == 0)
	                        {
	                            Bricks.add(new int(getPos(startoffX + loopindex, startoffY + loopindex)));
	                        }
	                    }
	                }
	                else
	                {
	
	                    if (foundbricks >= MinConnected)
	                    {
	                        ho.generateEvent(CID_conOnFoundConnected, ho.getEventParam());
	                        foundtotal++;
	                    }
	
	                    Bricks.clear();
	                    foundbricks = 0;
	                }
	                loopindex++;
	            }
	
	            if (foundbricks >= MinConnected)
	            {
	                ho.generateEvent(CID_conOnFoundConnected, ho.getEventParam());
	                foundtotal++;
	            }
	        }
	        if (foundtotal == 0)
	        {
	            ho.generateEvent(CID_conOnNoFoundConnected, ho.getEventParam());
	        }
	    }
	
	    private function actSearchConnected(startX:int, startY:int):void
	    {
	        var FindBrick:int = getBrick(startX, startY);
	        var size:int = BSizeX * BSizeY;
	        var FoundTotal:int = 0;
	
	        var Used:Array = new Array(size);
			var n:int;
			for (n=0; n<size; n++)
			{
				Used[n]=0;
			}
			
	        var BrickList:CArrayList = new CArrayList(); //<Integer>
	        BrickList.add(new int(getPos(startX, startY)));
	
	        if (CHECKPOS(getPos(startX, startY)))
	        {
	            Used[getPos(startX, startY)] = 1;
	        }
	
	        Bricks.clear();
	        Bricks.add(new int(getPos(startX, startY)));
	
	        var currentbrick:int = 0;
	        var currentX:int = 0;
	        var currentY:int = 0;
	
	        var offsetX:Array=
	        [
	            0, -1, 1, 0
	    	];
	        var offsetY:Array=
	        [
	            -1, 0, 0, 1
	    	];
	
	        //char * temp ="";
	
	        while (BrickList.size() > 0)
	        {
	            currentX = getXbrick(int(BrickList.get(0)));
	            currentY = getYbrick(int(BrickList.get(0)));
	            var dir:int;
	            for (dir = 0; dir < 4; dir++) //Loop around brick
	            {
	                currentbrick = getPos(currentX + offsetX[dir], currentY + offsetY[dir]);
	                if (CHECKPOS(currentbrick))
	                {
	                    if ((Board[currentbrick] == FindBrick) && (Used[currentbrick] == 0) && (currentbrick != -1))
	                    {
	                        BrickList.add(new int(currentbrick));
	                        Bricks.add(new int(currentbrick));
	                        Used[currentbrick] = 1;
	                    }
	                }
	            }
	            BrickList.removeIndex(0);
	        }
	        if (Bricks.size() >= MinConnected)
	        {
	            ho.generateEvent(CID_conOnFoundConnected, ho.getEventParam());
	            FoundTotal++;
	        }
	
	        BrickList.clear();
	
	        if (FoundTotal == 0)
	        {
	            ho.generateEvent(CID_conOnNoFoundConnected, ho.getEventParam());
	        }
	
	    }
	
	    private function actDeleteHorizonal(y:int, mode:int):void
	    {
	    	var del:int;
	        for (del = 0; del < BSizeX; del++)
	        {
	            if (CHECKPOS(getPos(del, y)))
	            {
	                var triggerdeletedflag:Boolean = false;
	                if (TriggerDeleted)
	                {
	                    DeletedFixed = FixedBoard[getPos(del, y)];
	                    DeletedX = del;
	                    DeletedY = y;
	                    triggerdeletedflag = true;
	                }
	
	                Board[getPos(del, y)] = 0;
	                if (MoveFixed)
	                {
	                    FixedBoard[getPos(del, y)] = 0;
	                }
	
	                if (triggerdeletedflag)
	                {
	                    ho.generateEvent(CID_conOnBrickDeleted, ho.getEventParam());
	                }
	            }
	        }
	
        	var udX:int, udY:int;
	        if (mode == 1) //MOVE ABOVE DOWNWARDS
	        {
	            for (udX = 0; udX < BSizeX; udX++)
	            {
	                for (udY = y - 1; udY >= 0; udY--)
	                {
	                    MoveBrick(udX, udY, udX, udY + 1);
	                }
	            }
	        }
	
	        if (mode == 2) //MOVE BELOW UPWARDS
	        {
	            for (udX = 0; udX < BSizeX; udX++)
	            {
	                for (udY = y + 1; udY < BSizeY; udY++)
	                {
	                    MoveBrick(udX, udY, udX, udY - 1);
	                }
	            }
	        }
	    }
	
	    private function actDeleteVertical(x:int, mode:int):void
	    {
	    	var del:int;
	        for (del = 0; del < BSizeY; del++)
	        {
	            if (CHECKPOS(getPos(x, del)))
	            {
	                var triggerdeletedflag:Boolean = false;
	                if (TriggerDeleted)
	                {
	                    DeletedFixed = FixedBoard[getPos(x, del)];
	                    DeletedX = x;
	                    DeletedY = del;
	                    triggerdeletedflag = true;
	                }
	
	                Board[getPos(x, del)] = 0;
	                if (MoveFixed)
	                {
	                    FixedBoard[getPos(x, del)] = 0;
	                }
	
	                if (triggerdeletedflag)
	                {
	                    ho.generateEvent(CID_conOnBrickDeleted, ho.getEventParam());
	                }
	            }
	        }
	
			var lrY:int, lrX:int;
	        if (mode == 1) //MOVE LEFT TO RIGHT ->-> ||
	        {
	            for (lrY = 0; lrY < BSizeY; lrY++)
	            {
	                for (lrX = x - 1; lrX >= 0; lrX--)
	                {
	                    MoveBrick(lrX, lrY, lrX + 1, lrY);
	                }
	            }
	        }
	        if (mode == 2) //MOVE RIGHT TO LEFT   || <-<-
	        {
	            for (lrY = 0; lrY < BSizeY; lrY++)
	            {
	                for (lrX = x + 1; lrX < BSizeX; lrX++)
	                {
	                    MoveBrick(lrX, lrY, lrX - 1, lrY);
	                }
	            }
	        }
	    }
	
	    private function actSwap(x1:int, y1:int, x2:int, y2:int):void
	    {
	        SwapBrick1 = getPos(x1, y1);  //Brick 1
	        SwapBrick2 = getPos(x2, y2);  //Brick 2
	
	        if (CHECKPOS(SwapBrick1) && CHECKPOS(SwapBrick2))
	        {
	            var temp:int = Board[SwapBrick1];
	            var tempfixed:int = FixedBoard[SwapBrick1];
	
	            Board[SwapBrick1] = Board[SwapBrick2];
	            Board[SwapBrick2] = temp;
	
	            if (MoveFixed)
	            {
	                FixedBoard[SwapBrick1] = FixedBoard[SwapBrick2];
	                FixedBoard[SwapBrick2] = tempfixed;
	            }
	
	            if (TriggerMoved)
	            {
	                MovedFixed = FixedBoard[SwapBrick1];
	                MovedNewX = x1;
	                MovedNewY = y1;
	                MovedOldX = x2;
	                MovedOldY = y2;
	                ho.generateEvent(CID_conOnBrickMoved, ho.getEventParam());
	
	                MovedFixed = FixedBoard[SwapBrick2];
	                MovedNewX = x2;
	                MovedNewY = y2;
	                MovedOldX = x1;
	                MovedOldY = y1;
	                ho.generateEvent(CID_conOnBrickMoved, ho.getEventParam());
	            }
	        }
	    }
	
	    private function actDropX(n:int):void
	    {
	    	var i:int;
	        for (i = 0; i < n; i++)
	        {
	            fall();
	        }
	    }
	
	    private function actMarkUsed(x:int, y:int):void
	    {
	        if (CHECKPOS(getPos(x, y)))
	        {
	            StateBoard[getPos(x, y)] = 1;
	        }
	    }
	
	    private function actDeleteMarked():void
	    {
	        var size:int = BSizeX * BSizeY;
	        var triggerdeleteflag:Boolean = false;
	
			var i:int;
	        for (i = 0; i < size; i++)
	        {
	            triggerdeleteflag = false;
	            if (StateBoard[i] == 1)
	            {
	                if (TriggerDeleted)
	                {
	                    DeletedFixed = FixedBoard[i];
	                    DeletedX = getXbrick(i);
	                    DeletedY = getYbrick(i);
	                    triggerdeleteflag = true;
	                }
	
	                Board[i] = 0;
	                StateBoard[i] = 0;
	
	                if (MoveFixed)
	                {
	                    FixedBoard[i] = 0;
	                }
	
	                if (triggerdeleteflag)
	                {
	                    ho.generateEvent(CID_conOnBrickDeleted, ho.getEventParam());
	                }
	            }
	        }
	    }
	
	    private function actUndoSwap():void
	    {
	        if (CHECKPOS(SwapBrick1) && CHECKPOS(SwapBrick2))
	        {
	            var temp:int = Board[SwapBrick1];
	            var tempfixed:int = FixedBoard[SwapBrick1];
	
	            Board[SwapBrick1] = Board[SwapBrick2];
	            Board[SwapBrick2] = temp;
	
	            if (MoveFixed)
	            {
	                FixedBoard[SwapBrick1] = FixedBoard[SwapBrick2];
	                FixedBoard[SwapBrick2] = tempfixed;
	            }
	
	            if (TriggerMoved)
	            {
	                MovedFixed = FixedBoard[SwapBrick1];
	                MovedNewX = getXbrick(SwapBrick1);
	                MovedNewY = getYbrick(SwapBrick1);
	                MovedOldX = getXbrick(SwapBrick2);
	                MovedOldY = getYbrick(SwapBrick2);
	                ho.generateEvent(CID_conOnBrickMoved, ho.getEventParam());
	
	                MovedFixed = FixedBoard[SwapBrick2];
	                MovedNewX = getXbrick(SwapBrick2);
	                MovedNewY = getYbrick(SwapBrick2);
	                MovedOldX = getXbrick(SwapBrick1);
	                MovedOldY = getYbrick(SwapBrick1);
	                ho.generateEvent(CID_conOnBrickMoved, ho.getEventParam());
	            }
	        }
	    }
	
	    private function actSearchDiagonalsRL(brickType:int):void
	    {
	
	        var around:int = BSizeY + BSizeX + 2;
	        var startoffX:int = BSizeX - 1;
	        var startoffY:int = BSizeY;
	        var loopindex:int = 0;
	        var foundtotal:int = 0;
	        var foundbricks:int = 0;
	
			var i:int;
	        for (i = 0; i < around; i++)
	        {
	            if (startoffY == 0)
	            {
	                startoffX--;
	            }
	
	            if (startoffY > 0)
	            {
	                startoffY--;
	            }
	
	            loopindex = 0;
	            foundbricks = 0;
	            Bricks.clear();
	
	            while ((getPos(startoffX - loopindex, startoffY + loopindex) != -1))
	            {
	                if (getBrick(startoffX - loopindex, startoffY + loopindex) == brickType)
	                {
	                    foundbricks++;
	
	                    if (CHECKPOS(getPos(startoffX - loopindex, startoffY + loopindex)))
	                    {
	                        if (StateBoard[getPos(startoffX - loopindex, startoffY + loopindex)] == 0)
	                        {
	                            Bricks.add(new int(getPos(startoffX - loopindex, startoffY + loopindex)));
	                        }
	                    }
	                }
	                else
	                {
	
	                    if (foundbricks >= MinConnected)
	                    {
	                        ho.generateEvent(CID_conOnFoundConnected, ho.getEventParam());
	                        foundtotal++;
	                    }
	
	                    Bricks.clear();
	                    foundbricks = 0;
	                }
	
	                loopindex++;
	            }
	
	            if (foundbricks >= MinConnected)
	            {
	                ho.generateEvent(CID_conOnFoundConnected, ho.getEventParam());
	                foundtotal++;
	            }
	
	        }
	        if (foundtotal == 0)
	        {
	            ho.generateEvent(CID_conOnNoFoundConnected, ho.getEventParam());
	        }
	    }
	
	    private function actLoopFoundBricks():void
	    {
	    	var loop:int;
	        for (loop = 0; loop < Bricks.size(); loop++)
	        {
	            LoopIndex = loop;
	            ho.generateEvent(CID_conOnFoundBrick, ho.getEventParam());
	        }
	    }
	
	    private function actSetFixedOfBrick(x:int, y:int, fv:int):void
	    {
	        if (CHECKPOS(getPos(x, y)))
	        {
	            FixedBoard[getPos(x, y)] = fv;
	        }
	    }
	
	    private function actImportActives(selected:CObject):void
	    {
	        var size:int = BSizeX * BSizeY;
	        if (CHECKPOS(size - AddIncrement - 1))
	        {
	            FixedBoard[size - AddIncrement - 1] = (selected.hoCreationId << 16) + selected.hoNumber;
	        }
	        AddIncrement++;
	    }
	
	    private function actMarkCurrentSystem():void
	    {
	    	var i:int;
	        for (i = 0; i < Bricks.size(); i++)
	        {
	            if (CHECKPOS(int(Bricks.get(i))))
	            {
	                StateBoard[int(Bricks.get(i))] = 1;
	            }
	        //MessageBox(NULL, "Brick marked in system" , "Brick marked", MB_ICONEXCLAMATION);
	        }
	    }
	
	    private function actMarkCurrentBrick():void
	    {
	        if (CHECKPOS(int(Bricks.get(LoopIndex))))
	        {
	            StateBoard[int(Bricks.get(LoopIndex))] = 1;
	        }
	    //MessageBox(NULL, "Brick marked" , "Brick marked", MB_ICONEXCLAMATION);
	    }
	
	    private function actLoopEntireBoard():void
	    {
	        var size:int = BSizeX * BSizeY;
	        Looped.clear();
	
			var i:int, u:int;
	        for (i = 0; i < size; i++)
	        {
	            Looped.add(new int(i));
	        }
	
	        for (u = 0; u < Looped.size(); u++)
	        {
	            LoopedIndex = u;
	            ho.generateEvent(CID_conOnFoundLooped, ho.getEventParam());
	        }
	    }
	
	    private function actLoopBoardOfType(brickType:int):void
	    {
	        var size:int = BSizeX * BSizeY;
	        Looped.clear();
	
			var i:int, u:int;
	        for (i = 0; i < size; i++)
	        {
	            if (Board[i] == brickType)
	            {
	                Looped.add(new int(i));
	            }
	        }
	        for (u = 0; u < Looped.size(); u++)
	        {
	            LoopedIndex = u;
	            ho.generateEvent(CID_conOnFoundLooped, ho.getEventParam());
	        }
	    }
	
	    private function actLoopSorrounding(x:int, y:int):void
	    {
	        Looped.clear();
	
	        var offsetX:Array =
	        [
	            -1, 0, 1, -1, 1, -1, 0, 1
	    	];
	        var offsetY:Array =
	        [
	            -1, -1, -1, 0, 0, 1, 1, 1
	    	];
	
			var i:int, u:int;
	        for (i = 0; i < 8; i++)
	        {
	            if (getBrick(x + offsetX[i], y + offsetY[i]) != -1)
	            {
	                Looped.add(new int(getPos(x + offsetX[i], y + offsetY[i])));
	            }
	        }
	
	        for (u = 0; u < Looped.size(); u++)
	        {
	            LoopedIndex = u;
	            ho.generateEvent(CID_conOnFoundLooped, ho.getEventParam());
	        }
	    }
	
	    private function actLoopHozLine(y:int):void
	    {
	        Looped.clear();
	        var i:int, u:int;
	        for (i = 0; i < BSizeX; i++)
	        {
	            Looped.add(new int(getPos(i, y)));
	        }
	
	        for (u = 0; u < Looped.size(); u++)
	        {
	            LoopedIndex = u;
	            ho.generateEvent(CID_conOnFoundLooped, ho.getEventParam());
	        }
	    }
	
	    private function actLoopVerLine(x:int):void
	    {
	        Looped.clear();
	        var i:int, u:int;
	        for (i = 0; i < BSizeY; i++)
	        {
	            Looped.add(new int(getPos(x, i)));
	        }
	
	        for (u = 0; u < Looped.size(); u++)
	        {
	            LoopedIndex = u;
	            ho.generateEvent(CID_conOnFoundLooped, ho.getEventParam());
	        }
	    }
	
	    private function actClearWithType(brickType:int):void
	    {
	        var size:int = BSizeX * BSizeY;
	        var i:int;
	        for (i = 0; i < size; i++)
	        {
	            Board[i] = brickType;
	        }
	    }
	
	    private function actInsertBrick(x:int, y:int, brickType:int):void
	    {
	        var size:int = BSizeX * BSizeY;
	        var triggerdeletedflag:Boolean = false;
	
	        if (TriggerDeleted && Board[size - 1] != 0)
	        {
	            DeletedFixed = FixedBoard[size - 1];
	            DeletedX = getXbrick(size - 1);
	            DeletedY = getYbrick(size - 1);
	            triggerdeletedflag = true;
	        }
	
			var i:int;
	        for (i = size - 2; i > getPos(x, y); i--)
	        {
	            MoveBrick(getXbrick(i), getYbrick(i), getXbrick(i) + 1, getYbrick(i));
	        }
	
	        if (CHECKPOS(getPos(x, y)))
	        {
	            Board[getPos(x, y)] = brickType;
	
	            if (MoveFixed)
	            {
	                FixedBoard[getPos(x, y)] = 0;
	            }
	        }
	
	        if (triggerdeletedflag && TriggerDeleted)
	        {
	            ho.generateEvent(CID_conOnBrickDeleted, ho.getEventParam());
	        }
	    }
	
	    private function actSetCellDimensions(x:int, y:int):void
	    {
	        CellWidth = x;
	        CellHeight = y;
	        if (CellWidth == 0)
	        {
	            CellWidth = 1;
	        }
	        if (CellHeight == 0)
	        {
	            CellHeight = 1;
	        }
	    }
	
	    private function actDropXUp(n:int):void
	    {
	    	var i:int;
	        for (i = 0; i < n; i++)
	        {
	            fallUP();
	        }
	    }
	
	    private function actDropXLeft(n:int):void
	    {
	    	var i:int;
	        for (i = 0; i < n; i++)
	        {
	            fallLEFT();
	        }
	    }
	
	    private function actDropXRight(n:int):void
	    {
	    	var i:int;
	        for (i = 0; i < n; i++)
	        {
	            fallRIGHT();
	        }
	    }
	
	    private function actSetCellValue(x:int, y:int, value:int):void
	    {
	        if (getPos(x, y) != -1)
	        {
	            CellValues[getPos(x, y)] = value;
	        }
	    }
	
	    private function actDeleteBrick(x:int, y:int):void
	    {
	        if (TriggerDeleted)
	        {
	            DeletedFixed = getFixed(x, y);
	            DeletedX = x;
	            DeletedY = y;
	        }
	
	        setBrick(x, y, 0);
	
	        if (TriggerDeleted)
	        {
	            ho.generateEvent(CID_conOnBrickDeleted, ho.getEventParam());
	        }
	    }
	
	    private function actShiftHosLine(yline:int, shift:int):void
	    {
	        var templine:Array = new Array(BSizeX);
	        var tempfixed:Array = new Array(BSizeX);
	
	        //write to templine
	        var i:int, j:int;
	        for (i = 0; i < BSizeX; i++)
	        {
	            templine[i] = getBrick(wrapX(i - shift), yline);
	            tempfixed[i] = getFixed(wrapX(i - shift), yline);
	        }
	
	        for (j = 0; j < BSizeX; j++)
	        {
	            if (TriggerMoved)
	            {
	                MovedOldX = j;
	                MovedOldY = yline;
	                MovedNewX = wrapX(j + shift);
	                MovedNewY = yline;
	                MovedFixed = getFixed(j, yline);
	            }
	
	            setBrick(j, yline, templine[j]);
	
	            if (MoveFixed)
	            {
	                setFixed(j, yline, tempfixed[j]);
	            }
	
	            if (TriggerMoved)
	            {
	                ho.generateEvent(CID_conOnBrickMoved, ho.getEventParam());
	            }
	        }
	    }
	
	    private function actShiftVerLine(xline:int, shift:int):void
	    {
	        var templine:Array = new Array(BSizeY);
	        var tempfixed:Array = new Array(BSizeY);
	
	        //write to templine*
	        var i:int, j:int;
	        for (i = 0; i < BSizeY; i++)
	        {
	            templine[i] = getBrick(xline, wrapY(i - shift));
	            tempfixed[i] = getFixed(xline, wrapY(i - shift));
	        }
	
	        for (j = 0; j < BSizeY; j++)
	        {
	            if (TriggerMoved)
	            {
	                MovedOldX = xline;
	                MovedOldY = j;
	                MovedNewX = xline;
	                MovedNewY = wrapY(j + shift);
	                MovedFixed = getFixed(xline, j);
	            }
	
	            setBrick(xline, j, templine[j]);
	
	            if (MoveFixed)
	            {
	                setFixed(xline, j, tempfixed[j]);
	            }
	
	            if (TriggerMoved)
	            {
	                ho.generateEvent(CID_conOnBrickMoved, ho.getEventParam());
	            }
	        }
	    }
	
	    private function CObjectFromFixed(fixed:int):CObject 
	    {
	        var list:Array = ho.hoAdRunHeader.rhObjectList;
	        var i:int;
	        for (i = 0; i < list.length; i++)
	        {
	            if (list[i] != null)
	            {
	                if (((list[i].hoCreationId << 16) + list[i].hoNumber) == fixed)
	                {
	                    return list[i];
	                }
	            }
	        }
	        return null;
	    }
	
	    private function actPositionBricks():void
	    {
	        var size:int = BSizeX * BSizeY;
	        var fixed:int = 0;
	        var active:CObject;
	        var posX:int = 0;
	        var posY:int = 0;
	
			var i:int;
	        for (i = 0; i < size; i++)
	        {
	            fixed = FixedBoard[i];
	            active = CObjectFromFixed(fixed);
	            posX = getXbrick(i);
	            posY = getYbrick(i);
	
	            if (active != null && fixed > 0)
	            {
	                active.hoX = CellWidth * posX + OriginX;
	                active.hoY = CellHeight * posY + OriginY;
	                active.roc.rcChanged = true;
	            }
	
	        }
	    }

	    public override function expression(num:int):CValue
	    {
	    	var ret:CValue;
	        switch (num)
	        {
	            case EID_expGetBrickAt:
	                return new CValue(getBrick(ho.getExpParam().getInt(), ho.getExpParam().getInt()));
	            case EID_expGetXSize:
	                return new CValue(BSizeX);
	            case EID_expGetYSize:
	                return new CValue(BSizeY);
	            case EID_expGetNumBricksInSystem:
	                return new CValue(Bricks.size());
	            case EID_expGetXofBrick:
	                return expGetXofBrick(ho.getExpParam().getInt());
	            case EID_expGetYofBrick:
	                return expGetYofBrick(ho.getExpParam().getInt());
	            case EID_expGetFoundBrickType:
	                return new CValue(SearchBrickType);
	            case EID_expGetNumBricksInHozLine:
	                return expGetNumBricksInHozLine(ho.getExpParam().getInt());
	            case EID_expGetNumBricksInVerLine:
	                return expGetNumBricksInVerLine(ho.getExpParam().getInt());
	            case EID_expCountSorrounding:
	                return expCountSorrounding(ho.getExpParam().getInt(), ho.getExpParam().getInt(), ho.getExpParam().getInt());
	            case EID_expCountTotal:
	                return expCountTotal();
	            case EID_expGetFoundBrickFixed:
	                return expGetFoundBrickFixed(ho.getExpParam().getInt());
	            case EID_expGetFoundXofBrick:
	                return new CValue(getXbrick(int(Bricks.get(LoopIndex))));
	            case EID_expGetFoundYofBrick:
	                return new CValue(getYbrick(int(Bricks.get(LoopIndex))));
	            case EID_expGetTypeofBrick:
	                return new CValue(SearchBrickType);
	            case EID_expGetFixedOfBrick:
	                return expGetFixedOfBrick();
	            case EID_expGetFixedAt:
	                return expGetFixedAt(ho.getExpParam().getInt(), ho.getExpParam().getInt());
	            case EID_expLoopIndex:
	                return new CValue(LoopIndex);
	            case EID_expFindXfromFixed:
	                return expFindXfromFixed(ho.getExpParam().getInt());
	            case EID_expFindYfromFixed:
	                return expFindYfromFixed(ho.getExpParam().getInt());
	            case EID_expFindBrickfromFixed:
	                return expFindBrickfromFixed(ho.getExpParam().getInt());
	            case EID_expGetLoopFoundXofBrick:
	                return new CValue(getXbrick(int(Looped.get(LoopedIndex))));
	            case EID_expGetLoopFoundYofBrick:
	                return new CValue(getYbrick(int(Looped.get(LoopedIndex))));
	            case EID_expGetLoopTypeofBrick:
	                return new CValue(getBrickAtPos(int(Looped.get(LoopedIndex))));
	            case EID_expGetLoopFoundBrickFixed:
	                return expGetLoopFoundBrickFixed();
	            case EID_expLoopLoopIndex:
	                return new CValue(LoopIndex);
	            case EID_expGetXBrickFromX:
	                return expGetXBrickFromX(ho.getExpParam().getInt());
	            case EID_expGetYBrickFromY:
	                return expGetYBrickFromY(ho.getExpParam().getInt());
	            case EID_expSnapXtoGrid:
	                return expSnapXtoGrid(ho.getExpParam().getInt());
	            case EID_expSnapYtoGrid:
	                return expSnapYtoGrid(ho.getExpParam().getInt());
	            case EID_expGetOriginX:
	                return new CValue(OriginX);
	            case EID_expGetOriginY:
	                return new CValue(OriginY);
	            case EID_expGetCellWidth:
	                return new CValue(CellWidth);
	            case EID_expGetCellHeight:
	                return new CValue(CellHeight);
	            case EID_expGetCellValue:
	                return expGetCellValue(ho.getExpParam().getInt(), ho.getExpParam().getInt());
	            case EID_expGetXofCell:
	                return new CValue(CellWidth * ho.getExpParam().getInt() + OriginX);
	            case EID_expGetYofCell:
	                return new CValue(CellHeight * ho.getExpParam().getInt() + OriginY);
	            case EID_expMovedFixed:
	                return new CValue(MovedFixed);
	            case EID_expMovedNewX:
	                return new CValue(MovedNewX);
	            case EID_expMovedNewY:
	                return new CValue(MovedNewY);
	            case EID_expMovedOldX:
	                return new CValue(MovedOldX);
	            case EID_expMovedOldY:
	                return new CValue(MovedOldY);
	            case EID_expDeletedFixed:
	                return new CValue(DeletedFixed);
	            case EID_expDeletedX:
	                return new CValue(DeletedX);
	            case EID_expDeletedY:
	                return new CValue(DeletedY);
	        }
	        return new CValue(0);//won't be used
	    }

	    private function expGetXofBrick(i:int):CValue
	    {
	        if (i < Bricks.size())
	        {
	            return new CValue(getXbrick(int(Bricks.get(i))));
	        }
	        else
	        {
	            return new CValue(-1);
	        }
	    }
	
	    private function expGetYofBrick(i:int):CValue
	    {
	        if (i < Bricks.size())
	        {
	            return new CValue(getYbrick(int(Bricks.get(i))));
	        }
	        else
	        {
	            return new CValue(-1);
	        }
	    }
	
	    private function expGetNumBricksInHozLine(y:int):CValue
	    {
	        var count:int = 0;
			var i:int;
	        for (i = 0; i < BSizeX; i++)
	        {
	            if (getBrick(i, y) != 0)
	            {
	                count++;
	            }
	        }
	        return new CValue(count);
	    }
	
	    private function expGetNumBricksInVerLine(x:int):CValue
	    {
	        var count:int = 0;
			var i:int;
			
	        for (i = 0; i < BSizeY; i++)
	        {
	            if (getBrick(x, i) != 0)
	            {
	                count++;
	            }
	        }
	        return new CValue(count);
	    }
	
	    private function expCountSorrounding(x:int, y:int, value:int):CValue
	    {
	        var offsetX:Array =
	        [
	            -1, 0, 1, -1, 1, -1, 0, 1
	        ];
	        var offsetY:Array =
	        [
	            -1, -1, -1, 0, 0, 1, 1, 1
	        ];
	
	        var count:int = 0;
			var i:int;
	        for (i = 0; i < 8; i++)
	        {
	            if (getBrick(x + offsetX[i], y + offsetY[i]) == value)
	            {
	                count++;
	            }
	        }
	
	        return new CValue(count);
	    }
	
	    private function expCountTotal():CValue
	    {
	        var count:int = 0;
	        var i:int;
	        for (i = 0; i < BSizeX * BSizeY; i++)
	        {
	            if (Board[i] != 0)
	            {
	                count++;
	            }
	        }
	        return new CValue(count);
	    }
	
	    private function expGetFoundBrickFixed(i:int):CValue
	    {
	        if (i < Looped.size())
	        {
	            if (CHECKPOS(LoopIndex))
	            {
	                return new CValue(FixedBoard[LoopIndex]);
	            }
	        }
	        return new CValue(-1);
	    }
	
	    private function expGetFixedOfBrick():CValue
	    {
	        if (LoopIndex < Bricks.size())
	        {
	            if (CHECKPOS(int(Bricks.get(LoopIndex))))
	            {
	                return new CValue(FixedBoard[int(Bricks.get(LoopIndex))]);
	            }
	        }
	        return new CValue(-1);
	    }
	
	    private function expGetFixedAt(x:int, y:int):CValue
	    {
	        if (getPos(x, y) != -1)
	        {
	            return new CValue(FixedBoard[getPos(x, y)]);
	        }
	        return new CValue(-1);
	    }
	
	    private function expFindXfromFixed(fixed:int):CValue
	    {
	        var size:int = BSizeX * BSizeY;
			var i:int;
	        for (i = 0; i < size; i++)
	        {
	            if (FixedBoard[i] == fixed)
	            {
	                return new CValue(getXbrick(i));
	            }
	        }
	        return new CValue(-1);
	    }
	
	    private function expFindYfromFixed(fixed:int):CValue
	    {
	        var size:int = BSizeX * BSizeY;
			var i:int;
	        for (i = 0; i < size; i++)
	        {
	            if (FixedBoard[i] == fixed)
	            {
	                return new CValue(getYbrick(i));
	            }
	        }
	        return new CValue(-1);
	    }
	
	    private function expFindBrickfromFixed(fixed:int):CValue
	    {
	        var size:int = BSizeX * BSizeY;
			var i:int;
	        for (i = 0; i < size; i++)
	        {
	            if (FixedBoard[i] == fixed)
	            {
	                return new CValue(Board[i]);
	            }
	        }
	        return new CValue(-1);
	    }
	
	    private function expGetLoopFoundBrickFixed():CValue
	    {
	        if (LoopedIndex < Looped.size())
	        {
	            if (CHECKPOS(int(Looped.get(LoopedIndex))))
	            {
	                return new CValue(FixedBoard[int(Looped.get(LoopedIndex))]);
	            }
	        }
	        return new CValue(-1);
	    }
	
	    private function expGetXBrickFromX(x:int):CValue
	    {
	        return new CValue( int((x - OriginX)/ CellWidth) );
	    }
	
	    private function expGetYBrickFromY(y:int):CValue
	    {
	        return new CValue( int((y - OriginY) / CellHeight) );
	    }
	
	    private function expSnapXtoGrid(x:int):CValue
	    {
	        return new CValue( int((x-OriginX)/CellWidth)*CellWidth+OriginX );
	    }
	
	    private function expSnapYtoGrid(y:int):CValue
	    {
	        return new CValue( int((y-OriginY)/CellHeight)*CellHeight+OriginY );
	    }
	
	    private function expGetCellValue(x:int, y:int):CValue
	    {
	        if (CHECKPOS(getPos(x, y)))
	        {
	            return new CValue(CellValues[getPos(x, y)]);
	        }
	        return new CValue(-1);
	    }

	}
}
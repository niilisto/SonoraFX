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
package Extensions;

/**
 * by Greyhill
 * @author Admin
 */
import Expressions.CValue;

public class AdvGameBoardExpr
{
    static final int EID_expGetBrickAt = 0;
    static final int EID_expGetXSize = 1;
    static final int EID_expGetYSize = 2;
    static final int EID_expGetNumBricksInSystem = 3;
    static final int EID_expGetXofBrick = 4;
    static final int EID_expGetYofBrick = 5;
    static final int EID_expGetFoundBrickType = 6;
    static final int EID_expGetNumBricksInHozLine = 7;
    static final int EID_expGetNumBricksInVerLine = 8;
    static final int EID_expCountSorrounding = 9;
    static final int EID_expCountTotal = 10;
    static final int EID_expGetFoundBrickFixed = 11;
    static final int EID_expGetFoundXofBrick = 12;
    static final int EID_expGetFoundYofBrick = 13;
    static final int EID_expGetTypeofBrick = 14;
    static final int EID_expGetFixedOfBrick = 15;
    static final int EID_expGetFixedAt = 16;
    static final int EID_expLoopIndex = 17;
    static final int EID_expFindXfromFixed = 18;
    static final int EID_expFindYfromFixed = 19;
    static final int EID_expFindBrickfromFixed = 20;
    static final int EID_expGetLoopFoundXofBrick = 21;
    static final int EID_expGetLoopFoundYofBrick = 22;
    static final int EID_expGetLoopTypeofBrick = 23;
    static final int EID_expGetLoopFoundBrickFixed = 24;
    static final int EID_expLoopLoopIndex = 25;
    static final int EID_expGetXBrickFromX = 26;
    static final int EID_expGetYBrickFromY = 27;
    static final int EID_expSnapXtoGrid = 28;
    static final int EID_expSnapYtoGrid = 29;
    static final int EID_expGetOriginX = 30;
    static final int EID_expGetOriginY = 31;
    static final int EID_expGetCellWidth = 32;
    static final int EID_expGetCellHeight = 33;
    static final int EID_expGetCellValue = 34;
    static final int EID_expGetXofCell = 35;
    static final int EID_expGetYofCell = 36;
    static final int EID_expMovedFixed = 37;
    static final int EID_expMovedNewX = 38;
    static final int EID_expMovedNewY = 39;
    static final int EID_expMovedOldX = 40;
    static final int EID_expMovedOldY = 41;
    static final int EID_expDeletedFixed = 42;
    static final int EID_expDeletedX = 43;
    static final int EID_expDeletedY = 44;
    CRunAdvGameBoard thisObject;

    public AdvGameBoardExpr(CRunAdvGameBoard object)
    {
        thisObject = object;
    }

    public CValue get(int num)
    {
        switch (num)
        {
            case EID_expGetBrickAt:
                thisObject.tempValue.forceInt(thisObject.getBrick(thisObject.ho.getExpParam().getInt(), thisObject.ho.getExpParam().getInt()));
				break;
            case EID_expGetXSize:
                thisObject.tempValue.forceInt(thisObject.BSizeX);
				break;
            case EID_expGetYSize:
                thisObject.tempValue.forceInt(thisObject.BSizeY);
				break;
            case EID_expGetNumBricksInSystem:
                thisObject.tempValue.forceInt(thisObject.Bricks.size());
				break;
            case EID_expGetXofBrick:
                thisObject.tempValue.forceInt(expGetXofBrick(thisObject.ho.getExpParam().getInt()));
				break;
            case EID_expGetYofBrick:
                thisObject.tempValue.forceInt(expGetYofBrick(thisObject.ho.getExpParam().getInt()));
				break;
            case EID_expGetFoundBrickType:
                thisObject.tempValue.forceInt(thisObject.SearchBrickType);
				break;
            case EID_expGetNumBricksInHozLine:
                thisObject.tempValue.forceInt(expGetNumBricksInHozLine(thisObject.ho.getExpParam().getInt()));
				break;
            case EID_expGetNumBricksInVerLine:
                thisObject.tempValue.forceInt(expGetNumBricksInVerLine(thisObject.ho.getExpParam().getInt()));
				break;
            case EID_expCountSorrounding:
                thisObject.tempValue.forceInt(expCountSorrounding(thisObject.ho.getExpParam().getInt(), thisObject.ho.getExpParam().getInt(), thisObject.ho.getExpParam().getInt()));
				break;
            case EID_expCountTotal:
                thisObject.tempValue.forceInt(expCountTotal());
				break;
            case EID_expGetFoundBrickFixed:
                thisObject.tempValue.forceInt(expGetFoundBrickFixed(thisObject.ho.getExpParam().getInt()));
				break;
            case EID_expGetFoundXofBrick:
                thisObject.tempValue.forceInt(thisObject.getXbrick(thisObject.Bricks.get(thisObject.LoopIndex).intValue()));
				break;
            case EID_expGetFoundYofBrick:
                thisObject.tempValue.forceInt(thisObject.getYbrick(thisObject.Bricks.get(thisObject.LoopIndex).intValue()));
				break;
            case EID_expGetTypeofBrick:
                thisObject.tempValue.forceInt(thisObject.SearchBrickType);
				break;
            case EID_expGetFixedOfBrick:
                thisObject.tempValue.forceInt(expGetFixedOfBrick());
				break;
            case EID_expGetFixedAt:
                thisObject.tempValue.forceInt(expGetFixedAt(thisObject.ho.getExpParam().getInt(), thisObject.ho.getExpParam().getInt()));
				break;
            case EID_expLoopIndex:
                thisObject.tempValue.forceInt(thisObject.LoopIndex);
				break;
            case EID_expFindXfromFixed:
                thisObject.tempValue.forceInt(expFindXfromFixed(thisObject.ho.getExpParam().getInt()));
				break;
            case EID_expFindYfromFixed:
                thisObject.tempValue.forceInt(expFindYfromFixed(thisObject.ho.getExpParam().getInt()));
				break;
            case EID_expFindBrickfromFixed:
                thisObject.tempValue.forceInt(expFindBrickfromFixed(thisObject.ho.getExpParam().getInt()));
				break;
            case EID_expGetLoopFoundXofBrick:
                thisObject.tempValue.forceInt(thisObject.getXbrick(thisObject.Looped.get(thisObject.LoopedIndex).intValue()));
				break;
            case EID_expGetLoopFoundYofBrick:
                thisObject.tempValue.forceInt(thisObject.getYbrick(thisObject.Looped.get(thisObject.LoopedIndex).intValue()));
				break;
            case EID_expGetLoopTypeofBrick:
                thisObject.tempValue.forceInt(thisObject.getBrickAtPos(thisObject.Looped.get(thisObject.LoopedIndex).intValue()));
				break;
            case EID_expGetLoopFoundBrickFixed:
                thisObject.tempValue.forceInt(expGetLoopFoundBrickFixed());
				break;
            case EID_expLoopLoopIndex:
                thisObject.tempValue.forceInt(thisObject.LoopIndex);
				break;
            case EID_expGetXBrickFromX:
                thisObject.tempValue.forceInt(expGetXBrickFromX(thisObject.ho.getExpParam().getInt()));
				break;
            case EID_expGetYBrickFromY:
                thisObject.tempValue.forceInt(expGetYBrickFromY(thisObject.ho.getExpParam().getInt()));
				break;
            case EID_expSnapXtoGrid:
                thisObject.tempValue.forceInt(expSnapXtoGrid(thisObject.ho.getExpParam().getInt()));
				break;
            case EID_expSnapYtoGrid:
                thisObject.tempValue.forceInt(expSnapYtoGrid(thisObject.ho.getExpParam().getInt()));
				break;
            case EID_expGetOriginX:
                thisObject.tempValue.forceInt(thisObject.OriginX);
				break;
            case EID_expGetOriginY:
                thisObject.tempValue.forceInt(thisObject.OriginY);
				break;
            case EID_expGetCellWidth:
                thisObject.tempValue.forceInt(thisObject.CellWidth);
				break;
            case EID_expGetCellHeight:
                thisObject.tempValue.forceInt(thisObject.CellHeight);
				break;
            case EID_expGetCellValue:
                thisObject.tempValue.forceInt(expGetCellValue(thisObject.ho.getExpParam().getInt(), thisObject.ho.getExpParam().getInt()));
				break;
            case EID_expGetXofCell:
                thisObject.tempValue.forceInt(thisObject.CellWidth * thisObject.ho.getExpParam().getInt() + thisObject.OriginX);
				break;
            case EID_expGetYofCell:
                thisObject.tempValue.forceInt(thisObject.CellHeight * thisObject.ho.getExpParam().getInt() + thisObject.OriginY);
				break;
            case EID_expMovedFixed:
                thisObject.tempValue.forceInt(thisObject.MovedFixed);
				break;
            case EID_expMovedNewX:
                thisObject.tempValue.forceInt(thisObject.MovedNewX);
				break;
            case EID_expMovedNewY:
                thisObject.tempValue.forceInt(thisObject.MovedNewY);
				break;
            case EID_expMovedOldX:
                thisObject.tempValue.forceInt(thisObject.MovedOldX);
				break;
            case EID_expMovedOldY:
                thisObject.tempValue.forceInt(thisObject.MovedOldY);
				break;
            case EID_expDeletedFixed:
                thisObject.tempValue.forceInt(thisObject.DeletedFixed);
				break;
            case EID_expDeletedX:
                thisObject.tempValue.forceInt(thisObject.DeletedX);
				break;
            case EID_expDeletedY:
                thisObject.tempValue.forceInt(thisObject.DeletedY);
				break;
			default:
		        thisObject.tempValue.forceInt(0);
				break;
        }
		return thisObject.tempValue;
    }

    private int expGetXofBrick(int i)
    {
        if (i < thisObject.Bricks.size())
        {
            return thisObject.getXbrick(thisObject.Bricks.get(i).intValue());
        }
        else
        {
            return -1;
        }
    }

    private int expGetYofBrick(int i)
    {
        if (i < thisObject.Bricks.size())
        {
            return thisObject.getYbrick(thisObject.Bricks.get(i).intValue());
        }
        else
        {
            return -1;
        }
    }

    private int expGetNumBricksInHozLine(int y)
    {
        int count = 0;

        for (int i = 0; i < thisObject.BSizeX; i++)
        {
            if (thisObject.getBrick(i, y) != 0)
            {
                count++;
            }
        }
        return count;
    }

    private int expGetNumBricksInVerLine(int x)
    {
        int count = 0;

        for (int i = 0; i < thisObject.BSizeY; i++)
        {
            if (thisObject.getBrick(x, i) != 0)
            {
                count++;
            }
        }
        return count;
    }

    private int expCountSorrounding(int x, int y, int value)
    {
        int offsetX[] =
        {
            -1, 0, 1, -1, 1, -1, 0, 1
        };
        int offsetY[] =
        {
            -1, -1, -1, 0, 0, 1, 1, 1
        };

        int count = 0;

        for (int i = 0; i < 8; i++)
        {
            if (thisObject.getBrick(x + offsetX[i], y + offsetY[i]) == value)
            {
                count++;
            }
        }

        return count;
    }

    private int expCountTotal()
    {
        int count = 0;
        for (int i = 0; i < thisObject.BSizeX * thisObject.BSizeY; i++)
        {
            if (thisObject.Board[i] != 0)
            {
                count++;
            }
        }
        return count;
    }

    private int expGetFoundBrickFixed(int i)
    {
        if (i < thisObject.Looped.size())
        {
            if (thisObject.CHECKPOS(thisObject.LoopIndex))
            {
                return thisObject.FixedBoard[thisObject.LoopIndex];
            }
        }
        return -1;
    }

    private int expGetFixedOfBrick()
    {
        if (thisObject.LoopIndex < thisObject.Bricks.size())
        {
            if (thisObject.CHECKPOS(thisObject.Bricks.get(thisObject.LoopIndex).intValue()))
            {
                return thisObject.FixedBoard[thisObject.Bricks.get(thisObject.LoopIndex).intValue()];
            }
        }
        return -1;
    }

    private int expGetFixedAt(int x, int y)
    {
        if (thisObject.getPos(x, y) != -1)
        {
            return thisObject.FixedBoard[thisObject.getPos(x, y)];
        }
        return -1;
    }

    private int expFindXfromFixed(int fixed)
    {
        int size = thisObject.BSizeX * thisObject.BSizeY;

        for (int i = 0; i < size; i++)
        {
            if (thisObject.FixedBoard[i] == fixed)
            {
                return thisObject.getXbrick(i);
            }
        }
        return -1;
    }

    private int expFindYfromFixed(int fixed)
    {
        int size = thisObject.BSizeX * thisObject.BSizeY;

        for (int i = 0; i < size; i++)
        {
            if (thisObject.FixedBoard[i] == fixed)
            {
                return thisObject.getYbrick(i);
            }
        }
        return -1;
    }

    private int expFindBrickfromFixed(int fixed)
    {
        int size = thisObject.BSizeX * thisObject.BSizeY;

        for (int i = 0; i < size; i++)
        {
            if (thisObject.FixedBoard[i] == fixed)
            {
                return thisObject.Board[i];
            }
        }
        return -1;
    }

    private int expGetLoopFoundBrickFixed()
    {
        if (thisObject.LoopedIndex < thisObject.Looped.size())
        {
            if (thisObject.CHECKPOS(thisObject.Looped.get(thisObject.LoopedIndex).intValue()))
            {
                return thisObject.FixedBoard[thisObject.Looped.get(thisObject.LoopedIndex).intValue()];
            }
        }
        return -1;
    }

    private int expGetXBrickFromX(int x)
    {
        return (x - thisObject.OriginX) / thisObject.CellWidth;
    }

    private int expGetYBrickFromY(int y)
    {
        return (y - thisObject.OriginY) / thisObject.CellHeight;
    }

    private int expSnapXtoGrid(int x)
    {
        return ((x - thisObject.OriginX) / thisObject.CellWidth) * thisObject.CellWidth + thisObject.OriginX;
    }

    private int expSnapYtoGrid(int y)
    {
        return ((y - thisObject.OriginY) / thisObject.CellHeight) * thisObject.CellHeight + thisObject.OriginY;
    }

    private int expGetCellValue(int x, int y)
    {
        if (thisObject.CHECKPOS(thisObject.getPos(x, y)))
        {
            return thisObject.CellValues[thisObject.getPos(x, y)];
        }
        return -1;
    }
}


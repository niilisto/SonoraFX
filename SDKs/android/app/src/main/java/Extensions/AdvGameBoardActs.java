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
import java.util.ArrayList;

import Actions.CActExtension;
import Objects.CObject;

public class AdvGameBoardActs
{
    static final int AID_actSetBrick = 0;
    static final int AID_actClear = 1;
    static final int AID_actSetBoadSize = 2;
    static final int AID_actSetMinConnected = 3;
    static final int AID_actSearchHorizontal = 4;
    static final int AID_actSearchVertical = 5;
    static final int AID_actSearchDiagonalsLR = 6;
    static final int AID_actSearchConnected = 7;
    static final int AID_actDeleteHorizonal = 8;
    static final int AID_actDeleteVertical = 9;
    static final int AID_actSwap = 10;
    static final int AID_actDropX = 11;
    static final int AID_actDropOne = 12;
    static final int AID_actMarkUsed = 13;
    static final int AID_actDeleteMarked = 14;
    static final int AID_actUndoSwap = 15;
    static final int AID_actSearchDiagonalsRL = 16;
    static final int AID_actLoopFoundBricks = 17;
    static final int AID_actSetFixedOfBrick = 18;
    static final int AID_actImportActives = 19;
    static final int AID_actMarkCurrentSystem = 20;
    static final int AID_actMarkCurrentBrick = 21;
    static final int AID_actLoopEntireBoard = 22;
    static final int AID_actLoopBoardOfType = 23;
    static final int AID_actLoopSorrounding = 24;
    static final int AID_actLoopHozLine = 25;
    static final int AID_actLoopVerLine = 26;
    static final int AID_actClearWithType = 27;
    static final int AID_actInsertBrick = 28;
    static final int AID_actSetOrigin = 29;
    static final int AID_actSetCellDimensions = 30;
    static final int AID_actMoveFixedON = 31;
    static final int AID_actMoveFixedOFF = 32;
    static final int AID_actMoveBrick = 33;
    static final int AID_actDropOneUp = 34;
    static final int AID_actDropOneLeft = 35;
    static final int AID_actDropOneRight = 36;
    static final int AID_actDropXUp = 37;
    static final int AID_actDropXLeft = 38;
    static final int AID_actDropXRight = 39;
    static final int AID_actSetCellValue = 40;
    static final int AID_actDeleteBrick = 41;
    static final int AID_actShiftHosLine = 42;
    static final int AID_actShiftVerLine = 43;
    static final int AID_actPositionBricks = 44;
    CRunAdvGameBoard thisObject;

    public AdvGameBoardActs(CRunAdvGameBoard object)
    {
        thisObject = object;
    }

    public void action(int num, CActExtension act)
    {
        switch (num)
        {
            case AID_actSetBrick:
                actSetBrick(act.getParamExpression(thisObject.rh, 0),
                        act.getParamExpression(thisObject.rh, 1),
                        act.getParamExpression(thisObject.rh, 2));
                break;
            case AID_actClear:
                actClear();
                break;
            case AID_actSetBoadSize:
                actSetBoadSize(act.getParamExpression(thisObject.rh, 0),
                        act.getParamExpression(thisObject.rh, 1));
                break;
            case AID_actSetMinConnected:
                thisObject.MinConnected = act.getParamExpression(thisObject.rh, 0);
                break;
            case AID_actSearchHorizontal:
                actSearchHorizontal(act.getParamExpression(thisObject.rh, 0));
                break;
            case AID_actSearchVertical:
                actSearchVertical(act.getParamExpression(thisObject.rh, 0));
                break;
            case AID_actSearchDiagonalsLR:
                actSearchDiagonalsLR(act.getParamExpression(thisObject.rh, 0));
                break;
            case AID_actSearchConnected:
                actSearchConnected(act.getParamExpression(thisObject.rh, 0), act.getParamExpression(thisObject.rh, 1));
                break;
            case AID_actDeleteHorizonal:
                actDeleteHorizonal(act.getParamExpression(thisObject.rh, 0), act.getParamExpression(thisObject.rh, 1));
                break;
            case AID_actDeleteVertical:
                actDeleteVertical(act.getParamExpression(thisObject.rh, 0), act.getParamExpression(thisObject.rh, 1));
                break;
            case AID_actSwap:
                actSwap(act.getParamExpression(thisObject.rh, 0), act.getParamExpression(thisObject.rh, 1),
                        act.getParamExpression(thisObject.rh, 2), act.getParamExpression(thisObject.rh, 3));
                break;
            case AID_actDropX:
                actDropX(act.getParamExpression(thisObject.rh, 0));
                break;
            case AID_actDropOne:
                thisObject.fall();
                break;
            case AID_actMarkUsed:
                actMarkUsed(act.getParamExpression(thisObject.rh, 0), act.getParamExpression(thisObject.rh, 1));
                break;
            case AID_actDeleteMarked:
                actDeleteMarked();
                break;
            case AID_actUndoSwap:
                actUndoSwap();
                break;
            case AID_actSearchDiagonalsRL:
                actSearchDiagonalsRL(act.getParamExpression(thisObject.rh, 0));
                break;
            case AID_actLoopFoundBricks:
                actLoopFoundBricks();
                break;
            case AID_actSetFixedOfBrick:
                actSetFixedOfBrick(act.getParamExpression(thisObject.rh, 0), act.getParamExpression(thisObject.rh, 1), act.getParamExpression(thisObject.rh, 2));
                break;
            case AID_actImportActives:
                actImportActives(act.getParamObject(thisObject.rh, 0));
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
                actLoopBoardOfType(act.getParamExpression(thisObject.rh, 0));
                break;
            case AID_actLoopSorrounding:
                actLoopSorrounding(act.getParamExpression(thisObject.rh, 0), act.getParamExpression(thisObject.rh, 1));
                break;
            case AID_actLoopHozLine:
                actLoopHozLine(act.getParamExpression(thisObject.rh, 0));
                break;
            case AID_actLoopVerLine:
                actLoopVerLine(act.getParamExpression(thisObject.rh, 0));
                break;
            case AID_actClearWithType:
                actClearWithType(act.getParamExpression(thisObject.rh, 0));
                break;
            case AID_actInsertBrick:
                actInsertBrick(act.getParamExpression(thisObject.rh, 0), act.getParamExpression(thisObject.rh, 1), act.getParamExpression(thisObject.rh, 2));
                break;
            case AID_actSetOrigin:
                thisObject.OriginX = act.getParamExpression(thisObject.rh, 0);
                thisObject.OriginY = act.getParamExpression(thisObject.rh, 1);
                break;
            case AID_actSetCellDimensions:
                actSetCellDimensions(act.getParamExpression(thisObject.rh, 0), act.getParamExpression(thisObject.rh, 1));
                break;
            case AID_actMoveFixedON:
                thisObject.MoveFixed = true;
                break;
            case AID_actMoveFixedOFF:
                thisObject.MoveFixed = false;
                break;
            case AID_actMoveBrick:
                thisObject.MoveBrick(act.getParamExpression(thisObject.rh, 0), act.getParamExpression(thisObject.rh, 1),
                        act.getParamExpression(thisObject.rh, 2), act.getParamExpression(thisObject.rh, 3));
                break;
            case AID_actDropOneUp:
                thisObject.fallUP();
                break;
            case AID_actDropOneLeft:
                thisObject.fallLEFT();
                break;
            case AID_actDropOneRight:
                thisObject.fallRIGHT();
                break;
            case AID_actDropXUp:
                actDropXUp(act.getParamExpression(thisObject.rh, 0));
                break;
            case AID_actDropXLeft:
                actDropXLeft(act.getParamExpression(thisObject.rh, 0));
                break;
            case AID_actDropXRight:
                actDropXRight(act.getParamExpression(thisObject.rh, 0));
                break;
            case AID_actSetCellValue:
                actSetCellValue(act.getParamExpression(thisObject.rh, 0), act.getParamExpression(thisObject.rh, 1), act.getParamExpression(thisObject.rh, 2));
                break;
            case AID_actDeleteBrick:
                actDeleteBrick(act.getParamExpression(thisObject.rh, 0), act.getParamExpression(thisObject.rh, 1));
                break;
            case AID_actShiftHosLine:
                actShiftHosLine(act.getParamExpression(thisObject.rh, 0), act.getParamExpression(thisObject.rh, 1));
                break;
            case AID_actShiftVerLine:
                actShiftVerLine(act.getParamExpression(thisObject.rh, 0), act.getParamExpression(thisObject.rh, 1));
                break;
            case AID_actPositionBricks:
                actPositionBricks();
                break;
        }
    }

    private void actSetBrick(int x, int y, int brickType)
    {
        thisObject.setBrick(x, y, brickType);
    }

    private void actClear()
    {
        int size = thisObject.BSizeX * thisObject.BSizeY;
        for (int i = 0; i < size; i++)
        {
            thisObject.Board[i] = 0;
        }
    }

    private void actSetBoadSize(int x, int y)
    {
        thisObject.BSizeX = x; //Update size
        thisObject.BSizeY = y;
        int size = thisObject.BSizeX * thisObject.BSizeY;
        thisObject.Board = new int[size];  //Create new array
        thisObject.StateBoard = new int[size];
        thisObject.FixedBoard = new int[size];
        thisObject.CellValues = new int[size];
    }

    private void actSearchHorizontal(int brickType)
    {
        int MinConnected = thisObject.MinConnected;
        thisObject.SearchBrickType = brickType;
        int SizeX = thisObject.BSizeX;
        int SizeY = thisObject.BSizeY;
        int Found = 0;
        thisObject.Bricks.clear();
        int FoundTotal = 0;

        for (int y = 0; y < SizeY; y++)
        {
            Found = 0;
            thisObject.Bricks.clear();

            for (int x = 0; x < SizeX; x++)
            {
                if (thisObject.getBrick(x, y) == brickType)
                {
                    Found++;
                    if (thisObject.CHECKPOS(thisObject.getPos(x, y)))
                    {
                        if (thisObject.StateBoard[thisObject.getPos(x, y)] == 0)
                        {
                            thisObject.Bricks.add(Integer.valueOf(thisObject.getPos(x, y)));
                        }
                    }
                }
                else
                {
                    if (Found >= MinConnected)
                    {
                        thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnFoundConnected, thisObject.ho.getEventParam());
                        FoundTotal++;
                    }
                    Found = 0;
                    thisObject.Bricks.clear();
                }

            }
            if (Found >= MinConnected)
            {
                thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnFoundConnected, thisObject.ho.getEventParam());
                FoundTotal++;
            }
            Found = 0;
            thisObject.Bricks.clear();
        }

        if (FoundTotal == 0)
        {
            thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnNoFoundConnected, thisObject.ho.getEventParam());
        }
    }

    private void actSearchVertical(int brickType)
    {
        int MinConnected = thisObject.MinConnected;
        thisObject.SearchBrickType = brickType;
        int SizeX = thisObject.BSizeX;
        int SizeY = thisObject.BSizeY;
        int Found = 0;
        thisObject.Bricks.clear();
        int FoundTotal = 0;

        for (int x = 0; x < SizeX; x++)
        {
            Found = 0;
            thisObject.Bricks.clear();

            for (int y = 0; y < SizeY; y++)
            {
                if (thisObject.getBrick(x, y) == brickType)
                {
                    Found++;
                    if (thisObject.CHECKPOS(thisObject.getPos(x, y)))
                    {
                        if (thisObject.StateBoard[thisObject.getPos(x, y)] == 0)
                        {
                            thisObject.Bricks.add(Integer.valueOf(thisObject.getPos(x, y)));
                        }
                    }
                }
                else
                {	//Trigger condition
                    if (Found >= MinConnected)
                    {
                        thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnFoundConnected, thisObject.ho.getEventParam());
                        FoundTotal++;
                    }
                    Found = 0;
                    thisObject.Bricks.clear();
                }

            } // Trigger condition
            if (Found >= MinConnected)
            {
                thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnFoundConnected, thisObject.ho.getEventParam());
                FoundTotal++;
            }
            Found = 0;
            thisObject.Bricks.clear();
        }
        if (FoundTotal == 0)
        {
            thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnNoFoundConnected, thisObject.ho.getEventParam());
        }
    }

    private void actSearchDiagonalsLR(int brickType)
    {
        int around = thisObject.BSizeY + thisObject.BSizeX + 2;
        int startoffX = 0;
        int startoffY = thisObject.BSizeY;
        int loopindex = 0;
        int foundtotal = 0;
        int foundbricks = 0;

        for (int i = 0; i < around; i++)
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
            thisObject.Bricks.clear();
            foundbricks = 0;

            while ((thisObject.getPos(startoffX + loopindex, startoffY + loopindex) != -1))
            {
                if (thisObject.getBrick(startoffX + loopindex, startoffY + loopindex) == brickType)
                {
                    foundbricks++;

                    if (thisObject.CHECKPOS(thisObject.getPos(startoffX + loopindex, startoffY + loopindex)))
                    {
                        if (thisObject.StateBoard[thisObject.getPos(startoffX + loopindex, startoffY + loopindex)] == 0)
                        {
                            thisObject.Bricks.add(Integer.valueOf(thisObject.getPos(startoffX + loopindex, startoffY + loopindex)));
                        }
                    }
                }
                else
                {

                    if (foundbricks >= thisObject.MinConnected)
                    {
                        thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnFoundConnected, thisObject.ho.getEventParam());
                        foundtotal++;
                    }

                    thisObject.Bricks.clear();
                    foundbricks = 0;
                }
                loopindex++;
            }

            if (foundbricks >= thisObject.MinConnected)
            {
                thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnFoundConnected, thisObject.ho.getEventParam());
                foundtotal++;
            }
        }
        if (foundtotal == 0)
        {
            thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnNoFoundConnected, thisObject.ho.getEventParam());
        }
    }

    private void actSearchConnected(int startX, int startY)
    {
        int FindBrick = thisObject.getBrick(startX, startY);
        int size = thisObject.BSizeX * thisObject.BSizeY;
        int FoundTotal = 0;

        int[] Used = new int[size];

        ArrayList<Integer> BrickList = new ArrayList<Integer>();
        BrickList.add(thisObject.getPos(startX, startY));

        if (thisObject.CHECKPOS(thisObject.getPos(startX, startY)))
        {
            Used[thisObject.getPos(startX, startY)] = 1;
        }

        thisObject.Bricks.clear();
        thisObject.Bricks.add(thisObject.getPos(startX, startY));

        int currentbrick = 0;
        int currentX = 0;
        int currentY = 0;

        int offsetX[] =
        {
            0, -1, 1, 0
        };
        int offsetY[] =
        {
            -1, 0, 0, 1
        };

        //char * temp ="";

        while ( BrickList.size() > 0)
        {
            currentX = thisObject.getXbrick(BrickList.get(0).intValue());
            currentY = thisObject.getYbrick(BrickList.get(0).intValue());
            for (int dir = 0; dir < 4; dir++) //Loop around brick
            {
                currentbrick = thisObject.getPos(currentX + offsetX[dir], currentY + offsetY[dir]);
                if (thisObject.CHECKPOS(currentbrick))
                {
                    if ((thisObject.Board[currentbrick] == FindBrick) && (Used[currentbrick] == 0) && (currentbrick != -1))
                    {
                        BrickList.add(Integer.valueOf(currentbrick));
                        thisObject.Bricks.add(Integer.valueOf(currentbrick));
                        Used[currentbrick] = 1;
                    }
                }
            }
            BrickList.remove(0);
        }
        if (thisObject.Bricks.size() >= thisObject.MinConnected)
        {
            thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnFoundConnected, thisObject.ho.getEventParam());
            FoundTotal++;
        }

        BrickList.clear();

        if (FoundTotal == 0)
        {
            thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnNoFoundConnected, thisObject.ho.getEventParam());
        }

    }

    private void actDeleteHorizonal(int y, int mode)
    {
        for (int del = 0; del < thisObject.BSizeX; del++)
        {
            if (thisObject.CHECKPOS(thisObject.getPos(del, y)))
            {
                boolean triggerdeletedflag = false;
                if (thisObject.TriggerDeleted)
                {
                    thisObject.DeletedFixed = thisObject.FixedBoard[thisObject.getPos(del, y)];
                    thisObject.DeletedX = del;
                    thisObject.DeletedY = y;
                    triggerdeletedflag = true;
                }

                thisObject.Board[thisObject.getPos(del, y)] = 0;
                if (thisObject.MoveFixed)
                {
                    thisObject.FixedBoard[thisObject.getPos(del, y)] = 0;
                }

                if (triggerdeletedflag)
                {
                    thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnBrickDeleted, thisObject.ho.getEventParam());
                }
            }
        }

        if (mode == 1) //MOVE ABOVE DOWNWARDS
        {
            for (int udX = 0; udX < thisObject.BSizeX; udX++)
            {
                for (int udY = y - 1; udY >= 0; udY--)
                {
                    thisObject.MoveBrick(udX, udY, udX, udY + 1);
                }
            }
        }

        if (mode == 2) //MOVE BELOW UPWARDS
        {
            for (int udX = 0; udX < thisObject.BSizeX; udX++)
            {
                for (int udY = y + 1; udY < thisObject.BSizeY; udY++)
                {
                    thisObject.MoveBrick(udX, udY, udX, udY - 1);
                }
            }
        }
    }

    private void actDeleteVertical(int x, int mode)
    {
        for (int del = 0; del < thisObject.BSizeY; del++)
        {
            if (thisObject.CHECKPOS(thisObject.getPos(x, del)))
            {
                boolean triggerdeletedflag = false;
                if (thisObject.TriggerDeleted)
                {
                    thisObject.DeletedFixed = thisObject.FixedBoard[thisObject.getPos(x, del)];
                    thisObject.DeletedX = x;
                    thisObject.DeletedY = del;
                    triggerdeletedflag = true;
                }

                thisObject.Board[thisObject.getPos(x, del)] = 0;
                if (thisObject.MoveFixed)
                {
                    thisObject.FixedBoard[thisObject.getPos(x, del)] = 0;
                }

                if (triggerdeletedflag)
                {
                    thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnBrickDeleted, thisObject.ho.getEventParam());
                }
            }
        }

        if (mode == 1) //MOVE LEFT TO RIGHT ->-> ||
        {
            for (int lrY = 0; lrY < thisObject.BSizeY; lrY++)
            {
                for (int lrX = x - 1; lrX >= 0; lrX--)
                {
                    thisObject.MoveBrick(lrX, lrY, lrX + 1, lrY);
                }
            }
        }
        if (mode == 2) //MOVE RIGHT TO LEFT   || <-<-
        {
            for (int lrY = 0; lrY < thisObject.BSizeY; lrY++)
            {
                for (int lrX = x + 1; lrX < thisObject.BSizeX; lrX++)
                {
                    thisObject.MoveBrick(lrX, lrY, lrX - 1, lrY);
                }
            }
        }
    }

    private void actSwap(int x1, int y1, int x2, int y2)
    {
        thisObject.SwapBrick1 = thisObject.getPos(x1, y1);  //Brick 1
        thisObject.SwapBrick2 = thisObject.getPos(x2, y2);  //Brick 2

        if (thisObject.CHECKPOS(thisObject.SwapBrick1) && thisObject.CHECKPOS(thisObject.SwapBrick2))
        {
            int temp = thisObject.Board[thisObject.SwapBrick1];
            int tempfixed = thisObject.FixedBoard[thisObject.SwapBrick1];

            thisObject.Board[thisObject.SwapBrick1] = thisObject.Board[thisObject.SwapBrick2];
            thisObject.Board[thisObject.SwapBrick2] = temp;

            if (thisObject.MoveFixed)
            {
                thisObject.FixedBoard[thisObject.SwapBrick1] = thisObject.FixedBoard[thisObject.SwapBrick2];
                thisObject.FixedBoard[thisObject.SwapBrick2] = tempfixed;
            }

            if (thisObject.TriggerMoved)
            {
                thisObject.MovedFixed = thisObject.FixedBoard[thisObject.SwapBrick1];
                thisObject.MovedNewX = x1;
                thisObject.MovedNewY = y1;
                thisObject.MovedOldX = x2;
                thisObject.MovedOldY = y2;
                thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnBrickMoved, thisObject.ho.getEventParam());

                thisObject.MovedFixed = thisObject.FixedBoard[thisObject.SwapBrick2];
                thisObject.MovedNewX = x2;
                thisObject.MovedNewY = y2;
                thisObject.MovedOldX = x1;
                thisObject.MovedOldY = y1;
                thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnBrickMoved, thisObject.ho.getEventParam());
            }
        }
    }

    private void actDropX(int n)
    {
        for (int i = 0; i < n; i++)
        {
            thisObject.fall();
        }
    }

    private void actMarkUsed(int x, int y)
    {
        if (thisObject.CHECKPOS(thisObject.getPos(x, y)))
        {
            thisObject.StateBoard[thisObject.getPos(x, y)] = 1;
        }
    }

    private void actDeleteMarked()
    {
        int size = thisObject.BSizeX * thisObject.BSizeY;
        boolean triggerdeleteflag = false;

        for (int i = 0; i < size; i++)
        {
            triggerdeleteflag = false;
            if (thisObject.StateBoard[i] == 1)
            {
                if (thisObject.TriggerDeleted)
                {
                    thisObject.DeletedFixed = thisObject.FixedBoard[i];
                    thisObject.DeletedX = thisObject.getXbrick(i);
                    thisObject.DeletedY = thisObject.getYbrick(i);
                    triggerdeleteflag = true;
                }

                thisObject.Board[i] = 0;
                thisObject.StateBoard[i] = 0;

                if (thisObject.MoveFixed)
                {
                    thisObject.FixedBoard[i] = 0;
                }

                if (triggerdeleteflag)
                {
                    thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnBrickDeleted, thisObject.ho.getEventParam());
                }
            }
        }
    }

    private void actUndoSwap()
    {
        if (thisObject.CHECKPOS(thisObject.SwapBrick1) && thisObject.CHECKPOS(thisObject.SwapBrick2))
        {
            int temp = thisObject.Board[thisObject.SwapBrick1];
            int tempfixed = thisObject.FixedBoard[thisObject.SwapBrick1];

            thisObject.Board[thisObject.SwapBrick1] = thisObject.Board[thisObject.SwapBrick2];
            thisObject.Board[thisObject.SwapBrick2] = temp;

            if (thisObject.MoveFixed)
            {
                thisObject.FixedBoard[thisObject.SwapBrick1] = thisObject.FixedBoard[thisObject.SwapBrick2];
                thisObject.FixedBoard[thisObject.SwapBrick2] = tempfixed;
            }

            if (thisObject.TriggerMoved)
            {
                thisObject.MovedFixed = thisObject.FixedBoard[thisObject.SwapBrick1];
                thisObject.MovedNewX = thisObject.getXbrick(thisObject.SwapBrick1);
                thisObject.MovedNewY = thisObject.getYbrick(thisObject.SwapBrick1);
                thisObject.MovedOldX = thisObject.getXbrick(thisObject.SwapBrick2);
                thisObject.MovedOldY = thisObject.getYbrick(thisObject.SwapBrick2);
                thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnBrickMoved, thisObject.ho.getEventParam());

                thisObject.MovedFixed = thisObject.FixedBoard[thisObject.SwapBrick2];
                thisObject.MovedNewX = thisObject.getXbrick(thisObject.SwapBrick2);
                thisObject.MovedNewY = thisObject.getYbrick(thisObject.SwapBrick2);
                thisObject.MovedOldX = thisObject.getXbrick(thisObject.SwapBrick1);
                thisObject.MovedOldY = thisObject.getYbrick(thisObject.SwapBrick1);
                thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnBrickMoved, thisObject.ho.getEventParam());
            }
        }
    }

    private void actSearchDiagonalsRL(int brickType)
    {

        int around = thisObject.BSizeY + thisObject.BSizeX + 2;
        int startoffX = thisObject.BSizeX - 1;
        int startoffY = thisObject.BSizeY;
        int loopindex = 0;
        int foundtotal = 0;
        int foundbricks = 0;

        for (int i = 0; i < around; i++)
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
            thisObject.Bricks.clear();

            while ((thisObject.getPos(startoffX - loopindex, startoffY + loopindex) != -1))
            {
                if (thisObject.getBrick(startoffX - loopindex, startoffY + loopindex) == brickType)
                {
                    foundbricks++;

                    if (thisObject.CHECKPOS(thisObject.getPos(startoffX - loopindex, startoffY + loopindex)))
                    {
                        if (thisObject.StateBoard[thisObject.getPos(startoffX - loopindex, startoffY + loopindex)] == 0)
                        {
                            thisObject.Bricks.add(Integer.valueOf(thisObject.getPos(startoffX - loopindex, startoffY + loopindex)));
                        }
                    }
                }
                else
                {

                    if (foundbricks >= thisObject.MinConnected)
                    {
                        thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnFoundConnected, thisObject.ho.getEventParam());
                        foundtotal++;
                    }

                    thisObject.Bricks.clear();
                    foundbricks = 0;
                }

                loopindex++;
            }

            if (foundbricks >= thisObject.MinConnected)
            {
                thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnFoundConnected, thisObject.ho.getEventParam());
                foundtotal++;
            }

        }
        if (foundtotal == 0)
        {
            thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnNoFoundConnected, thisObject.ho.getEventParam());
        }
    }

    private void actLoopFoundBricks()
    {
        int Brick_size = thisObject.Bricks.size();
    	for (int loop = 0; loop < Brick_size; loop++)
        {
            thisObject.LoopIndex = loop;
            thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnFoundBrick, thisObject.ho.getEventParam());
        }
    }

    private void actSetFixedOfBrick(int x, int y, int fv)
    {
        if (thisObject.CHECKPOS(thisObject.getPos(x, y)))
        {
            thisObject.FixedBoard[thisObject.getPos(x, y)] = fv;
        }
    }

    private void actImportActives(CObject selected)
    {
        int size = thisObject.BSizeX * thisObject.BSizeY;
        if (thisObject.CHECKPOS(size - thisObject.AddIncrement - 1))
        {
            thisObject.FixedBoard[size - thisObject.AddIncrement - 1] = (selected.hoCreationId << 16) + selected.hoNumber;
        }
        thisObject.AddIncrement++;
    }

    private void actMarkCurrentSystem()
    {
        int Brick_size = thisObject.Bricks.size();
    	for (int i = 0; i < Brick_size; i++)
        {
            if (thisObject.CHECKPOS(thisObject.Bricks.get(i).intValue()))
            {
                thisObject.StateBoard[thisObject.Bricks.get(i).intValue()] = 1;
            }
        //MessageBox(NULL, "Brick marked in system" , "Brick marked", MB_ICONEXCLAMATION);
        }
    }

    private void actMarkCurrentBrick()
    {
        if (thisObject.CHECKPOS(thisObject.Bricks.get(thisObject.LoopIndex).intValue()))
        {
            thisObject.StateBoard[thisObject.Bricks.get(thisObject.LoopIndex).intValue()] = 1;
        }
    //MessageBox(NULL, "Brick marked" , "Brick marked", MB_ICONEXCLAMATION);
    }

    private void actLoopEntireBoard()
    {
        int size = thisObject.BSizeX * thisObject.BSizeY;
        thisObject.Looped.clear();
        for (int i = 0; i < size; i++)
        {
            thisObject.Looped.add(Integer.valueOf(i));
        }

        int loop_size = thisObject.Looped.size();
        
        for (int u = 0; u < loop_size; u++)
        {
            thisObject.LoopedIndex = u;
            thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnFoundLooped, thisObject.ho.getEventParam());
        }
    }

    private void actLoopBoardOfType(int brickType)
    {
        int size = thisObject.BSizeX * thisObject.BSizeY;
        thisObject.Looped.clear();

        for (int i = 0; i < size; i++)
        {
            if (thisObject.Board[i] == brickType)
            {
                thisObject.Looped.add(Integer.valueOf(i));
            }
        }
        
        int loop_size = thisObject.Looped.size();
        
        for (int u = 0; u < loop_size; u++)
        {
            thisObject.LoopedIndex = u;
            thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnFoundLooped, thisObject.ho.getEventParam());
        }
    }

    private void actLoopSorrounding(int x, int y)
    {
        thisObject.Looped.clear();

        int offsetX[] =
        {
            -1, 0, 1, -1, 1, -1, 0, 1
        };
        int offsetY[] =
        {
            -1, -1, -1, 0, 0, 1, 1, 1
        };

        for (int i = 0; i < 8; i++)
        {
            if (thisObject.getBrick(x + offsetX[i], y + offsetY[i]) != -1)
            {
                thisObject.Looped.add(Integer.valueOf(thisObject.getPos(x + offsetX[i], y + offsetY[i])));
            }
        }

        int loop_size = thisObject.Looped.size();

        for (int u = 0; u < loop_size; u++)
        {
            thisObject.LoopedIndex = u;
            thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnFoundLooped, thisObject.ho.getEventParam());
        }
    }

    private void actLoopHozLine(int y)
    {
        thisObject.Looped.clear();
        for (int i = 0; i < thisObject.BSizeX; i++)
        {
            thisObject.Looped.add(Integer.valueOf(thisObject.getPos(i, y)));
        }

        int loop_size = thisObject.Looped.size();
        
        for (int u = 0; u < loop_size; u++)
        {
            thisObject.LoopedIndex = u;
            thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnFoundLooped, thisObject.ho.getEventParam());
        }
    }

    private void actLoopVerLine(int x)
    {
        thisObject.Looped.clear();
        for (int i = 0; i < thisObject.BSizeY; i++)
        {
            thisObject.Looped.add(Integer.valueOf(thisObject.getPos(x, i)));
        }

        int loop_size = thisObject.Looped.size();
        
        for (int u = 0; u < loop_size; u++)
        {
            thisObject.LoopedIndex = u;
            thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnFoundLooped, thisObject.ho.getEventParam());
        }
    }

    private void actClearWithType(int brickType)
    {
        int size = thisObject.BSizeX * thisObject.BSizeY;
        for (int i = 0; i < size; i++)
        {
            thisObject.Board[i] = brickType;
        }
    }

    private void actInsertBrick(int x, int y, int brickType)
    {
        int size = thisObject.BSizeX * thisObject.BSizeY;
        boolean triggerdeletedflag = false;

        if (thisObject.TriggerDeleted && thisObject.Board[size - 1] != 0)
        {
            thisObject.DeletedFixed = thisObject.FixedBoard[size - 1];
            thisObject.DeletedX = thisObject.getXbrick(size - 1);
            thisObject.DeletedY = thisObject.getYbrick(size - 1);
            triggerdeletedflag = true;
        }

        int getPosXY = thisObject.getPos(x, y);
        for (int i = size - 2; i > getPosXY; i--)
        {
            thisObject.MoveBrick(thisObject.getXbrick(i), thisObject.getYbrick(i), thisObject.getXbrick(i) + 1, thisObject.getYbrick(i));
        }

        if (thisObject.CHECKPOS(thisObject.getPos(x, y)))
        {
            thisObject.Board[thisObject.getPos(x, y)] = brickType;

            if (thisObject.MoveFixed)
            {
                thisObject.FixedBoard[thisObject.getPos(x, y)] = 0;
            }
        }

        if (triggerdeletedflag && thisObject.TriggerDeleted)
        {
            thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnBrickDeleted, thisObject.ho.getEventParam());
        }
    }

    private void actSetCellDimensions(int x, int y)
    {
        thisObject.CellWidth = x;
        thisObject.CellHeight = y;
        if (thisObject.CellWidth == 0)
        {
            thisObject.CellWidth = 1;
        }
        if (thisObject.CellHeight == 0)
        {
            thisObject.CellHeight = 1;
        }
    }

    private void actDropXUp(int n)
    {
        for (int i = 0; i < n; i++)
        {
            thisObject.fallUP();
        }
    }

    private void actDropXLeft(int n)
    {
        for (int i = 0; i < n; i++)
        {
            thisObject.fallLEFT();
        }
    }

    private void actDropXRight(int n)
    {
        for (int i = 0; i < n; i++)
        {
            thisObject.fallRIGHT();
        }
    }

    private void actSetCellValue(int x, int y, int value)
    {
        if (thisObject.getPos(x, y) != -1)
        {
            thisObject.CellValues[thisObject.getPos(x, y)] = value;
        }
    }

    private void actDeleteBrick(int x, int y)
    {
        if (thisObject.TriggerDeleted)
        {
            thisObject.DeletedFixed = thisObject.getFixed(x, y);
            thisObject.DeletedX = x;
            thisObject.DeletedY = y;
        }

        thisObject.setBrick(x, y, 0);

        if (thisObject.TriggerDeleted)
        {
            thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnBrickDeleted, thisObject.ho.getEventParam());
        }
    }

    private void actShiftHosLine(int yline, int shift)
    {
        int templine[] = new int[thisObject.BSizeX];
        int tempfixed[] = new int[thisObject.BSizeX];

        //write to templine
        for (int i = 0; i < thisObject.BSizeX; i++)
        {
            templine[i] = thisObject.getBrick(thisObject.wrapX(i - shift), yline);
            tempfixed[i] = thisObject.getFixed(thisObject.wrapX(i - shift), yline);
        }

        for (int j = 0; j < thisObject.BSizeX; j++)
        {
            if (thisObject.TriggerMoved)
            {
                thisObject.MovedOldX = j;
                thisObject.MovedOldY = yline;
                thisObject.MovedNewX = thisObject.wrapX(j + shift);
                thisObject.MovedNewY = yline;
                thisObject.MovedFixed = thisObject.getFixed(j, yline);
            }

            thisObject.setBrick(j, yline, templine[j]);

            if (thisObject.MoveFixed)
            {
                thisObject.setFixed(j, yline, tempfixed[j]);
            }

            if (thisObject.TriggerMoved)
            {
                thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnBrickMoved, thisObject.ho.getEventParam());
            }
        }
    }

    private void actShiftVerLine(int xline, int shift)
    {
        int templine[] = new int[thisObject.BSizeY];
        int tempfixed[] = new int[thisObject.BSizeY];

        //write to templine
        for (int i = 0; i < thisObject.BSizeY; i++)
        {
            templine[i] = thisObject.getBrick(xline, thisObject.wrapY(i - shift));
            tempfixed[i] = thisObject.getFixed(xline, thisObject.wrapY(i - shift));
        }

        for (int j = 0; j < thisObject.BSizeY; j++)
        {
            if (thisObject.TriggerMoved)
            {
                thisObject.MovedOldX = xline;
                thisObject.MovedOldY = j;
                thisObject.MovedNewX = xline;
                thisObject.MovedNewY = thisObject.wrapY(j + shift);
                thisObject.MovedFixed = thisObject.getFixed(xline, j);
            }

            thisObject.setBrick(xline, j, templine[j]);

            if (thisObject.MoveFixed)
            {
                thisObject.setFixed(xline, j, tempfixed[j]);
            }

            if (thisObject.TriggerMoved)
            {
                thisObject.ho.generateEvent(AdvGameBoardCnds.CID_conOnBrickMoved, thisObject.ho.getEventParam());
            }
        }
    }

    private CObject CObjectFromFixed(int fixed)
    {
        CObject list[] = thisObject.ho.hoAdRunHeader.rhObjectList;
        int list_length = list.length;
        for (int i = 0; i < list_length; i++)
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

    private void actPositionBricks()
    {
        int size = thisObject.BSizeX * thisObject.BSizeY;
        int fixed = 0;
        CObject active;
        int posX = 0;
        int posY = 0;

        for (int i = 0; i < size; i++)
        {
            fixed = thisObject.FixedBoard[i];
            active = CObjectFromFixed(fixed);
            posX = thisObject.getXbrick(i);
            posY = thisObject.getYbrick(i);

            if (active != null && fixed > 0)
            {
                active.hoX = thisObject.CellWidth * posX + thisObject.OriginX;
                active.hoY = thisObject.CellHeight * posY + thisObject.OriginY;
                active.roc.rcChanged = true;
            }

        }
    }
}

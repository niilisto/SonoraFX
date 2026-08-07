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

//----------------------------------------------------------------------------------
//
// CRunAdvGameBoard : Advanced Game Board object
// fin: 4/10/09
//greyhill
//----------------------------------------------------------------------------------

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

public class CRunAdvGameBoard extends CRunExtension
{
    public static final int MOORECEPIENT_CHANNEL = -1;
//typedef struct tagEDATA_V1
//{
//	extHeader		eHeader;
//	short			sx;
//	short			sy;
//	short			swidth;
//	short			sheight;
//	int				BSizeX;
//	int				BSizeY;
//	int				MinConnected;
//	int				OriginX;
//	int				OriginY;
//	int				CellWidth;
//	int				CellHeight;
//	bool			MoveFixed;
//	bool			TriggerMoved;
//	bool			TriggerDeleted;
//
//
//} EDITDATA;
    public int BSizeX,  BSizeY,  MinConnected,  SwapBrick1,  SwapBrick2,  LoopIndex,  LoopedIndex,  OriginX,  OriginY,  CellWidth,  CellHeight;
    public int[] Board,  StateBoard,  FixedBoard,  CellValues;
    public boolean MoveFixed,  TriggerMoved,  TriggerDeleted;
    public int DeletedFixed,  DeletedX,  DeletedY,  MovedFixed,  MovedNewX,  MovedNewY,  MovedOldX,  MovedOldY;
    public int AddIncrement,  SearchBrickType;
    ArrayList<Integer> Bricks = new ArrayList<Integer>();
    ArrayList<Integer> Looped = new ArrayList<Integer>();
    public AdvGameBoardActs actions = new AdvGameBoardActs(this);
    public AdvGameBoardCnds conditions = new AdvGameBoardCnds(this);
    public AdvGameBoardExpr expressions = new AdvGameBoardExpr(this);
	public CValue		tempValue;

    public CRunAdvGameBoard()
    {
		tempValue = new CValue();
    }

    @Override
	public int getNumberOfConditions()
    {
        return 11;
    }

    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        file.skipBytes(8);
        this.BSizeX = file.readInt();
        this.BSizeY = file.readInt();
        this.MinConnected = file.readInt();
        this.SwapBrick1 = 0;
        this.SwapBrick2 = 0;
        this.LoopIndex = 0;
        this.LoopedIndex = 0;

        int size = this.BSizeX * this.BSizeY;
        this.Board = new int[size];
        this.StateBoard = new int[size];
        this.FixedBoard = new int[size];
        this.CellValues = new int[size];

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

    public int getBrick(int x, int y)
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

    public int getBrickAtPos(int pos)
    {
        if (CHECKPOS(pos))
        {
            return this.Board[pos];
        }
        return 0;
    }

    public boolean CHECKPOS(int nPos)
    {
        if (nPos >= 0 && nPos < this.BSizeX * this.BSizeY)
        {
            return true;
        }
        return false;
    }

    public int getPos(int x, int y)
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

    public int getXbrick(int pos)
    {
        return pos % this.BSizeX;
    }

    public int getYbrick(int pos)
    {
        return pos / this.BSizeX;
    }

    public void setBrick(int x, int y, int value)
    {
        if (CHECKPOS(getPos(x, y)))
        {
            this.Board[getPos(x, y)] = value;
        }
    }

    public int getFixed(int x, int y)
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

    void setFixed(int x, int y, int value)
    {
        if (CHECKPOS(getPos(x, y)))
        {
            this.FixedBoard[getPos(x, y)] = value;
        }
    }

    public int wrapX(int shift)
    {
        return (shift >= 0) ? (shift % this.BSizeX) : this.BSizeX + (shift % this.BSizeX);
    }

    public int wrapY(int shift)
    {
        return (shift >= 0) ? (shift % this.BSizeY) : this.BSizeY + (shift % this.BSizeY);
    }

    public void MoveBrick(int sourceX, int sourceY, int destX, int destY)
    {

        if ((getPos(destX, destY) != -1) && (getPos(sourceX, sourceY) != -1))
        {
            boolean triggerdeletedflag = false;
            boolean triggermovedflag = false;

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
                ho.generateEvent(AdvGameBoardCnds.CID_conOnBrickMoved, ho.getEventParam());
            }
            if (triggerdeletedflag)
            {
                ho.generateEvent(AdvGameBoardCnds.CID_conOnBrickDeleted, ho.getEventParam());
            }
        }
    }

    public void fall()
    {
        for (int x = 0; x < BSizeX; x++)
        {
            for (int y = BSizeY - 2; y >= 0; y--)
            {
                if (getBrick(x, y + 1) == 0)
                {
                    MoveBrick(x, y, x, y + 1);
                }
            }
        }
    }

    public void fallUP()
    {
        for (int x = 0; x < BSizeX; x++)
        {
            for (int y = 1; y <= BSizeY - 1; y++)
            {
                if (getBrick(x, y - 1) == 0)
                {
                    MoveBrick(x, y, x, y - 1);
                }
            }
        }
    }

    public void fallLEFT()
    {
        for (int y = 0; y <= BSizeY; y++)
        {
            for (int x = 1; x < BSizeX; x++)
            {
                if (getBrick(x - 1, y) == 0)
                {
                    MoveBrick(x, y, x - 1, y);
                }
            }
        }
    }

    public void fallRIGHT()
    {
        for (int y = 0; y <= BSizeY; y++)
        {
            for (int x = BSizeX - 2; x >= 0; x--)
            {
                if (getBrick(x + 1, y) == 0)
                {
                    MoveBrick(x, y, x + 1, y);
                }
            }
        }
    }

    @Override
	public void destroyRunObject(boolean bFast)
    {
    }

    @Override
	public int handleRunObject()
    {
        this.AddIncrement = 0;
        return 0;
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

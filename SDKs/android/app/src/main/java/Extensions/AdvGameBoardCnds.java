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
import Conditions.CCndExtension;

public class AdvGameBoardCnds
{
    public static final int CID_conOnFoundConnected = 0;
    public static final int CID_conOnFoundBrick = 1;
    public static final int CID_conOnFoundLooped = 2;
    public static final int CID_conOnNoFoundConnected = 3;
    public static final int CID_conBrickCanFallUp = 4;
    public static final int CID_conBrickCanFallDown = 5;
    public static final int CID_conBrickCanFallLeft = 6;
    public static final int CID_conBrickCanFallRight = 7;
    public static final int CID_conOnBrickMoved = 8;
    public static final int CID_conOnBrickDeleted = 9;
    public static final int CID_conIsEmpty = 10;
    CRunAdvGameBoard thisObject;

    public AdvGameBoardCnds(CRunAdvGameBoard object)
    {
        thisObject = object;
    }

    public boolean get(int num, CCndExtension cnd)
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
                return conBrickCanFallUp(cnd.getParamExpression(thisObject.rh, 0), cnd.getParamExpression(thisObject.rh, 1));
            case CID_conBrickCanFallDown:
                return conBrickCanFallDown(cnd.getParamExpression(thisObject.rh, 0), cnd.getParamExpression(thisObject.rh, 1));
            case CID_conBrickCanFallLeft:
                return conBrickCanFallLeft(cnd.getParamExpression(thisObject.rh, 0), cnd.getParamExpression(thisObject.rh, 1));
            case CID_conBrickCanFallRight:
                return conBrickCanFallRight(cnd.getParamExpression(thisObject.rh, 0), cnd.getParamExpression(thisObject.rh, 1));
            case CID_conOnBrickMoved:
                return true;
            case CID_conOnBrickDeleted:
                return true;
            case CID_conIsEmpty:
                return conIsEmpty(cnd.getParamExpression(thisObject.rh, 0), cnd.getParamExpression(thisObject.rh, 1));
        }
        return false;
    }

    private boolean conBrickCanFallUp(int x, int y)
    {
        int tempbrick = 0;
        int currentbrick = thisObject.getBrick(x, y);
        int belowbrick = thisObject.getBrick(x, y + 1);

        if (belowbrick == -1 || currentbrick == 0 || currentbrick == -1)
        {
            return false;
        }

        for (int i = y; i >= 0; i--)
        {
            tempbrick = thisObject.getBrick(x, i);

            if (tempbrick == 0)
            {
                return true;
            }
        }
        return false;
    }

    private boolean conBrickCanFallDown(int x, int y)
    {
        int tempbrick = 0;
        int currentbrick = thisObject.getBrick(x, y);
        int belowbrick = thisObject.getBrick(x, y + 1);

        if (belowbrick == -1 || currentbrick == 0 || currentbrick == -1)
        {
            return false;
        }

        for (int i = y; i <= thisObject.BSizeY - 1; i++)
        {
            tempbrick = thisObject.getBrick(x, i);

            if (tempbrick == 0)
            {
                return true;
            }
        }
        return false;
    }

    private boolean conBrickCanFallLeft(int x, int y)
    {
        int tempbrick = 0;
        int currentbrick = thisObject.getBrick(x, y);
        int belowbrick = thisObject.getBrick(x - 1, y);

        if (belowbrick == -1 || currentbrick == 0 || currentbrick == -1)
        {
            return false;
        }

        for (int i = x; i >= 0; i--)
        {
            tempbrick = thisObject.getBrick(i, y);

            if (tempbrick == 0)
            {
                return true;
            }
        }
        return false;
    }

    private boolean conBrickCanFallRight(int x, int y)
    {
        int tempbrick = 0;
        int currentbrick = thisObject.getBrick(x, y);
        int belowbrick = thisObject.getBrick(x + 1, y);

        if (belowbrick == -1 || currentbrick == 0 || currentbrick == -1)
        {
            return false;
        }

        for (int i = x; i <= thisObject.BSizeX - 1; i++)
        {
            tempbrick = thisObject.getBrick(i, y);

            if (tempbrick == 0)
            {
                return true;
            }
        }
        return false;
    }

    private boolean conIsEmpty(int x, int y)
    {
        //if (thisObject.getBrick(x, y) == 0)
        //{
        //    return true;
        //}
        //else
        //{
        //    return false;
        //}
        return (thisObject.getBrick(x, y) == 0);
    }
}

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


import Actions.CActExtension;
//import java.io.BufferedInputStream;
//import java.io.DataInputStream;
//import java.io.File;


public class WargameMapActs
{
    static final int ACT_SETWIDTH = 0;
    static final int ACT_SETHEIGHT = 1;
    static final int ACT_SETCOST = 2;
    static final int ACT_CALCULATEPATH = 3;
    static final int ACT_NEXTPOINT = 4;
    static final int ACT_PREVPOINT = 5;
    static final int ACT_RESETPOINT = 6;
    static final int ACT_CALCULATELOS = 7;
    CRunWargameMap thisObject;

    public WargameMapActs(CRunWargameMap object)
    {
        thisObject = object;
    }

    public void action(int num, CActExtension act)
    {
        switch (num)
        {
            case ACT_SETWIDTH:
                aSetWidth(act.getParamExpression(thisObject.rh, 0));
                break;
            case ACT_SETHEIGHT:
                aSetHeight(act.getParamExpression(thisObject.rh, 0));
                break;
            case ACT_SETCOST:
                aSetCost(act.getParamExpression(thisObject.rh, 0), act.getParamExpression(thisObject.rh, 1), act.getParamExpression(thisObject.rh, 2));
                break;
            case ACT_CALCULATEPATH:
                aCalculatePath(act.getParamExpression(thisObject.rh, 0), act.getParamExpression(thisObject.rh, 1), act.getParamExpression(thisObject.rh, 2), act.getParamExpression(thisObject.rh, 3));
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
                aCalculateLOS(act.getParamExpression(thisObject.rh, 0), act.getParamExpression(thisObject.rh, 1), act.getParamExpression(thisObject.rh, 2), act.getParamExpression(thisObject.rh, 3));
                break;
        }
    }

    private void aSetWidth(int w)
    {
        thisObject.mapWidth = w;
        thisObject.map = new byte[w * thisObject.mapHeight];
        thisObject.fillMap((byte) 0);
    }

    private void aSetHeight(int h)
    {
        thisObject.mapHeight = h;
        thisObject.map = new byte[h * thisObject.mapWidth];
        thisObject.fillMap((byte) 0);
    }

    private void aSetCost(int x, int y, int cost)
    {
        if (thisObject.WithinBounds(x, y))
        {
            if (cost > 255)
            {
                cost = 255;
            }
            thisObject.SetTileInArray(x - 1, y - 1, (byte) cost);
        }
    }

    private void aCalculatePath(int startX, int startY, int destX, int destY)
    {
        thisObject.startX = startX;
        thisObject.startY = startY;
        thisObject.destX = destX;
        thisObject.destY = destY;
        thisObject.path = thisObject.Pathfinder(startX - 1, startY - 1, destX - 1, destY - 1);
        thisObject.iterator = 0;
    }

    private void aNextPoint()
    {
        if ((thisObject.path != null) && (thisObject.iterator < thisObject.path.size() - 1))
        {
            thisObject.iterator++;
        }
    }

    private void aPrevPoint()
    {
        if (thisObject.iterator > 0)
        {
            thisObject.iterator--;
        }
    }

    private void aResetPoint()
    {
        thisObject.iterator = 0;
    }

    private void aCalculateLOS(int startX, int startY, int destX, int destY)
    {
        thisObject.startX = startX;
        thisObject.startY = startY;
        thisObject.destX = destX;
        thisObject.destY = destY;
        thisObject.path = thisObject.GetStraightLinePath(startX - 1, startY - 1, destX - 1, destY - 1);
        thisObject.iterator = 0;
    }
}

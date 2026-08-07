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
/*
 * high score OBJECT
 * 
 */

package Extensions;

/**
 * by Greyhill
 * @author Admin
 */
import Conditions.CCndExtension;
import RunLoop.CRun;

public class kchiscCnds
{
    static final int CND_ISPLAYER = 0;
    static final int CND_VISIBLE = 1;
    CRunkchisc thisObject;

    public kchiscCnds(CRunkchisc object)
    {
        thisObject = object;
    }

    public boolean get(int num, CCndExtension cnd)
    {
        switch (num)
        {
            case CND_ISPLAYER:
                return IsPlayerHiScore(cnd.getParamPlayer(thisObject.rh, 0));
            case CND_VISIBLE:
                return IsVisible();
        }
        return false;//won't happen
    }

    private boolean IsPlayerHiScore(short player)
    {
        CRun rhPtr = this.thisObject.ho.hoAdRunHeader;
        int score = rhPtr.rhApp.scores[player];
        if ((score > this.thisObject.Scores[this.thisObject.NbScores - 1]) && (score != this.thisObject.scrPlayer[player]))
        {
            this.thisObject.scrPlayer[player] = score;
            return true;
        }
        return false;
    }

    private boolean IsVisible()
    {
        return (thisObject.sVisible);
    }
}

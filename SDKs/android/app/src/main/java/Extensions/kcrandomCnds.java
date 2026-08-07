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

/*
 * Randomizer OBJECT
 * 
 */

/**
 * by Greyhill
 * @author Admin
 */
import Conditions.CCndExtension;

public class kcrandomCnds
{
    static final int CND_RAND_EVENT	=	0;
    static final int CND_RAND_EVENT_GROUP	= 1;
    static final int CND_RAND_EVENT_GROUP_CUST =	2;

    CRunkcrandom thisObject;

    public kcrandomCnds(CRunkcrandom thisObject) {
        this.thisObject = thisObject;
    }

    public boolean get(int num, CCndExtension cnd)
    {
        switch (num)
        {
            case CND_RAND_EVENT:
                return RandomEvent(cnd.getParamExpression(thisObject.rh, 0));
            case CND_RAND_EVENT_GROUP:
                return RandomEventGroup(cnd.getParamExpression(thisObject.rh, 0));
            case CND_RAND_EVENT_GROUP_CUST:
                return RandomEventGroupCustom(cnd.getParamExpString(thisObject.rh, 0), cnd.getParamExpression(thisObject.rh, 1));
        }
        return false;//won't happen
    }
    
    private boolean RandomEvent(int p) {
        if (thisObject.random(100) < p)
            return true;
	return false;
    }
    private boolean RandomEventGroup(int p) {
        thisObject.globalPosition += p;
	if ((thisObject.globalRandom >= thisObject.globalPosition - p) &&
            (thisObject.globalRandom < thisObject.globalPosition))
            return true;
	return false;
    }
    private boolean RandomEventGroupCustom(String name, int p) {
        if (thisObject.currentGroupName.equals(name)) {
            thisObject.currentPosition += p;
            if ((thisObject.currentRandom >= thisObject.currentPosition - p) &&
                (thisObject.currentRandom < thisObject.currentPosition))
                return true;
	}
	return false;
    }
}

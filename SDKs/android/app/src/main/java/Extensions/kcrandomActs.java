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
import Actions.CActExtension;

public class kcrandomActs
{
    static final int ACT_NEW_SEED	=	0;
    static final int ACT_SET_SEED	=	1;
    static final int ACT_TRIGGER_RAND_EVENT_GROUP	=	2;
    static final int ACT_TRIGGER_RAND_EVENT_GROUP_CUST =	3;
    
    CRunkcrandom thisObject;

    public kcrandomActs(CRunkcrandom object) {
        thisObject = object;
    }
    
    public void action(int num, CActExtension act)
    {   
        switch (num)
        {        
            case ACT_NEW_SEED:
                thisObject.lastSeed = thisObject.newseed();
                break;        
            case ACT_SET_SEED:
                SetSeed(act.getParamExpression(thisObject.rh, 0));
                break;
            case ACT_TRIGGER_RAND_EVENT_GROUP:
                TriggerRandomEventGroup(act.getParamExpression(thisObject.rh, 0));
                break;
            case ACT_TRIGGER_RAND_EVENT_GROUP_CUST:
                TriggerRandomEventGroupCustom(act.getParamExpString(thisObject.rh, 0), act.getParamExpression(thisObject.rh, 1));
                break;
        }
    }
    
    private void SetSeed(int pSeed){
        thisObject.lastSeed = pSeed;
        thisObject.setseed(pSeed);
    }
    
    private void TriggerRandomEventGroup(int pPercentMax){
        thisObject.globalPercentMax = pPercentMax;
        if (thisObject.globalPercentMax <= 0){
            thisObject.globalPercentMax = 100;
        }
        thisObject.globalRandom = thisObject.random(thisObject.globalPercentMax);
	thisObject.globalPosition = 0;
        thisObject.ho.generateEvent(kcrandomCnds.CND_RAND_EVENT_GROUP, thisObject.ho.getEventParam());
    }

    private void TriggerRandomEventGroupCustom(String name, int pPercentMax){
        int		lastPercentMax = thisObject.currentPercentMax;
	int		lastRandom = thisObject.currentRandom;
	int		lastPosition = thisObject.currentPosition;
	String	lastGroupName = thisObject.currentGroupName;

        thisObject.currentGroupName = name;
	thisObject.currentPercentMax = pPercentMax;
	if (thisObject.currentPercentMax <= 0)
            thisObject.currentPercentMax = 100;
	thisObject.currentRandom = thisObject.random(thisObject.currentPercentMax);
	thisObject.currentPosition = 0;
	thisObject.ho.generateEvent(kcrandomCnds.CND_RAND_EVENT_GROUP_CUST, thisObject.ho.getEventParam());
	thisObject.currentPercentMax = lastPercentMax;
	thisObject.currentRandom = lastRandom;
	thisObject.currentPosition = lastPosition;
	thisObject.currentGroupName = lastGroupName;
    }
}

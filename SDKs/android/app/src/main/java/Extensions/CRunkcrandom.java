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
// CRunkcrandom: Randomizer object
// fin 26/09/09
//greyhill
//----------------------------------------------------------------------------------

import java.util.Calendar;
import java.util.Random;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import RunLoop.CCreateObjectInfo;
import Services.CBinaryFile;

public class CRunkcrandom extends CRunExtension
{
    String			currentGroupName;
    int				currentPercentMax;
    int				currentPosition;
    int				currentRandom;
    int				globalPercentMax;
    int				globalPosition;
    int				globalRandom;
    int				lastSeed;
    Random                      random;
                
    kcrandomActs actions = new kcrandomActs(this);
    kcrandomCnds conditions = new kcrandomCnds(this);
    kcrandomExpr expressions = new kcrandomExpr(this);
    public CRunkcrandom()
    {
    }
    @Override
	public int getNumberOfConditions()
    {
	return 3;
    }
    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        this.lastSeed = newseed();
        
	return true;
    }
    public int newseed(){
        int time = (int)Calendar.getInstance().getTimeInMillis();
        random = new Random(time);
        return time;
    }
    public void setseed(int pSeed){
        random = new Random(pSeed);
    }
    public int random(int max) {
	return random.nextInt(max);
    }
    public int randommm(int min, int max) {
	return random(max-min)+min;
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

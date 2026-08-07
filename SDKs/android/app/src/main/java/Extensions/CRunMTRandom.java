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
// CRunMTTandom: MT random object
// fin 3rd feb 2010
//greyhill
//----------------------------------------------------------------------------------

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.util.Calendar;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import RunLoop.CCreateObjectInfo;
import Services.CBinaryFile;
import Services.CFontInfo;
import Services.CRect;
import Sprites.CMask;

public class CRunMTRandom extends CRunExtension
{
//    typedef struct tagEDATA_V1
//{
//	extHeader		eHeader;
//	short			sx;
//	short			sy;
//	short			swidth;
//	short			sheight;
//
//	bool			seedvalues;
//	long			seed[10];
//
//} EDITDATA;
//typedef EDITDATA _far *			LPEDATA;

    MTRandomMersenne rand;
    static long START_TIME = -1;
                
    MTRandomActs actions = new MTRandomActs(this);
    MTRandomExpr expressions = new MTRandomExpr(this);
    public CRunMTRandom()
    {
        if (START_TIME == -1)
            START_TIME = Calendar.getInstance().getTimeInMillis();
    }
    @Override
	public int getNumberOfConditions()
    {
	return 0;
    }
    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        boolean seedvalues = (file.readByte() != 0) ? true: false;

        int seed[] = { file.readInt(), file.readInt(),
                        file.readInt(), file.readInt(),
                        file.readInt(), file.readInt(),
                        file.readInt(), file.readInt(),
                        file.readInt(), file.readInt() };

        this.rand = new MTRandomMersenne();
        if (seedvalues){
            this.rand.setSeed(seed);
        }/* else {
            this.rand.seed();
        }*/

	return true;
    }
   
    @Override
	public void destroyRunObject(boolean bFast)
    {
    }    
    
    @Override
	public int handleRunObject()
    {
        return REFLAG_ONESHOT; 
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
        return false;
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

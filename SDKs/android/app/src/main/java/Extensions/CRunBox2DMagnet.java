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
//----------------------------------------------------------------------------------
//
// CRUNBOX2DFAN
//
//----------------------------------------------------------------------------------
package Extensions;

import java.util.ArrayList;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import Objects.CExtension;
import Objects.CObject;
import RunLoop.CCreateObjectInfo;
import RunLoop.CRun;
import RunLoop.CRunBaseParent;
import RunLoop.CRunMBase;
import Services.CBinaryFile;

public class CRunBox2DMagnet extends CRunBaseParent
{
    private static final int CND_ISACTIVE=0;
    private static final int CND_LAST=1;
    private static final int ACT_SETSTRENGTH=0;
    private static final int ACT_SETANGLE=1;
    private static final int ACT_SETWIDTH=2;
    private static final int ACT_SETHEIGHT=3;
    private static final int ACT_ONOFF=4;
    private static final int EXP_STRENGTH=0;
    private static final int EXP_WIDTH=1;
    private static final int EXP_HEIGHT=2;
    private static final int MAGNETFLAG_ON=0x0001;
    private static final float STRENGTHMULT = 0.001f;

    private CRunBox2DBase base = null;
    private ArrayList<CRunMBase> objects = new ArrayList<CRunMBase>();
    private int flags = 0;
    private float strength = 0;
    private int strengthBase = 0;
    private int angle = 0;
    private int radius = 0;

    public CRunBox2DMagnet()
    {
    }

    @Override
	public void rAddObject(CRunMBase movement)
    {
        if (movement.m_identifier==this.identifier)
        {
            this.objects.add(movement);
        }
    }

    @Override
	public void rRemoveObject(CRunMBase movement)
    {
        this.objects.remove(movement);
    }

    @Override
	public boolean rStartObject()
    {
        if (this.base==null)
        {
            this.base=this.GetBase();
            if (this.base == null)
                return false;
        }
        return base.started;
    }

    // Build 283.2 increasing performance
    private CRunBox2DBase GetBase()
    {
        int nObjects = this.rh.rhNObjects;
        CObject[] localObjectList=this.rh.rhObjectList;
        for (CObject pObject : localObjectList)
        {
            if (pObject != null) {
            	--nObjects;
	            if(pObject.hoType>=32)
	            {
	                if (pObject.hoCommon.ocIdentifier == CRun.BASEIDENTIFIER)
	                {
	                    CRunBox2DBase pBase = (CRunBox2DBase)((CExtension)pObject).ext;
	                    if (pBase.identifier == this.identifier)
	                    {
	                        return pBase;
	                    }
	                }
	            }
            }
            if(nObjects==0)
            	break;
        }
        return null;
    }

    @Override
	public int getNumberOfConditions()
    {
        return CND_LAST;
    }

    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        this.flags=file.readInt();
        this.angle=file.readInt();
        this.strengthBase=file.readInt();
        this.strength=this.strengthBase*STRENGTHMULT;
        this.ho.hoImgWidth=file.readInt();
        this.ho.hoImgHeight=file.readInt();
        this.identifier=file.readInt();

        int sx=this.ho.hoImgWidth/2;
        int sy=this.ho.hoImgHeight/2;
        this.radius=(int)(Math.sqrt(sx*sx+sy*sy));

        this.base = null;
        return false;
    }

    @Override
	public void destroyRunObject(boolean bFast)
    {
    }

    @Override
	public int handleRunObject()
    {
        if (!this.rStartObject() || this.base.isPaused())
            return 0;

        if ((this.flags&MAGNETFLAG_ON)!=0)
        {
            int n;
            int objects_size = this.objects.size();
            for (n=0; n<objects_size; n++)
            {
                CRunMBase pMovement=this.objects.get(n);
                if(pMovement == null)
                	continue;
                
                int x = -1000000;
                int y = -1000000;
                if (pMovement.m_type ==CRunMBase.MTYPE_PARTICULE || pMovement.m_type == CRunMBase.MTYPE_ELEMENT)
                {
                    x = pMovement.x;
                    y = pMovement.y;
                }
                else if (pMovement.m_type == CRunMBase.MTYPE_OBJECT)
                {
                    x = pMovement.m_pHo.hoX;
                    y = pMovement.m_pHo.hoY;
                }

                if (x>=this.ho.hoX && x<this.ho.hoX+this.ho.hoImgWidth && y>=this.ho.hoY && y<this.ho.hoY+this.ho.hoImgHeight)
                {
                    int dx=x-(this.ho.hoX+this.ho.hoImgWidth/2);
                    int dy=y-(this.ho.hoY+this.ho.hoImgHeight/2);
                    int distance=(int)(Math.sqrt(dx*dx+dy*dy));
                    if (distance<this.radius)
                    {
                        float angle = (float)(Math.atan2(-dy, dx) * 180.0 / Math.PI);
                        if (angle<0)
                            angle=360.0f+angle;
                        int a=(int)(angle/11.25);
                        int mask=1<<a;
                        if ((this.angle&mask)!=0)
                        {
                            this.base.rBodyApplyImpulse(pMovement.m_body, this.strength, angle+180.0f);
                        }
                    }
                }
            }
        }
        return 0;
    }

    // Conditions
    // --------------------------------------------------
    @Override
	public boolean condition(int num, CCndExtension cnd)
    {
        if (num == CRunBox2DMagnet.CND_ISACTIVE)
        {
            return (this.flags&CRunBox2DMagnet.MAGNETFLAG_ON)!=0;
        }
        return false;
    }

    // Actions
    // -------------------------------------------------
    @Override
	public void action(int num, CActExtension act)
    {
        switch (num)
        {
            case CRunBox2DMagnet.ACT_SETSTRENGTH:
                this.strengthBase=act.getParamExpression(this.rh, 0);
                this.strength=this.strengthBase/100.0f*STRENGTHMULT;
                break;
            case CRunBox2DMagnet.ACT_SETANGLE:
                this.angle=act.getParamNewDirection(this.rh, 0);
                break;
            case CRunBox2DMagnet.ACT_SETWIDTH:
                int width = act.getParamExpression(this.rh, 0);
                if (width>0)
                    this.ho.hoImgWidth=width;
                break;
            case CRunBox2DMagnet.ACT_SETHEIGHT:
                int  height = act.getParamExpression(this.rh, 0);
                if (height>0)
                    this.ho.hoImgHeight=height;
                break;
            case CRunBox2DMagnet.ACT_ONOFF:
                int on = act.getParamExpression(this.rh, 0);
                if (on!=0)
                    this.flags|=CRunBox2DMagnet.MAGNETFLAG_ON;
                else
                    this.flags&=~CRunBox2DMagnet.MAGNETFLAG_ON;
                break;
        }
    }


    // Expressions
    // --------------------------------------------
    @Override
	public CValue expression(int num)
    {
        CValue ret = new CValue(0);
        switch (num)
        {
            case CRunBox2DMagnet.EXP_STRENGTH:
                ret.forceInt(this.strengthBase);
                break;
            case CRunBox2DMagnet.EXP_WIDTH:
                ret.forceInt(this.ho.hoImgWidth);
                break;
            case CRunBox2DMagnet.EXP_HEIGHT:
                ret.forceInt(this.ho.hoImgHeight);
                break;
        }
        return ret;
    }
}

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
// CRUNBOX2DJOINT : easy revolute joint creation
//
//----------------------------------------------------------------------------------
package Extensions;

import java.util.ArrayList;
import java.util.Collections;

import Actions.CActExtension;
import Expressions.CValue;
import OI.COI;
import Objects.CExtension;
import Objects.CObject;
import RunLoop.CCreateObjectInfo;
import RunLoop.CRun;
import RunLoop.CRunMBase;
import Services.CBinaryFile;
import Sprites.CSpriteGen;

import com.badlogic.gdx.math.Vector2;
import com.badlogic.gdx.physics.box2d.Body;
import com.badlogic.gdx.physics.box2d.BodyDef;
import com.badlogic.gdx.physics.box2d.joints.RevoluteJoint;
import com.badlogic.gdx.physics.box2d.joints.RevoluteJointDef;

public class CRunBox2DJoint extends CRunBox2DBaseParent
{
    private int flags = 0;
    private int number = 0;
    private int angle1 = 0;
    private int angle2 = 0;
    private int speed = 0;
    private int torque = 0;
    private CRunBox2DBase base = null;
    private Body bodyStatic = null;
    private ArrayList<CJointO> joints = new ArrayList<CJointO>();
    private static final int PINFLAG_LINK = 0x0001;
    private static final int ACT_SETLIMITS = 0;
    private static final int ACT_SETMOTOR = 1;
    private static final int ACT_DESTROY = 2;
    private static final int EXP_ANGLE1=0;
    private static final int EXP_ANGLE2=1;
    private static final int EXP_TORQUE=2;
    private static final int EXP_SPEED=3;

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
            if (pObject != null)
            {
            	--nObjects;
                if (pObject.hoType>=32 && pObject.hoCommon.ocIdentifier == CRun.BASEIDENTIFIER)
                {
                    CRunBox2DBase pBase = (CRunBox2DBase)((CExtension)pObject).ext;
                    if (pBase.identifier == this.identifier)
                    {
                        return pBase;
                    }
                }
            }
            if(nObjects == 0)
            	break;
        }
        return null;
    }

    @Override
	public int getNumberOfConditions()
    {
        return 0;
    }

    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        this.ho.hoX = cob.cobX;
        this.ho.hoY = cob.cobY;
        if ((cob.cobFlags & CRun.COF_CREATEDATSTART) != 0)
        {
            this.ho.hoX += 16;
            this.ho.hoY += 16;
        }
        this.flags = file.readInt();
        this.number = file.readShort();
        this.angle1 = file.readInt();
        this.angle2 = file.readInt();
        this.torque = file.readInt();
        this.speed = file.readInt();
        this.identifier = file.readInt();
        return false;
    }

    @Override
	public void destroyRunObject(boolean bFast)
    {
        if (bodyStatic != null)
        {
            CRunBox2DBase pBase = GetBase();
            if (pBase != null)
                pBase.rDestroyBody(bodyStatic);
        }
        
	    // Build 286.5: destroy the joints for the objects that still exist...
		this.VerifyJoints();
		for (int n = 0; n < this.joints.size() ; n++) {
		    CJointO pJointO = this.joints.get(n);
		    this.base.rDestroyJoint(pJointO.m_joint);
		}
    }

	private void ListSort(ArrayList<CRunMBase> array)
	{
		boolean sorted;
		
		if(array == null)
			return;
		do
		{
			sorted = true; // Everything sorted
			for (int i=0; i < array.size()-1; i++) {
				if (array.get(i+1).m_pHo.ros.rsZOrder < array.get(i).m_pHo.ros.rsZOrder) 
				{
					Collections.swap(array,i,i+1);
					sorted = false; // Not everything sorted yet 
				}
			}
		} while (!sorted); //repeat do...while until there`s nothing left to be sorted
	}
	
	private boolean isObjectUnder(CObject pHox, int x, int y, int w, int h)
	{
		int x1, y1, x2, y2;
		CRun rhPtr=this.rh;

		x1=pHox.hoX-pHox.hoImgXSpot;
		y1=pHox.hoY-pHox.hoImgYSpot;
		x2=x1+pHox.hoImgWidth;
		y2=y1+pHox.hoImgHeight;
		//
		// Referenced for sub-apps and screen
		//
		x -= rhPtr.rhApp.absoluteX;
		y -= rhPtr.rhApp.absoluteY;

		int mx = x + rhPtr.rhWindowX;
		int my = y + rhPtr.rhWindowY;

		
		if ((pHox.hoFlags & CObject.HOF_DESTROYED) == 0)
		{
			if (pHox.hoType==COI.OBJ_SPR)
			{
				return (rhPtr.spriteGen.spriteCol_TestRectOne(pHox.roc.rcSprite, CSpriteGen.LAYER_ALL, x, y, w, h, 0) != null);
			}
			else
			{
				return (mx >= x1 && mx < x2 && my >= y1 && my < y2);
			}
		}
		return false;
	}
	
	private void GetTopMostObjects(ArrayList<CRunMBase>list, int x, int y, int w, int h)
	{
		int nObjects=rh.rhNObjects;
		CObject[] localObjectList =rh.rhObjectList;
		for (CObject pHox : localObjectList)
		{
			if (pHox != null) {
				--nObjects;
				if (this.isObjectUnder(pHox, x, y, w, h))
				{
					CRunMBase pMBase = base.GetMBase(pHox);
					if (pMBase != null && pMBase.m_identifier == this.identifier)
					{
						list.add(pMBase);
					}
				}
				if(nObjects < 0)
					break;
			}
		}
		
        ListSort(list);
    }

    @Override
	public int handleRunObject()
    {
        if (!this.rStartObject() || this.base.isPaused())
            return 0;

        ArrayList<CRunMBase> list = new ArrayList<CRunMBase>();
        int x = this.ho.hoX;
        int y = this.ho.hoY;
        this.GetTopMostObjects(list, this.ho.hoX, this.ho.hoY, 32, 32);
        if (list.size() > 0)
        {
            if ((this.flags & CRunBox2DJoint.PINFLAG_LINK) != 0 || list.size() == 1)
            {
                this.bodyStatic = this.base.rCreateBody(BodyDef.BodyType.StaticBody, x, y, 0, 0, null, 0, 0);
                this.base.rBodyCreateBoxFixture(this.bodyStatic, null, x, y, 16, 16, 0, 0, 0);
            }
            RevoluteJointDef jointDef = new RevoluteJointDef();
            jointDef.collideConnected=true;
            Vector2 position = new Vector2(x, y);
            this.base.rFrameToWorld(position);
            RevoluteJoint joint;
            if (list.size() == 1)
            {
                CRunMBase pMBase = list.get(0);
                if(pMBase != null) {
	                joint = this.base.rWorldCreateRevoluteJoint(jointDef, this.bodyStatic, pMBase.m_body, position);
		            if(joint != null) {
		                this.base.rRJointSetLimits(joint, this.angle1, this.angle2);
		                this.base.rRJointSetMotor(joint, this.torque, this.speed);
		                this.joints.add(new CJointO(null, pMBase, joint));
	                }
                }
            }
            if (list.size() >= 2)
            {
                int numbers = 1;
                if (this.number == 1)
                    numbers = 10000;
                int n;
                CRunMBase pMBase1 = null;
                CRunMBase pMBase2 = null;
                for (n = 0; n < numbers; n++)
                {
                    int index = list.size() - 1 - n;
                    pMBase1 = list.get(index);
                    pMBase2 = list.get(index - 1);
                    if(pMBase1 != null && pMBase2 != null) {
	                    joint = this.base.rWorldCreateRevoluteJoint(jointDef, pMBase1.m_body, pMBase2.m_body, position);
	                    if(joint != null) {
		                    this.base.rRJointSetLimits(joint, this.angle1, this.angle2);
		                    this.base.rRJointSetMotor(joint, this.torque, this.speed);
		                    this.joints.add(new CJointO(pMBase1, pMBase2, joint));
	                    }
                    }
                    if (index == 1)
                        break;
                }
                if ((this.flags & CRunBox2DJoint.PINFLAG_LINK) != 0)
                {
                    joint = this.base.rWorldCreateRevoluteJoint(jointDef, this.bodyStatic, pMBase2.m_body, position);
                    this.joints.add(new CJointO(null, pMBase2, joint));
                }
            }
        }
        return CRunExtension.REFLAG_ONESHOT;
    }

    public CObject GetHO(int fixedValue)
    {
        CObject hoPtr=this.rh.rhObjectList[fixedValue&0xFFFF];
        if (hoPtr!=null && hoPtr.hoCreationId==fixedValue>>16)
            return hoPtr;
        return null;
    }

    private void VerifyJoints()
    {
        int n;
        int joints_size = this.joints.size();
        for (n = 0; n < joints_size; n++)
        {
            CJointO pJointO = this.joints.get(n);
            if(pJointO == null)
            	continue;
            
            CObject pHo;
            boolean bFlag = true;
            if (pJointO.m_fv1 != -1)
            {
                pHo = this.GetHO(pJointO.m_fv1);
                if (pHo == null)
                    bFlag = false;
            }
            if (pJointO.m_fv2 != -1)
            {
                pHo = this.GetHO(pJointO.m_fv2);
                if (pHo == null)
                    bFlag = false;
            }
            if (!bFlag)
            {
                this.joints.remove(n);
                joints_size = this.joints.size();
                n--;
            }
        }
    }

    @Override
	public void action(int num, CActExtension act)
    {
        int n;
        int joints_size = this.joints.size();
        switch (num)
        {
            case CRunBox2DJoint.ACT_SETLIMITS:
                this.angle1 = act.getParamExpression(this.rh, 0);
                this.angle2 = act.getParamExpression(this.rh, 1);
                this.VerifyJoints();
                for (n = 0; n < joints_size; n++)
                {
                    CJointO pJointO = this.joints.get(n);
                    this.base.rRJointSetLimits(pJointO.m_joint, this.angle1, this.angle2);
                }
                break;
            case CRunBox2DJoint.ACT_SETMOTOR:
                this.torque = act.getParamExpression(this.rh, 0);
                this.speed = act.getParamExpression(this.rh, 1);
                this.VerifyJoints();
                for (n = 0; n < joints_size; n++)
                {
                    CJointO pJointO = this.joints.get(n);
                    this.base.rRJointSetMotor(pJointO.m_joint, this.torque, this.speed);
                }
                break;
            case CRunBox2DJoint.ACT_DESTROY:
                this.VerifyJoints();
                for (n = 0; n < this.joints.size(); n++)
                {
                    CJointO pJointO = this.joints.get(n);
                    this.base.rDestroyJoint(pJointO.m_joint);
                    this.joints.remove(n);
                    n--;
                }
                break;
        }
    }
    @Override
	public CValue expression(int num)
    {
        switch (num)
        {
            case EXP_ANGLE1:
                return new CValue(this.angle1);
            case EXP_ANGLE2:
                return new CValue(this.angle2);
            case EXP_TORQUE:
                return new CValue(this.torque);
            case EXP_SPEED:
                return new CValue(this.speed);
        }
        return null;
    }
}

class CJointO
{
    public int m_fv1;
    public int m_fv2;
    public RevoluteJoint m_joint;

    public CJointO(CRunMBase pBase1, CRunMBase pBase2, RevoluteJoint joint)
    {
        CObject pHo;
        this.m_fv1 = -1;
        if (pBase1 != null)
        {
            pHo = pBase1.m_pHo;
            this.m_fv1 = (pHo.hoCreationId<<16)|(pHo.hoNumber&0xFFFF);
        }
        this.m_fv2 = -1;
        if (pBase2 != null)
        {
            pHo = pBase2.m_pHo;
            this.m_fv2 = (pHo.hoCreationId<<16)|(pHo.hoNumber&0xFFFF);
        }
        this.m_joint = joint;
    }
}
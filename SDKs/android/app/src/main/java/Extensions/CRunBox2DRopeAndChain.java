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
// CRUNBOX2DROPEANDCHAIN
//
//----------------------------------------------------------------------------------
package Extensions;

import java.util.ArrayList;

import Actions.CActExtension;
import Banks.CImage;
import Conditions.CCndExtension;
import Events.CQualToOiList;
import Expressions.CValue;
import Objects.CExtension;
import Objects.CObject;
import Params.PARAM_OBJECT;
import RunLoop.CCreateObjectInfo;
import RunLoop.CRun;
import RunLoop.CRunMBase;
import Services.CBinaryFile;
import Sprites.CRSpr;
import Sprites.CSprite;

import com.badlogic.gdx.math.Vector2;
import com.badlogic.gdx.physics.box2d.Body;
import com.badlogic.gdx.physics.box2d.BodyDef;
import com.badlogic.gdx.physics.box2d.Joint;
import com.badlogic.gdx.physics.box2d.joints.RevoluteJointDef;

public class CRunBox2DRopeAndChain extends CRunBox2DBaseParent
{
	private static final int MAX_IMAGES = 8;
	private static final int RCFLAG_ATTACHED = 0x0001;

	private static final int CND_ONEACH = 0;
	private static final int CND_ELEMENTCOLLISION = 1;
	private static final int CND_ELEMENTOUTLEFT = 2;
	private static final int CND_ELEMENTOUTRIGHT = 3;
	private static final int CND_ELEMENTOUTTOP = 4;
	private static final int CND_ELEMENTOUTBOTTOM = 5;
	private static final int CND_ELEMENTCOLLISIONBACKDROP = 7;
	private static final int CND_LAST = 8;

	private static final int ACT_FOREACH = 0;
	private static final int ACT_STOP = 1;
	private static final int ACT_CLIMBUP = 2;
	private static final int ACT_CLIMBDOWN = 3;
	private static final int ACT_ATTACH = 4;
	private static final int ACT_RELEASE = 5;
	private static final int ACT_STOPLOOP = 6;
	private static final int ACT_CUT = 7;
	private static final int ACT_ATTACHNUMBER = 8;

	private static final int EXP_LOOPINDEX = 0;
	private static final int EXP_GETX1 = 1;
	private static final int EXP_GETY1 = 2;
	private static final int EXP_GETX2 = 3;
	private static final int EXP_GETY2 = 4;
	private static final int EXP_GETXMIDDLE = 5;
	private static final int EXP_GETYMIDDLE = 6;
	private static final int EXP_GETANGLE = 7;
	private static final int EXP_GETELEMENT = 8;

	public CRunBox2DBase base = null;
	private int flags;
	private int number;
	private float angle;
	private float friction;
	private float restitution;
	private float density;
	private float gravity;
	private int nImages;
	private short imageStart[];
	private short images[];
	private short imageEnd[];
	private Body bodyStart;
	private Body bodyEnd;
	private boolean stopLoop;
	private int loopIndex;
	private ArrayList<CElement> elements;
	private ArrayList<CJointRC> joints;
	private ArrayList<Joint> ropeJoints;
	private String loopName;
	private int oldX;
	private int oldY;
	private int lastElement;
	private int effect;
	private int effectParam;
	private boolean visible;
	public CRunBox2DBasePosAndAngle posAndAngle = null;

	public CRunBox2DRopeAndChain()
	{
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

    @Override
	public void rRemoveObject(CRunMBase movement)
    {
		int n;
		int joints_size = this.joints.size();
		for (n = 0; n < joints_size ; n++)
		{
			CJointRC cjoint = this.joints.get(n);
			if (cjoint != null && cjoint.object == movement && cjoint.joint != null)
			{
				this.base.world.destroyJoint(cjoint.joint);
				cjoint.counter = 200;
				break;
			}
		}
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
		this.ho.hoImgWidth = file.readInt();
		this.ho.hoImgHeight = file.readInt();
		this.flags = file.readInt();
		this.angle = (float)(file.readInt() * 11.25);
		this.number = file.readInt();
		this.friction = file.readInt() / 100.0f;
		this.restitution = file.readInt() / 100.0f;
		this.density = file.readInt() / 100.0f;
		this.gravity = file.readInt() / 100.0f;
		this.identifier = file.readInt();
		this.nImages = file.readShort();
		this.imageStart = new short[1];
		this.imageStart[0] = file.readShort();
		this.ho.loadImageList(this.imageStart);
		this.images = new short[this.nImages];
		int n;
		for (n = 0; n < this.nImages; n++)
			this.images[n] = file.readShort();
		file.skipBytes((MAX_IMAGES - n) * 2);
		this.ho.loadImageList(this.images);
		this.imageEnd = new short[1];
		this.imageEnd[0] = file.readShort();
		this.ho.loadImageList(this.imageEnd);
		this.effect = this.ho.ros.rsEffect;
		this.effectParam = this.ho.ros.rsEffectParam;
		this.visible = (this.ho.ros.rsFlags & CRSpr.RSFLAG_VISIBLE)!=0;

		this.elements = new ArrayList<CElement>();
		this.joints = new ArrayList<CJointRC>();
		this.ropeJoints = new ArrayList<Joint>();
		this.oldX = this.ho.hoX;
		this.oldY = this.ho.hoY;

		posAndAngle = new CRunBox2DBasePosAndAngle();

		return false;
	}

	@Override
	public void destroyRunObject(boolean bFast)
	{
		CRunBox2DBase base = GetBase();
		int n;
		synchronized(base)
		{
			int elements_size = elements.size();
			for (n = 0; n < elements_size; n++)
			{
				CElement element = elements.get(n);
				if(element != null)
					element.destroy(base);
			}
			if (base != null)
			{
				if (bodyStart != null)
					base.rDestroyBody(bodyStart);
				if (bodyEnd != null)
					base.rDestroyBody(bodyEnd);
			}
		}
	}

	@Override
	public int handleRunObject()
	{
		if(!this.rStartObject())
			return 0;
		
		if (this.base.isPaused())
		{
			if (this.elements.size() == 0)
				return 0;
			
			CElement element;
			int elements_size = this.elements.size() ;
			if (this.ho.hoX != this.oldX || this.ho.hoY != this.oldY)
			{
				float deltaX = (this.ho.hoX - this.oldX) / this.base.factor;
				float deltaY = -((this.ho.hoY - this.oldY) / this.base.factor);
				this.oldX = this.ho.hoX;
				this.oldY = this.ho.hoY;

				Vector2 pos = this.bodyStart.getPosition();
				float angle = this.bodyStart.getAngle();
				pos.x += deltaX;
				pos.y += deltaY;
				this.bodyStart.setTransform(pos, angle);

				int n;
				for (n = 0; n < elements_size ; n++)
				{
					element = this.elements.get(n);
					if(element == null)
						continue;
					pos = element.m_body.getPosition();
					angle = element.m_body.getAngle();
					pos.x += deltaX;
					pos.y += deltaY;
					element.m_body.setTransform(pos, angle);
				}

				if (this.bodyEnd!=null)
				{
					pos = this.bodyEnd.getPosition();
					angle = this.bodyEnd.getAngle();
					pos.x += deltaX;
					pos.y += deltaY;
					this.bodyEnd.setTransform(pos, angle);
				}
			}

			int n;

			for (n = 0; n < elements_size; n++)
			{
				element = this.elements.get(n);
				if(element != null)
					element.setPosition();
			}

			if (elements_size >= 2 && this.bodyEnd == null)
			{
				Vector2 position = this.elements.get(this.elements.size() - 1).m_body.getPosition();
				float angle = this.elements.get(this.elements.size() - 2).m_body.getAngle();
				this.elements.get(this.elements.size() - 1).m_body.setTransform(position, angle);
			}

			
			int joints_size = this.joints.size();
			for (n = 0; n < joints_size ; n++)
			{
				CJointRC cjoint = this.joints.get(n);
				if (cjoint != null && cjoint.counter > 0)
				{
					cjoint.counter--;
					if (cjoint.counter == 0)
					{
						this.joints.remove(n);
						joints_size = this.joints.size();
						n--;
					}
				}
			}

			if (this.ho.ros.rsEffect != this.effect || this.ho.ros.rsEffectParam != this.effectParam)
			{
				this.effect = this.ho.ros.rsEffect;
				this.effectParam = this.ho.ros.rsEffectParam;
				for (n = 0; n < elements_size ; n++)
				{
					this.elements.get(n).setEffect(this.effect, this.effectParam);
				}
			}
			boolean v = (this.ho.ros.rsFlags & CRSpr.RSFLAG_VISIBLE)!=0;
			if (v != this.visible)
			{
				this.visible = v;
				for (n = 0; n < elements_size ; n++)
				{
					this.elements.get(n).show(visible);
				}
			}
		}
		else
		{
			CElement element;
			if (this.elements.size() == 0)
			{
				int x , y;
				x = this.oldX;
				y = this.oldY;

				this.bodyStart = this.base.rCreateBody(BodyDef.BodyType.StaticBody, x, y, 0, 0, null, 0, 0);
				this.base.rBodyCreateBoxFixture(this.bodyStart, null, x, y, 16, 16, 0, 0, 0);
				Body previousBody = this.bodyStart;

				float angle = - (float)(this.angle * Math.PI / 180.0);

				element = new CElement(this, this.imageStart[0], 0, x, y, visible);
				element.setEffect(this.effect, this.effectParam);
				
				CImage image = this.rh.rhApp.imageBank.getImageFromHandle(this.imageStart[0]);
				
				element.m_body = this.base.rCreateBody(BodyDef.BodyType.DynamicBody, x, y, this.angle, this.gravity, element, 0, 0);
				this.base.rBodyCreateBoxFixture(element.m_body, element, x, y, image.getWidth(), image.getHeight(),this.density, this.friction, this.restitution);

				RevoluteJointDef JointDef = new RevoluteJointDef();
				JointDef.collideConnected = false;
				JointDef.enableMotor = false;
				JointDef.enableLimit = false;

				JointDef.initialize(element.m_body, previousBody, element.m_body.getPosition());
				Joint joint = this.base.world.createJoint(JointDef);
				this.ropeJoints.add(joint);
				previousBody = element.m_body;

				int deltaX = 0;
				int deltaY = 0;
				int plusX = 0;
				int plusY = 0;

				if(image != null) {
					deltaX = image.getXAP() - image.getXSpot();
					deltaY = image.getYAP() - image.getYSpot();
					plusX = (int)(deltaX * Math.cos(angle) - deltaY * Math.sin(angle));
					plusY = (int)(deltaX * Math.sin(angle) + deltaY * Math.cos(angle));
					x += plusX;
					y += plusY;
				}

				this.elements.add(element);

				int n;
				int nImage = 0;
				for (n=1; n<this.number - 1; n++)
				{
					element = new CElement(this, this.images[nImage], n, x, y, visible);
					element.setEffect(this.effect, this.effectParam);
					
					image = this.rh.rhApp.imageBank.getImageFromHandle(this.images[nImage]);
					
					if(image == null)
						continue;
					
					element.m_body = this.base.rCreateBody(BodyDef.BodyType.DynamicBody, x, y, this.angle, this.gravity, element, 0, 0);
					this.base.rBodyCreateBoxFixture(element.m_body, element, x, y, image.getWidth(), image.getHeight(), this.density, this.friction, this.restitution);

					JointDef.initialize(element.m_body, previousBody, element.m_body.getPosition());
					joint = this.base.world.createJoint(JointDef);
					this.ropeJoints.add(joint);
					previousBody = element.m_body;

					deltaX = image.getXAP() - image.getXSpot();
					deltaY = image.getYAP() - image.getYSpot();
					plusX = (int)(deltaX * Math.cos(angle) - deltaY * Math.sin(angle));
					plusY = (int)(deltaX * Math.sin(angle) + deltaY * Math.cos(angle));
					x += plusX;
					y += plusY;
					
					nImage++;
					if (nImage >= this.nImages)
						nImage = 0;
					this.elements.add(element);
				}
				
				element = new CElement(this, this.imageEnd[0], n, x, y, visible);
				
				image = this.rh.rhApp.imageBank.getImageFromHandle(this.imageEnd[0]);
				if(image != null) {
					element.m_body = this.base.rCreateBody(BodyDef.BodyType.DynamicBody, x, y, this.angle, this.gravity, element, 0, 0);
					this.base.rBodyCreateBoxFixture(element.m_body, element, x, y, image.getWidth(), image.getHeight(), this.density, this.friction, this.restitution);
				}
				JointDef.initialize(element.m_body, previousBody, element.m_body.getPosition());
				joint = this.base.world.createJoint(JointDef);
				this.ropeJoints.add(joint);
				this.elements.add(element);
				previousBody = element.m_body;

				if ((this.flags & CRunBox2DRopeAndChain.RCFLAG_ATTACHED)!=0)
				{
					deltaX = image.getXAP() - image.getXSpot();
					deltaY = image.getYAP() - image.getYSpot();
					plusX = (int)(deltaX * Math.cos(angle) - deltaY * Math.sin(angle));
					plusY = (int)(deltaX * Math.sin(angle) + deltaY * Math.cos(angle));
					x += plusX;
					y += plusY;

					this.bodyEnd = this.base.rCreateBody(BodyDef.BodyType.StaticBody, x, y, 0, 0, null, 0, 0);
					this.base.rBodyCreateBoxFixture(this.bodyEnd, null, x, y, 16, 16, 0, 0, 0);
					JointDef.initialize(this.bodyEnd, previousBody, this.bodyEnd.getPosition());
					joint = this.base.world.createJoint(JointDef);
					this.ropeJoints.add(joint);
				}
			}

			int elements_size = this.elements.size() ;
			if (this.ho.hoX != this.oldX || this.ho.hoY != this.oldY)
			{
				float deltaX = (this.ho.hoX - this.oldX) / this.base.factor;
				float deltaY = -((this.ho.hoY - this.oldY) / this.base.factor);
				this.oldX = this.ho.hoX;
				this.oldY = this.ho.hoY;

				Vector2 pos = this.bodyStart.getPosition();
				float angle = this.bodyStart.getAngle();
				pos.x += deltaX;
				pos.y += deltaY;
				this.bodyStart.setTransform(pos, angle);

				int n;
				for (n = 0; n < elements_size ; n++)
				{
					element = this.elements.get(n);
					if(element == null)
						continue;
					pos = element.m_body.getPosition();
					angle = element.m_body.getAngle();
					pos.x += deltaX;
					pos.y += deltaY;
					element.m_body.setTransform(pos, angle);
				}

				if (this.bodyEnd!=null)
				{
					pos = this.bodyEnd.getPosition();
					angle = this.bodyEnd.getAngle();
					pos.x += deltaX;
					pos.y += deltaY;
					this.bodyEnd.setTransform(pos, angle);
				}
			}

			int n;

			for (n = 0; n < elements_size; n++)
			{
				element = this.elements.get(n);
				if(element != null)
					element.setPosition();
			}

			if (elements_size >= 2 && this.bodyEnd == null)
			{
				Vector2 position = this.elements.get(this.elements.size() - 1).m_body.getPosition();
				float angle = this.elements.get(this.elements.size() - 2).m_body.getAngle();
				this.elements.get(this.elements.size() - 1).m_body.setTransform(position, angle);
			}

			int joints_size = this.joints.size();
			for (n = 0; n < joints_size ; n++)
			{
				CJointRC cjoint = this.joints.get(n);
				if (cjoint != null && cjoint.counter > 0)
				{
					cjoint.counter--;
					if (cjoint.counter == 0)
					{
						this.joints.remove(n);
						joints_size = this.joints.size();
						n--;
					}
				}
			}

			if (this.ho.ros.rsEffect != this.effect || this.ho.ros.rsEffectParam != this.effectParam)
			{
				this.effect = this.ho.ros.rsEffect;
				this.effectParam = this.ho.ros.rsEffectParam;
				for (n = 0; n < elements_size ; n++)
				{
					this.elements.get(n).setEffect(this.effect, this.effectParam);
				}
			}
			boolean v = (this.ho.ros.rsFlags & CRSpr.RSFLAG_VISIBLE)!=0;
			if (v != this.visible)
			{
				this.visible = v;
				for (n = 0; n < elements_size ; n++)
				{
					this.elements.get(n).show(visible);
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
		switch (num)
		{
		case CRunBox2DRopeAndChain.CND_ELEMENTCOLLISION:
			PARAM_OBJECT param = cnd.getParamObject(this.rh, 0);
			if(param == null)
				break;
			if (this.collidingHO == null)
				break;
			if (param.oi == this.rh.rhEvtProg.rhCurParam0)
			{
				this.rh.rhEvtProg.evt_AddCurrentObject(this.collidingHO);
				return true;
			}
			else
			{
				short oil = param.oiList;
				if ((oil & 0x8000) != 0)
				{
					CQualToOiList pq = this.rh.rhEvtProg.qualToOiList[oil & 0x7FFF];
					int numOi = 0;
					int pq_length = pq.qoiList.length;
					while (numOi < pq_length)
					{
						if (pq.qoiList[numOi] == this.rh.rhEvtProg.rhCurParam0)
						{
							this.rh.rhEvtProg.evt_AddCurrentObject(this.collidingHO);
							return true;
						}
						numOi += 2;
					}
				}
			}
			break;
		case CRunBox2DRopeAndChain.CND_ONEACH:
			String name = cnd.getParamExpString(this.rh, 0);
			return name.equalsIgnoreCase(this.loopName);
		case CRunBox2DRopeAndChain.CND_ELEMENTOUTLEFT:
		case CRunBox2DRopeAndChain.CND_ELEMENTOUTRIGHT:
		case CRunBox2DRopeAndChain.CND_ELEMENTOUTTOP:
		case CRunBox2DRopeAndChain.CND_ELEMENTOUTBOTTOM:
		case CRunBox2DRopeAndChain.CND_ELEMENTCOLLISIONBACKDROP:
			return true;
		}
		return false;
	}

	// Actions
	// -------------------------------------------------
	@Override
	public void action(int num, CActExtension act)
	{
		int n;
		CObject pHo;
		CRunMBase object;
		switch (num)
		{
		case CRunBox2DRopeAndChain.ACT_FOREACH:
			this.loopName = act.getParamExpString(this.rh, 0);
			this.stopLoop = false;
			int elements_size = this.elements.size();
			for (n = 0; n < elements_size ; n++)
			{
				if (this.stopLoop)
					break;
				CElement element = this.elements.get(n);
				if(element != null) {
					this.currentElement = element;
					this.loopIndex = n;
					this.ho.generateEvent(CRunBox2DRopeAndChain.CND_ONEACH, 0);
				}
			}
			break;
		case CRunBox2DRopeAndChain.ACT_STOP:
			this.stopped = true;
			break;
		case CRunBox2DRopeAndChain.ACT_CLIMBUP:
			pHo = act.getParamObject(this.rh, 0);
			object = this.base.GetMBase(pHo);
			if (object!=null && this.joints != null)
			{
				int joints_size = this.joints.size();
				for (n = 0; n < joints_size ; n++)
				{
					CJointRC cjoint = this.joints.get(n);
					if (cjoint != null && cjoint.object == object)
					{
						n = cjoint.element.number;
						if (n > 0)
						{
							this.base.world.destroyJoint(cjoint.joint);

							Vector2 pos1 = cjoint.element.m_body.getPosition();
							CElement nextElement = this.elements.get(n - 1);
							Vector2 pos2 = nextElement.m_body.getPosition();
							float angle = cjoint.object.m_body.getAngle();
							Vector2 pos3 = cjoint.object.m_body.getPosition();
							pos3.x += pos2.x - pos1.x;
							pos3.y += pos2.y - pos1.y;
							cjoint.object.m_body.setTransform(pos3, angle);

							RevoluteJointDef JointDef = new RevoluteJointDef();
							JointDef.collideConnected = false;
							JointDef.enableMotor = true;
							JointDef.maxMotorTorque = 100000;
							JointDef.motorSpeed = 0;
							JointDef.initialize(cjoint.object.m_body, nextElement.m_body, nextElement.m_body.getPosition());
							Joint joint = this.base.world.createJoint(JointDef);

							cjoint.element = nextElement;
							cjoint.joint = joint;
						}
						break;
					}
				}
			}
			break;
		case CRunBox2DRopeAndChain.ACT_CLIMBDOWN:
			pHo = act.getParamObject(this.rh, 0);
			object = this.base.GetMBase(pHo);
			if (object != null && this.joints != null)
			{
				int joints_size = this.joints.size();
				for (n = 0; n < joints_size ; n++)
				{
					CJointRC cjoint = this.joints.get(n);
					if (cjoint != null && cjoint.object == object)
					{
						n = cjoint.element.number;
						if (n < this.elements.size() - 1)
						{
							this.base.world.destroyJoint(cjoint.joint);

							Vector2 pos1 = cjoint.element.m_body.getPosition();
							CElement nextElement = this.elements.get(n + 1);
							Vector2 pos2 = nextElement.m_body.getPosition();
							float angle = cjoint.object.m_body.getAngle();
							Vector2 pos3 = cjoint.object.m_body.getPosition();
							pos3.x += pos2.x - pos1.x;
							pos3.y += pos2.y - pos1.y;
							cjoint.object.m_body.setTransform(pos3, angle);

							RevoluteJointDef JointDef = new RevoluteJointDef();
							JointDef.collideConnected = false;
							JointDef.enableMotor = true;
							JointDef.maxMotorTorque = 100000;
							JointDef.motorSpeed = 0;
							JointDef.initialize(cjoint.object.m_body, nextElement.m_body, nextElement.m_body.getPosition());
							Joint joint = this.base.world.createJoint(JointDef);

							cjoint.element = nextElement;
							cjoint.joint = joint;
						}
						break;
					}
				}
			}
			break;
		case CRunBox2DRopeAndChain.ACT_ATTACH:
			if (this.currentElement == null)
				break;
			pHo = act.getParamObject(this.rh, 0);
			object = this.base.GetMBase(pHo);
			if (object != null && this.joints != null)
			{
				int joints_size = this.joints.size();
				for (n = 0; n < joints_size ; n++)
				{
					CJointRC cjoint = this.joints.get(n);
					if(cjoint == null)
						continue;

					if (cjoint.object == object)
						break;
				}
				if (n == joints_size)
				{
					float angle = object.m_body.getAngle();
					Vector2 posObject = object.m_body.getPosition();
					int distance = act.getParamExpression(this.rh, 1);
					Vector2 position = this.currentElement.m_body.getPosition();
					if (posObject.x > position.x)
						posObject.x = position.x + distance / this.base.factor;
					else
						posObject.x = position.x - distance / this.base.factor;
					object.m_body.setTransform(posObject, angle);
					RevoluteJointDef JointDef = new RevoluteJointDef();
					JointDef.collideConnected = false;
					JointDef.enableMotor = true;
					JointDef.maxMotorTorque = 100000;
					JointDef.motorSpeed = 0;
					JointDef.initialize(object.m_body, this.currentElement.m_body, position);
					Joint joint = this.base.world.createJoint(JointDef);
					this.joints.add(new CJointRC(object, (CElement)this.currentElement, joint));
				}
			}
			break;
		case CRunBox2DRopeAndChain.ACT_CUT:
		{
			int number = act.getParamExpression(this.rh, 0);
			if (this.ropeJoints != null && number >= 0 && number < this.ropeJoints.size())
			{
				Joint joint = this.ropeJoints.get(number);
				this.base.world.destroyJoint(joint);
				this.ropeJoints.remove(number);
			}
			this.stopLoop = true;
			break;
		}
		case CRunBox2DRopeAndChain.ACT_ATTACHNUMBER:
			pHo = act.getParamObject(this.rh, 0);
			object = this.base.GetMBase(pHo);
			if (object != null && this.joints != null)
			{
				int joints_size = this.joints.size();
				for (n = 0; n < joints_size ; n++)
				{
					CJointRC cjoint = this.joints.get(n);
					if (cjoint.object == object)
						break;
				}
				if (n == joints_size)
				{
					//float angle = object.m_body.getAngle();
					//Vector2 posObject = object.m_body.getPosition();
					int number = act.getParamExpression(this.rh, 1);
					if (number >= 0 && number < this.elements.size())
					{
						CElement element = this.elements.get(number);
						//int distance = act.getParamExpression(this.rh, 2);
						Vector2 position = element.m_body.getPosition();
						this.base.rGetBodyPosition(element.m_body, this.posAndAngle);
						CImage image = this.rh.rhApp.imageBank.getImageFromHandle(pHo.roc.rcImage);
						if(image != null) {
							this.posAndAngle.x -= (image.getXAP() - image.getXSpot());
							this.posAndAngle.y -= (image.getYAP() - image.getYSpot());
						}
						this.base.rBodySetPosition(object.m_body, this.posAndAngle.x, this.posAndAngle.y);
						RevoluteJointDef JointDef = new RevoluteJointDef();
						JointDef.collideConnected = false;
						JointDef.enableMotor = true;
						JointDef.maxMotorTorque = 100000;
						JointDef.motorSpeed = 0;
						JointDef.initialize(object.m_body, element.m_body, position);
						Joint joint = this.base.world.createJoint(JointDef);
						this.joints.add(new CJointRC(object, element, joint));
					}
				}
			}
			break;
		case CRunBox2DRopeAndChain.ACT_RELEASE:
			pHo = act.getParamObject(this.rh, 0);
			if(pHo != null) {
				object = this.base.GetMBase(pHo);
				if (object != null && this.joints != null)
				{
					int joints_size = this.joints.size();
					for (n = 0; n < joints_size ; n++)
					{
						CJointRC cjoint = this.joints.get(n);
						if (cjoint != null && cjoint.object == object && cjoint.joint != null)
						{
							this.base.world.destroyJoint(cjoint.joint);
							cjoint.counter = 200;
							break;
						}
					}
				}
			}
			break;
		case CRunBox2DRopeAndChain.ACT_STOPLOOP:
			this.stopLoop = true;
			break;
		}
	}


	// Expressions
	// --------------------------------------------
	private CElement getElement(int index)
	{
		if (index >= 0 && index < this.elements.size())
			return this.elements.get(index);
		return null;
	}

	private int getX2(CElement element)
	{
		this.base.rGetBodyPosition(element.m_body, this.posAndAngle);
		float angle = (float)(-this.posAndAngle.angle / 180 * Math.PI);
		CImage image = this.rh.rhApp.imageBank.getImageFromHandle(element.image);
		int deltaX = image.getXAP() - image.getXSpot();
		int deltaY = image.getYAP() - image.getYSpot();
		int plusX = (int)(deltaX * Math.cos(angle) - deltaY * Math.sin(angle));
		return this.posAndAngle.x + plusX;
	}
	private int getY2(CElement element)
	{
		this.base.rGetBodyPosition(element.m_body, this.posAndAngle);
		float angle = (float)(-this.posAndAngle.angle / 180 * Math.PI);
		CImage image = this.rh.rhApp.imageBank.getImageFromHandle(element.image);
		int deltaX = image.getXAP() - image.getXSpot();
		int deltaY = image.getYAP() - image.getYSpot();
		int plusY = (int)(deltaX * Math.sin(angle) + deltaY * Math.cos(angle));
		return this.posAndAngle.y + plusY;
	}
	@Override
	public CValue expression(int num)
	{
		CValue ret = new CValue(0);
		CElement element;
		switch (num)
		{
		case CRunBox2DRopeAndChain.EXP_GETELEMENT:
			if (this.currentElement != null)
				ret.forceInt(((CElement)this.currentElement).number);
			break;
		case CRunBox2DRopeAndChain.EXP_LOOPINDEX:
			ret.forceInt(this.loopIndex);
			break;
		case CRunBox2DRopeAndChain.EXP_GETX1:
			element = this.getElement(this.ho.getExpParam().getInt());
			if (element!=null)
			{
				this.base.rGetBodyPosition(element.m_body, this.posAndAngle);
				ret.forceInt(this.posAndAngle.x);
			}
			break;
		case CRunBox2DRopeAndChain.EXP_GETY1:
			element = this.getElement(this.ho.getExpParam().getInt());
			if (element!=null)
			{
				this.base.rGetBodyPosition(element.m_body, this.posAndAngle);
				ret.forceInt(this.posAndAngle.y);
			}
			break;
		case CRunBox2DRopeAndChain.EXP_GETX2:
			element = this.getElement(this.ho.getExpParam().getInt());
			if (element != null)
			{
				ret.forceInt(this.getX2(element));
			}
			break;
		case CRunBox2DRopeAndChain.EXP_GETY2:
			element = this.getElement(this.ho.getExpParam().getInt());
			if (element != null)
			{
				ret.forceInt(this.getY2(element));
			}
			break;
		case CRunBox2DRopeAndChain.EXP_GETXMIDDLE:
			element = this.getElement(this.ho.getExpParam().getInt());
			if (element != null)
			{
				this.base.rGetBodyPosition(element.m_body, this.posAndAngle);
				int x2 = this.getX2(element);
				ret.forceInt((this.posAndAngle.x + x2) / 2);
			}
			break;
		case CRunBox2DRopeAndChain.EXP_GETYMIDDLE:
			element = this.getElement(this.ho.getExpParam().getInt());
			if (element != null)
			{
				this.base.rGetBodyPosition(element.m_body, this.posAndAngle);
				int y2 = this.getY2(element);
				ret.forceInt((this.posAndAngle.y + y2) / 2);
			}
			break;
		case CRunBox2DRopeAndChain.EXP_GETANGLE:
			element = this.getElement(this.ho.getExpParam().getInt());
			if (element != null)
			{
				float angle = (float)(element.m_body.getAngle() * 180 / Math.PI);
				ret.forceInt((int)angle);
			}
			break;
		}
		return ret;
	}
}

class CJointRC
{
	public CRunMBase object;
	public CElement element;
	public Joint joint;
	public int counter;

	public CJointRC()
	{
	}
	public CJointRC(CRunMBase o, CElement e, Joint j)
	{
		object = o;
		element = e;
		joint = j;
		counter = 0;
	}

}
class CElement extends CRunBox2DBaseElementParent
{
	public int number;
	public int x;
	public int y;
	public float angle;
	public short image;
	public short nLayer;
	CSprite sprite;

	public CElement()
	{

	}
	public CElement(CRunBox2DRopeAndChain p, short i, int n, int xx, int yy, boolean visible)
	{
		parent = p;
		image = i;
		number = n;
		x = xx;
		y = yy;
		this.InitBase(parent.ho, CRunMBase.MTYPE_ELEMENT);
		m_identifier = parent.identifier;
		nLayer = parent.ho.ros.rsLayer;

		CRun rhPtr = parent.ho.hoAdRunHeader;
        int rsFlags = visible?0:CSprite.SF_HIDDEN;    
    	if(parent.ho.hoOiList.oilAntialias)	//Add anti-alias effect
    		rsFlags |= CSprite.EFFECTFLAG_ANTIALIAS;
		sprite = rhPtr.spriteGen.addSprite(x - rhPtr.rhWindowX, y - rhPtr.rhWindowY,
				image, parent.ho.ros.rsLayer, parent.ho.ros.rsZOrder, parent.ho.ros.rsBackColor, rsFlags, null);
	}

	public void destroy(CRunBox2DBase pBase)
	{
		CRun rhPtr = parent.ho.hoAdRunHeader;
		rhPtr.spriteGen.delSprite(sprite);
		if (pBase != null)
			pBase.rDestroyBody(m_body);
	}

	public void setPosition()
	{
		CRunBox2DRopeAndChain father = (CRunBox2DRopeAndChain)this.parent;

		father.base.rBodyAddVelocity(m_body, m_addVX, m_addVY);
		ResetAddVelocity();
		father.base.rGetBodyPosition(m_body, father.posAndAngle);

		CRun rhPtr = parent.ho.hoAdRunHeader;
		rhPtr.spriteGen.modifSpriteEx(sprite, father.posAndAngle.x - rhPtr.rhWindowX, father.posAndAngle.y - rhPtr.rhWindowY, image, 1.0f, 1.0f, true, father.posAndAngle.angle, false);

        if (nLayer != parent.ho.ros.rsLayer) {
            nLayer = parent.ho.ros.rsLayer;
			rhPtr.spriteGen.setSpriteLayer(sprite, nLayer);
        }
	}

	public void setEffect(int effect, int  effectParam)
	{
		CRun rhPtr = parent.ho.hoAdRunHeader;
		rhPtr.spriteGen.modifSpriteEffect(sprite, effect, effectParam);
	}
	public void show(boolean visible)
	{
		CRun rhPtr = parent.ho.hoAdRunHeader;
		rhPtr.spriteGen.showSprite(sprite, visible);
	}

}

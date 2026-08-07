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
// CRUNBOX2DPARTICULE
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

import com.badlogic.gdx.physics.box2d.BodyDef;
import com.badlogic.gdx.physics.box2d.Fixture;

public class CRunBox2DParticules extends CRunBox2DBaseParent
{
    public static final int PATYPE_POINT = 0;
    public static final int PATYPE_ZONE = 1;
    public static final int PAFLAG_CREATEATSTART = 0x0001;
    public static final int PAFLAG_LOOP = 0x0002;
    public static final int PAFLAG_DESTROYANIM = 0x0004;
    public static final int ANGLENONE = 5666565;

    private static final int CND_ONEACH = 0;
    private static final int CND_PARTICULECOLLISION = 1;
    private static final int CND_PARTICULEOUTLEFT = 2;
    private static final int CND_PARTICULEOUTRIGHT = 3;
    private static final int CND_PARTICULEOUTTOP = 4;
    private static final int CND_PARTICULEOUTBOTTOM = 5;
    private static final int CND_PARTICULESCOLLISION = 6;
    private static final int CND_PARTICULECOLLISIONBACKDROP = 7;
    private static final int CND_LAST = 8;

    private static final int ACT_CREATEPARTICULES = 0;
    private static final int ACT_STOPPARTICULE = 1;
    private static final int ACT_FOREACH = 2;
    private static final int ACT_SETSPEED = 3;
    private static final int ACT_SETROTATION = 4;
    private static final int ACT_SETINTERVAL = 5;
    private static final int ACT_SETANGLE = 6;
    private static final int ACT_DESTROYPARTICULE = 7;
    private static final int ACT_DESTROYPARTICULES = 8;
    private static final int ACT_SETSPEEDINTERVAL = 9;
    private static final int ACT_SETCREATIONSPEED = 10;
    private static final int ACT_SETCREATIONON = 11;
    private static final int ACT_STOPLOOP = 12;
    private static final int ACT_SETAPPLYFORCE = 13;
    private static final int ACT_SETAPPLYTORQUE = 14;
    private static final int ACT_SETASPEED = 15;
    private static final int ACT_SETALOOP = 16;
    private static final int ACT_SETSCALE = 17;
    private static final int ACT_SETFRICTION = 18;
    private static final int ACT_SETELASTICITY = 19;
    private static final int ACT_SETDENSITY = 20;
    private static final int ACT_SETGRAVITY = 21;
    private static final int ACT_SETDESTROYDISTANCE = 22;
    private static final int ACT_SETDESTROYANIM = 23;

    private static final int EXP_PARTICULENUMBER = 0;
    private static final int EXP_GETPARTICULEX = 1;
    private static final int EXP_GETPARTICULEY = 2;
    private static final int EXP_GETPARTICULEANGLE = 3;
    private static final int EXP_GETSPEED = 4;
    private static final int EXP_GETSPEEDINTERVAL = 5;
    private static final int EXP_GETANGLE = 6;
    private static final int EXP_GETANGLEINTERVAL = 7;
    private static final int EXP_GETROTATION = 8;
    private static final int EXP_GETLOOPINDEX = 9;
    private static final int EXP_GETAPPLIEDFORCE = 10;
    private static final int EXP_GETAPPLIEDTORQUE = 11;

    private static final float APPLYFORCE_MULT = 5.0f;
    private static final float APPLYTORQUE_MULT = 0.1f;
    private static final float ROTATION_MULT = 20f;

    public short type;
    public int flags;
    public int number;
    public int animationSpeed;
    public int angleDWORD;
    public int speed;
    public int speedInterval;
    public float friction;
    public float restitution;
    public float density;
    public int angleInterval;
    public float gravity;
    public float rotation;
    public int nImages;
    public short images[];
    public int creationSpeed;
    public int creationSpeedCounter;
    public float angle = CRunBox2DParticules.ANGLENONE;
    public boolean stopLoop;
    public int loopIndex;
    public float applyForce;
    public float applyTorque;
    public float scaleSpeed;
    public int destroyDistance;
    public String loopName;
    public int effect;
    public int effectParam;
    public boolean visible;
    public CRunBox2DBasePosAndAngle m_posAndAngle = new CRunBox2DBasePosAndAngle();

    public CRunBox2DParticules()
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
        return this.base.started;
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

    private int dirAtStart(int dirAtStart)
    {
        int dir;

        // Compte le nombre de directions demandees
        int cpt = 0;
        int das = dirAtStart;
        int das2;
        for (int n = 0; n < 32; n++)
        {
            das2 = das;
            das >>= 1;
            if ((das2 & 1)!=0) cpt++;
        }

        // Une ou zero direction?
        if (cpt == 0)
        {
            dir = 0;
        }
        else
        {
            // Appelle le hasard pour trouver le bit
            cpt = this.rh.random((short)cpt);
            das = dirAtStart;
            for (dir = 0; ; dir++)
            {
                das2 = das;
                das >>= 1;
                if ((das2 & 1)!=0)
                {
                    cpt--;
                    if (cpt < 0) break;
                }
            }
        }
        return dir;
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
        this.type = file.readShort();
        this.flags = file.readInt();
        this.creationSpeed = file.readInt();
        this.number = file.readInt();
        this.animationSpeed = file.readInt();
        this.angleDWORD = file.readInt();
        this.speed = file.readInt();
        this.speedInterval = file.readInt();
        this.friction = file.readInt() / 100.0f;
        this.restitution=file.readInt()/100.0f;
        this.density=file.readInt()/100.0f;
        this.angleInterval=file.readInt();
        this.identifier=file.readInt();
        this.gravity=file.readInt()/100.0f;
        this.rotation = file.readInt() / 100.0f * CRunBox2DParticules.ROTATION_MULT*this.RunFactor;
        this.applyForce = file.readInt() / 100f * CRunBox2DParticules.APPLYFORCE_MULT*this.RunFactor;
        this.applyTorque = file.readInt() / 100f * CRunBox2DParticules.APPLYTORQUE_MULT*this.RunFactor;
        this.scaleSpeed = file.readInt() / 400f;
        this.destroyDistance = file.readInt();
        this.nImages = file.readShort();
        int n;
        this.images = new short[nImages];
        for (n=0; n<this.nImages; n++)
            this.images[n] = file.readShort();
        this.ho.loadImageList(this.images);
        this.particules = new ArrayList<CRunBox2DBaseElementParent>();
        this.toDestroy = new ArrayList<CRunBox2DBaseElementParent>();

        return false;
    }

    @Override
	public void destroyRunObject(boolean bFast)
    {
        CRunBox2DBase base = GetBase();
        int n;
        int particules_size = this.particules.size() ;
        for (n = 0; n < particules_size ; n++)
        {
            CParticule particule = (CParticule)this.particules.get(n);
            particule.destroy(base);
        }
    }

    @Override
	public int handleRunObject()
    {
        if (!this.rStartObject() || this.base.isPaused())
            return 0;

        int n;
        CParticule particule;
        if ((flags & PAFLAG_CREATEATSTART)!=0)
        {
            creationSpeedCounter += creationSpeed;
            if (creationSpeedCounter >= 100)
            {
                creationSpeedCounter -= 100;
                createParticules(number);
            }
        }

        for (n = 0; n < toDestroy.size() ; n++)
        {
            particule = (CParticule)toDestroy.get(n);
            particule.destroy(this.base);
            toDestroy.remove(n);
            particules.remove(particule);
            particule = null;
            n--;
        }

        CRun rhPtr = ho.hoAdRunHeader;
        int particules_size = particules.size() ;
        for (n = 0; n < particules_size ; n++)
        {
            particule = (CParticule)particules.get(n);
            if(particule == null)
            	continue;
            
            //int x, y;
            //float angle;
            base.rGetBodyPosition(particule.m_body, m_posAndAngle);
            if (m_posAndAngle.x < rhPtr.rh3XMinimumKill || m_posAndAngle.x > rhPtr.rh3XMaximumKill
                    || m_posAndAngle.y < rhPtr.rh3YMinimumKill || m_posAndAngle.y > rhPtr.rh3YMaximumKill)
            {
                toDestroy.add(particule);
                particule.bDestroyed = true;
            }
            else
            {
                particule.animate();
            }
        }

        if (ho.ros.rsEffect != effect || ho.ros.rsEffectParam != effectParam)
        {
            effect = ho.ros.rsEffect;
            effectParam = ho.ros.rsEffectParam;
            for (n = 0; n < particules.size() ; n++)
            {
                particule = (CParticule)particules.get(n);
                if (!particule.bDestroyed)
                    particule.setEffect(effect, effectParam);
            }
        }
        boolean v = (ho.ros.rsFlags & CRSpr.RSFLAG_VISIBLE) != 0;
        if (v != visible)
        {
            visible = v;
            for (n = 0; n < particules.size() ; n++)
            {
                particule = (CParticule)particules.get(n);
                if (!particule.bDestroyed)
                    particule.show(visible);
            }
        }
        return 0;
    }

    private void createParticules(int number)
    {
        int n;
        CParticule particule;
        for (n = 0; n < number; n++)
        {
            int x, y;
            if (this.type == CRunBox2DParticules.PATYPE_POINT)
            {
                x = this.ho.hoX;
                y = this.ho.hoY;
            }
            else
            {
                x = this.ho.hoX + this.rh.random((short)this.ho.hoImgWidth);
                y = this.ho.hoY + this.rh.random((short)this.ho.hoImgHeight);
            }

            float angle, interval;
            if (this.angle == CRunBox2DParticules.ANGLENONE)
                angle = dirAtStart(this.angleDWORD) * 11.25f;
            else
                angle = this.angle;
            if (this.angleInterval > 0)
            {
                interval = this.rh.random((short)(this.angleInterval * 2));
                angle += interval - this.angleInterval;
            }

            particule = new CParticule(this, x, y);
            particule.InitBase(this.ho, CRunMBase.MTYPE_PARTICULE);
            particule.setScale(scaleSpeed);
            particule.setAnimation(images, nImages, animationSpeed, flags, visible);
            particule.setForce(applyForce, applyTorque, angle);
            particule.setEffect(effect, effectParam);

            CImage image = this.rh.rhApp.imageBank.getImageFromHandle(this.images[0]);
            particule.m_body = base.rCreateBody(BodyDef.BodyType.DynamicBody, x, y, angle, gravity, particule, 0, 0);
            particule.fixture = base.rBodyCreateCircleFixture(particule.m_body, particule, x, y, (image.getWidth() + image.getHeight()) / 4, density, friction, restitution);

            float mass = particule.m_body.getMass();
            interval = this.rh.random((short)(speedInterval * 2));
            int s = (int)(speed + interval - speedInterval);
            s = Math.max(s, 1);
            float speedFloat = (float)(s / 100.0 * 20.0);
            base.rBodyApplyImpulse(particule.m_body, (float) (Math.max(1.0, speedFloat * mass)), angle);
            base.rBodyApplyAngularImpulse(particule.m_body, rotation);

            this.particules.add(particule);
        }
    }

    private void destroyParticule(CParticule particule)
    {
        particule.destroy(this.base);
        this.particules.remove(particule);
        particule = null;
    }

    // Conditions
    // --------------------------------------------------
    @Override
	public boolean condition(int num, CCndExtension cnd)
    {
        switch (num)
        {
            case CRunBox2DParticules.CND_ONEACH:
                String name = cnd.getParamExpString(this.rh, 0);
                return name.equalsIgnoreCase(this.loopName);
            case CRunBox2DParticules.CND_PARTICULECOLLISION:
                PARAM_OBJECT param = cnd.getParamObject(this.rh, 0);
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
                        while (numOi < pq.qoiList.length)
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
            case CRunBox2DParticules.CND_PARTICULECOLLISIONBACKDROP:
            case CRunBox2DParticules.CND_PARTICULEOUTLEFT:
            case CRunBox2DParticules.CND_PARTICULEOUTRIGHT:
            case CRunBox2DParticules.CND_PARTICULEOUTTOP:
            case CRunBox2DParticules.CND_PARTICULEOUTBOTTOM:
            case CRunBox2DParticules.CND_PARTICULESCOLLISION:
                return true;
            default:
                break;
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
            case CRunBox2DParticules.ACT_CREATEPARTICULES:
                int number = act.getParamExpression(this.rh, 0);
               	this.createParticules(number);
                break;
            case CRunBox2DParticules.ACT_STOPPARTICULE:
                this.stopped = true;
                break;
            case CRunBox2DParticules.ACT_FOREACH:
                this.loopName = act.getParamExpString(this.rh, 0);
                int n;
                this.stopLoop = false;
                int particules_size = this.particules.size();
                for (n = 0; n < particules_size ; n++)
                {
                    if (this.stopLoop)
                        break;
                    CParticule particule = (CParticule)this.particules.get(n);
                    this.currentParticule1 = particule;
                    this.loopIndex = n;
                    this.ho.generateEvent(CRunBox2DParticules.CND_ONEACH, 0);
                }
                break;
            case CRunBox2DParticules.ACT_STOPLOOP:
                this.stopLoop = true;
                break;
            case CRunBox2DParticules.ACT_SETSPEED:
                this.speed = Math.min(act.getParamExpression(this.rh, 0), 250);
                this.speed = Math.max(this.speed, 0);
                break;
            case CRunBox2DParticules.ACT_SETSPEEDINTERVAL:
                this.speedInterval = Math.max(act.getParamExpression(this.rh, 0), 0);
                break;
            case CRunBox2DParticules.ACT_SETANGLE:
                this.angle = act.getParamExpression(this.rh, 0);
                break;
            case CRunBox2DParticules.ACT_SETINTERVAL:
                this.angleInterval = Math.min(act.getParamExpression(this.rh, 0), 360);
                this.angleInterval = Math.max(this.angleInterval, 0);
                break;
            case CRunBox2DParticules.ACT_SETROTATION:
                this.rotation = Math.min(act.getParamExpression(this.rh, 0), 250);
                this.rotation = Math.max(this.rotation, -250);
                break;
            case CRunBox2DParticules.ACT_DESTROYPARTICULE:
                if (this.currentParticule1 != null)
                {
                    if (!((CParticule)this.currentParticule1).bDestroyed && this.particules.indexOf(this.currentParticule1) >= 0)
					{
                        this.toDestroy.add(this.currentParticule1);
						((CParticule)this.currentParticule1).bDestroyed=true;
					}
                }
                break;
            case CRunBox2DParticules.ACT_DESTROYPARTICULES:
                if (this.currentParticule1 != null)
				{
                    if (!((CParticule)this.currentParticule1).bDestroyed && this.particules.indexOf(this.currentParticule1) >= 0)
					{
                        this.toDestroy.add(this.currentParticule1);
						((CParticule)this.currentParticule1).bDestroyed=true;
					}
				}
                if (this.currentParticule2 != null)
				{
                    if (!((CParticule)this.currentParticule2).bDestroyed && this.particules.indexOf(this.currentParticule2) >= 0)
					{
                        this.toDestroy.add(this.currentParticule2);
						((CParticule)this.currentParticule2).bDestroyed=true;
					}
				}
                break;
            case CRunBox2DParticules.ACT_SETCREATIONSPEED:
                this.creationSpeed = Math.min(act.getParamExpression(this.rh, 0), 100);
                this.creationSpeed = Math.max(this.creationSpeed, 0);
                break;
            case CRunBox2DParticules.ACT_SETCREATIONON:
                if (act.getParamExpression(this.rh, 0)!=0)
                    this.flags |= CRunBox2DParticules.PAFLAG_CREATEATSTART;
                else
                    this.flags &= ~CRunBox2DParticules.PAFLAG_CREATEATSTART;
                break;
            case CRunBox2DParticules.ACT_SETAPPLYFORCE:
                this.applyForce = act.getParamExpression(this.rh, 0) / 100.0f * CRunBox2DParticules.APPLYFORCE_MULT*this.RunFactor;
                break;
            case CRunBox2DParticules.ACT_SETAPPLYTORQUE:
                this.applyTorque = act.getParamExpression(this.rh, 0) / 100.0f * CRunBox2DParticules.APPLYTORQUE_MULT*this.RunFactor;
                break;
            case CRunBox2DParticules.ACT_SETASPEED:
                this.animationSpeed = act.getParamExpression(this.rh, 0);
                break;
            case CRunBox2DParticules.ACT_SETALOOP:
                this.flags &= ~CRunBox2DParticules.PAFLAG_LOOP;
                if (act.getParamExpression(this.rh, 0)!=0)
                    this.flags |= CRunBox2DParticules.PAFLAG_LOOP;
                break;
            case CRunBox2DParticules.ACT_SETSCALE:
                this.scaleSpeed = act.getParamExpression(this.rh, 0) / 400.0f;
                break;
            case CRunBox2DParticules.ACT_SETFRICTION:
                this.friction = act.getParamExpression(this.rh, 0) / 100.0f;
                break;
            case CRunBox2DParticules.ACT_SETELASTICITY:
                this.restitution = act.getParamExpression(this.rh, 0) / 100.0f;
                break;
            case CRunBox2DParticules.ACT_SETDENSITY:
                this.density = act.getParamExpression(this.rh, 0) / 100.0f;
                break;
            case CRunBox2DParticules.ACT_SETGRAVITY:
                this.gravity = act.getParamExpression(this.rh, 0) / 100.0f;
                break;
            case CRunBox2DParticules.ACT_SETDESTROYDISTANCE:
                this.destroyDistance = act.getParamExpression(this.rh, 0);
                break;
            case CRunBox2DParticules.ACT_SETDESTROYANIM:
                if (act.getParamExpression(this.rh, 0)!=0)
                    this.flags |= CRunBox2DParticules.PAFLAG_DESTROYANIM;
                else
                    this.flags &= ~CRunBox2DParticules.PAFLAG_DESTROYANIM;
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
            case CRunBox2DParticules.EXP_PARTICULENUMBER:
                ret.forceInt(this.particules.size());
                break;
            case CRunBox2DParticules.EXP_GETPARTICULEX:
                if (this.currentParticule1!=null)
                    ret.forceInt(((CParticule)this.currentParticule1).x);
                break;
            case CRunBox2DParticules.EXP_GETPARTICULEY:
                if (this.currentParticule1!=null)
                    ret.forceInt(((CParticule)this.currentParticule1).y);
                break;
            case CRunBox2DParticules.EXP_GETPARTICULEANGLE:
                if (this.currentParticule1!=null)
                    ret.forceInt((int)((CParticule)this.currentParticule1).angle);
                break;
            case CRunBox2DParticules.EXP_GETSPEED:
                ret.forceInt(this.speed);
                break;
            case CRunBox2DParticules.EXP_GETSPEEDINTERVAL:
                ret.forceInt(this.speedInterval);
                break;
            case CRunBox2DParticules.EXP_GETANGLE:
                ret.forceInt((int)this.angle);
                break;
            case CRunBox2DParticules.EXP_GETANGLEINTERVAL:
                ret.forceInt(this.angleInterval);
                break;
            case CRunBox2DParticules.EXP_GETROTATION:
                ret.forceInt((int)this.rotation);
                break;
            case CRunBox2DParticules.EXP_GETLOOPINDEX:
                ret.forceInt(this.loopIndex);
                break;
            case CRunBox2DParticules.EXP_GETAPPLIEDFORCE:
                ret.forceInt((int)(this.applyForce * 100.0 / CRunBox2DParticules.APPLYFORCE_MULT/this.RunFactor));
                break;
            case CRunBox2DParticules.EXP_GETAPPLIEDTORQUE:
                ret.forceInt((int)(this.applyTorque * 100.0 / CRunBox2DParticules.APPLYTORQUE_MULT/this.RunFactor));
                break;
            default:
                break;
        }
        return ret;
    }

}

class CParticule extends CRunBox2DBaseElementParent
{
    //private int nLayer;
    //private CLayer pLayer;
    private int initialX;
    private int initialY;
    public int x;
    public int y;
    public float angle;
    private int nImages;
    private short images[];
    private int image;
    private int animationSpeed = 0;
    private int animationSpeedCounter = 0;
    public boolean bDestroyed = false;
    private float oldWidth = 0;
    private float oldHeight = 0;
    public Fixture fixture = null;
    private float scaleSpeed = 0;
    private float scale = 0;
    private CSprite sprite;
    private float m_force;
    private float m_torque;
    private float m_direction;
    private boolean stopped;
    private int flags;

    public CParticule()
    {
    }
    public CParticule(CRunBox2DParticules pp, int xx, int yy)
    {
        parent = pp;
        initialX = xx;
        initialY= yy;
        x = xx;
        y = yy;
        angle = 0;
        nImages = 0;
        image = 0;
        animationSpeed = 0;
        animationSpeedCounter = 0;
        bDestroyed = false;
        oldWidth = 0;
        oldHeight = 0;
        fixture = null;
        scaleSpeed = 0;
        scale = 1.0f;
        sprite = null;
    }
    public void destroy(CRunBox2DBase pBase)
    {
        CRun rhPtr = parent.ho.hoAdRunHeader;
        rhPtr.spriteGen.delSprite(sprite);
        if (pBase != null)
            pBase.rDestroyBody(m_body);
    }
    public void setForce(float force, float torque, float direction)
    {
        m_force = force;
        m_torque = torque;
        m_direction = direction;
    }
    public void setAnimation(short pImages[], int nI, int aSpeed, int f, boolean visible)
    {
        images = pImages;
        nImages = nI;
        animationSpeed = aSpeed;
        animationSpeedCounter = 0;
        flags = f;
        stopped = false;

        CImage image = parent.rh.rhApp.imageBank.getImageFromHandle(images[0]);
        oldWidth = image.getWidth() * scale;
        oldHeight = image.getHeight() * scale;

        CRun rhPtr = parent.ho.hoAdRunHeader;
        sprite = rhPtr.spriteGen.addSprite(x-rhPtr.rhWindowX, y-rhPtr.rhWindowY,
                images[0], parent.ho.ros.rsLayer, parent.ho.ros.rsZOrder, parent.ho.ros.rsBackColor, visible?0:CSprite.SF_HIDDEN, null);
    }
    public void setScale(float scaleSpeed)
    {
        this.scaleSpeed = scaleSpeed;
        this.scale = 1;
    }
    public void setEffect(int effect, int effectParam)
    {
        CRun rhPtr = parent.ho.hoAdRunHeader;
        rhPtr.spriteGen.modifSpriteEffect(sprite, effect, effectParam);
    }
    public void show(boolean visible)
    {
        CRun rhPtr = parent.ho.hoAdRunHeader;
        rhPtr.spriteGen.showSprite(sprite, visible);
    }
    public void animate()
    {
        if (!this.stopped)
        {
            this.animationSpeedCounter += this.animationSpeed * this.parent.rh.rh4MvtTimerCoef;
            while (this.animationSpeedCounter >= 100)
            {
                this.animationSpeedCounter -= 100;
                this.image++;
                if (this.image >= this.nImages)
                {
                    if ((this.flags & CRunBox2DParticules.PAFLAG_LOOP)!=0)
                    {
                        this.image = 0;
                    }
                    else
                    {
                        this.image--;
                        this.stopped = true;
                        if ((this.flags & CRunBox2DParticules.PAFLAG_DESTROYANIM)!=0)
                        {
                            if (!bDestroyed)
                            {
                                bDestroyed = true;
                                this.parent.toDestroy.add(this);
                            }
                        }
                    }
                }
            }
        }
        float oldScale = this.scale;
        this.scale += this.scaleSpeed;

        CRunBox2DParticules father = (CRunBox2DParticules)this.parent;
        CImage cImage = this.parent.rh.rhApp.imageBank.getImageFromHandle(this.images[this.image]);
        float width = cImage.getWidth() * this.scale;
        float height = cImage.getHeight() * this.scale;
        if (width < 1 || height < 1)
        {
            if (!bDestroyed)
            {
                bDestroyed = true;
                this.parent.toDestroy.add(this);
            }
            this.scale = oldScale;
        }
        else
        {
            if (width != this.oldWidth || height != this.oldHeight)
            {
                this.oldWidth = (int)width;
                this.oldHeight = (int)height;
                this.m_body.destroyFixture(this.fixture);
                this.fixture = this.parent.base.rBodyCreateCircleFixture(this.m_body, this, this.x, this.y, (int)((width + height) / 4), father.density, father.friction, father.restitution);
            }
        }

        this.parent.base.rBodyAddVelocity(this.m_body, this.m_addVX, this.m_addVY);
        this.ResetAddVelocity();

        parent.base.rBodyApplyImpulse(m_body, m_force, m_direction);
        parent.base.rBodyApplyAngularImpulse(m_body, m_torque);

        parent.base.rGetBodyPosition(m_body, father.m_posAndAngle);

        int dx = father.m_posAndAngle.x - initialX;
        int dy = father.m_posAndAngle.y - initialY;
        int distance = (int)(Math.sqrt(dx * dx + dy * dy));
        if (distance > father.destroyDistance)
        {
            if (!bDestroyed)
            {
                bDestroyed = true;
                parent.toDestroy.add(this);
            }
        }
        else
        {
            CRun rhPtr = parent.ho.hoAdRunHeader;
            rhPtr.spriteGen.modifSpriteEx(sprite, father.m_posAndAngle.x - rhPtr.rhWindowX, father.m_posAndAngle.y - rhPtr.rhWindowY, images[image],
                    scale, scale, true, angle, true);
        }
    }
}
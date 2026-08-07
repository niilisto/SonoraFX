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

import Actions.CActExtension;
import Animations.CAnimDir;
import Animations.CRAni;
import Application.CRunApp;
import Application.CRunFrame;
import Banks.CImage;
import Banks.CImageShape;
import Conditions.CCndExtension;
import Expressions.CValue;
import Frame.CLO;
import Frame.CLayer;
import Movements.CMoveDef;
import Movements.CMoveDefExtension;
import Movements.CMoveExtension;
import OI.COC;
import OI.COCBackground;
import OI.COI;
import OI.CObjectCommon;
import Objects.CExtension;
import Objects.CObject;
import RunLoop.*;
import Services.CBinaryFile;
import Sprites.CMask;
import android.os.Handler;
import android.util.Log;

import com.badlogic.gdx.math.Vector2;
import com.badlogic.gdx.physics.box2d.*;
import com.badlogic.gdx.physics.box2d.joints.*;

import java.util.ArrayList;

public class CRunBox2DBase extends CRunBaseParent
{
    public static final int FANIDENTIFIER = 0x42324641;
    public static final int TREADMILLIDENTIFIER = 0x4232544D;
    public static final int MAGNETIDENTIFIER = 0x42369856;
    public static final int GROUNDIDENTIFIER = 0x42324E4F;
    public static final int ROPEANDCHAINIDENTIFIER = 0x4232EFFA;
    public static final int JOINTIDENTIFIER = 0x423296EF;
    public static final int CBFLAG_FIXEDROTATION=0x0001;
    public static final int CBFLAG_BULLET=0x0002;
    public static final int CBFLAG_DAMPING=0x0004;
    public static final int POSDEFAULT=0x56586532;
    public static final int DIRECTION_LEFTTORIGHT=0;
    public static final int DIRECTION_RIGHTTOLEFT=1;
    public static final int DIRECTION_TOPTOBOTTOM=2;
    public static final int DIRECTION_BOTTOMTOTOP=3;
    public static final int OBSTACLE_OBSTACLE=0;
    public static final int OBSTACLE_PLATFORM=1;
    public static final int B2FLAG_ADDBACKDROPS = 0x0001;
    public static final int B2FLAG_BULLETCREATE=0x0002;
    public static final int B2FLAG_ADDOBJECTS = 0x0004;
    public static final int TYPE_ALL = 0;
    public static final int TYPE_DISTANCE=1;
    public static final int TYPE_REVOLUTE=2;
    public static final int TYPE_PRISMATIC=3;
    public static final int TYPE_PULLEY=4;
    public static final int TYPE_GEAR=5;
    public static final int TYPE_MOUSE=6;
    public static final int TYPE_WHEEL=7;
    public static final float RMOTORTORQUEMULT=20.0f;
    public static final float RMOTORSPEEDMULT=10.0f;
    public static final float PJOINTMOTORFORCEMULT=20.0f;
    public static final float PJOINTMOTORSPEEDMULT=10.0f;
    public static final float APPLYIMPULSE_MULT=19.0f;
    public static final float APPLYANGULARIMPULSE_MULT=0.1f;
    public static final float APPLYFORCE_MULT=5.0f;
    public static final float APPLYTORQUE_MULT=1.0f;
    public static final float SETVELOCITY_MULT=20.5f;
    public static final float SETANGULARVELOCITY_MULT=15.0f;
    public static final int JTYPE_NONE = 0;
    public static final int JTYPE_REVOLUTE = 1;
    public static final int JTYPE_DISTANCE = 2;
    public static final int JTYPE_PRISMATIC = 3;
    public static final int JANCHOR_HOTSPOT = 0;
    public static final int JANCHOR_ACTIONPOINT = 1;
    public static final int MAX_JOINTNAME = 24;
    public static final int MAX_JOINTOBJECT = 24;

    public static final int CND_LAST = 0;
    public static final int ACTION_SETGRAVITYFORCE=0;
    public static final int ACTION_SETGRAVITYANGLE=1;
    public static final int ACTION_DJOINTHOTSPOT=8;
    public static final int ACTION_DJOINTACTIONPOINT=9;
    public static final int ACTION_DJOINTPOSITION=10;
    public static final int ACTION_RJOINTHOTSPOT=11;
    public static final int ACTION_RJOINTACTIONPOINT=12;
    public static final int ACTION_RJOINTPOSITION=13;
    public static final int ACTION_PJOINTHOTSPOT=14;
    public static final int ACTION_PJOINTACTIONPOINT=15;
    public static final int ACTION_PJOINTPOSITION=16;
    public static final int ACTION_ADDOBJECT=23;
    public static final int ACTION_SUBOBJECT=24;
    public static final int ACTION_SETDENSITY = 25;
    public static final int ACTION_SETFRICTION = 26;
    public static final int ACTION_SETELASTICITY = 27;
    public static final int ACTION_SETGRAVITY = 28;
    public static final int ACTION_DJOINTSETELASTICITY = 29;
    public static final int ACTION_RJOINTSETLIMITS=30;
    public static final int ACTION_RJOINTSETMOTOR=31;
    public static final int ACTION_PJOINTSETLIMITS=32;
    public static final int ACTION_PJOINTSETMOTOR=33;
    public static final int ACTION_PUJOINTHOTSPOT=34;
    public static final int ACTION_PUJOINTACTIONPOINT=35;
    public static final int ACTION_DESTROYJOINT=38;
    public static final int ACTION_SETITERATIONS=39;
    public static final int ACTION_SETPAUSE=40;
    public static final int ACTION_SETRESUME=41;
    public static final int EXPRESSION_GRAVITYSTRENGTH=0;
    public static final int EXPRESSION_GRAVITYANGLE=1;
    public static final int EXPRESSION_VELOCITYITERATIONS=2;
    public static final int EXPRESSION_POSITIONITERATIONS=3;
    public static final int EXPRESSION_ELASTICITYFREQUENCY=4;
    public static final int EXPRESSION_ELASTICITYDAMPING=5;
    public static final int EXPRESSION_LOWERANGLELIMIT=6;
    public static final int EXPRESSION_UPPERANGLELIMIT=7;
    public static final int EXPRESSION_MOTORSTRENGTH=8;
    public static final int EXPRESSION_MOTORSPEED=9;
    public static final int EXPRESSION_LOWERTRANSLATION=10;
    public static final int EXPRESSION_UPPERTRANSLATION=11;
    public static final int EXPRESSION_PMOTORSTRENGTH=12;
    public static final int EXPRESSION_PMOTORSPEED=13;


    private ArrayList<CRunBaseParent> fans = new ArrayList<CRunBaseParent>();
    private ArrayList<CRunBaseParent> treadmills = new ArrayList<CRunBaseParent>();
    private ArrayList<CRunBaseParent> magnets = new ArrayList<CRunBaseParent>();
    private ArrayList<CRunBaseParent> ropes = new ArrayList<CRunBaseParent>();
    public boolean started = false;

    public float factor = 0;
    public int xBase = 0;
    public int yBase = 0;
    private int flags = 0;
    public World world = null;
    public float gravity = 0;
    public float angle = 0;
    private int angleBase = 0;
    private int velocityIterations = 0;
    private int positionIterations = 0;
    private float friction = 0;
    private float restitution = 0;
    private CContactListener contactListener = null;
    //private Boolean fanSearched = false;
    //private Boolean magnetSearched = false;
    //private Boolean treadmillSearched = false;
    private float bulletGravity = 0;
    private float bulletDensity = 0;
    private float bulletRestitution = 0;
    private float bulletFriction = 0;
    
    ArrayList<CRunMBase> objects = new ArrayList<CRunMBase>();
    ArrayList<Integer> objectIDs = new ArrayList<Integer>();
    ArrayList<CForce> forces = new ArrayList<CForce>();
    ArrayList<CTorque> torques = new ArrayList<CTorque>();
    ArrayList<CJoint> joints = new ArrayList<CJoint>();
    ArrayList<Body> bodiesToDestroy = new ArrayList<Body>();
    
    private float npDensity = 0;
    private float npFriction = 0;
    
    protected boolean bPaused;
    protected boolean bListener;

    @Override
    public int getNumberOfConditions()
    {
        return CND_LAST;
    }
    @Override
    public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        this.xBase=0;
        this.yBase=this.rh.rhApp.gaCyWin;

        this.flags=file.readInt();
        this.velocityIterations=file.readInt();
        this.positionIterations=file.readInt();
        file.skipBytes(4);
        this.angle=(float)(file.readInt()*Math.PI/16.0f);
        this.factor=(float)file.readInt();
        this.friction=(float)file.readInt()/100.0f;
        this.restitution=(float)file.readInt()/100.0f;
        this.bulletFriction=(float)file.readInt()/100.0f;
        this.bulletRestitution=(float)file.readInt()/100.0f;
        this.bulletGravity=(float)file.readInt()/100.0f;
        this.bulletDensity=(float)file.readInt()/100.0f;
        this.gravity=file.readFloat();
        this.identifier=file.readInt();
        this.npDensity = (float)file.readInt() / 100.0f;
        this.npFriction = (float)file.readInt() / 100.0f;

        Vector2 gravity = new Vector2((float)(this.gravity*Math.cos(this.angle)), (float)(this.gravity*Math.sin(this.angle)));
        this.world=new World(gravity, false);
        this.world.setAutoClearForces(true);
        this.contactListener=new CContactListener();
        this.world.setContactListener(this.contactListener);
        this.bListener = true;
        
        // If another engine exists with the same identifier -> set identifier to random value
        if (CheckOtherEngines())
            identifier = 1000 + ho.hoNumber;

        this.createBorders();

        ho.hoAdRunHeader.rh4Box2DObject = true;
        
        this.bPaused = false;
        
        // No errors
        return false;
    }

    @Override
    public void destroyRunObject(boolean bFast)
    {
        if(this.world != null)
        	this.world.dispose();
    	this.world = null;
        ho.hoAdRunHeader.rh4Box2DObject = false;
    }

    double XRunFactor;
    
    @Override
    public int handleRunObject()
    {
        this.rStartObject();

        if (this.bPaused)
        {
        	if(this.bListener)
        		this.world.setContactListener(null); // this will set contact listener to null then no more collision
        	this.bListener = false;
        	return 0;
        }
        else
        {
        	if(!this.bListener)
         		this.world.setContactListener(this.contactListener); // restore the listener to continue detect collisions
            this.bListener = true;
        }
        
        int i;
        int forces_size = this.forces.size();
        int torques_size = this.torques.size();
        int objectIDs_size = this.objectIDs.size();
       		
        for (i=0; i<forces_size; i++)
        {
            CForce force = this.forces.get(i);
            if(force == null)
            	continue;
            force.m_body.applyForceToCenter(force.m_force);
        }
        for (i=0; i<torques_size; i++)
        {
            CTorque torque = this.torques.get(i);
            if(torque == null)
            	continue;
            torque.m_body.applyTorque(torque.m_torque);
        }

        for (i=0; i<objectIDs_size; i++)
        {
            int value=this.objectIDs.get(i);
            CObject pHo=this.GetHO(value);
            CRunMBase pBase=this.objects.get(i);
            if (pHo!=null && pBase != null && pBase.m_pHo!=pHo)
            {
                pHo=null;
            }
            if (pHo==null)
            {
                this.rDestroyBody(pBase.m_body);
                this.objectIDs.remove(i);
                this.objects.remove(i);
                objectIDs_size = this.objectIDs.size();
                i--;
            }
            else
            {
                Vector2 position = new Vector2(((float)(this.xBase+pHo.hoX)/this.factor), (float)((this.yBase-pHo.hoY)/this.factor));
                float angle=(float)(getAnimDir(pHo, pHo.roc.rcDir)*Math.PI/16.0);
                pBase.m_body.setTransform(position, angle);
            }
        }
         
        
        if (this.world!=null)
        {
            float timeStep = (float)(1.0f / (this.rh.rhApp.gaFrameRate*1.0f));
            this.world.step(timeStep, this.velocityIterations, this.positionIterations);
        }

        int bodiesToDestroy_size = this.bodiesToDestroy.size();
        if (bodiesToDestroy_size>0)
        {
            int n;
            for (n = 0; n < bodiesToDestroy_size; n++)
            {
                rDestroyBody(this.bodiesToDestroy.get(n));
            }
            this.bodiesToDestroy.clear();
        }
        return 0;
    }

    @Override
    public boolean isPaused()
    {
    	return this.bPaused;
    }
    
    @Override
    public boolean condition (int num, CCndExtension cnd)
    {
        return false;
    }

    @Override
    public void action (int num, CActExtension act)
    {
        switch (num)
        {
            case CRunBox2DBase.ACTION_SETGRAVITYFORCE:
                this.RACTION_SETGRAVITYFORCE(act);
                break;
            case CRunBox2DBase.ACTION_SETGRAVITYANGLE:
                this.RACTION_SETGRAVITYANGLE(act);
                break;
            case CRunBox2DBase.ACTION_DJOINTHOTSPOT:
                this.RACTION_DJOINTHOTSPOT(act);
                break;
            case CRunBox2DBase.ACTION_DJOINTACTIONPOINT:
                this.RACTION_DJOINTACTIONPOINT(act);
                break;
            case CRunBox2DBase.ACTION_DJOINTPOSITION:
                this.RACTION_DJOINTPOSITION(act);
                break;
            case CRunBox2DBase.ACTION_RJOINTHOTSPOT:
                this.RACTION_RJOINTHOTSPOT(act);
                break;
            case CRunBox2DBase.ACTION_RJOINTACTIONPOINT:
                this.RACTION_RJOINTACTIONPOINT(act);
                break;
            case CRunBox2DBase.ACTION_RJOINTPOSITION:
                this.RACTION_RJOINTPOSITION(act);
                break;
            case CRunBox2DBase.ACTION_PJOINTHOTSPOT:
                this.RACTION_PJOINTHOTSPOT(act);
                break;
            case CRunBox2DBase.ACTION_PJOINTACTIONPOINT:
                this.RACTION_PJOINTACTIONPOINT(act);
                break;
            case CRunBox2DBase.ACTION_PJOINTPOSITION:
                this.RACTION_PJOINTPOSITION(act);
                break;
            case CRunBox2DBase.ACTION_ADDOBJECT:
                this.RACTION_ADDOBJECT(act);
                break;
            case CRunBox2DBase.ACTION_SUBOBJECT:
                this.RACTION_SUBOBJECT(act);
                break;
            case CRunBox2DBase.ACTION_DJOINTSETELASTICITY:
                this.RACTION_DJOINTSETELASTICITY(act);
                break;
            case CRunBox2DBase.ACTION_RJOINTSETLIMITS:
                this.RACTION_RJOINTSETLIMITS(act);
                break;
            case CRunBox2DBase.ACTION_RJOINTSETMOTOR:
                this.RACTION_RJOINTSETMOTOR(act);
                break;
            case CRunBox2DBase.ACTION_PJOINTSETLIMITS:
                this.RACTION_PJOINTSETLIMITS(act);
                break;
            case CRunBox2DBase.ACTION_PJOINTSETMOTOR:
                this.RACTION_PJOINTSETMOTOR(act);
                break;
            case CRunBox2DBase.ACTION_PUJOINTHOTSPOT:
                this.RACTION_PUJOINTHOTSPOT(act);
                break;
            case CRunBox2DBase.ACTION_PUJOINTACTIONPOINT:
                this.RACTION_PUJOINTACTIONPOINT(act);
                break;
            case CRunBox2DBase.ACTION_DESTROYJOINT:
                this.RACTION_DESTROYJOINT(act);
                break;
            case CRunBox2DBase.ACTION_SETITERATIONS:
                this.RACTION_SETITERATIONS(act);
                break;
            case CRunBox2DBase.ACTION_SETDENSITY:
                this.RACTION_SETDENSITY(act);
                break;
            case CRunBox2DBase.ACTION_SETFRICTION:
                this.RACTION_SETFRICTION(act);
                break;
            case CRunBox2DBase.ACTION_SETELASTICITY:
                this.RACTION_SETELASTICITY(act);
                break;
            case CRunBox2DBase.ACTION_SETGRAVITY:
                this.RACTION_SETGRAVITY(act);
                break;
            case CRunBox2DBase.ACTION_SETPAUSE:
                this.bPaused=true;
                break;
            case CRunBox2DBase.ACTION_SETRESUME:
                this.bPaused=false;
                break;
        }
    }

    @Override
    public CValue expression (int num)
    {
        CValue ret = new CValue(0);
        String pName;
        CJoint pJoint;
        switch (num)
        {
            case CRunBox2DBase.EXPRESSION_GRAVITYSTRENGTH:
                ret.forceDouble(this.gravity);
                break;
            case CRunBox2DBase.EXPRESSION_GRAVITYANGLE:
                ret.forceInt(this.angleBase);
                break;
            case CRunBox2DBase.EXPRESSION_VELOCITYITERATIONS:
                ret.forceInt(this.velocityIterations);
                break;
            case CRunBox2DBase.EXPRESSION_POSITIONITERATIONS:
                ret.forceInt(this.positionIterations);
                break;
            case CRunBox2DBase.EXPRESSION_ELASTICITYFREQUENCY:
            {
                pName = this.ho.getExpParam().getString();
                pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_DISTANCE);
                if (pJoint!=null)
                {
                    ret.forceDouble(((DistanceJoint)pJoint.m_joint).getFrequency());
                }
                break;
            }
            case CRunBox2DBase.EXPRESSION_ELASTICITYDAMPING:
            {
                pName = this.ho.getExpParam().getString();
                pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_DISTANCE);
                if (pJoint!=null)
                {
                    ret.forceDouble(((DistanceJoint)pJoint.m_joint).getDampingRatio()*100);
                }
                break;
            }
            case CRunBox2DBase.EXPRESSION_LOWERANGLELIMIT:
            {
                pName = this.ho.getExpParam().getString();
                pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_REVOLUTE);
                if (pJoint!=null)
                {
                    ret.forceInt((int)(((RevoluteJoint)pJoint.m_joint).getLowerLimit()*180.0f/Math.PI));
                }
                break;
            }
            case CRunBox2DBase.EXPRESSION_UPPERANGLELIMIT:
            {
                pName = this.ho.getExpParam().getString();
                pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_REVOLUTE);
                if (pJoint!=null)
                {
                    ret.forceInt((int)(((RevoluteJoint)pJoint.m_joint).getUpperLimit()*180.0f/Math.PI));
                }
                break;
            }
            case CRunBox2DBase.EXPRESSION_MOTORSTRENGTH:
            {
                pName = this.ho.getExpParam().getString();
                pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_REVOLUTE);
                if (pJoint!=null)
                {
                    ret.forceInt( (int)( ((RevoluteJoint)pJoint.m_joint).getMaxMotorTorque()*100.0f/(CRunBox2DBase.RMOTORTORQUEMULT*this.RunFactor)));
                }
                break;
            }
            case CRunBox2DBase.EXPRESSION_MOTORSPEED:
            {
                pName = this.ho.getExpParam().getString();
                pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_REVOLUTE);
                if (pJoint!=null)
                {
                    ret.forceInt( (int)( ((RevoluteJoint)pJoint.m_joint).getMotorSpeed()*100.0f/(CRunBox2DBase.RMOTORSPEEDMULT*this.RunFactor)));
                }
                break;
            }
            case CRunBox2DBase.EXPRESSION_LOWERTRANSLATION:
            {
                pName = this.ho.getExpParam().getString();
                pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_PRISMATIC);
                if (pJoint!=null)
                {
                    ret.forceInt((int)(((PrismaticJoint)pJoint.m_joint).getLowerLimit()*factor));
                }
                break;
            }
            case CRunBox2DBase.EXPRESSION_UPPERTRANSLATION:
            {
                pName = this.ho.getExpParam().getString();
                pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_PRISMATIC);
                if (pJoint!=null)
                {
                    ret.forceInt((int)(((PrismaticJoint)pJoint.m_joint).getUpperLimit()*factor));
                }
                break;
            }
            case CRunBox2DBase.EXPRESSION_PMOTORSTRENGTH:
            {
                pName = this.ho.getExpParam().getString();
                pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_PRISMATIC);
                if (pJoint!=null)
                {
                    ret.forceInt( (int)( ((PrismaticJoint)pJoint.m_joint).getMotorForce(0)*100/(CRunBox2DBase.PJOINTMOTORFORCEMULT*this.RunFactor)) );
                }
                break;
            }
            case CRunBox2DBase.EXPRESSION_PMOTORSPEED:
            {
                pName = this.ho.getExpParam().getString();
                pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_PRISMATIC);
                if (pJoint!=null)
                {
                    ret.forceInt( (int)( ((PrismaticJoint)pJoint.m_joint).getMotorSpeed()*100/(CRunBox2DBase.PJOINTMOTORSPEEDMULT*this.RunFactor)) );
                }
                break;
            }
        }
        return ret;
    }

    // ACTIONS //////////////////////////////////////////////////////////////////////
    public CRunMBase GetMBase(CObject pHo)
    {
        if (pHo == null)
            return null;
        if (pHo.rom == null || (pHo.hoFlags & CObject.HOF_DESTROYED) != 0)
            return null;
        if (pHo.roc.rcMovementType==CMoveDef.MVTYPE_EXT)
        {
            CMoveDefExtension mvPtr= (CMoveDefExtension)pHo.hoCommon.ocMovements.moveList[pHo.rom.rmMvtNum];
            if (mvPtr.moduleName.equalsIgnoreCase("box2d8directions")
                    || mvPtr.moduleName.equalsIgnoreCase("box2dspring")
                    || mvPtr.moduleName.equalsIgnoreCase("box2dspaceship")
                    || mvPtr.moduleName.equalsIgnoreCase("box2dstatic")
                    || mvPtr.moduleName.equalsIgnoreCase("box2dracecar")
                    || mvPtr.moduleName.equalsIgnoreCase("box2daxial")
                    || mvPtr.moduleName.equalsIgnoreCase("box2dplatform")
                    || mvPtr.moduleName.equalsIgnoreCase("box2dbouncingball")
                    || mvPtr.moduleName.equalsIgnoreCase("box2dbackground")
                    )
            {
                CRunMBase pBase = (CRunMBase)(((CMoveExtension)pHo.rom.rmMovement).movement);
                if (pBase.m_identifier==this.identifier)
                {
                    return pBase;
                }
            }
        }
        return null;
    }

    private void RACTION_SETDENSITY(CActExtension act)
    {
        CObject pHo = act.getParamObject(this.rh, 0);
        CRunMBase pmBase = this.GetMBase(pHo);
        if (pmBase != null)
        {
            pmBase.SetDensity(act.getParamExpression(this.rh, 1));
        }
    }
    private void RACTION_SETFRICTION(CActExtension act)
    {
        CObject pHo = act.getParamObject(this.rh, 0);
        CRunMBase pmBase = this.GetMBase(pHo);
        if (pmBase != null)
        {
            pmBase.SetFriction(act.getParamExpression(this.rh, 1));
        }
    }
    private void RACTION_SETELASTICITY(CActExtension act)
    {
        CObject pHo = act.getParamObject(this.rh, 0);
        CRunMBase pmBase = this.GetMBase(pHo);
        if (pmBase != null)
        {
            pmBase.SetRestitution(act.getParamExpression(this.rh, 1));
        }
    }
    private void RACTION_SETGRAVITY(CActExtension act)
    {
        CObject pHo = act.getParamObject(this.rh, 0);
        CRunMBase pmBase = this.GetMBase(pHo);
        if (pmBase != null)
        {
            pmBase.SetGravity(act.getParamExpression(this.rh, 1));
        }
    }

    private void RACTION_SETITERATIONS(CActExtension act)
    {
        this.velocityIterations=act.getParamExpression(this.rh, 0);
        this.positionIterations=act.getParamExpression(this.rh, 1);
    }

    private void RACTION_SETGRAVITYFORCE(CActExtension act)
    {
        this.gravity=(float)act.getParamExpDouble(this.rh, 0);
        Vector2 gravity= new Vector2((float)(this.gravity*Math.cos(this.angle)), (float)(this.gravity*Math.sin(this.angle)));
        this.world.setGravity(gravity);
    }

    private void RACTION_SETGRAVITYANGLE(CActExtension act)
    {
        this.angleBase=act.getParamExpression(this.rh, 0);
        this.angle=(float)(this.angleBase*Math.PI/180.0);
        Vector2 gravity = new Vector2((float)(this.gravity*Math.cos(this.angle)), (float)(this.gravity*Math.sin(this.angle)));
        this.world.setGravity(gravity);
    }

    private CJoint CreateJoint(String name)
    {
        //int n;
        CJoint pJoint = null;
        pJoint=new CJoint(this, name);
        this.joints.add(pJoint);
        return pJoint;
    }
    private CJoint GetJoint(CJoint sJoint, String name, int type)
    {
        int n;
        CJoint pJoint = null;
        int index = 0;
        if (sJoint != null)
        {
            index = this.joints.indexOf(sJoint);
            if (index < 0)
                return null;
            index++;
        }
        for (n=index; n<this.joints.size(); n++)
        {
            pJoint=this.joints.get(n);
            if (pJoint.m_name.equalsIgnoreCase(name))
            {
                break;
            }
        }
        if (n<this.joints.size())
        {
            if (type==CRunBox2DBase.TYPE_ALL || type==pJoint.m_type)
            {
                return pJoint;
            }
        }
        return null;
    }

    private Vector2 GetActionPointPosition(CRunMBase pBase)
    {
        CObject pHo=pBase.m_pHo;
        int x=pHo.hoX;
        int y=pHo.hoY;
        if ((pHo.hoOEFlags&CObjectCommon.OEFLAG_ANIMATIONS)!=0)
        {
            float angle=(float)(pHo.roc.rcAngle * Math.PI / 180.0f);
            CImage image=this.rh.rhApp.imageBank.getImageFromHandle(pHo.roc.rcImage);
            if(image != null) {
	            int deltaX = image.getXAP()-image.getXSpot();
	            int deltaY = image.getYAP()-image.getYSpot();
	            x += (deltaX * Math.cos(angle) - deltaY * Math.sin(angle));
	            y += (deltaX * Math.sin(angle) + deltaY * Math.cos(angle));
            }
        }
        Vector2 position = new Vector2((float)((this.xBase+x)/this.factor), (float)((this.yBase-y)/this.factor));
        return position;
    }

    private void RACTION_DJOINTHOTSPOT(CActExtension act)
    {
        String name=act.getParamExpString(this.rh, 0);
        CRunMBase pBase1=this.GetMBase(act.getParamObject(this.rh, 1));
        CRunMBase pBase2=this.GetMBase(act.getParamObject(this.rh, 2));
        if (pBase1!=null && pBase2!=null)
        {
            CJoint pJoint=this.CreateJoint(name);
            DistanceJointDef jointdef = new DistanceJointDef();
            jointdef.collideConnected=true;
            jointdef.frequencyHz = 0;
            jointdef.dampingRatio = 0;
            Vector2 position1 = pBase1.m_body.getPosition();
            Vector2 position2 = pBase2.m_body.getPosition();
            jointdef.initialize(pBase1.m_body, pBase2.m_body, position1, position2);
            pJoint.SetJoint(CRunBox2DBase.TYPE_DISTANCE, this.world.createJoint(jointdef));
        }
    }

    private void RACTION_DJOINTACTIONPOINT(CActExtension act)
    {
        String name = act.getParamExpString(this.rh, 0);
        CRunMBase pBase1=this.GetMBase(act.getParamObject(this.rh, 1));
        CRunMBase pBase2=this.GetMBase(act.getParamObject(this.rh, 2));
        if (pBase1!=null && pBase2!=null)
        {
            CJoint pJoint=this.CreateJoint(name);
            DistanceJointDef jointDef = new DistanceJointDef();
            jointDef.collideConnected=true;
            jointDef.frequencyHz = 0;
            jointDef.dampingRatio = 0;
            Vector2 position1=this.GetActionPointPosition(pBase1);
            Vector2 position2=this.GetActionPointPosition(pBase2);
            jointDef.initialize(pBase1.m_body, pBase2.m_body, position1, position2);
            pJoint.SetJoint(CRunBox2DBase.TYPE_DISTANCE, this.world.createJoint(jointDef));
        }
    }

    private void RACTION_DJOINTSETELASTICITY(CActExtension act)
    {
        String pName = act.getParamExpString(this.rh, 0);
        float frequency=(float)act.getParamExpDouble(this.rh, 1);
        float damping=(float)(act.getParamExpression(this.rh, 2)/100.0);
        CJoint pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_DISTANCE);
        while (pJoint!=null)
        {
            DistanceJoint pdJoint=(DistanceJoint)pJoint.m_joint;
            pdJoint.setFrequency(frequency);
            pdJoint.setDampingRatio(damping);
            pJoint=this.GetJoint(pJoint, pName, CRunBox2DBase.TYPE_DISTANCE);
        }
    }

    private Vector2 GetImagePosition(CRunMBase pBase, int x1, int y1)
    {
        Vector2 position=new Vector2(pBase.m_body.getPosition().x, pBase.m_body.getPosition().y);
        position.x+=x1/this.factor;
        position.y-=y1/this.factor;
        return position;
    }

    private void RACTION_DJOINTPOSITION(CActExtension act)
    {
        String name = act.getParamExpString(this.rh, 0);
        CRunMBase pBase1=this.GetMBase(act.getParamObject(this.rh, 1));
        int x1=act.getParamExpression(this.rh, 2);
        int y1=act.getParamExpression(this.rh, 3);
        CRunMBase pBase2=this.GetMBase(act.getParamObject(this.rh, 4));
        int x2=act.getParamExpression(this.rh, 5);
        int y2=act.getParamExpression(this.rh, 6);
        if (pBase1!=null && pBase2!=null)
        {
            CJoint pJoint=this.CreateJoint(name);
            Vector2 position1=this.GetImagePosition(pBase1, x1, y1);
            Vector2 position2=this.GetImagePosition(pBase2, x2, y2);
            DistanceJointDef jointDef=new DistanceJointDef();
            jointDef.collideConnected=true;
            jointDef.initialize(pBase1.m_body, pBase2.m_body, position1, position2);
            pJoint.SetJoint(CRunBox2DBase.TYPE_DISTANCE, this.world.createJoint(jointDef));
        }
    }

    private void RACTION_RJOINTHOTSPOT(CActExtension act)
    {
        String name = act.getParamExpString(this.rh, 0);
        CRunMBase pBase1=this.GetMBase(act.getParamObject(this.rh, 1));
        CRunMBase pBase2=this.GetMBase(act.getParamObject(this.rh, 2));
        if (pBase1!=null && pBase2!=null)
        {
            CJoint pJoint=this.CreateJoint(name);
            RevoluteJointDef jointDef = new RevoluteJointDef();
            jointDef.collideConnected=true;
            Vector2 position=pBase1.m_body.getPosition();
            jointDef.initialize(pBase1.m_body, pBase2.m_body, position);
            pJoint.SetJoint(CRunBox2DBase.TYPE_REVOLUTE, this.world.createJoint(jointDef));
        }
    }

    private void RACTION_RJOINTACTIONPOINT(CActExtension act)
    {
        String name=act.getParamExpString(this.rh, 0);
        CRunMBase pBase1=this.GetMBase(act.getParamObject(this.rh, 1));
        CRunMBase pBase2=this.GetMBase(act.getParamObject(this.rh, 2));
        if (pBase1!=null && pBase2!=null)
        {
            CJoint pJoint=this.CreateJoint(name);
            RevoluteJointDef jointDef = new RevoluteJointDef();
            jointDef.collideConnected=true;
            Vector2 position=this.GetActionPointPosition(pBase1);
            jointDef.initialize(pBase1.m_body, pBase2.m_body, position);
            pJoint.SetJoint(CRunBox2DBase.TYPE_REVOLUTE, this.world.createJoint(jointDef));
        }
    }

    private void RACTION_RJOINTPOSITION(CActExtension act)
    {
        String name=act.getParamExpString(this.rh, 0);
        CRunMBase pBase1=this.GetMBase(act.getParamObject(this.rh, 1));
        int x1=act.getParamExpression(this.rh, 2);
        int y1=act.getParamExpression(this.rh, 3);
        CRunMBase pBase2=this.GetMBase(act.getParamObject(this.rh, 4));
        if (pBase1!=null && pBase2!=null)
        {
            CJoint pJoint=this.CreateJoint(name);
            RevoluteJointDef jointDef = new RevoluteJointDef();
            jointDef.collideConnected=true;
            Vector2 position=this.GetImagePosition(pBase1, x1, y1);
            jointDef.initialize(pBase1.m_body, pBase2.m_body, position);
            pJoint.SetJoint(CRunBox2DBase.TYPE_REVOLUTE, this.world.createJoint(jointDef));
        }
    }

    private void RACTION_RJOINTSETLIMITS(CActExtension act)
    {
        String pName = act.getParamExpString(this.rh, 0);
        float lAngle=(float)(act.getParamExpression(this.rh, 1)*Math.PI/180.0);
        float uAngle=(float)(act.getParamExpression(this.rh, 2)*Math.PI/180.0);
        CJoint pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_REVOLUTE);
        while (pJoint!=null)
        {
            RevoluteJoint prJoint=(RevoluteJoint)pJoint.m_joint;
            //boolean flag=true;
            if (lAngle>uAngle)
                prJoint.enableLimit(false);
            else
            {
                prJoint.enableLimit(true);
                prJoint.setLimits(lAngle, uAngle);
            }
            pJoint=this.GetJoint(pJoint, pName, CRunBox2DBase.TYPE_REVOLUTE);
        }
    }

    private void RACTION_RJOINTSETMOTOR(CActExtension act)
    {
        String pName = act.getParamExpString(this.rh, 0);
        float torque=(float)(act.getParamExpression(this.rh, 1)/100.0*CRunBox2DBase.RMOTORTORQUEMULT*this.RunFactor);
        float speed=(float)(act.getParamExpression(this.rh, 2)/100.0*CRunBox2DBase.RMOTORSPEEDMULT*this.RunFactor);
        CJoint pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_REVOLUTE);
        while (pJoint!=null)
        {
            RevoluteJoint prJoint=(RevoluteJoint)pJoint.m_joint;
            boolean flag=true;
            if (torque==0 && speed==0)
                flag=false;
            prJoint.enableMotor(flag);
            prJoint.setMaxMotorTorque(torque);
            prJoint.setMotorSpeed(-speed);
            pJoint=this.GetJoint(pJoint, pName, CRunBox2DBase.TYPE_REVOLUTE);
        }
    }

    private void RACTION_PJOINTHOTSPOT(CActExtension act)
    {
        String name = act.getParamExpString(this.rh, 0);
        CRunMBase pBase1=this.GetMBase(act.getParamObject(this.rh, 1));
        CRunMBase pBase2=this.GetMBase(act.getParamObject(this.rh, 2));
        if (pBase1!=null && pBase2!=null)
        {
            CJoint pJoint=this.CreateJoint(name);
            PrismaticJointDef jointDef = new PrismaticJointDef();
            jointDef.collideConnected=true;
            Vector2 position1=pBase1.m_body.getPosition();
            Vector2 position2=pBase2.m_body.getPosition();
            Vector2 axis = new Vector2(position2.x-position1.x, position2.y-position1.y);
            jointDef.initialize(pBase1.m_body, pBase2.m_body, position1, axis);
            pJoint.SetJoint(CRunBox2DBase.TYPE_PRISMATIC, this.world.createJoint(jointDef));
        }
    }

    private void RACTION_PJOINTACTIONPOINT(CActExtension act)
    {
        String name = act.getParamExpString(this.rh, 0);
        CRunMBase pBase1=this.GetMBase(act.getParamObject(this.rh, 1));
        CRunMBase pBase2=this.GetMBase(act.getParamObject(this.rh, 2));
        if (pBase1!=null && pBase2!=null)
        {
            CJoint pJoint=this.CreateJoint(name);
            PrismaticJointDef jointDef = new PrismaticJointDef();
            jointDef.collideConnected=true;
            Vector2 position1=this.GetActionPointPosition(pBase1);
            Vector2 position2=this.GetActionPointPosition(pBase2);
            Vector2 axis=new Vector2(position2.x-position1.x, position2.y-position1.y);
            jointDef.initialize(pBase1.m_body, pBase2.m_body, position1, axis);
            pJoint.SetJoint(CRunBox2DBase.TYPE_PRISMATIC, this.world.createJoint(jointDef));
        }
    }

    private void RACTION_PJOINTPOSITION(CActExtension act)
    {
        String name = act.getParamExpString(this.rh, 0);
        CRunMBase pBase1=this.GetMBase(act.getParamObject(this.rh, 1));
        int x1=act.getParamExpression(this.rh, 2);
        int y1=act.getParamExpression(this.rh, 3);
        CRunMBase pBase2=this.GetMBase(act.getParamObject(this.rh, 4));
        int x2=act.getParamExpression(this.rh, 5);
        int y2=act.getParamExpression(this.rh, 6);
        if (pBase1!=null && pBase2!=null)
        {
            CJoint pJoint=this.CreateJoint(name);
            PrismaticJointDef jointDef = new PrismaticJointDef();
            jointDef.collideConnected=true;
            Vector2 position1=this.GetImagePosition(pBase1, x1, y1);
            Vector2 position2=this.GetImagePosition(pBase1, x2, y2);
            Vector2 axis=new Vector2(position2.x-position1.x, position2.y-position1.y);
            jointDef.initialize(pBase1.m_body, pBase2.m_body, position1, axis);
            pJoint.SetJoint(CRunBox2DBase.TYPE_PRISMATIC, this.world.createJoint(jointDef));
        }
    }

    private void RACTION_PJOINTSETLIMITS(CActExtension act)
    {
        String pName = act.getParamExpString(this.rh, 0);
        float lLimit=(float)(act.getParamExpression(this.rh, 1)/this.factor);
        float uLimit=(float)(act.getParamExpression(this.rh, 2)/this.factor);
        CJoint pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_PRISMATIC);
        while (pJoint!=null)
        {
            PrismaticJoint prJoint=(PrismaticJoint)pJoint.m_joint;
            boolean flag=true;
            if (lLimit>uLimit)
                flag=false;
            prJoint.enableLimit(flag);
            prJoint.setLimits(lLimit, uLimit);
            pJoint=this.GetJoint(pJoint, pName, CRunBox2DBase.TYPE_PRISMATIC);
        }
    }

    private void RACTION_PJOINTSETMOTOR(CActExtension act)
    {
        String pName = act.getParamExpString(this.rh, 0);
        float force=(float)(act.getParamExpression(this.rh, 1)/100.0*CRunBox2DBase.PJOINTMOTORFORCEMULT*this.RunFactor);
        float speed=(float)(act.getParamExpression(this.rh, 2)/100.0*CRunBox2DBase.PJOINTMOTORSPEEDMULT*this.RunFactor);
        CJoint pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_PRISMATIC);
        while (pJoint!=null)
        {
            PrismaticJoint prJoint=(PrismaticJoint)pJoint.m_joint;
            boolean flag=true;
            if (force==0 && speed==0)
                flag=false;
            prJoint.enableMotor(flag);
            prJoint.setMaxMotorForce(force);
            prJoint.setMotorSpeed(-speed);
            pJoint=this.GetJoint(pJoint, pName, CRunBox2DBase.TYPE_PRISMATIC);
        }
    }

    private void RACTION_PUJOINTHOTSPOT(CActExtension act)
    {
        String name = act.getParamExpString(this.rh, 0);
        CRunMBase pBase1=this.GetMBase(act.getParamObject(this.rh, 1));
        CRunMBase pBase2=this.GetMBase(act.getParamObject(this.rh, 2));
        if (pBase1!=null && pBase2!=null)
        {
            CJoint pJoint=this.CreateJoint(name);
            PulleyJointDef jointDef = new PulleyJointDef();
            jointDef.collideConnected=true;
            Vector2 position1=pBase1.m_body.getPosition();
            Vector2 position2=pBase2.m_body.getPosition();
            float length1=(float)(act.getParamExpression(this.rh, 3)/this.factor);
            float angle1=(float)(act.getParamExpression(this.rh, 4)*Math.PI/180.0);
            float length2=(float)(act.getParamExpression(this.rh, 5)/this.factor);
            float angle2=(float)(act.getParamExpression(this.rh, 6)*Math.PI/180.0);
            float ratio=(float)(act.getParamExpression(this.rh, 7)/100.0);
            Vector2 rope1=new Vector2((float)(position1.x+length1*Math.cos(angle1)), (float)(position1.y+length1*Math.sin(angle1)));
            Vector2 rope2=new Vector2((float)(position2.x+length2*Math.cos(angle2)), (float)(position2.y+length2*Math.sin(angle2)));
            jointDef.initialize(pBase1.m_body, pBase2.m_body, rope1, rope2, position1, position2, ratio);
            pJoint.SetJoint(CRunBox2DBase.TYPE_PULLEY, this.world.createJoint(jointDef));
        }
    }

    private void RACTION_PUJOINTACTIONPOINT(CActExtension act)
    {
        String name = act.getParamExpString(this.rh, 0);
        CRunMBase pBase1=this.GetMBase(act.getParamObject(this.rh, 1));
        CRunMBase pBase2=this.GetMBase(act.getParamObject(this.rh, 2));
        if (pBase1!=null && pBase2!=null)
        {
            CJoint pJoint=this.CreateJoint(name);
            PulleyJointDef jointDef = new PulleyJointDef();
            jointDef.collideConnected=true;
            Vector2 position1=this.GetActionPointPosition(pBase1);
            Vector2 position2=this.GetActionPointPosition(pBase2);
            float length1=(float)(act.getParamExpression(this.rh, 3)/this.factor);
            float angle1=(float)(act.getParamExpression(this.rh, 4)*Math.PI/180.0);
            float length2=(float)(act.getParamExpression(this.rh, 5)/this.factor);
            float angle2=(float)(act.getParamExpression(this.rh, 6)*Math.PI/180.0);
            float ratio=(float)(act.getParamExpression(this.rh, 7)/100.0);
            Vector2 rope1=new Vector2((float)(position1.x+length1*Math.cos(angle1)), (float)(position1.y+length1*Math.sin(angle1)));
            Vector2 rope2=new Vector2((float)(position2.x+length2*Math.cos(angle2)), (float)(position2.y+length2*Math.sin(angle2)));
            jointDef.initialize(pBase1.m_body, pBase2.m_body, rope1, rope2, position1, position2, ratio);
            pJoint.SetJoint(CRunBox2DBase.TYPE_PULLEY, this.world.createJoint(jointDef));
        }
    }

    private void RACTION_DESTROYJOINT(CActExtension act)
    {
        String pName = act.getParamExpString(this.rh, 0);
        int n;
        int joints_size = this.joints.size();
        for (n=0; n < joints_size; n++)
        {
            CJoint pJoint=this.joints.get(n);
            if (pJoint != null && pJoint.m_name.equalsIgnoreCase(pName))
            {
                this.world.destroyJoint(pJoint.m_joint);
                this.joints.remove(n);
                joints_size = this.joints.size();
                n--;
            }
        }
    }

    private void destroyJointsWithBody(Body body)
    {
        int n;
        int joints_size = this.joints.size();
        for (n=0; n < joints_size; n++)
        {
            CJoint pJoint=this.joints.get(n);
            if (pJoint != null && (pJoint.m_joint.getBodyA() == body || pJoint.m_joint.getBodyB() == body))
            {
                this.joints.remove(n);
                joints_size = this.joints.size();
                n--;
            }
        }
    }

    public void rAddNormalObject(CObject pHo)
    {
        if ((this.flags & CRunBox2DBase.B2FLAG_ADDOBJECTS)!=0)
        {
            if (this.objects.indexOf(pHo) < 0)
            {
                if (pHo.rom != null && pHo.roa != null && this.GetMBase(pHo)==null)
                {
                    CRunMBase pBase = new CRunMBase();
                    pBase.InitBase(pHo, CRunMBase.MTYPE_FAKEOBJECT);
                    float angle = (float)(getAnimDir(pHo, pHo.roc.rcDir) * 11.25);
                    pBase.m_body = this.rCreateBody(BodyDef.BodyType.StaticBody, pHo.hoX, pHo.hoY, angle, 0, pBase, 0, 0);
                    this.rBodyCreateShapeFixture(pBase.m_body, pBase, pHo.hoX, pHo.hoY, pHo.roc.rcImage, this.npDensity, this.npFriction, 0, pHo.roc.rcScaleX, pHo.roc.rcScaleY);
                    this.objects.add(pBase);
                    this.objectIDs.add((pHo.hoCreationId << 16) | (pHo.hoNumber & 0xFFFF));
                }
            }
        }
    }

    public Body rAddABackdrop(int x, int y, short img, short obstacleType)
    {
        if ((this.flags & CRunBox2DBase.B2FLAG_ADDBACKDROPS)!=0)
        {
            CImage image = this.rh.rhApp.imageBank.getImageFromHandle(img);
            CRunMBase mBase = new CRunMBase();
            if (obstacleType==COC.OBSTACLE_SOLID)
                mBase.m_type = CRunMBase.MTYPE_OBSTACLE;
            else
                mBase.m_type = CRunMBase.MTYPE_PLATFORM;
            mBase.m_body = this.rCreateBody(BodyDef.BodyType.StaticBody, x + image.getWidth() / 2, y + image.getHeight() / 2, 0, 0, mBase, 0, 0);
            this.rBodyCreateShapeFixture(mBase.m_body, mBase, x+image.getWidth()/2, y+image.getHeight()/2, img, -1, this.friction, this.restitution, 1.0f, 1.0f);
            return mBase.m_body;
        }
        return null;
    }

    public void rSubABackdrop(Body body)
    {
        this.world.destroyBody(body);
    }

    private void RACTION_ADDOBJECT(CActExtension act)
    {
        CObject pHo=act.getParamObject(this.rh, 0);
        if (this.objects.indexOf(pHo)<0)
        {
            if (pHo.rom != null && pHo.roa != null && this.GetMBase(pHo) == null)
            {
                CRunMBase pBase = new CRunMBase();
                pBase.InitBase(pHo, CRunMBase.MTYPE_FAKEOBJECT);
                float angle = (float)(getAnimDir(pHo, pHo.roc.rcDir) * 11.25);
                float density = (float)(act.getParamExpression(this.rh, 1) / 100.0);
                float friction = (float)(act.getParamExpression(this.rh, 2) / 100.0);
                int shape = act.getParamExpression(this.rh, 3);;
                pBase.m_body = this.rCreateBody(BodyDef.BodyType.StaticBody, pHo.hoX, pHo.hoY, angle, 0, pBase, 0, 0);
                switch (shape)
                {
                    case 0:
                        this.rBodyCreateBoxFixture(pBase.m_body, pBase, pHo.hoX, pHo.hoY, pHo.hoImgWidth, pHo.hoImgHeight, density, friction, 0);
                        break;
                    case 1:
                        this.rBodyCreateCircleFixture(pBase.m_body, pBase, pHo.hoX, pHo.hoY, pHo.hoImgWidth / 4, density, friction, 0);
                        break;
                    default:
                        this.rBodyCreateShapeFixture(pBase.m_body, pBase, pHo.hoX, pHo.hoY, pHo.roc.rcImage, density, friction, 0, pHo.roc.rcScaleX, pHo.roc.rcScaleY);
                        break;
                }
                this.objects.add(pBase);
                this.objectIDs.add((pHo.hoCreationId << 16) | (pHo.hoNumber & 0xFFFF));
            }
        }
    }

    private void RACTION_SUBOBJECT(CActExtension act)
    {
        CObject pHo=act.getParamObject(this.rh, 0);
        int n=this.objects.indexOf(pHo);
        if (n>=0)
        {
            CRunMBase mBase=this.objects.get(n);
            this.rDestroyBody(mBase.m_body);
            this.objects.remove(n);
            this.objectIDs.remove(n);
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Build 283.2: add fans, treadmills and magnet to engine - Yves
    // Build 283.2 Change for performance
    public void AddPhysicsAttractor(CObject pHo)
    {
     		int nObjects=rh.rhNObjects;
    		CObject[] localObjectList =rh.rhObjectList;
    		for (CObject pObject : localObjectList)
    		{
    			if (pObject != null) {
	    			--nObjects;
	    			if(pObject.hoType>=32 && pObject.hoCommon.ocIdentifier == CRun.BASEIDENTIFIER)
	    			{
	    				CRunBaseParent pBase;
	    				if (pHo.hoCommon.ocIdentifier==CRun.FANIDENTIFIER)
	    				{
	    					pBase = (CRunBaseParent)((CExtension)pHo).ext;
	    					if (pBase.identifier == identifier)
	    						this.fans.add(pBase);
	    				}
	    				if (pHo.hoCommon.ocIdentifier==CRun.MAGNETIDENTIFIER)
	    				{
	    					pBase = (CRunBaseParent)((CExtension)pHo).ext;
	    					if (pBase.identifier == identifier)
	    						this.magnets.add(pBase);
	    				}
	    				if (pHo.hoCommon.ocIdentifier==CRun.TREADMILLIDENTIFIER)
	    				{
	    					pBase = (CRunBaseParent)((CExtension)pHo).ext;
	    					if (pBase.identifier == identifier)
	    						this.treadmills.add(pBase);
	    				}
	    				if (pHo.hoCommon.ocIdentifier==CRun.ROPEANDCHAINIDENTIFIER)
	    				{
	    					pBase = (CRunBaseParent)((CExtension)pHo).ext;
	    					if (pBase.identifier == identifier)
	    						this.ropes.add(pBase);
	    				}
	    			}
	    			if(nObjects == 0)
	    				break;
    			}
    		}

    		// Object added to base list, now add the physical objects to the fan/treadmill/magnet list
	    	if (pHo.hoCommon.ocIdentifier!=CRun.ROPEANDCHAINIDENTIFIER)
			{
    			nObjects=rh.rhNObjects;
        		for (CObject pObjActive : localObjectList)	
    			{
    				if (pObjActive != null) {
    				--nObjects;
    				if( pObjActive.hoType == COI.OBJ_SPR  && (this.flags & CRunBox2DBase.B2FLAG_ADDOBJECTS)!=0 )
    				{
    					CRunMBase pBase = this.GetMBase(pObjActive);

    					if (pBase != null)
    					{
    					
    						if (pHo.hoCommon.ocIdentifier == CRun.FANIDENTIFIER)
    							this.fans.get(this.fans.size()-1).rAddObject(pBase);
    						else if (pHo.hoCommon.ocIdentifier == CRun.TREADMILLIDENTIFIER)
    							this.treadmills.get(this.treadmills.size()-1).rAddObject(pBase);
    						else if (pHo.hoCommon.ocIdentifier == CRun.MAGNETIDENTIFIER)
    							this.magnets.get(this.magnets.size()-1).rAddObject(pBase);

    					}
    				}
    				if(nObjects == 0)
    					break;
    				}
    			}
			}
     }

    /////////////////////////////////////////////////////////////////////////////////
    // Build 283.2 Change for performance
    private void GetObjects()
    {
        fans.clear();
        treadmills.clear();
        magnets.clear();
        ropes.clear();

        int nObjects=rh.rhNObjects;
		CObject[] localObjectList =rh.rhObjectList;
		for (CObject pObject : localObjectList)
        {
            if (pObject != null) {
	            --nObjects;
	            if(pObject.hoType>=32)
	            {
	                CRunBaseParent pBase;
	                if (pObject.hoCommon.ocIdentifier==FANIDENTIFIER)
	                {
	                    pBase = (CRunBaseParent)((CExtension)pObject).ext;
	                    if (pBase.identifier == identifier)
	                        this.fans.add(pBase);
	                }
	                if (pObject.hoCommon.ocIdentifier==MAGNETIDENTIFIER)
	                {
	                    pBase = (CRunBaseParent)((CExtension)pObject).ext;
	                    if (pBase.identifier == identifier)
	                        this.magnets.add(pBase);
	                }
	                if (pObject.hoCommon.ocIdentifier==TREADMILLIDENTIFIER)
	                {
	                    pBase = (CRunBaseParent)((CExtension)pObject).ext;
	                    if (pBase.identifier == identifier)
	                        this.treadmills.add(pBase);
	                }
	                if (pObject.hoCommon.ocIdentifier==ROPEANDCHAINIDENTIFIER)
	                {
	                    pBase = (CRunBaseParent)((CExtension)pObject).ext;
	                    if (pBase.identifier == identifier)
	                        this.ropes.add(pBase);
	                }
	            }
	            if(nObjects == 0)
	            	break;
            }
        }
    }

    public Joint rJointCreate(CRunMBase pMBase1, short jointType, short jointAnchor, String jointName, String jointObject, float param1, float param2)
    {
        if (jointType == CRunBox2DBase.JTYPE_NONE)
            return null;

        int nObjects = rh.rhNObjects;
        CRunMBase pMBase2 = null;
        double distance = 10000000;
		CObject[] localObjectList =rh.rhObjectList;
		for (CObject pObject : localObjectList)
        {
            if (pObject != null) {
	            --nObjects;
	            if(pObject.hoOiList.oilName.equalsIgnoreCase(jointObject))
	            {
	                CRunMBase pMBaseObject = this.GetMBase(pObject);
	                if (pMBaseObject != null)
	                {
	                    int deltaX = pMBaseObject.m_pHo.hoX - pMBase1.m_pHo.hoX;
	                    int deltaY = pMBaseObject.m_pHo.hoY - pMBase1.m_pHo.hoY;
	                    double d = Math.sqrt(deltaX * deltaX + deltaY * deltaY);
	                    if (d <= distance)
	                    {
	                        distance = d;
	                        pMBase2 = pMBaseObject;
	                    }
	                }
	            }
	            if(nObjects == 0)
	            	break;
            }
        }
        if (pMBase2 != null)
        {
            CJoint pJoint = this.CreateJoint(jointName);
            if (pJoint != null)
            {
                switch (jointType)
                {
                    case CRunBox2DBase.JTYPE_REVOLUTE:
                    {
                        RevoluteJointDef jointDef = new RevoluteJointDef();
                        jointDef.collideConnected=true;
                        if (param1 > param2)
                            jointDef.enableLimit = false;
                        else
                        {
                            jointDef.enableLimit = true;
                            jointDef.lowerAngle = param1;
                            jointDef.upperAngle = param2;
                        }
                        Vector2 position = null;
                        switch (jointAnchor)
                        {
                            case CRunBox2DBase.JANCHOR_HOTSPOT:
                                position=pMBase1.m_body.getPosition();
                                break;
                            case CRunBox2DBase.JANCHOR_ACTIONPOINT:
                                position=this.GetActionPointPosition(pMBase1);
                                break;
                        }
                        jointDef.initialize(pMBase1.m_body, pMBase2.m_body, position);
                        pJoint.SetJoint(CRunBox2DBase.TYPE_REVOLUTE, this.world.createJoint(jointDef));
                        return pJoint.m_joint;
                    }
                    case CRunBox2DBase.JTYPE_DISTANCE:
                    {
                        DistanceJointDef jointDef = new DistanceJointDef();
                        jointDef.collideConnected=true;
                        jointDef.frequencyHz = param1;
                        jointDef.dampingRatio = param2;
                        Vector2 position1 = null;
                        Vector2 position2 = null;
                        switch (jointAnchor)
                        {
                            case CRunBox2DBase.JANCHOR_HOTSPOT:
                                position1=pMBase1.m_body.getPosition();
                                position2=pMBase2.m_body.getPosition();
                                break;
                            case CRunBox2DBase.JANCHOR_ACTIONPOINT:
                                position1=this.GetActionPointPosition(pMBase1);
                                position2=this.GetActionPointPosition(pMBase2);
                                break;
                        }
                        jointDef.initialize(pMBase1.m_body, pMBase2.m_body, position1, position2);
                        pJoint.SetJoint(CRunBox2DBase.TYPE_DISTANCE, this.world.createJoint(jointDef));
                        return pJoint.m_joint;
                    }
                    case CRunBox2DBase.JTYPE_PRISMATIC:
                    {
                        PrismaticJointDef jointDef = new PrismaticJointDef();
                        jointDef.collideConnected=true;
                        if (param1 > param2)
                            jointDef.enableLimit = false;
                        else
                        {
                            jointDef.enableLimit = true;
                            jointDef.lowerTranslation = param1 / this.factor;
                            jointDef.upperTranslation = param2 / this.factor;
                        }
                        Vector2 position1 = null;
                        Vector2 position2 = null;
                        switch (jointAnchor)
                        {
                            case CRunBox2DBase.JANCHOR_HOTSPOT:
                                position1=pMBase1.m_body.getPosition();
                                position2=pMBase2.m_body.getPosition();
                                break;
                            case CRunBox2DBase.JANCHOR_ACTIONPOINT:
                                position1=this.GetActionPointPosition(pMBase1);
                                position2=this.GetActionPointPosition(pMBase2);
                                break;
                        }
                        Vector2 axis = new Vector2(position2.x-position1.x, position2.y-position1.y);
                        jointDef.initialize(pMBase1.m_body, pMBase2.m_body, position1, axis);
                        pJoint.SetJoint(CRunBox2DBase.TYPE_PRISMATIC, this.world.createJoint(jointDef));
                        return pJoint.m_joint;
                    }
                }
            }
        }
        return null;
    }

    public void rWorldToFrame(Vector2 pVec)
    {
        pVec.x=(float)((pVec.x*this.factor)-this.xBase);
        pVec.y=(float)(this.yBase-(pVec.y*this.factor));
    }

    public void rFrameToWorld(Vector2 pVec)
    {
        pVec.x=(float)((this.xBase+pVec.x)/this.factor);
        pVec.y=(float)((this.yBase-pVec.y)/this.factor);
    }

    public int getAnimDir(CObject pHo, int dir)
    {
        CRAni raPtr = pHo.roa;

        CAnimDir adPtr = raPtr.raAnimOffset.anDirs[dir];
        if (adPtr != null)
            return dir;

        if ((raPtr.raAnimOffset.anAntiTrigo[dir] & 0x40) != 0)
            dir = raPtr.raAnimOffset.anAntiTrigo[dir] & 0x3F;
        else if ((raPtr.raAnimOffset.anTrigo[dir] & 0x40) != 0)
            dir = raPtr.raAnimOffset.anTrigo[dir] & 0x3F;
        else
        {
            int offset = dir;
            if (raPtr.raAnimPreviousDir < 0)
                dir = raPtr.raAnimOffset.anTrigo[dir] & 0x3F;
            else
            {
                dir -= raPtr.raAnimPreviousDir;
                dir &= 31;
                if (dir > 15)
                    dir = raPtr.raAnimOffset.anTrigo[offset] & 0x3F;
                else
                    dir = raPtr.raAnimOffset.anAntiTrigo[offset] & 0x3F;
            }
        }
        return dir;
    }
    public Body rCreateBody(BodyDef.BodyType type, int x, int y, float angle, float gravity, CRunMBase pBase, int flags, float deceleration)
    {
        if (pBase != null && type != BodyDef.BodyType.StaticBody && pBase.m_type!= CRunMBase.MTYPE_PLATFORM && pBase.m_type!= CRunMBase.MTYPE_OBSTACLE)
        {
            int n;
            int fans_size = this.fans.size();
            int treadmills_size = this.treadmills.size();
            int magnets_size = this.magnets.size();
            
            for (n=0; n < fans_size; n++)
                this.fans.get(n).rAddObject(pBase);
            for (n=0; n < treadmills_size; n++)
                this.treadmills.get(n).rAddObject(pBase);
            for (n=0; n < magnets_size; n++)
                this.magnets.get(n).rAddObject(pBase);
        }

        BodyDef bodyDef = new BodyDef();
        bodyDef.type = type;
        bodyDef.position.set((this.xBase+x)/this.factor, (this.yBase-y)/this.factor);
        bodyDef.angle = (float)((angle * Math.PI) / 180.0);
        bodyDef.gravityScale = gravity;
        bodyDef.linearDamping = 0.001f;
        bodyDef.angularDamping= 0.001f;
        if ((flags & CBFLAG_FIXEDROTATION) != 0)
            bodyDef.fixedRotation=true;
        if ((flags & CBFLAG_BULLET) != 0)
            bodyDef.bullet=true;
        if ((flags & CBFLAG_DAMPING) != 0)
            bodyDef.linearDamping=deceleration;

        Body pBody = this.world.createBody(bodyDef);
        pBody.setUserData(pBase);

        return pBody;
    }

    public void rDestroyBody(Body pBody)
    {
		if(!this.bListener)	
			this.world.setContactListener(this.contactListener);
		
        if (this.contactListener.bWorking)
        {
            this.bodiesToDestroy.add(pBody);
            return;
        }

        CRunMBase pBase = (CRunMBase)pBody.getUserData();
        if (pBase != null)
		{
			if (pBase.m_type!= CRunMBase.MTYPE_PLATFORM && pBase.m_type!= CRunMBase.MTYPE_OBSTACLE)
			{
				int n;
				int fans_size = this.fans.size();
				int treadmills_size = this.treadmills.size();
				int magnets_size = this.magnets.size();
				int ropes_size = this.ropes.size();
            
				for (n=0; n < fans_size; n++)
					this.fans.get(n).rRemoveObject(pBase);
				for (n=0; n < treadmills_size; n++)
					this.treadmills.get(n).rRemoveObject(pBase);
				for (n=0; n < magnets_size; n++)
					this.magnets.get(n).rRemoveObject(pBase);
				for (n=0; n < ropes_size; n++)
					this.ropes.get(n).rRemoveObject(pBase);

			}
            pBody.setUserData(null);
		}
        destroyJointsWithBody(pBody);
        rBodyStopForce(pBody);
        rBodyStopTorque(pBody);
        if(pBody != null)
        	this.world.destroyBody(pBody);
        
		if(!this.bListener)	
			this.world.setContactListener(null);
		
    }

    public Fixture rBodyCreateBoxFixture(Body pBody, CRunMBase pMBase, int x, int y, int sx, int sy, float density, float friction, float restitution)
    {
        PolygonShape box = new PolygonShape();
        sx-=1;
        sy-=1;
        if (pMBase != null)
        {
            pMBase.rc.left = - sx / 2;
            pMBase.rc.right = sx / 2;
            pMBase.rc.top = - sy / 2;
            pMBase.rc.bottom = sy / 2;
        }

        Vector2 vect = new Vector2((float)((this.xBase + x) / this.factor), (float)((this.yBase - (y)) / this.factor));
        box.setAsBox((float)(sx/2.0/this.factor), (float)(sy/2.0/this.factor), pBody.getLocalPoint(vect), 0);

        FixtureDef fixtureDef = new FixtureDef();
        fixtureDef.shape = box;
        fixtureDef.density = density;
        fixtureDef.friction = friction;
        fixtureDef.restitution=restitution;
        Fixture pFixture = pBody.createFixture(fixtureDef);
        pFixture.setUserData(this);
        return pFixture;
    }

    public Fixture rBodyCreateCircleFixture(Body pBody, CRunMBase pMBase, int x, int y, int radius, float density, float friction, float restitution)
    {
        if (pMBase != null)
        {
            pMBase.rc.left = - radius;
            pMBase.rc.right = radius;
            pMBase.rc.top = - radius;
            pMBase.rc.bottom = radius;
        }

        CircleShape circle = new CircleShape();
        circle.setRadius(radius/this.factor);
        Vector2 vect = new Vector2((float)((this.xBase+x)/this.factor), (float)((this.yBase-y)/this.factor));
        Vector2 local=pBody.getLocalPoint(vect);
        circle.setPosition(local);

        FixtureDef fixtureDef = new FixtureDef();
        fixtureDef.shape = circle;
        fixtureDef.density = density;
        fixtureDef.friction = friction;
        fixtureDef.restitution=restitution;
        Fixture pFixture = pBody.createFixture(fixtureDef);
        pFixture.setUserData(this);
        return pFixture;
    }

    public Joint rCreateDistanceJoint(Body pBody1, Body pBody2, float dampingRatio, float frequency, int x, int y)
    {
        Vector2 position1 = new Vector2(pBody1.getPosition().x, pBody1.getPosition().y);
        position1.x+=x/this.factor;
        position1.y+=y/this.factor;
        Vector2 position2 = new Vector2(pBody2.getPosition().x, pBody2.getPosition().y);
        DistanceJointDef JointDef = new DistanceJointDef();
        JointDef.collideConnected = true;
        JointDef.frequencyHz=frequency;
        JointDef.dampingRatio=dampingRatio;
        JointDef.initialize(pBody1, pBody2, position1, position2);
        return this.world.createJoint(JointDef);
    }
    public void rBodyApplyForce(Body pBody, float force, float angle)
    {
        Vector2 f = new Vector2( (float)(force * Math.cos(angle * Math.PI / 180.0)), (float)(force * Math.sin(angle * Math.PI / 180.0)));
        int n;
        CForce cForce;
        int forces_size = this.forces.size();
        for (n=0; n<forces_size; n++)
        {
            cForce = this.forces.get(n);
            if (cForce != null && cForce.m_body == pBody)
            {
                cForce.m_force = f;
                return;
            }
        }
        cForce = new CForce(pBody, f);
        this.forces.add(cForce);
    }

    public void rBodyStopForce(Body pBody)
    {
        int n;
        CForce cForce;
        int forces_size = this.forces.size();
        for (n=0; n<forces_size; n++)
        {
            cForce = this.forces.get(n);
            if (cForce != null && cForce.m_body == pBody)
            {
                cForce.m_body.applyForceToCenter(new Vector2(0,0));
                this.forces.remove(n);
                break;
            }
        }
    }

    public void rBodyApplyAngularImpulse(Body pBody, float torque)
    {
        pBody.setAngularVelocity(torque * 100 / 0.375391f);
    }
    public void rBodyApplyTorque(Body pBody, float torque)
    {
        int n;
        CTorque cTorque;
        int torques_size = this.torques.size();
        for (n=0; n<torques_size; n++)
        {
            cTorque = this.torques.get(n);
            if (cTorque != null && cTorque.m_body == pBody)
            {
                cTorque.m_torque = torque;
                return;
            }
        }
        cTorque = new CTorque(pBody, torque);
        this.torques.add(cTorque);
    }
    public void rBodyStopTorque(Body pBody)
    {
        int n;
        CTorque cTorque;
        int torques_size = this.torques.size();
        for (n=0; n<torques_size; n++)
        {
            cTorque = this.torques.get(n);
            if (cTorque != null && cTorque.m_body == pBody)
            {
            	this.torques.remove(n);
                break;
            }
        }
    }

    public void rRJointSetLimits(RevoluteJoint pJoint, int angle1, int angle2)
    {
        float lAngle=(float)((float)angle1*Math.PI/180.0);
        float uAngle=(float)((float)angle2*Math.PI/180.0);
        if (lAngle>uAngle)
        {
            pJoint.enableLimit(false);
        }
        else
        {
            pJoint.enableLimit(true);
            pJoint.setLimits(lAngle, uAngle);
        }
    }

    public void rRJointSetMotor(RevoluteJoint pJoint, int t, int s)
    {
        float torque=(float)t/100.0f*CRunBox2DBase.RMOTORTORQUEMULT*this.RunFactor;
        float speed=(float)s/100.0f*CRunBox2DBase.RMOTORSPEEDMULT*this.RunFactor;
        boolean flag=true;
        if (torque==0 && speed==0)
            flag=false;
        pJoint.enableMotor(flag);
        pJoint.setMaxMotorTorque(torque);
        pJoint.setMotorSpeed(speed);
    }

    public RevoluteJoint rWorldCreateRevoluteJoint(RevoluteJointDef jointDef, Body body1, Body body2, Vector2 position)
    {
        jointDef.initialize(body1, body2, position);
        return (RevoluteJoint)this.world.createJoint(jointDef);
    }

    public void rBodySetAngularVelocity(Body pBody, float torque)
    {
        pBody.setAngularVelocity(torque);
    }
    public void rBodyAddVelocity(Body pBody, float vx, float vy)
    {
        Vector2 velocity=pBody.getLinearVelocity();
        velocity.x+=vx;
        velocity.y+=vy;
        pBody.setLinearVelocity(velocity);
    }
    public void rBodyApplyMMFImpulse(Body pBody, float force, float angle)
    {
        Vector2 f = new Vector2((float)(force * Math.cos(angle * Math.PI / 180.0)), (float)(force * Math.sin(angle * Math.PI / 180.0)));
        Vector2 velocity=pBody.getLinearVelocity();
        velocity.x+=f.x/pBody.getMass();
        velocity.y+=f.y/pBody.getMass();
        pBody.setLinearVelocity(velocity);
    }
    public void rBodyApplyImpulse(Body pBody, float force, float angle)
    {
        Vector2 position = new Vector2(pBody.getPosition().x, pBody.getPosition().y);
        Vector2 f = new Vector2((float)(force * Math.cos(angle * Math.PI / 180.0)), (float)(force * Math.sin(angle * Math.PI / 180.0)));
        pBody.applyLinearImpulse(f, position);
    }
    public float rBodyGetAngle(Body body)
    {
        return (float)(body.getAngle() * 180.0 / Math.PI);
    }
    public void rBodySetPosition(Body pBody, int x, int y)
    {
        float angle=pBody.getAngle();
        Vector2 position = new Vector2(pBody.getPosition().x, pBody.getPosition().y);
        if (x!=POSDEFAULT)
            position.x=(this.xBase+x)/this.factor;
        if (y!=POSDEFAULT)
            position.y=(this.yBase-y)/this.factor;
        pBody.setTransform(position, angle);
    }
    public void rBodySetAngle(Body pBody, float angle)
    {
        Vector2 position = new Vector2(pBody.getPosition().x, pBody.getPosition().y);
        pBody.setTransform(position, (float)(angle * Math.PI / 180.0));
    }
    public void rBodySetLinearVelocity(Body pBody, float force, float angle)
    {
        Vector2 f = new Vector2((float)(force * Math.cos(angle * Math.PI / 180.0)), (float)(force * Math.sin(angle * Math.PI / 180.0)));
        pBody.setLinearVelocity(f);
    }

    public void rBodyAddLinearVelocity(Body pBody, float speed, float angle)
    {
        Vector2 v = new Vector2((float)(speed * Math.cos(angle * Math.PI / 180.0)), (float)(speed * Math.sin(angle * Math.PI / 180.0)));
        Vector2 velocity=pBody.getLinearVelocity();
        velocity.x+=v.x;
        velocity.y+=v.y;
        pBody.setLinearVelocity(velocity);
    }
    public void rBodySetLinearVelocityAdd(Body pBody, float force, float angle, float vx, float vy)
    {
        Vector2 f = new Vector2((float)(force * Math.cos(angle * Math.PI/ 180.0) + vx), (float)(force * Math.sin(angle * Math.PI/ 180.0) + vy));
        pBody.setLinearVelocity(f);
    }
//    public Boolean isPoint(CMask pMask, int x, int y)
//    {
//        return pMask.testPoint(x, y);
//    }
//    public Boolean PointOK(int xNew, int yNew, int xOld, int yOld, CPointTest angle)
//    {
//        int deltaX=xNew-xOld;
//        int deltaY=yNew-yOld;
//        float a=angle.angle;
//        angle.angle=(float)(Math.atan2(deltaY, deltaX)*57.2957795);
//        if (a==angle.angle)
//            return false;
//        return true;
//    }
    public Fixture rBodyCreateShapeFixture(Body pBody, CRunMBase pMBase, int xp, int yp, short img, float density, float friction, float restitution, float scaleX, float scaleY)
    {
        CImage image = this.rh.rhApp.imageBank.getImageFromHandle(img);
        int width = image.getWidth();
        int height = image.getHeight();

		CImageShape shape = null;
		int nshape;
		int nshapes = this.rh.rhApp.imageShapes.size();
		for (nshape=0; nshape<nshapes; nshape++)
		{
			CImageShape shape1 = this.rh.rhApp.imageShapes.get(nshape);
			if ( shape1.image == img )
			{
				shape = shape1;
				//Log.Log("Saved shape!");
				break;
			}
		}
		if ( shape == null )
		{
			shape = new CImageShape();
			shape.CreateShape(this.rh.rhApp.imageBank, img);
			//Log.Log("Created shape!");
		}

		if (pMBase != null)
		{
			pMBase.rc.left = - width / 2;
			pMBase.rc.right = width / 2;
			pMBase.rc.top = - height/ 2;
			pMBase.rc.bottom = height / 2;
		}

		boolean bBackground = false;
		if (density < 0)
		{
			density = 0;
			bBackground = true;
		}

		int count = shape.count;
		if ( count == 0 )
			return this.rBodyCreateBoxFixture(pBody, pMBase, xp, yp, width, height, density, friction, restitution);

		//Log.Log("Shape count: " + count);
		//Log.Log("Shape width: " + width);
		//Log.Log("Shape height: " + height);
		//Log.Log("Shape xArray: " + Arrays.toString(shape.xArray));
		//Log.Log("Shape yArray: " + Arrays.toString(shape.yArray));

        int n;
        float xMiddle = 0;
        float yMiddle = 0;
        if (!bBackground)
        {
            for (n = 0; n < count; n++)
            {
                xMiddle += shape.xArray[n];
                yMiddle += shape.yArray[n];
            }
            xMiddle /= count;
            yMiddle /= count;
        }
        else
        {
            xMiddle = width / 2;
            yMiddle = height / 2;
        }
		final float scaleError = 1.0f;    //((float)height - 2.0f) / (float)height;
        Vector2 vertices[] = new Vector2[count];
        for (n=0; n<count; n++)
        {
            vertices[n] = new Vector2((float)((shape.xArray[n]-xMiddle)/this.factor*scaleX*scaleError), (float)((yMiddle-shape.yArray[n])/this.factor*scaleY*scaleError));
        }

        PolygonShape polygon = new PolygonShape();
        EdgeShape edge = new EdgeShape();
        FixtureDef fixtureDef = new FixtureDef();
        if (count > 2)
        {
            polygon.set(vertices);
            fixtureDef.shape = polygon;
        }
        else if (count == 2)
        {
            edge.set(vertices[0], vertices[1]);
            fixtureDef.shape = edge;
        }
        else
            return this.rBodyCreateBoxFixture(pBody, pMBase, xp, yp, width, height, density, friction, restitution);

        fixtureDef.density = density;
        fixtureDef.friction = friction;
        fixtureDef.restitution=restitution;
        Fixture pFixture = pBody.createFixture(fixtureDef);
        pFixture.setUserData(this);
        return pFixture;
    }

    public Body rCreateBullet(float angle, float speed, CRunMBase pMBase)
    {
    	if ((flags & CRunBox2DBase.B2FLAG_BULLETCREATE)==0)
            return null;

        CObject hoPtr=pMBase.m_pHo;

        BodyDef bodyDef = new BodyDef();
        bodyDef.type = BodyDef.BodyType.DynamicBody;
        bodyDef.position.set((float)(this.xBase+hoPtr.hoX)/this.factor, (float)(this.yBase-hoPtr.hoY)/this.factor);
        bodyDef.angle = (float)(angle * Math.PI / 180.0);
        bodyDef.gravityScale=this.bulletGravity;
        bodyDef.angularDamping = 0.01f;
        bodyDef.linearDamping = 0.0f;

        Body pBody=this.world.createBody(bodyDef);
        pBody.setUserData(pMBase);

        this.rBodyCreateShapeFixture(pBody, pMBase, hoPtr.hoX, hoPtr.hoY, hoPtr.roc.rcImage, this.bulletDensity, this.bulletFriction, this.bulletRestitution, 1.0f, 1.0f);

        //speed *= (0.4f/this.RunFactor);
        Vector2 velocity = new Vector2( (float)(speed * Math.cos(angle * Math.PI / 180.0)), (float)(speed * Math.sin(angle * Math.PI / 180.0)) );
        pBody.setLinearVelocity(velocity);

        return pBody;
    }
    public void rBodyResetMassData(Body pBody)
    {
        pBody.resetMassData();
    }
    public void rBodySetTransform(Body pBody, Vector2 position, float angle)
    {
        pBody.setTransform(position, angle);
    }
    public void rDestroyJoint(Joint joint)
    {
        this.world.destroyJoint(joint);
    }
    public void rGetBodyPosition(Body pBody, CRunBox2DBasePosAndAngle o)
    {
        Vector2 vect = pBody.getPosition();

        //Vector2 position = new Vector2(vect);
        //this.rWorldToFrame(position);
        //o.x=(int)position.x;
        //o.y=(int)position.y;

		// Build 284.2: optimization and avoids memory allocations
        o.x=(int)((vect.x*this.factor)-this.xBase);		// -> rWorldToFrame
        o.y=(int)(this.yBase-(vect.y*this.factor));		// -> rWorldToFrame

        o.angle = (float)(((pBody.getAngle() * 180.0) / Math.PI));
    }
    public void rGetImageDimensions(short img, CRunBox2DBaseImageDimension o)
    {
        CImage image = this.rh.rhApp.imageBank.getImageFromHandle(img);
        CMask pMask = image.getMask(0, 0, 1.0, 1.0);

        int xx, yy;
        //int previousX=-1, previousY=-1;
        //int count=1;
        int height = pMask.getHeight();
        int width = pMask.getWidth();
        o.y1=0;
        o.y2=height-1;
        Boolean quit = false;
        for (yy=0, quit=false; yy<height; yy++)
        {
            for (xx=0; xx<width; xx++)
            {
                if (pMask.testPoint(xx, yy))	// this.isPoint(pMask, xx, yy))
                {
                    o.y1=yy;
                    quit=true;
                    break;
                }
            }
            if (quit) break;
        }
        for (yy=height-1, quit=false; yy>=0; yy--)
        {
            for (xx=0; xx<width; xx++)
            {
                if (pMask.testPoint(xx, yy))	// this.isPoint(pMask, xx, yy))
                {
                    o.y2=yy;
                    quit=true;
                    break;
                }
            }
            if (quit) break;
        }
        o.x1=0;
        o.x2=width-1;
        for (xx=0, quit=false; xx<width; xx++)
        {
            for (yy=0; yy<height; yy++)
            {
                if (pMask.testPoint(xx, yy))	// this.isPoint(pMask, xx, yy))
                {
                    o.x1=xx;
                    quit=true;
                    break;
                }
            }
            if (quit) break;
        }
        for (xx=width-1, quit=false; xx>=0; xx--)
        {
            for (yy=height-1; yy>=0; yy--)
            {
                if (pMask.testPoint(xx, yy))	// this.isPoint(pMask, xx, yy))
                {
                    o.x2=xx;
                    quit=true;
                    break;
                }
            }
            if (quit) break;
        }
    }

    public Fixture rBodyCreatePlatformFixture(Body pBody, CRunMBase pMBase, short img, int vertical, float density, float friction, float restitution, CRunBox2DBaseImageDimension o, float scaleX, float scaleY, float maskWidth)
    {
        CRunBox2DBaseImageDimension dims = new CRunBox2DBaseImageDimension();
        this.rGetImageDimensions(img, dims);
        dims.x1 = (int)(dims.x1 * scaleX);
        dims.x2 = (int)(dims.x2 * scaleX);
        dims.y1 = (int)(dims.y1 * scaleY);
        dims.y2 = (int)(dims.y2 * scaleY);
        maskWidth = Math.max(maskWidth, 0.1f);

        //CImage image = this.rh.rhApp.imageBank.getImageFromHandle(img);
        //CMask pMask = null;
        //if(image != null)
        //	pMask = image.getMask(0, 0, 1.0, 1.0);
        float xx, yy;
        Vector2 vertices[] = new Vector2[6];
        int n;
        for (n=0; n<6; n++)
            vertices[n] = new Vector2(0, 0);

        if (vertical == 0)
        {
            float sx=dims.x2-dims.x1;
            float middleX=(dims.x1+dims.x2)/2;
            float middleY=0;
            float sy=(dims.y1+dims.y2)/2;
            xx=-sx/4*maskWidth;
            yy=middleY;
            vertices[0].set(xx / this.factor, yy / this.factor);
            xx=sx/4*maskWidth;
            vertices[1].set(xx / this.factor, yy / this.factor);
            xx=sx / 2 * maskWidth;
            yy=middleY + sy / 8;
            vertices[2].set(xx / this.factor, yy / this.factor);
            xx=sx/2*maskWidth;
            yy=middleY+sy*2;
            vertices[3].set(xx / this.factor, yy / this.factor);
            xx=-sx/2*maskWidth;
            vertices[4].set(xx / this.factor, yy / this.factor);
            xx=- sx / 2 * maskWidth;
            yy=middleY + sy / 8;
            vertices[5].set(xx / this.factor, yy / this.factor);
            o.x1 = (int)sx;
            o.y1 = (int)sy;
            pMBase.rc.left = -(int)middleX;
            pMBase.rc.right = (int)middleX;
            pMBase.rc.top = -(int)sy;
            pMBase.rc.bottom = (int)sy;
        }
        else
        {
            float sx=dims.y2-dims.y1;
            float sy=dims.x2-dims.x1;
            float middleX=sx/2;
            float middleY=sy/2;
            xx=middleX;
            yy=0;
            vertices[0].set(xx / this.factor, yy / this.factor);
            xx=sx;
            yy=middleY-sy/8;
            vertices[1].set(xx / this.factor, yy / this.factor);
            yy=middleY+sy/8;
            vertices[2].set(xx / this.factor, yy / this.factor);
            xx=middleX;
            yy=sy;
            vertices[3].set(xx / this.factor, yy / this.factor);
            xx=0;
            yy=middleY+sy/8;
            vertices[4].set(xx / this.factor, yy / this.factor);
            yy=middleY-sy/8;
            vertices[5].set(xx / this.factor, yy / this.factor);
            o.x1 = (int)sx;
            o.y1 = (int)sy;
            pMBase.rc.left = -(int)middleX;
            pMBase.rc.right = (int)middleX;
            pMBase.rc.top = -(int)middleY;
            pMBase.rc.bottom = (int)middleY;
        }

        PolygonShape polygon = new PolygonShape();
        polygon.set(vertices);
        FixtureDef fixtureDef = new FixtureDef();
        fixtureDef.shape = polygon;
        fixtureDef.density = density;
        fixtureDef.friction = friction;
        fixtureDef.restitution=restitution;
        Fixture pFixture = pBody.createFixture(fixtureDef);
        pFixture.setUserData(this);
        return pFixture;
    }

    public void computeGroundObjects()
    {
        CRun rhPtr=this.ho.hoAdRunHeader;
        int pOL = 0;
        CObjectCommon ocGround = null;
        ArrayList<CObjectCommon> ocGrounds = new ArrayList<CObjectCommon>();
        CObject[] localObjectList = rhPtr.rhObjectList;
        for (int nObjects=0; nObjects<rhPtr.rhNObjects; nObjects++)
        {
            while(localObjectList[pOL]==null) pOL++;
            CObject pHo=localObjectList[pOL];
            pOL++;
            if (pHo.hoType>=32)
            {
                if (pHo.hoCommon.ocIdentifier==CRunBox2DBase.GROUNDIDENTIFIER)
                {
                    CRunBox2DBaseParent pGround = (CRunBox2DBaseParent)((CExtension)pHo).ext;
                    if (pGround.identifier == this.identifier)
                    {
                        int n;
                        for (n = 0; n < ocGrounds.size(); n++)
                        {
                            if (ocGrounds.get(n) == pHo.hoCommon)
                                break;
                        }
                        if (n == ocGrounds.size())
                        {
                            ocGrounds.add(pHo.hoCommon);
                            ocGround = pHo.hoCommon;
                            short obstacle = pGround.gObstacle;
                            short direction = pGround.gDirection;
                            int pOL2 = pOL;
                            ArrayList<CRunBox2DBaseParent> list = new ArrayList<CRunBox2DBaseParent>();
                            list.add(pGround);
                            for (int nObjects2 = nObjects + 1; nObjects2 < rhPtr.rhNObjects; nObjects2++)
                            {
                                while (localObjectList[pOL2] == null) pOL2++;
                                pHo = localObjectList[pOL2];
                                pOL2++;

                                if (pHo.hoType>=32)
                                {
                                    if (pHo.hoCommon.ocIdentifier == CRunBox2DBase.GROUNDIDENTIFIER && pHo.hoCommon == ocGround)
                                    {
                                        CRunBox2DBaseParent pGround2 = (CRunBox2DBaseParent)((CExtension)pHo).ext;
                                        if (pGround2.identifier == this.identifier && pGround2.gObstacle == obstacle && pGround2.gDirection == direction)
                                        {
                                            list.add(pGround2);
                                        }
                                    }
                                }
                            }
                            if (list.size() > 1)
                            {
                                int pos;
                                boolean flag;
                                do
                                {
                                    flag = false;
                                    pos = 0;
                                    do
                                    {
                                        CRunBox2DBaseParent pSort1 = list.get(pos);
                                        CRunBox2DBaseParent pSort2 = list.get(pos + 1);
                                        CRunBox2DBaseParent temp;
                                        int x1 = pSort1.ho.hoX + 8;
                                        int x2 = pSort2.ho.hoX + 8;
                                        int y1 = pSort1.ho.hoY + 8;
                                        int y2 = pSort2.ho.hoY + 8;
                                        switch(direction)
                                        {
                                            case CRunBox2DBase.DIRECTION_LEFTTORIGHT:
                                                if (x2 < x1)
                                                {
                                                    temp = pSort1;
                                                    list.set(pos, pSort2);
                                                    list.set(pos + 1, temp);
                                                    flag = true;
                                                }
                                                break;
                                            case CRunBox2DBase.DIRECTION_RIGHTTOLEFT:
                                                if (x2 > x1)
                                                {
                                                    temp = pSort1;
                                                    list.set(pos, pSort2);
                                                    list.set(pos + 1, temp);
                                                    flag = true;
                                                }
                                                break;
                                            case CRunBox2DBase.DIRECTION_TOPTOBOTTOM:
                                                if (y2 < y1)
                                                {
                                                    temp = pSort1;
                                                    list.set(pos, pSort2);
                                                    list.set(pos + 1, temp);
                                                    flag = true;
                                                }
                                                break;
                                            case CRunBox2DBase.DIRECTION_BOTTOMTOTOP:
                                                if (y2 > y1)
                                                {
                                                    temp = pSort1;
                                                    list.set(pos, pSort2);
                                                    list.set(pos + 1, temp);
                                                    flag = true;
                                                }
                                                break;
                                        }
                                        pos++;
                                    } while(pos < list.size() - 1);
                                } while(flag);

                                CRunBox2DBaseParent pSort = list.get(0);
                                int x1 = pSort.ho.hoX + 8;
                                pSort = (CRunBox2DBaseParent)list.get(list.size()-1);
                                int x2 = pSort.ho.hoX + 8;
                                int y1 = 10000;
                                int y2 = -10000;
                                int list_size = list.size();
                                for (pos = 0; pos < list_size; pos++)
                                {
                                    pSort = list.get(pos);
                                    y1 = Math.min(pSort.ho.hoY + 8, y1);
                                    y2 = Math.max(pSort.ho.hoY + 8, y2);
                                }
                                int middleX = (x1 + x2) / 2;
                                int middleY = (y1 + y2) / 2;
                                CRunMBase pMBase = new CRunMBase();
                                pMBase.InitBase(pHo, obstacle==0?CRunMBase.MTYPE_OBSTACLE:CRunMBase.MTYPE_PLATFORM);
                                pMBase.m_identifier = this.identifier;
                                pMBase.m_subType = CRunMBase.MSUBTYPE_BOTTOM;
                                pMBase.m_body = this.rCreateBody(BodyDef.BodyType.StaticBody, middleX, middleY, 0, 0, pMBase, 0, 0);
                                pMBase.rc.left = -middleX;
                                pMBase.rc.right = middleX;
                                pMBase.rc.top = y2 - y1;
                                pMBase.rc.bottom = y2 - y1;
                                
                                Vector2 chain[] = new Vector2[list_size];
                                for (pos = 0; pos < list_size; pos++)
                                {
                                    chain[pos] = new Vector2();

                                    pSort = list.get(pos);
                                    x1 = pSort.ho.hoX + 8;
                                    y1 = pSort.ho.hoY + 8;
                                    chain[pos].x = (float)((float)(x1 - middleX))/this.factor;
                                    chain[pos].y = -(float)((float)(y1 - middleY))/this.factor;
                                }
                                ChainShape shape = new ChainShape();
                                shape.createChain(chain);
                                FixtureDef fixtureDef = new FixtureDef();
                                fixtureDef.shape = shape;
                                fixtureDef.density = 1.0f;
                                fixtureDef.friction = pGround.gFriction;
                                fixtureDef.restitution = pGround.gRestitution;
                                fixtureDef.isSensor = false;
                                Fixture fixture = pMBase.m_body.createFixture(fixtureDef);
                                fixture.setUserData(this);
                            }
                        }
                    }
                }
            }
        }
    }

    public void createBorders()
    {
        CRunMBase pBase = new CRunMBase();
        pBase.InitBase(null, CRunMBase.MTYPE_BORDERBOTTOM);
        pBase.m_body = this.rCreateBody(BodyDef.BodyType.StaticBody, this.rh.rhLevelSx/2, this.rh.rhLevelSy + 8, 0, 0, pBase, 0, 0);
        this.rBodyCreateBoxFixture(pBase.m_body, pBase, this.rh.rhLevelSx/2, this.rh.rhLevelSy + 8, this.rh.rhLevelSx, 16, 0, 1, 0);

        pBase = new CRunMBase();
        pBase.InitBase(null, CRunMBase.MTYPE_BORDERLEFT);
        pBase.m_body = this.rCreateBody(BodyDef.BodyType.StaticBody, -8, this.rh.rhLevelSy / 2, 0, 0, pBase, 0, 0);
        this.rBodyCreateBoxFixture(pBase.m_body, pBase, -8, this.rh.rhLevelSy / 2, 16, this.rh.rhLevelSy, 0, 1, 0);

        pBase = new CRunMBase();
        pBase.InitBase(null, CRunMBase.MTYPE_BORDERRIGHT);
        pBase.m_body = this.rCreateBody(BodyDef.BodyType.StaticBody, this.rh.rhLevelSx + 8, this.rh.rhLevelSy / 2, 0, 0, pBase, 0, 0);
        this.rBodyCreateBoxFixture(pBase.m_body, pBase, this.rh.rhLevelSx + 8, this.rh.rhLevelSy / 2, 16, this.rh.rhLevelSy, 0, 1, 0);

        pBase = new CRunMBase();
        pBase.InitBase(null, CRunMBase.MTYPE_BORDERTOP);
        pBase.m_body = this.rCreateBody(BodyDef.BodyType.StaticBody, this.rh.rhLevelSx / 2, -8, 0, 0, pBase, 0, 0);
        this.rBodyCreateBoxFixture(pBase.m_body, pBase, this.rh.rhLevelSx / 2, -8, this.rh.rhLevelSx, 16, 0, 1, 0);
    }

    // Build 283.3 increasing performance
    public CObject Find_HeaderObject(short hlo)
    {
    	int nObjects = this.rh.rhNObjects;
        CObject[] localObjectList=this.rh.rhObjectList;
        for (CObject pHo : localObjectList)
        {
			if (pHo != null) {
	        	--nObjects;
				if(hlo==pHo.hoHFII)
					return pHo;
			}

            if(nObjects==0)
            	break;
        }
        return null;
    }

    public void computeBackdropObjects()
    {
        CRun rhPtr=this.rh;
        CRunFrame pCurFrame=rhPtr.rhFrame;
        CRunApp pCurApp=rhPtr.rhApp;

        int nLayer, i;
        CLO plo;
        CObject hoPtr = null;
        COI poi = null;
        COC poc = null;
        CObjectCommon pOCommon = null;

        for (nLayer=0; nLayer < pCurFrame.layers.length; nLayer++)
        {
            CLayer pLayer = pCurFrame.layers[nLayer];

            // Invisible layer? continue
            if ( (pLayer.dwOptions&CLayer.FLOPT_VISIBLE) == 0 )
            {
                continue;
            }

            int cpt;
            for (i=pLayer.nFirstLOIndex, cpt = 0; cpt < pLayer.nBkdLOs; i++, cpt++)
            {
                plo = this.rh.rhFrame.LOList.list[i];
                int x, y;
                int typeObj = plo.loType;
                int width, height, obstacle;

                if ( typeObj < COI.OBJ_SPR )
                {
                    x=plo.loX;
                    y=plo.loY;
                }
                else
                {
                    poi = pCurApp.OIList.getOIFromHandle(plo.loOiHandle);
                    if ( poi==null || poi.oiOC==null )
                        continue;
                    pOCommon = (CObjectCommon)poi.oiOC;
                    if ( (pOCommon.ocOEFlags & CObjectCommon.OEFLAG_BACKGROUND) == 0 || (hoPtr = Find_HeaderObject(plo.loHandle)) == null )
                        continue;
                    x = hoPtr.hoX - pCurFrame.leX - hoPtr.hoImgXSpot;
                    y = hoPtr.hoY - pCurFrame.leY - hoPtr.hoImgYSpot;
                }

                if ( typeObj < COI.OBJ_SPR )
                {
                    poi = pCurApp.OIList.getOIFromHandle(plo.loOiHandle);
                    if ( poi==null || poi.oiOC==null )
                        continue;
                    poc = poi.oiOC;

                    width=poc.ocCx;
                    height=poc.ocCy;
                    obstacle = poc.ocObstacleType;
                }
                else
                {
                    width=hoPtr.hoImgWidth;
                    height=hoPtr.hoImgHeight;
                    obstacle = ((pOCommon.ocFlags2 & CObjectCommon.OCFLAGS2_OBSTACLEMASK) >> CObjectCommon.OCFLAGS2_OBSTACLESHIFT);
                }
                if (obstacle==COC.OBSTACLE_SOLID || obstacle==COC.OBSTACLE_PLATFORM)
                {
                    CRunMBase pBase = new CRunMBase();
                    if (obstacle==COC.OBSTACLE_SOLID)
                        pBase.m_type = CRunMBase.MTYPE_OBSTACLE;
                    else
                        pBase.m_type = CRunMBase.MTYPE_PLATFORM;
                    pBase.m_body = this.rCreateBody(BodyDef.BodyType.StaticBody, x + width / 2, y + height / 2, 0, 0, pBase, 0, 0);
                    if (typeObj==COI.OBJ_BOX || typeObj >= COI.OBJ_SPR)
                        this.rBodyCreateBoxFixture(pBase.m_body, pBase, x+width/2, y+height/2, width, height, 0, this.friction, this.restitution);
                    else
                    {
                        short img = ((COCBackground)poc).ocImage;
                        this.rBodyCreateShapeFixture(pBase.m_body, pBase, x+width/2, y+height/2, img, -1, this.friction, this.restitution, 1.0f, 1.0f);
                    }
                }
            }
        }
    }

    private boolean CheckOtherEngines()
    {
        int nObjects=this.rh.rhNObjects;
    	CObject[] localObjectList=this.rh.rhObjectList;
        for (CObject pObject : localObjectList)
        {
            if (pObject != null) {
            
	            --nObjects;
	            if(pObject.hoType >= 32)
	            {
	                if (pObject != this.ho)
	                {
	                    if (pObject.hoCommon.ocIdentifier == CRun.BASEIDENTIFIER)
	                    {
	                        CExtension pExt = (CExtension)pObject;
	                        CRunBaseParent pBase = (CRunBaseParent)pExt.ext;
	                        if (pBase.identifier == this.identifier)
	                        {
	                            return true;
	                        }
	                    }
	                }
	            }
	            if(nObjects == 0)
	            	break;
            }
        }
        return false;
    }


    @Override
    public boolean rStartObject()
    {
        if (!this.started)
        {
            this.started=true;
            GetObjects();
            if ((this.flags& CRunBox2DBase.B2FLAG_ADDBACKDROPS)!=0)
                this.computeBackdropObjects();
            this.computeGroundObjects();
        }
        return false;
    }

    public CObject GetHO(int fixedValue)
    {
        CObject hoPtr=this.rh.rhObjectList[fixedValue&0xFFFF];
        if (hoPtr!=null && hoPtr.hoCreationId==fixedValue>>16)
            return hoPtr;
        return null;
    }
}

class CForce
{
    public Body m_body;
    public Vector2 m_force;

    public CForce()
    {
    }
    public CForce(Body body, Vector2 force)
    {
        m_body = body;
        m_force = force;
    }
}
class CTorque
{
    public Body m_body;
    public float m_torque;

    public CTorque()
    {
    }
    public CTorque(Body body, float torque)
    {
        m_body = body;
        m_torque = torque;
    }
}

class CJoint
{
    public CRunBox2DBase m_rdPtr = null;
    public String m_name = null;
    public int m_type = 0;
    public Joint m_joint;

    public CJoint()
    {
    }
    public CJoint(CRunBox2DBase rdPtr, String name)
    {
        m_rdPtr = rdPtr;
        m_name = name;
    }
    public void DestroyJoint()
    {
        m_rdPtr.world.destroyJoint(m_joint);
    }
    public void SetJoint(int type, Joint joint)
    {
        m_type=type;
        m_joint=joint;
    }
}

class CContactListener implements ContactListener
{
    private static final int CNDL_EXTCOLLISION=(-14<<16);
    private static final int CNDL_EXTCOLBACK = (-13 << 16);
    private static final int BORDER_LEFT = 1;
    private static final int BORDER_RIGHT = 2;
    private static final int BORDER_TOP = 4;
    private static final int BORDER_BOTTOM = 8;
    private static final int CNDL_EXTOUTPLAYFIELD = (-12 << 16);
    //private static final int MAGIC = 0x12345678;
    private static final int CND_PARTICULECOLLISION = 1;
    private static final int CND_PARTICULEOUTLEFT = 2;
    private static final int CND_PARTICULEOUTRIGHT = 3;
    private static final int CND_PARTICULEOUTTOP = 4;
    private static final int CND_PARTICULEOUTBOTTOM = 5;
    private static final int CND_PARTICULESCOLLISION = 6;
    private static final int CND_PARTICULECOLLISIONBACKDROP = 7;
    private static final int CND_ELEMENTCOLLISION = 1;
	private static final int CND_ELEMENTCOLLISIONBACKDROP = 7;

    public boolean bWorking = false;
	public CRunBox2DBasePosAndAngle m_tempPosAndAngle = new CRunBox2DBasePosAndAngle();

    public void preSolve(Contact contact, Manifold oldManifold)
    {
        bWorking = true;

        //WorldManifold worldManifold = contact.getWorldManifold();
        Body bodyB = contact.getFixtureB().getBody();
        Body bodyA = contact.getFixtureA().getBody();
        CRunBox2DBase rdPtr=(CRunBox2DBase)contact.getFixtureA().getUserData();
        CRun rhPtr=rdPtr.ho.hoAdRunHeader;

        CRunMBase movement1=(CRunMBase)bodyA.getUserData();
        CRunMBase movement2=(CRunMBase)bodyB.getUserData();
        CRunMBase movement;
        CRunMBase movementB;

        //CExtension pHo;
        //CRunMBase particule, element;
        CRunBox2DBaseParent parent;
        if (movement1==null || movement2==null)
        {
            contact.setEnabled(false);
        }
        else if (movement1.m_type == CRunMBase.MTYPE_BORDERLEFT || movement2.m_type == CRunMBase.MTYPE_BORDERLEFT )
        {
            if (movement1.m_type == CRunMBase.MTYPE_BORDERLEFT)
            {
                movement = movement2;
                movementB = movement1;
            }
            else
            {
                movement = movement1;
                movementB = movement2;
            }
            switch (movement.m_type)
            {
                case CRunMBase.MTYPE_OBJECT:
                    movement.PrepareCondition();
                    movement.SetCollidingObject(movementB);
                    rhPtr.rhEvtProg.rhCurParam0 = BORDER_LEFT;
                    rhPtr.rhEvtProg.handle_Event(movement.m_pHo, CNDL_EXTOUTPLAYFIELD);
                    if (!movement.IsStop())
                        contact.setEnabled(false);
                    break;
                case CRunMBase.MTYPE_FAKEOBJECT:
                    contact.setEnabled(false);
                    break;
                case CRunMBase.MTYPE_PARTICULE:
                    parent = ((CRunBox2DBaseElementParent)movement).parent;
                    parent.currentParticule1 = (CRunBox2DBaseElementParent)movement;
                    parent.currentParticule2 = null;
                    parent.stopped = false;
                    ((CExtension)movement.m_pHo).generateEvent(CND_PARTICULEOUTLEFT, 0);
                    if (!parent.stopped)
                        contact.setEnabled(false);
                    break;
                case CRunMBase.MTYPE_ELEMENT:
                    parent = ((CRunBox2DBaseElementParent)movement).parent;
                    parent.currentElement = (CRunBox2DBaseElementParent)movement;
                    parent.stopped = false;
                    ((CExtension)movement.m_pHo).generateEvent(CND_PARTICULEOUTLEFT, 0);
                    if (!parent.stopped)
                        contact.setEnabled(false);
                    break;
            }
        }
        else if (movement1.m_type == CRunMBase.MTYPE_BORDERRIGHT || movement2.m_type == CRunMBase.MTYPE_BORDERRIGHT )
        {
            if (movement1.m_type == CRunMBase.MTYPE_BORDERRIGHT)
            {
                movement = movement2;
                movementB = movement1;
            }
            else
            {
                movement = movement1;
                movementB = movement2;
            }
            switch (movement.m_type)
            {
                case CRunMBase.MTYPE_OBJECT:
                    movement.PrepareCondition();
                    movement.SetCollidingObject(movementB);
                    rhPtr.rhEvtProg.rhCurParam0 = BORDER_RIGHT;
                    rhPtr.rhEvtProg.handle_Event(movement.m_pHo, CNDL_EXTOUTPLAYFIELD);
                    if (!movement.IsStop())
                        contact.setEnabled(false);
                    break;
                case CRunMBase.MTYPE_FAKEOBJECT:
                    contact.setEnabled(false);
                    break;
                case CRunMBase.MTYPE_PARTICULE:
                    parent = ((CRunBox2DBaseElementParent)movement).parent;
                    parent.currentParticule1 = (CRunBox2DBaseElementParent)movement;
                    parent.currentParticule2 = null;
                    parent.stopped = false;
                    ((CExtension)movement.m_pHo).generateEvent(CND_PARTICULEOUTRIGHT, 0);
                    if (!parent.stopped)
                        contact.setEnabled(false);
                    break;
                case CRunMBase.MTYPE_ELEMENT:
                    parent = ((CRunBox2DBaseElementParent)movement).parent;
                    parent.currentElement = (CRunBox2DBaseElementParent)movement;
                    parent.stopped = false;
                    ((CExtension)movement.m_pHo).generateEvent(CND_PARTICULEOUTRIGHT, 0);
                    if (!parent.stopped)
                        contact.setEnabled(false);
                    break;
            }
        }
        else if (movement1.m_type == CRunMBase.MTYPE_BORDERTOP || movement2.m_type == CRunMBase.MTYPE_BORDERTOP )
        {
            if (movement1.m_type == CRunMBase.MTYPE_BORDERTOP)
            {
                movement = movement2;
                movementB = movement1;
            }
            else
            {
                movement = movement1;
                movementB = movement2;
            }
            switch (movement.m_type)
            {
                case CRunMBase.MTYPE_OBJECT:
                    movement.PrepareCondition();
                    movement.SetCollidingObject(movementB);
                    rhPtr.rhEvtProg.rhCurParam0 = BORDER_TOP;
                    rhPtr.rhEvtProg.handle_Event(movement.m_pHo, CNDL_EXTOUTPLAYFIELD);
                    if (!movement.IsStop())
                        contact.setEnabled(false);
                    break;
                case CRunMBase.MTYPE_FAKEOBJECT:
                    contact.setEnabled(false);
                    break;
                case CRunMBase.MTYPE_PARTICULE:
                    parent = ((CRunBox2DBaseElementParent)movement).parent;
                    parent.currentParticule1 = (CRunBox2DBaseElementParent)movement;
                    parent.currentParticule2 = null;
                    parent.stopped = false;
                    ((CExtension)movement.m_pHo).generateEvent(CND_PARTICULEOUTTOP, 0);
                    if (!parent.stopped)
                        contact.setEnabled(false);
                    break;
                case CRunMBase.MTYPE_ELEMENT:
                    parent = ((CRunBox2DBaseElementParent)movement).parent;
                    parent.currentElement = (CRunBox2DBaseElementParent)movement;
                    parent.stopped = false;
                    ((CExtension)movement.m_pHo).generateEvent(CND_PARTICULEOUTTOP, 0);
                    if (!parent.stopped)
                        contact.setEnabled(false);
                    break;
            }
        }
        else if (movement1.m_type == CRunMBase.MTYPE_BORDERBOTTOM || movement2.m_type == CRunMBase.MTYPE_BORDERBOTTOM )
        {
            if (movement1.m_type == CRunMBase.MTYPE_BORDERBOTTOM)
            {
                movement = movement2;
                movementB = movement1;
            }
            else
            {
                movement = movement1;
                movementB = movement2;
            }
            switch (movement.m_type)
            {
                case CRunMBase.MTYPE_OBJECT:
                    movement.PrepareCondition();
                    movement.SetCollidingObject(movementB);
                    rhPtr.rhEvtProg.rhCurParam0 = BORDER_BOTTOM;
                    rhPtr.rhEvtProg.handle_Event(movement.m_pHo, CNDL_EXTOUTPLAYFIELD);
                    if (!movement.IsStop())
                        contact.setEnabled(false);
                    break;
                case CRunMBase.MTYPE_FAKEOBJECT:
                    contact.setEnabled(false);
                    break;
                case CRunMBase.MTYPE_PARTICULE:
                    parent = ((CRunBox2DBaseElementParent)movement).parent;
                    parent.currentParticule1 = (CRunBox2DBaseElementParent)movement;
                    parent.currentParticule2 = null;
                    parent.stopped = false;
                    ((CExtension)movement.m_pHo).generateEvent(CND_PARTICULEOUTBOTTOM, 0);
                    if (!parent.stopped)
                        contact.setEnabled(false);
                    break;
                case CRunMBase.MTYPE_ELEMENT:
                    parent = ((CRunBox2DBaseElementParent)movement).parent;
                    parent.currentElement = (CRunBox2DBaseElementParent)movement;
                    parent.stopped = false;
                    ((CExtension)movement.m_pHo).generateEvent(CND_PARTICULEOUTBOTTOM, 0);
                    if (!parent.stopped)
                        contact.setEnabled(false);
                    break;
            }
        }
        else if (movement1.m_type == CRunMBase.MTYPE_OBSTACLE || movement2.m_type == CRunMBase.MTYPE_OBSTACLE )
        {
            if (movement1.m_type == CRunMBase.MTYPE_OBSTACLE)
            {
                movement = movement2;
                movementB = movement1;
            }
            else
            {
                movement = movement1;
                movementB = movement2;
            }
            switch (movement.m_type)
            {
                case CRunMBase.MTYPE_OBJECT:
                    movement.PrepareCondition();
                    movement.SetCollidingObject(movementB);
                    rhPtr.rhEvtProg.handle_Event(movement.m_pHo, CNDL_EXTCOLBACK);
                    if (!movement.IsStop())
                        contact.setEnabled(false);
                    break;
                case CRunMBase.MTYPE_FAKEOBJECT:
                    contact.setEnabled(false);
                    break;
                case CRunMBase.MTYPE_PARTICULE:
                    parent = ((CRunBox2DBaseElementParent)movement).parent;
                    parent.currentParticule1 = (CRunBox2DBaseElementParent)movement;
                    parent.currentParticule2 = null;
                    parent.stopped = false;
                    ((CExtension)movement.m_pHo).generateEvent(CND_PARTICULECOLLISIONBACKDROP, 0);
                    if (!parent.stopped)
                        contact.setEnabled(false);
                    break;
                case CRunMBase.MTYPE_ELEMENT:
                    parent = ((CRunBox2DBaseElementParent)movement).parent;
                    parent.currentElement = (CRunBox2DBaseElementParent)movement;
                    parent.stopped = false;
                    ((CExtension)movement.m_pHo).generateEvent(CND_ELEMENTCOLLISIONBACKDROP, 0);
                    if (!parent.stopped)
                        contact.setEnabled(false);
                    break;
            }
        }
        else if (movement1.m_type == CRunMBase.MTYPE_PLATFORM || movement2.m_type == CRunMBase.MTYPE_PLATFORM )
        {
            Vector2 velocity;
            if (movement1.m_type==CRunMBase.MTYPE_PLATFORM)
            {
                movement = movement2;
                movementB = movement1;
                velocity=bodyB.getLinearVelocity();
            }
            else
            {
                movement = movement1;
                movementB = movement2;
                velocity=bodyA.getLinearVelocity();
            }
            switch (movement.m_type)
            {
                case CRunMBase.MTYPE_OBJECT:
                    movement.PrepareCondition();
                    movement.SetCollidingObject(movementB);
                    rhPtr.rhEvtProg.handle_Event(movement.m_pHo, CNDL_EXTCOLBACK);
                    if (!movement.IsStop())
                        contact.setEnabled(false);
                    else
                    {
					    // Build 286.0: don't disable the contact if the platform is under the feet of the object
					    boolean bPlatformUnder = false;
					    if ( rdPtr != null )
					    {
							rdPtr.rGetBodyPosition(movementB.m_body, this.m_tempPosAndAngle);
							int left = this.m_tempPosAndAngle.x + movementB.rc.left;
							int right = this.m_tempPosAndAngle.x + movementB.rc.right;
							int bottom = this.m_tempPosAndAngle.y + movementB.rc.bottom;
					        if (movement.m_pHo.hoX >= left && movement.m_pHo.hoX <= right && movement.m_pHo.hoY <= bottom)	// platform under the feet of the object?
					            bPlatformUnder = true;
					    }
					    if ( !bPlatformUnder )
					    {
							if (velocity.y>=0)
								contact.setEnabled(false);
						}
                    }
                    break;
                case CRunMBase.MTYPE_FAKEOBJECT:
                    contact.setEnabled(false);
                    break;
                case CRunMBase.MTYPE_PARTICULE:
                    parent = ((CRunBox2DBaseElementParent)movement).parent;
                    parent.currentParticule1 = (CRunBox2DBaseElementParent)movement;
                    parent.currentParticule2 = null;
                    parent.stopped = false;
                    velocity = movement.m_body.getLinearVelocity();
                    ((CExtension)movement.m_pHo).generateEvent(CND_PARTICULECOLLISIONBACKDROP, 0);
                    if (!parent.stopped)
                        contact.setEnabled(false);
                    else
                    {
                        if (velocity.y >= 0)
                            contact.setEnabled(false);
                    }
                    break;
                case CRunMBase.MTYPE_ELEMENT:
                    parent = ((CRunBox2DBaseElementParent)movement).parent;
                    parent.currentElement = (CRunBox2DBaseElementParent)movement;
                    parent.stopped = false;
                    velocity = movement.m_body.getLinearVelocity();
                    ((CExtension)movement.m_pHo).generateEvent(CND_PARTICULECOLLISIONBACKDROP, 0);
                    if (!parent.stopped)
                        contact.setEnabled(false);
                    else
                    {
                        if (velocity.y >= 0)
                            contact.setEnabled(false);
                    }
                    break;
            }
        }
        else
        {

            movement = movement1;
            switch (movement.m_type)
            {
                case CRunMBase.MTYPE_OBJECT:
                    switch (movement2.m_type)
                    {
                        case CRunMBase.MTYPE_OBJECT:
                            if (movement.m_background)
                            {
                                CRunMBase temp = movement;
                                movement = movement2;
                                movement2 = temp;
                            }
                            movement.PrepareCondition();
                            movement2.PrepareCondition();
                            
                            movement.SetCollidingObject(movement2);
                            movement2.SetCollidingObject(movement);
                            rhPtr.rhEvtProg.rh1stObjectNumber = movement2.m_pHo.hoNumber;
                            rhPtr.rhEvtProg.rhCurParam0 = movement2.m_pHo.hoOi;
                            rhPtr.rhEvtProg.handle_Event(movement.m_pHo, CNDL_EXTCOLLISION);
                            if (!movement1.IsStop() && !movement2.IsStop())
                                contact.setEnabled(false);
                            break;
                        case CRunMBase.MTYPE_FAKEOBJECT:
                            movement.PrepareCondition();
                            movement2.PrepareCondition();
                            movement.SetCollidingObject(movement2);
                            rhPtr.rhEvtProg.rh1stObjectNumber = movement2.m_pHo.hoNumber;
                            rhPtr.rhEvtProg.rhCurParam0 = movement2.m_pHo.hoOi;
                            rhPtr.rhEvtProg.handle_Event(movement1.m_pHo, CNDL_EXTCOLLISION);
                            if (!movement1.IsStop())
                                contact.setEnabled(false);
                            break;
                        case CRunMBase.MTYPE_PARTICULE:
                            parent = ((CRunBox2DBaseElementParent)movement2).parent;
                            parent.currentParticule1 = (CRunBox2DBaseElementParent)movement2;
                            parent.currentParticule2 = null;
                            parent.stopped = false;
                            parent.collidingHO = movement.m_pHo;
                            movement.PrepareCondition();
                            movement.SetCollidingObject(movement2);
                            ((CExtension)movement2.m_pHo).generateEvent(CND_PARTICULECOLLISION, movement.m_pHo.hoOi);
                            if (!parent.stopped)
                                contact.setEnabled(false);
                            break;
                        case CRunMBase.MTYPE_ELEMENT:
                            parent = ((CRunBox2DBaseElementParent)movement2).parent;
//                            parent.currentObject = obstacle;
                            parent.currentElement = (CRunBox2DBaseElementParent)movement2;
                            parent.stopped = false;
                            parent.collidingHO = movement.m_pHo;
                            movement.PrepareCondition();
                            movement.SetCollidingObject(movement2);
                            ((CExtension)movement2.m_pHo).generateEvent(CND_ELEMENTCOLLISION, movement.m_pHo.hoOi);
                            if (!movement.IsStop() && !movement2.IsStop())
                                contact.setEnabled(false);
                            break;
                    }
                    break;
                case CRunMBase.MTYPE_FAKEOBJECT:
                    switch (movement2.m_type)
                    {
                        case CRunMBase.MTYPE_OBJECT:
                            movement2.PrepareCondition();
                            movement2.SetCollidingObject(movement);
                            rhPtr.rhEvtProg.rh1stObjectNumber = movement.m_pHo.hoNumber;
                            rhPtr.rhEvtProg.rhCurParam0 = movement.m_pHo.hoOi; 
                            rhPtr.rhEvtProg.handle_Event(movement2.m_pHo, CNDL_EXTCOLLISION);
                            if (!movement2.IsStop())
                                contact.setEnabled(false);
                            break;
                        case CRunMBase.MTYPE_FAKEOBJECT:
//                          rhPtr.rhEvtProg.rh1stObjectNumber = movement2.m_pHo.hoNumber;
//                          rhPtr.rhEvtProg.handle_Event(movement1.m_pHo, CNDL_EXTCOLLISION);
                            contact.setEnabled(false);
                            break;
                        case CRunMBase.MTYPE_PARTICULE:
                            parent = ((CRunBox2DBaseElementParent)movement2).parent;
                            parent.currentParticule1 = (CRunBox2DBaseElementParent)movement2;
                            parent.currentParticule2 = null;
                            parent.stopped = false;
                            parent.collidingHO = movement.m_pHo;
                            movement.PrepareCondition();
                            ((CExtension)movement2.m_pHo).generateEvent(CND_PARTICULECOLLISION, movement.m_pHo.hoOi);
                            if (!parent.stopped)
                                contact.setEnabled(false);
                            break;
                        case CRunMBase.MTYPE_ELEMENT:
                            parent = ((CRunBox2DBaseElementParent)movement2).parent;
//                            parent.currentObject = obstacle;
                            parent.currentElement = (CRunBox2DBaseElementParent)movement2;
                            parent.stopped = false;
                            parent.collidingHO = movement.m_pHo;
                            movement1.PrepareCondition();
                            ((CExtension)movement2.m_pHo).generateEvent(CND_ELEMENTCOLLISION, movement.m_pHo.hoOi);
                            if (!parent.stopped)
                                contact.setEnabled(false);
                            break;
                    }
                    break;
                case CRunMBase.MTYPE_PARTICULE:
                    switch (movement2.m_type)
                    {
                        case CRunMBase.MTYPE_OBJECT:
                            parent = ((CRunBox2DBaseElementParent)movement).parent;
                            parent.currentParticule1 = (CRunBox2DBaseElementParent)movement;
                            parent.currentParticule2 = null;
                            parent.stopped = false;
                            parent.collidingHO = movement2.m_pHo;
                            movement2.PrepareCondition();
                            movement2.SetCollidingObject(movement);
                            ((CExtension)movement1.m_pHo).generateEvent(CND_PARTICULECOLLISION, movement2.m_pHo.hoOi);
                            if (!parent.stopped)
                                contact.setEnabled(false);
                            break;
                        case CRunMBase.MTYPE_FAKEOBJECT:
                            parent = ((CRunBox2DBaseElementParent)movement1).parent;
                            parent.currentParticule1 = (CRunBox2DBaseElementParent)movement;
                            parent.currentParticule2 = null;
                            parent.stopped = false;
                            movement2.PrepareCondition();
                            ((CExtension)movement.m_pHo).generateEvent(CND_PARTICULECOLLISION, movement2.m_pHo.hoOi);
                            if (!parent.stopped)
                                contact.setEnabled(false);
                            break;
                        case CRunMBase.MTYPE_PARTICULE:
                            parent = ((CRunBox2DBaseElementParent)movement).parent;
                            parent.currentParticule1 = (CRunBox2DBaseElementParent)movement;
                            parent.currentParticule2 = (CRunBox2DBaseElementParent)movement2;
                            parent.stopped = false;
                            ((CExtension)movement.m_pHo).generateEvent(CND_PARTICULESCOLLISION, 0);
                            if (!parent.stopped)
                                contact.setEnabled(false);
                            break;
                        case CRunMBase.MTYPE_ELEMENT:
                            contact.setEnabled(false);
                            break;
/*                        {
                            parent = ((CRunBox2DBaseElementParent)movement1).parent;
                            parent.currentParticule1 = (CRunBox2DBaseElementParent)movement1;
                            parent.currentParticule2 = null;
                            parent.stopped = false;
                            CRunBox2DBaseParent rope = ((CRunBox2DBaseElementParent)movement2).parent;
                            rope.currentElement = (CRunBox2DBaseElementParent)movement2;
                            rope.stopped = false;
                            ((CExtension)movement1.m_pHo).generateEvent(CND_PARTICULESCOLLISION, 0);
                            ((CExtension)movement2.m_pHo).generateEvent(CND_ELEMENTSCOLLISION, 0);
                            if (!parent.stopped && !rope.stopped)
                                contact.setEnabled(false);
                            break;
                        }
*/
                    }
                    break;
                case CRunMBase.MTYPE_ELEMENT:
                    switch (movement2.m_type)
                    {
                        case CRunMBase.MTYPE_OBJECT:
                            parent = ((CRunBox2DBaseElementParent)movement1).parent;
                            parent.currentElement = (CRunBox2DBaseElementParent)movement1;
                            parent.stopped = false;
                            parent.collidingHO = movement2.m_pHo;
                            movement2.PrepareCondition();
                            movement2.SetCollidingObject(movement);
                            ((CExtension)movement.m_pHo).generateEvent(CND_ELEMENTCOLLISION, movement2.m_pHo.hoOi);
                            if (!movement2.IsStop() && !parent.stopped)
                                contact.setEnabled(false);
                            break;
                        case CRunMBase.MTYPE_FAKEOBJECT:
                            parent = ((CRunBox2DBaseElementParent)movement1).parent;
                            parent.currentElement = (CRunBox2DBaseElementParent)movement1;
                            parent.stopped = false;
                            movement2.PrepareCondition();
                            ((CExtension)movement.m_pHo).generateEvent(CND_ELEMENTCOLLISION, movement2.m_pHo.hoOi);
                            if (!movement2.IsStop() && !parent.stopped)
                                contact.setEnabled(false);
                            break;
                        case CRunMBase.MTYPE_PARTICULE:
                            contact.setEnabled(false);
                            break;
/*                        {
                            parent = ((CRunBox2DBaseElementParent)movement2).parent;
                            parent.currentParticule1 = (CRunBox2DBaseElementParent)movement2;
                            parent.currentParticule2 = null;
                            parent.stopped = false;
                            CRunBox2DBaseParent rope = ((CRunBox2DBaseElementParent)movement1).parent;
                            rope.currentElement = (CRunBox2DBaseElementParent)movement1;
                            rope.stopped = false;
                            ((CExtension)movement2.m_pHo).generateEvent(CND_PARTICULESCOLLISION, 0);
                            ((CExtension)movement1.m_pHo).generateEvent(CND_ELEMENTSCOLLISION, 0);
                            if (!parent.stopped && !rope.stopped)
                                contact.setEnabled(false);
                            break;
                        }
*/
                        case CRunMBase.MTYPE_ELEMENT:
                            contact.setEnabled(false);
                            break;
                    }
                    break;
            }
        }
        bWorking = false;
    }
    public void beginContact(Contact c)
    {
    }
    public void endContact(Contact c)
    {

    }
    public void postSolve(Contact c, ContactImpulse ci)
    {

    }
}
//class CPointTest
//{
//    public float angle;
//}

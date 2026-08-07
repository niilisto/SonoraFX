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
package Extensions {
	
	import Actions.*;
	
	import Animations.*;
	
	import Application.CRunApp;
	import Application.CRunFrame;
	
	import Banks.*;
	
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Common.b2internal;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Joints.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Frame.*;
	
	import Movements.*;
	
	import OI.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	use namespace b2internal;
	
	
	public class CRunBox2DBase extends CRunBaseParent
	{
		public static const FANIDENTIFIER:int= 0x42324641;
		public static const TREADMILLIDENTIFIER:int= 0x4232544D;
		public static const MAGNETIDENTIFIER:int= 0x42369856;
		public static const GROUNDIDENTIFIER:int= 0x42324E4F;
		public static const CBFLAG_FIXEDROTATION:int=0x0001;
		public static const CBFLAG_BULLET:int=0x0002;
		public static const CBFLAG_DAMPING:int=0x0004;
		public static const POSDEFAULT:int=0x56586532;
		public static const DIRECTION_LEFTTORIGHT:int=0;
		public static const DIRECTION_RIGHTTOLEFT:int=1;
		public static const DIRECTION_TOPTOBOTTOM:int=2;
		public static const DIRECTION_BOTTOMTOTOP:int=3;
		public static const OBSTACLE_OBSTACLE:int=0;
		public static const OBSTACLE_PLATFORM:int=1;
		public static const B2FLAG_ADDBACKDROPS:int= 0x0001;
		public static const B2FLAG_BULLETCREATE:int=0x0002;
		public static const B2FLAG_ADDOBJECTS:int= 0x0004;
		public static const TYPE_ALL:int= 0;
		public static const TYPE_DISTANCE:int=1;
		public static const TYPE_REVOLUTE:int=2;
		public static const TYPE_PRISMATIC:int=3;
		public static const TYPE_PULLEY:int=4;
		public static const TYPE_GEAR:int=5;
		public static const TYPE_MOUSE:int=6;
		public static const TYPE_WHEEL:int=7;
		public static const RMOTORTORQUEMULT:Number=20.0;
		public static const RMOTORSPEEDMULT:Number=10.0;
		public static const PJOINTMOTORFORCEMULT:Number=20.0;
		public static const PJOINTMOTORSPEEDMULT:Number=10.0;
		public static const APPLYIMPULSE_MULT:Number=1.90;
		public static const APPLYANGULARIMPULSE_MULT:Number=0.1;
		public static const APPLYFORCE_MULT:Number=5.0;
		public static const APPLYTORQUE_MULT:Number=1.0;
		public static const SETVELOCITY_MULT:Number=20.5;
		public static const SETANGULARVELOCITY_MULT:Number=15.0;
		public static const JTYPE_NONE:int= 0;
		public static const JTYPE_REVOLUTE:int= 1;
		public static const JTYPE_DISTANCE:int= 2;
		public static const JTYPE_PRISMATIC:int= 3;
		public static const JANCHOR_HOTSPOT:int= 0;
		public static const JANCHOR_ACTIONPOINT:int= 1;
		public static const MAX_JOINTNAME:int= 24;
		public static const MAX_JOINTOBJECT:int= 24;
		
		public static const CND_LAST:int= 0;
		public static const ACTION_SETGRAVITYFORCE:int=0;
		public static const ACTION_SETGRAVITYANGLE:int=1;
		public static const ACTION_DJOINTHOTSPOT:int=8;
		public static const ACTION_DJOINTACTIONPOINT:int=9;
		public static const ACTION_DJOINTPOSITION:int=10;
		public static const ACTION_RJOINTHOTSPOT:int=11;
		public static const ACTION_RJOINTACTIONPOINT:int=12;
		public static const ACTION_RJOINTPOSITION:int=13;
		public static const ACTION_PJOINTHOTSPOT:int=14;
		public static const ACTION_PJOINTACTIONPOINT:int=15;
		public static const ACTION_PJOINTPOSITION:int=16;
		public static const ACTION_ADDOBJECT:int=23;
		public static const ACTION_SUBOBJECT:int=24;
		public static const ACTION_SETDENSITY:int= 25;
		public static const ACTION_SETFRICTION:int= 26;
		public static const ACTION_SETELASTICITY:int= 27;
		public static const ACTION_SETGRAVITY:int= 28;
		public static const ACTION_DJOINTSETELASTICITY:int= 29;
		public static const ACTION_RJOINTSETLIMITS:int=30;
		public static const ACTION_RJOINTSETMOTOR:int=31;
		public static const ACTION_PJOINTSETLIMITS:int=32;
		public static const ACTION_PJOINTSETMOTOR:int=33;
		public static const ACTION_PUJOINTHOTSPOT:int=34;
		public static const ACTION_PUJOINTACTIONPOINT:int=35;
		public static const ACTION_DESTROYJOINT:int=38;
		public static const ACTION_SETITERATIONS:int=39;
		public static const EXPRESSION_GRAVITYSTRENGTH:int=0;
		public static const EXPRESSION_GRAVITYANGLE:int=1;
		public static const EXPRESSION_VELOCITYITERATIONS:int=2;
		public static const EXPRESSION_POSITIONITERATIONS:int=3;
		public static const EXPRESSION_ELASTICITYFREQUENCY:int=4;
		public static const EXPRESSION_ELASTICITYDAMPING:int=5;
		public static const EXPRESSION_LOWERANGLELIMIT:int=6;
		public static const EXPRESSION_UPPERANGLELIMIT:int=7;
		public static const EXPRESSION_MOTORSTRENGTH:int=8;
		public static const EXPRESSION_MOTORSPEED:int=9;
		public static const EXPRESSION_LOWERTRANSLATION:int=10;
		public static const EXPRESSION_UPPERTRANSLATION:int=11;
		public static const EXPRESSION_PMOTORSTRENGTH:int=12;
		public static const EXPRESSION_PMOTORSPEED:int=13;
		
		private var fans:CArrayList;
		private var treadmills:CArrayList;
		private var magnets:CArrayList;
		public var started:Boolean= false;
		
		public var factor:int;
		public var xBase:int;
		public var yBase:int;
		public var world:b2World= null;
		public var gravity:Number= 0;
		public var angle:Number= 0;
		
		private var flags:int= 0;
		private var angleBase:int= 0;
		private var velocityIterations:int= 0;
		private var positionIterations:int= 0;
		private var friction:Number= 0;
		private var restitution:Number= 0;
		private var contactListener:CContactListener= null;
		private var fanSearched:Boolean= false;
		private var bulletGravity:Number= 0;
		private var bulletDensity:Number= 0;
		private var bulletRestitution:Number= 0;
		private var bulletFriction:Number= 0;
		private var objects:CArrayList;
		private var objectIDs:CArrayList;
		private var forces:CArrayList;
		private var torques:CArrayList;
		private var joints:CArrayList;
		private var bodiesToDestroy:CArrayList;
		private var npDensity:Number= 0;
		private var npFriction:Number= 0;
		private var magnetSearched:Boolean= false;
		private var treadmillSearched:Boolean= false;
		
		public function CRunBox2DBase () {
			fans = new CArrayList();
			treadmills = new CArrayList();
			magnets = new CArrayList();
			objects = new CArrayList();
			objectIDs = new CArrayList();
			forces = new CArrayList();
			torques = new CArrayList();
			joints = new CArrayList();
			bodiesToDestroy = new CArrayList();
		}
		
		public override function getNumberOfConditions():int {
			return CND_LAST;
		}
		
		public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean {
			this.xBase=0;
			this.yBase=this.rh.rhApp.gaCyWin;
			
			this.flags=file.readInt();
			this.velocityIterations=file.readInt();
			this.positionIterations=file.readInt();
			file.skipBytes(4);
			this.angle=Number(file.readInt()*Math.PI/16.0);
			this.factor=file.readInt();
			this.friction=Number(file.readInt())/100.0;
			this.restitution=Number(file.readInt())/100.0;
			this.bulletFriction=Number(file.readInt())/100.0;
			this.bulletRestitution=Number(file.readInt())/100.0;
			this.bulletGravity=Number(file.readInt())/100.0;
			this.bulletDensity=Number(file.readInt())/100.0;
			this.gravity=file.readFloat();
			this.identifier=file.readInt();
			this.npDensity = Number(file.readInt())/100.0;
			this.npFriction = Number(file.readInt())/100.0;
			
			var gravity:b2Vec2= new b2Vec2(this.gravity*Math.cos(this.angle), this.gravity*Math.sin(this.angle));
			this.world=new b2World(gravity, false);
			//this.world.SetWarmStarting(true);
			this.contactListener=new CContactListener();
			this.world.SetContactListener(this.contactListener);
			
			// If another engine exists with the same identifier -> set identifier to random value
			if (CheckOtherEngines())
				identifier = 1000+ this.ho.hoNumber ;
			
			this.createBorders();
			
			ho.hoAdRunHeader.rh4Box2DObject = true;

			// No errors
			return false;
		}
		
		
		public override function destroyRunObject(bFast:Boolean):void {
			this.world = null;
			ho.hoAdRunHeader.rh4Box2DObject = false;
		}
		
		
		public override function handleRunObject():int {
			this.rStartObject();
			
			var i:int;
			var forces_size:int= this.forces.size();
			var torques_size:int= this.torques.size();
			var objectIDs_size:int= this.objectIDs.size();
			var position:b2Vec2 = new b2Vec2(0,0);
			
			for (i=0; i<forces_size; i++)
			{
				var force:CForce= CForce(this.forces.get(i));
				if(force == null)
					continue;
				position = force.m_body.GetWorldCenter();
				force.m_body.ApplyForce(force.m_force, position);
			}
			for (i=0; i<torques_size; i++)
			{
				var torque:CTorque= CTorque(this.torques.get(i));
				if(torque == null)
					continue;
				torque.m_body.ApplyTorque(torque.m_torque);
			}
			
			for (i=0; i<objectIDs_size; i++)
			{
				var value:int=int(this.objectIDs.get(i));
				var pHo:CObject=this.GetHO(value);
				var pBase:CRunMBase=CRunMBase(this.objects.get(i));
				if (pHo!=null && pBase != null && pBase.m_pHo!=pHo)
				{
					pHo=null;
				}
				if (pHo==null)
				{
					this.rDestroyBody(pBase.m_body);
					this.objectIDs.removeIndex(i);
					this.objects.removeIndex(i);
					objectIDs_size = this.objectIDs.size();
					i--;
				}
				else
				{
					position = new b2Vec2((Number(this.xBase+pHo.hoX)/this.factor), (Number(this.yBase-pHo.hoY)/this.factor));
					var angle:Number=getAnimDir(pHo, pHo.roc.rcDir)*Math.PI/16.0;
					pBase.m_body.setTransform(position, angle);
				}
			}
			
			//RunFactor = Math.min((RunFactor + (0.005)*this.rh.rh4MvtTimerCoef)/1.005, 5.0);
			//trace(" Run factor "+RunFactor);
			
			if (this.world!=null)
			{
				var timeStep:Number = Number(1.0 / this.rh.rhApp.gaFrameRate);
				this.world.Step(timeStep, this.velocityIterations, this.positionIterations);
				this.world.ClearForces();
			}
			
			if (this.bodiesToDestroy.size()>0)
			{
				var n:int;
				var bodiesToDestroy_size:int= this.bodiesToDestroy.size();
				for (n = 0; n < bodiesToDestroy_size; n++)
				{
					rDestroyBody(b2Body(this.bodiesToDestroy.get(n)));
				}
				this.bodiesToDestroy.clear();
			}
			return 0;
		}
		
		
		public override function condition(num:int, cnd:CCndExtension):Boolean {
			return false;
		}
		
		
		public override function action(num:int, act:CActExtension):void {
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
			}
		}
		
		
		public override function expression(num:int):CValue {
			var ret:CValue= new CValue(0);
			var pName:String;
			var pJoint:CJoint;
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
						ret.forceDouble((b2DistanceJoint(pJoint.m_joint)).GetFrequency());
					}
					break;
				}
				case CRunBox2DBase.EXPRESSION_ELASTICITYDAMPING:
				{
					pName = this.ho.getExpParam().getString();
					pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_DISTANCE);
					if (pJoint!=null)
					{
						ret.forceDouble((b2DistanceJoint(pJoint.m_joint)).GetDampingRatio()*100.0);
					}
					break;
				}
				case CRunBox2DBase.EXPRESSION_LOWERANGLELIMIT:
				{
					pName = this.ho.getExpParam().getString();
					pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_REVOLUTE);
					if (pJoint!=null)
					{
						ret.forceInt(int(((b2RevoluteJoint(pJoint.m_joint)).GetLowerLimit()*180.0)/Math.PI));
					}
					break;
				}
				case CRunBox2DBase.EXPRESSION_UPPERANGLELIMIT:
				{
					pName = this.ho.getExpParam().getString();
					pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_REVOLUTE);
					if (pJoint!=null)
					{
						ret.forceInt(int(((b2RevoluteJoint(pJoint.m_joint)).GetUpperLimit()*180.0)/Math.PI));
					}
					break;
				}
				case CRunBox2DBase.EXPRESSION_MOTORSTRENGTH:
				{
					pName = this.ho.getExpParam().getString();
					pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_REVOLUTE);
					if (pJoint!=null)
					{
						ret.forceInt( int(( (b2RevoluteJoint(pJoint.m_joint)).GetMaxMotorTorque()*100/(CRunBox2DBase.RMOTORTORQUEMULT*this.RunFactor))));
					}
					break;
				}
				case CRunBox2DBase.EXPRESSION_MOTORSPEED:
				{
					pName = this.ho.getExpParam().getString();
					pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_REVOLUTE);
					if (pJoint!=null)
					{
						ret.forceInt(int(((b2RevoluteJoint(pJoint.m_joint)).GetMotorSpeed()*100/(CRunBox2DBase.RMOTORSPEEDMULT*this.RunFactor))));
					}
					break;
				}
				case CRunBox2DBase.EXPRESSION_LOWERTRANSLATION:
				{
					pName = this.ho.getExpParam().getString();
					pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_PRISMATIC);
					if (pJoint!=null)
					{
						ret.forceInt(int(( (b2PrismaticJoint(pJoint.m_joint)).GetLowerLimit()*factor)));
					}
					break;
				}
				case CRunBox2DBase.EXPRESSION_UPPERTRANSLATION:
				{
					pName = this.ho.getExpParam().getString();
					pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_PRISMATIC);
					if (pJoint!=null)
					{
						ret.forceInt(int(( (b2PrismaticJoint(pJoint.m_joint)).GetUpperLimit()*factor)));
					}
					break;
				}
				case CRunBox2DBase.EXPRESSION_PMOTORSTRENGTH:
				{
					pName = this.ho.getExpParam().getString();
					pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_PRISMATIC);
					if (pJoint!=null)
					{
						ret.forceInt( int(( (b2PrismaticJoint(pJoint.m_joint)).GetMotorForce()*100/(CRunBox2DBase.PJOINTMOTORFORCEMULT*this.RunFactor))));
					}
					break;
				}
				case CRunBox2DBase.EXPRESSION_PMOTORSPEED:
				{
					pName = this.ho.getExpParam().getString();
					pJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_PRISMATIC);
					if (pJoint!=null)
					{
						ret.forceInt( int(( (b2PrismaticJoint(pJoint.m_joint)).GetMotorSpeed()*100/(CRunBox2DBase.PJOINTMOTORSPEEDMULT*this.RunFactor))));
					}
					break;
				}
			}
			return ret;
		}
		
		// ACTIONS //////////////////////////////////////////////////////////////////////
		public function GetMBase(pHo:CObject):CRunMBase {
			if (pHo == null)
				return null;
			if (pHo.rom == null || (pHo.hoFlags & CObject.HOF_DESTROYED) != 0)
				return null;
			if (pHo.roc.rcMovementType==CMoveDef.MVTYPE_EXT)
			{
				var mvPtr:CMoveDefExtension= CMoveDefExtension(pHo.hoCommon.ocMovements.moveList[pHo.rom.rmMvtNum]);
				if (CServices.compareStringsIgnoreCase(mvPtr.moduleName, "box2d8directions")
					|| CServices.compareStringsIgnoreCase(mvPtr.moduleName, "box2dspring")
					|| CServices.compareStringsIgnoreCase(mvPtr.moduleName, "box2dspaceship")
					|| CServices.compareStringsIgnoreCase(mvPtr.moduleName, "box2dstatic")
					|| CServices.compareStringsIgnoreCase(mvPtr.moduleName, "box2dracecar")
					|| CServices.compareStringsIgnoreCase(mvPtr.moduleName, "box2daxial")
					|| CServices.compareStringsIgnoreCase(mvPtr.moduleName, "box2dplatform")
					|| CServices.compareStringsIgnoreCase(mvPtr.moduleName, "box2dbouncingball")
					|| CServices.compareStringsIgnoreCase(mvPtr.moduleName, "box2dbackground")
				)
				{
					var pBase:CRunMBase= CRunMBase((CMoveExtension(pHo.rom.rmMovement).movement));
					if (pBase.m_identifier==this.identifier)
					{
						return pBase;
					}
				}
			}
			return null;
		}
		
		private function RACTION_SETDENSITY(act:CActExtension):void {
			var pHo:CObject= act.getParamObject(this.rh, 0);
			var pmBase:CRunMBase= this.GetMBase(pHo);
			if (pmBase != null)
			{
				pmBase.SetDensity(act.getParamExpression(this.rh, 1));
			}
		}
		private function RACTION_SETFRICTION(act:CActExtension):void {
			var pHo:CObject= act.getParamObject(this.rh, 0);
			var pmBase:CRunMBase= this.GetMBase(pHo);
			if (pmBase != null)
			{
				pmBase.SetFriction(act.getParamExpression(this.rh, 1));
			}
		}
		private function RACTION_SETELASTICITY(act:CActExtension):void {
			var pHo:CObject= act.getParamObject(this.rh, 0);
			var pmBase:CRunMBase= this.GetMBase(pHo);
			if (pmBase != null)
			{
				pmBase.SetRestitution(act.getParamExpression(this.rh, 1));
			}
		}
		private function RACTION_SETGRAVITY(act:CActExtension):void {
			var pHo:CObject= act.getParamObject(this.rh, 0);
			var pmBase:CRunMBase= this.GetMBase(pHo);
			if (pmBase != null)
			{
				pmBase.SetGravity(act.getParamExpression(this.rh, 1));
			}
		}
		
		private function RACTION_SETITERATIONS(act:CActExtension):void {
			this.velocityIterations=act.getParamExpression(this.rh, 0);
			this.positionIterations=act.getParamExpression(this.rh, 1);
		}
		
		private function RACTION_SETGRAVITYFORCE(act:CActExtension):void {
			this.gravity=act.getParamExpDouble(this.rh, 0);
			var gravity:b2Vec2= new b2Vec2((this.gravity*Math.cos(this.angle)), (this.gravity*Math.sin(this.angle)));
			this.world.SetGravity(gravity);
		}
		
		private function RACTION_SETGRAVITYANGLE(act:CActExtension):void {
			this.angleBase=act.getParamExpression(this.rh, 0);
			this.angle=(this.angleBase*Math.PI/180.0);
			var gravity:b2Vec2= new b2Vec2((this.gravity*Math.cos(this.angle)), (this.gravity*Math.sin(this.angle)));
			this.world.SetGravity(gravity);
		}
		
		private function CreateJoint(name:String):CJoint {
			var n:int;
			var pJoint:CJoint= null;
			pJoint=new CJoint(this, name);
			this.joints.add(pJoint);
			return pJoint;
		}
		private function GetJoint(sJoint:CJoint, name:String, type:int):CJoint {
			var n:int;
			var pJoint:CJoint= null;
			var index:int= 0;
			if (sJoint != null)
			{
				index = this.joints.indexOf(sJoint);
				if (index < 0)
					return null;
				index++;
			}
			var joints_size:int = this.joints.size();
			for (n=index; n<joints_size; n++)
			{
				pJoint=CJoint(this.joints.get(n));
				if (CServices.compareStringsIgnoreCase(pJoint.m_name, name))
				{
					break;
				}
			}
			if (n<joints_size)
			{
				if (type==CRunBox2DBase.TYPE_ALL || type==pJoint.m_type)
				{
					return pJoint;
				}
			}
			return null;
		}
		
		private function GetActionPointPosition(pBase:CRunMBase):b2Vec2 {
			var pHo:CObject=pBase.m_pHo;
			var x:int=pHo.hoX;
			var y:int=pHo.hoY;
			if ((pHo.hoOEFlags&CObjectCommon.OEFLAG_ANIMATIONS)!=0)
			{
				var angle:Number=pHo.roc.rcAngle * Math.PI / 180.0;
				var image:CImage=this.rh.rhApp.imageBank.getImageFromHandle(pHo.roc.rcImage);
				if(image != null) {
					var deltaX:int= image.xAP-image.xSpot;
					var deltaY:int= image.yAP-image.ySpot;
					x += (deltaX * Math.cos(angle) - deltaY * Math.sin(angle));
					y += (deltaX * Math.sin(angle) + deltaY * Math.cos(angle));
				}
			}
			var position:b2Vec2= new b2Vec2((Number(this.xBase+x)/this.factor), (Number(this.yBase-y)/this.factor));
			return position;
		}
		
		private function RACTION_DJOINTHOTSPOT(act:CActExtension):void {
			var name:String=act.getParamExpString(this.rh, 0);
			var pBase1:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 1));
			var pBase2:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 2));
			if (pBase1!=null && pBase2!=null)
			{
				var pJoint:CJoint=this.CreateJoint(name);
				var jointdef:b2DistanceJointDef= new b2DistanceJointDef();
				jointdef.collideConnected=true;
				jointdef.frequencyHz = 0;
				jointdef.dampingRatio = 0;
				var position1:b2Vec2= pBase1.m_body.GetPosition();
				var position2:b2Vec2= pBase2.m_body.GetPosition();
				jointdef.Initialize(pBase1.m_body, pBase2.m_body, position1, position2);
				pJoint.SetJoint(CRunBox2DBase.TYPE_DISTANCE, this.world.CreateJoint(jointdef));
			}
		}
		
		private function RACTION_DJOINTACTIONPOINT(act:CActExtension):void {
			var name:String= act.getParamExpString(this.rh, 0);
			var pBase1:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 1));
			var pBase2:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 2));
			if (pBase1!=null && pBase2!=null)
			{
				var pJoint:CJoint=this.CreateJoint(name);
				var jointDef:b2DistanceJointDef= new b2DistanceJointDef();
				jointDef.collideConnected=true;
				jointDef.frequencyHz = 0;
				jointDef.dampingRatio = 0;
				var position1:b2Vec2=this.GetActionPointPosition(pBase1);
				var position2:b2Vec2=this.GetActionPointPosition(pBase2);
				jointDef.Initialize(pBase1.m_body, pBase2.m_body, position1, position2);
				pJoint.SetJoint(CRunBox2DBase.TYPE_DISTANCE, this.world.CreateJoint(jointDef));
			}
		}
		
		private function RACTION_DJOINTSETELASTICITY(act:CActExtension):void {
			var pName:String= act.getParamExpString(this.rh, 0);
			var frequency:Number=(act.getParamExpDouble(this.rh, 1));
			var damping:Number=((act.getParamExpression(this.rh, 2)/100.0));
			var pJoint:CJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_DISTANCE);
			while (pJoint!=null)
			{
				var pdJoint:b2DistanceJoint=b2DistanceJoint(pJoint.m_joint);
				pdJoint.SetFrequency(frequency);
				pdJoint.SetDampingRatio(damping);
				pJoint=this.GetJoint(pJoint, pName, CRunBox2DBase.TYPE_DISTANCE);
			}
		}
		
		private function GetImagePosition(pBase:CRunMBase, x1:int, y1:int):b2Vec2 {
			var position:b2Vec2=new b2Vec2(pBase.m_body.GetPosition().x, pBase.m_body.GetPosition().y);
			position.x+=x1/this.factor;
			position.y-=y1/this.factor;
			return position;
		}
		
		private function RACTION_DJOINTPOSITION(act:CActExtension):void {
			var name:String= act.getParamExpString(this.rh, 0);
			var pBase1:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 1));
			var x1:int=act.getParamExpression(this.rh, 2);
			var y1:int=act.getParamExpression(this.rh, 3);
			var pBase2:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 4));
			var x2:int=act.getParamExpression(this.rh, 5);
			var y2:int=act.getParamExpression(this.rh, 6);
			if (pBase1!=null && pBase2!=null)
			{
				var pJoint:CJoint=this.CreateJoint(name);
				var position1:b2Vec2=this.GetImagePosition(pBase1, x1, y1);
				var position2:b2Vec2=this.GetImagePosition(pBase2, x2, y2);
				var jointDef:b2DistanceJointDef=new b2DistanceJointDef();
				jointDef.collideConnected=true;
				jointDef.Initialize(pBase1.m_body, pBase2.m_body, position1, position2);
				pJoint.SetJoint(CRunBox2DBase.TYPE_DISTANCE, this.world.CreateJoint(jointDef));
			}
		}
		
		private function RACTION_RJOINTHOTSPOT(act:CActExtension):void {
			var name:String= act.getParamExpString(this.rh, 0);
			var pBase1:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 1));
			var pBase2:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 2));
			if (pBase1!=null && pBase2!=null)
			{
				var pJoint:CJoint=this.CreateJoint(name);
				var jointDef:b2RevoluteJointDef= new b2RevoluteJointDef();
				jointDef.collideConnected=true;
				var position:b2Vec2=pBase1.m_body.GetPosition();
				jointDef.Initialize(pBase1.m_body, pBase2.m_body, position);
				pJoint.SetJoint(CRunBox2DBase.TYPE_REVOLUTE, this.world.CreateJoint(jointDef));
			}
		}
		
		private function RACTION_RJOINTACTIONPOINT(act:CActExtension):void {
			var name:String=act.getParamExpString(this.rh, 0);
			var pBase1:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 1));
			var pBase2:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 2));
			if (pBase1!=null && pBase2!=null)
			{
				var pJoint:CJoint=this.CreateJoint(name);
				var jointDef:b2RevoluteJointDef= new b2RevoluteJointDef();
				jointDef.collideConnected=true;
				var position:b2Vec2=this.GetActionPointPosition(pBase1);
				jointDef.Initialize(pBase1.m_body, pBase2.m_body, position);
				pJoint.SetJoint(CRunBox2DBase.TYPE_REVOLUTE, this.world.CreateJoint(jointDef));
			}
		}
		
		private function RACTION_RJOINTPOSITION(act:CActExtension):void {
			var name:String=act.getParamExpString(this.rh, 0);
			var pBase1:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 1));
			var x1:int=act.getParamExpression(this.rh, 2);
			var y1:int=act.getParamExpression(this.rh, 3);
			var pBase2:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 4));
			if (pBase1!=null && pBase2!=null)
			{
				var pJoint:CJoint=this.CreateJoint(name);
				var jointDef:b2RevoluteJointDef= new b2RevoluteJointDef();
				jointDef.collideConnected=true;
				var position:b2Vec2=this.GetImagePosition(pBase1, x1, y1);
				jointDef.Initialize(pBase1.m_body, pBase2.m_body, position);
				pJoint.SetJoint(CRunBox2DBase.TYPE_REVOLUTE, this.world.CreateJoint(jointDef));
			}
		}
		
		private function RACTION_RJOINTSETLIMITS(act:CActExtension):void {
			var pName:String= act.getParamExpString(this.rh, 0);
			var lAngle:Number=(act.getParamExpression(this.rh, 1)*Math.PI/180.0);
			var uAngle:Number=(act.getParamExpression(this.rh, 2)*Math.PI/180.0);
			var pJoint:CJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_REVOLUTE);
			while (pJoint!=null)
			{
				var prJoint:b2RevoluteJoint=b2RevoluteJoint(pJoint.m_joint);
				if (lAngle>uAngle) {
					prJoint.EnableLimit(false);
				}
				else
				{
					prJoint.EnableLimit(true);
					prJoint.SetLimits(lAngle, uAngle);
				}
				pJoint=this.GetJoint(pJoint, pName, CRunBox2DBase.TYPE_REVOLUTE);
			}
		}
		
		private function RACTION_RJOINTSETMOTOR(act:CActExtension):void {
			var pName:String= act.getParamExpString(this.rh, 0);
			var torque:Number=(act.getParamExpression(this.rh, 1)/100.0*CRunBox2DBase.RMOTORTORQUEMULT*this.RunFactor);
			var speed:Number=(act.getParamExpression(this.rh, 2)/100.0*CRunBox2DBase.RMOTORSPEEDMULT*this.RunFactor);
			var pJoint:CJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_REVOLUTE);
			while (pJoint!=null)
			{
				var prJoint:b2RevoluteJoint=b2RevoluteJoint(pJoint.m_joint);
				var flag:Boolean=true;
				if (torque==0&& speed==0)
					flag=false;
				prJoint.EnableMotor(flag);
				prJoint.SetMaxMotorTorque(torque);
				prJoint.SetMotorSpeed(-speed);
				pJoint=this.GetJoint(pJoint, pName, CRunBox2DBase.TYPE_REVOLUTE);
			}
		}
		
		private function RACTION_PJOINTHOTSPOT(act:CActExtension):void {
			var name:String= act.getParamExpString(this.rh, 0);
			var pBase1:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 1));
			var pBase2:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 2));
			if (pBase1!=null && pBase2!=null)
			{
				var pJoint:CJoint=this.CreateJoint(name);
				var jointDef:b2PrismaticJointDef= new b2PrismaticJointDef();
				jointDef.collideConnected=true;
				jointDef.enableLimit=false;
				var position1:b2Vec2=pBase1.m_body.GetPosition();
				var position2:b2Vec2=pBase2.m_body.GetPosition();
				var axis:b2Vec2= new b2Vec2(position2.x-position1.x, position2.y-position1.y);
				jointDef.Initialize(pBase1.m_body, pBase2.m_body, position1, axis);
				pJoint.SetJoint(CRunBox2DBase.TYPE_PRISMATIC, this.world.CreateJoint(jointDef));
			}
		}
		
		private function RACTION_PJOINTACTIONPOINT(act:CActExtension):void {
			var name:String= act.getParamExpString(this.rh, 0);
			var pBase1:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 1));
			var pBase2:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 2));
			if (pBase1!=null && pBase2!=null)
			{
				var pJoint:CJoint=this.CreateJoint(name);
				var jointDef:b2PrismaticJointDef= new b2PrismaticJointDef();
				jointDef.collideConnected=true;
				var position1:b2Vec2=this.GetActionPointPosition(pBase1);
				var position2:b2Vec2=this.GetActionPointPosition(pBase2);
				var axis:b2Vec2=new b2Vec2(position2.x-position1.x, position2.y-position1.y);
				jointDef.Initialize(pBase1.m_body, pBase2.m_body, position1, axis);
				pJoint.SetJoint(CRunBox2DBase.TYPE_PRISMATIC, this.world.CreateJoint(jointDef));
			}
		}
		
		private function RACTION_PJOINTPOSITION(act:CActExtension):void {
			var name:String= act.getParamExpString(this.rh, 0);
			var pBase1:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 1));
			var x1:int=act.getParamExpression(this.rh, 2);
			var y1:int=act.getParamExpression(this.rh, 3);
			var pBase2:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 4));
			var x2:int=act.getParamExpression(this.rh, 5);
			var y2:int=act.getParamExpression(this.rh, 6);
			if (pBase1!=null && pBase2!=null)
			{
				var pJoint:CJoint=this.CreateJoint(name);
				var jointDef:b2PrismaticJointDef= new b2PrismaticJointDef();
				jointDef.collideConnected=true;
				var position1:b2Vec2=this.GetImagePosition(pBase1, x1, y1);
				var position2:b2Vec2=this.GetImagePosition(pBase1, x2, y2);
				var axis:b2Vec2=new b2Vec2(position2.x-position1.x, position2.y-position1.y);
				jointDef.Initialize(pBase1.m_body, pBase2.m_body, position1, axis);
				pJoint.SetJoint(CRunBox2DBase.TYPE_PRISMATIC, this.world.CreateJoint(jointDef));
			}
		}
		
		private function RACTION_PJOINTSETLIMITS(act:CActExtension):void {
			var pName:String= act.getParamExpString(this.rh, 0);
			var lLimit:Number=(act.getParamExpression(this.rh, 1)/this.factor);
			var uLimit:Number=(act.getParamExpression(this.rh, 2)/this.factor);
			var pJoint:CJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_PRISMATIC);
			while (pJoint!=null)
			{
				var prJoint:b2PrismaticJoint=b2PrismaticJoint(pJoint.m_joint);
				var flag:Boolean=true;
				if (lLimit>uLimit)
					flag=false;
				prJoint.EnableLimit(flag);
				prJoint.SetLimits(lLimit, uLimit);
				pJoint=this.GetJoint(pJoint, pName, CRunBox2DBase.TYPE_PRISMATIC);
			}
		}
		
		private function RACTION_PJOINTSETMOTOR(act:CActExtension):void {
			var pName:String= act.getParamExpString(this.rh, 0);
			var force:Number=(act.getParamExpression(this.rh, 1)/100.0*CRunBox2DBase.PJOINTMOTORFORCEMULT*this.RunFactor);
			var speed:Number=(act.getParamExpression(this.rh, 2)/100.0*CRunBox2DBase.PJOINTMOTORSPEEDMULT*this.RunFactor);
			var pJoint:CJoint=this.GetJoint(null, pName, CRunBox2DBase.TYPE_PRISMATIC);
			while (pJoint!=null)
			{
				var prJoint:b2PrismaticJoint=b2PrismaticJoint(pJoint.m_joint);
				var flag:Boolean=true;
				if (force==0&& speed==0)
					flag=false;
				prJoint.EnableMotor(flag);
				prJoint.SetMaxMotorForce(force);
				prJoint.SetMotorSpeed(-speed);
				pJoint=this.GetJoint(pJoint, pName, CRunBox2DBase.TYPE_PRISMATIC);
			}
		}
		
		private function RACTION_PUJOINTHOTSPOT(act:CActExtension):void {
			var name:String= act.getParamExpString(this.rh, 0);
			var pBase1:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 1));
			var pBase2:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 2));
			if (pBase1!=null && pBase2!=null)
			{
				var pJoint:CJoint=this.CreateJoint(name);
				var jointDef:b2PulleyJointDef= new b2PulleyJointDef();
				jointDef.collideConnected=true;
				var position1:b2Vec2=pBase1.m_body.GetPosition();
				var position2:b2Vec2=pBase2.m_body.GetPosition();
				var length1:Number=(act.getParamExpression(this.rh, 3)/this.factor);
				var angle1:Number=(act.getParamExpression(this.rh, 4)*Math.PI/180.0);
				var length2:Number=(act.getParamExpression(this.rh, 5)/this.factor);
				var angle2:Number=(act.getParamExpression(this.rh, 6)*Math.PI/180.0);
				var ratio:Number=(act.getParamExpression(this.rh, 7)/100.0);
				var rope1:b2Vec2=new b2Vec2((position1.x+length1*Math.cos(angle1)), (position1.y+length1*Math.sin(angle1)));
				var rope2:b2Vec2=new b2Vec2((position2.x+length2*Math.cos(angle2)), (position2.y+length2*Math.sin(angle2)));
				jointDef.Initialize(pBase1.m_body, pBase2.m_body, rope1, rope2, position1, position2, ratio);
				pJoint.SetJoint(CRunBox2DBase.TYPE_PULLEY, this.world.CreateJoint(jointDef));
			}
		}
		
		private function RACTION_PUJOINTACTIONPOINT(act:CActExtension):void {
			var name:String= act.getParamExpString(this.rh, 0);
			var pBase1:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 1));
			var pBase2:CRunMBase=this.GetMBase(act.getParamObject(this.rh, 2));
			if (pBase1!=null && pBase2!=null)
			{
				var pJoint:CJoint=this.CreateJoint(name);
				var jointDef:b2PulleyJointDef= new b2PulleyJointDef();
				jointDef.collideConnected=true;
				var position1:b2Vec2=this.GetActionPointPosition(pBase1);
				var position2:b2Vec2=this.GetActionPointPosition(pBase2);
				var length1:Number=(act.getParamExpression(this.rh, 3)/this.factor);
				var angle1:Number=(act.getParamExpression(this.rh, 4)*Math.PI/180.0);
				var length2:Number=(act.getParamExpression(this.rh, 5)/this.factor);
				var angle2:Number=(act.getParamExpression(this.rh, 6)*Math.PI/180.0);
				var ratio:Number=(act.getParamExpression(this.rh, 7)/100.0);
				var rope1:b2Vec2=new b2Vec2((position1.x+length1*Math.cos(angle1)), (position1.y+length1*Math.sin(angle1)));
				var rope2:b2Vec2=new b2Vec2((position2.x+length2*Math.cos(angle2)), (position2.y+length2*Math.sin(angle2)));
				jointDef.Initialize(pBase1.m_body, pBase2.m_body, rope1, rope2, position1, position2, ratio);
				pJoint.SetJoint(CRunBox2DBase.TYPE_PULLEY, this.world.CreateJoint(jointDef));
			}
		}
		
		private function RACTION_DESTROYJOINT(act:CActExtension):void {
			var pName:String= act.getParamExpString(this.rh, 0);
			var n:int;
			var joints_size:int= this.joints.size();
			for (n=0; n < joints_size; n++)
			{
				var pJoint:CJoint=CJoint(this.joints.get(n));
				if (pJoint != null && CServices.compareStringsIgnoreCase(pJoint.m_name, pName))
				{
					this.world.DestroyJoint(pJoint.m_joint);
					pJoint.m_joint = null;
					this.joints.removeIndex(n);
					joints_size = this.joints.size();
					n--;
				}
			}
		}
		
		private function destroyJointsWithBody(body:b2Body):void {
			var n:int;
			var joints_size:int= this.joints.size();
			for (n=0; n < joints_size; n++)
			{
				var pJoint:CJoint=CJoint(this.joints.get(n));
				if (pJoint != null && (pJoint.m_joint.GetBodyA() == body || pJoint.m_joint.GetBodyB() == body))
				{
					this.joints.removeIndex(n);
					joints_size = this.joints.size();
					n--;
				}
			}
		}
		
		public override function rAddNormalObject(pHo:CObject):void {
			if ((this.flags & CRunBox2DBase.B2FLAG_ADDOBJECTS)!=0)
			{
				if (this.objects.indexOf(pHo) < 0)
				{
					if (pHo.rom != null && pHo.roa != null && this.GetMBase(pHo)==null)
					{
						var pBase:CRunMBase= new CRunMBase();
						pBase.InitBase(pHo, CRunMBase.MTYPE_FAKEOBJECT);
						var angle:Number= getAnimDir(pHo, pHo.roc.rcDir) * 11.25;
						pBase.m_body = this.rCreateBody(b2Body.b2_staticBody, pHo.hoX, pHo.hoY, angle, 0, pBase, 0, 0);
						this.rBodyCreateShapeFixture(pBase.m_body, pBase, pHo.hoX, pHo.hoY, pHo.roc.rcImage, this.npDensity, this.npFriction, 0.001, pHo.roc.rcScaleX, pHo.roc.rcScaleY);
						this.objects.add(pBase);
						this.objectIDs.add((pHo.hoCreationId << 16) | (pHo.hoNumber & 0xFFFF));
					}
				}
			}
		}
		
		public override function rAddABackdrop(x:int, y:int, img:Number, obstacleType:Number):b2Body {
			if ((this.flags & CRunBox2DBase.B2FLAG_ADDBACKDROPS)!=0)
			{
				var image:CImage= this.rh.rhApp.imageBank.getImageFromHandle(img);
				var mBase:CRunMBase= new CRunMBase();
				if (obstacleType==COC.OBSTACLE_SOLID)
					mBase.m_type = CRunMBase.MTYPE_OBSTACLE;
				else
					mBase.m_type = CRunMBase.MTYPE_PLATFORM;
				mBase.m_body = this.rCreateBody(b2Body.b2_staticBody, x + image.width / 2, y + image.height / 2, 0, 0, mBase, 0, 0);
				this.rBodyCreateShapeFixture(mBase.m_body, mBase, x+image.width/2, y+image.height/2, img, -1, this.friction, this.restitution, 1.0, 1.0);
				return mBase.m_body;
			}
			return null;
		}
		
		public override function rSubABackdrop(body:b2Body):void {
			this.world.DestroyBody(body);
		}
		
		private function RACTION_ADDOBJECT(act:CActExtension):void {
			var pHo:CObject=act.getParamObject(this.rh, 0);
			if (this.objects.indexOf(pHo)<0)
			{
				if (pHo.rom != null && pHo.roa != null && this.GetMBase(pHo) == null)
				{
					var pBase:CRunMBase= new CRunMBase();
					pBase.InitBase(pHo, CRunMBase.MTYPE_FAKEOBJECT);
					var angle:Number= (getAnimDir(pHo, pHo.roc.rcDir) * 11.25);
					var density:Number= (act.getParamExpression(this.rh, 1) / 100.0);
					var friction:Number= (act.getParamExpression(this.rh, 2) / 100.0);
					var shape:int= act.getParamExpression(this.rh, 3);;
					pBase.m_body = this.rCreateBody(b2Body.b2_staticBody, pHo.hoX, pHo.hoY, angle, 0, pBase, 0, 0);
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
		
		private function RACTION_SUBOBJECT(act:CActExtension):void {
			var pHo:CObject=act.getParamObject(this.rh, 0);
			var n:int=this.objects.indexOf(pHo);
			if (n>=0)
			{
				var mBase:CRunMBase=CRunMBase(this.objects.get(n));
				this.rDestroyBody(mBase.m_body);
				this.objects.removeIndex(n);
			}
		}
		
		/////////////////////////////////////////////////////////////////////////////////
		
		private function GetObjects():void {
			fans.clear();
			treadmills.clear();
			magnets.clear();
			
			var pOL:int=0;
			var nObjects:int;
			for (nObjects=0; nObjects<this.rh.rhNObjects; pOL++, nObjects++)
			{
				while(this.rh.rhObjectList[pOL]==null) pOL++;
				var pObject:CObject=this.rh.rhObjectList[pOL];
				if (pObject.hoType>=32)
				{
					var pBase:CRunBaseParent;
					if (pObject.hoCommon.ocIdentifier==FANIDENTIFIER)
					{
						pBase = CRunBaseParent(CExtension(pObject).ext);
						if (pBase.identifier == identifier)
							this.fans.add(pBase);
					}
					if (pObject.hoCommon.ocIdentifier==MAGNETIDENTIFIER)
					{
						pBase = CRunBaseParent(CExtension(pObject).ext);
						if (pBase.identifier == identifier)
							this.fans.add(pBase);
					}
					if (pObject.hoCommon.ocIdentifier==TREADMILLIDENTIFIER)
					{
						pBase = CRunBaseParent(CExtension(pObject).ext);
						if (pBase.identifier == identifier)
							this.fans.add(pBase);
					}
				}
			}
		}
		
		public function rJointCreate(pMBase1:CRunMBase, jointType:Number, jointAnchor:Number, jointName:String, jointObject:String, param1:Number, param2:Number):b2Joint {
			if (jointType == CRunBox2DBase.JTYPE_NONE)
				return null;
			
			var pOL:int=0;
			var nObjects:int= 0;
			var pMBase2:CRunMBase= null;
			var distance:Number= 10000000;
			for (nObjects=0; nObjects<this.rh.rhNObjects; pOL++, nObjects++)
			{
				while(this.rh.rhObjectList[pOL]==null) pOL++;
				var pObject:CObject=this.rh.rhObjectList[pOL];
				if (CServices.compareStringsIgnoreCase(pObject.hoOiList.oilName, jointObject))
				{
					var pMBaseObject:CRunMBase= this.GetMBase(pObject);
					if (pMBaseObject != null)
					{
						var deltaX:int= pMBaseObject.m_pHo.hoX - pMBase1.m_pHo.hoX;
						var deltaY:int= pMBaseObject.m_pHo.hoY - pMBase1.m_pHo.hoY;
						var d:Number= Math.sqrt(deltaX * deltaX + deltaY * deltaY);
						if (d <= distance)
						{
							distance = d;
							pMBase2 = pMBaseObject;
						}
					}
				}
			}
			if (pMBase2 != null)
			{
				var pJoint:CJoint= this.CreateJoint(jointName);
				var position1:b2Vec2= new b2Vec2(0,0);
				var position2:b2Vec2= new b2Vec2(0,0);
				
				if (pJoint != null)
				{
					switch (jointType)
					{
						case CRunBox2DBase.JTYPE_REVOLUTE:
						{
							var jointDefR:b2RevoluteJointDef = new b2RevoluteJointDef();
							jointDefR.collideConnected=true;
							if (param1 > param2)
								jointDefR.enableLimit = false;
							else
							{
								jointDefR.enableLimit = true;
								jointDefR.lowerAngle = param1;
								jointDefR.upperAngle = param2;
							}
							var position:b2Vec2= null;
							switch (jointAnchor)
							{
								case CRunBox2DBase.JANCHOR_HOTSPOT:
									position=pMBase1.m_body.GetPosition();
									break;
								case CRunBox2DBase.JANCHOR_ACTIONPOINT:
									position=this.GetActionPointPosition(pMBase1);
									break;
							}
							jointDefR.Initialize(pMBase1.m_body, pMBase2.m_body, position);
							pJoint.SetJoint(CRunBox2DBase.TYPE_REVOLUTE, this.world.CreateJoint(b2JointDef(jointDefR)));
							return pJoint.m_joint;
						}
						case CRunBox2DBase.JTYPE_DISTANCE:
						{
							var jointDefD:b2DistanceJointDef = new b2DistanceJointDef();
							jointDefD.collideConnected=true;
							jointDefD.frequencyHz = param1;
							jointDefD.dampingRatio = param2;
							switch (jointAnchor)
							{
								case CRunBox2DBase.JANCHOR_HOTSPOT:
									position1=pMBase1.m_body.GetPosition();
									position2=pMBase2.m_body.GetPosition();
									break;
								case CRunBox2DBase.JANCHOR_ACTIONPOINT:
									position1=this.GetActionPointPosition(pMBase1);
									position2=this.GetActionPointPosition(pMBase2);
									break;
							}
							jointDefD.Initialize(pMBase1.m_body, pMBase2.m_body, position1, position2);
							pJoint.SetJoint(CRunBox2DBase.TYPE_DISTANCE, this.world.CreateJoint(b2JointDef(jointDefD)));
							return pJoint.m_joint;
						}
						case CRunBox2DBase.JTYPE_PRISMATIC:
						{
							var jointDefP:b2PrismaticJointDef = new b2PrismaticJointDef();
							jointDefP.collideConnected=true;
							jointDefP.motorSpeed = 0.0;
							if (param1 > param2)
								jointDefP.enableLimit = false;
							else
							{
								jointDefP.enableLimit = true;
								jointDefP.lowerTranslation = param1 / this.factor;
								jointDefP.upperTranslation = param2 / this.factor;
							}
							//var position1:b2Vec2= new b2Vec2(0,0);
							//var position2:b2Vec2= new b2Vec2(0,0);
							switch (jointAnchor)
							{
								case CRunBox2DBase.JANCHOR_HOTSPOT:
									position1=pMBase1.m_body.GetPosition();
									position2=pMBase2.m_body.GetPosition();
									break;
								case CRunBox2DBase.JANCHOR_ACTIONPOINT:
									position1=this.GetActionPointPosition(pMBase1);
									position2=this.GetActionPointPosition(pMBase2);
									break;
							}
							var axis:b2Vec2= new b2Vec2(position1.x-position2.x, position1.y-position2.y);
							jointDefP.Initialize(pMBase1.m_body, pMBase2.m_body, position1, axis);
							pJoint.SetJoint(CRunBox2DBase.TYPE_PRISMATIC, this.world.CreateJoint(b2JointDef(jointDefP)));
							return pJoint.m_joint;
						}
					}
				}
			}
			return null;
		}
		
		public function rWorldToFrame(pVec:b2Vec2):void {
			pVec.x=(pVec.x*this.factor)-this.xBase;
			pVec.y=this.yBase-(pVec.y*this.factor);
		}
		
		public function rFrameToWorld(pVec:b2Vec2):void {
			pVec.x=(this.xBase+pVec.x)/this.factor;
			pVec.y=(this.yBase-pVec.y)/this.factor;
		}
		
		public function getAnimDir(pHo:CObject, dir:int):int {
			var raPtr:CRAni= pHo.roa;
			
			var adPtr:CAnimDir= raPtr.raAnimOffset.anDirs[dir];
			if (adPtr != null)
				return dir;
			
			if ((raPtr.raAnimOffset.anAntiTrigo[dir] & 0x40) != 0)
				dir = raPtr.raAnimOffset.anAntiTrigo[dir] & 0x3F;
			else if ((raPtr.raAnimOffset.anTrigo[dir] & 0x40) != 0)
				dir = raPtr.raAnimOffset.anTrigo[dir] & 0x3F;
			else
			{
				var offset:int= dir;
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
		public function rCreateBody(type:uint, x:int, y:int, angle:Number, gravity:Number, pBase:CRunMBase, flags:int, deceleration:Number):b2Body
		{
			if (pBase != null && type != b2Body.b2_staticBody && pBase.m_type!= CRunMBase.MTYPE_PLATFORM && pBase.m_type!= CRunMBase.MTYPE_OBSTACLE)
			{
				var n:int;
				var fans_size:int= this.fans.size();
				var treadmills_size:int= this.treadmills.size();
				var magnets_size:int= this.magnets.size();
				
				for (n=0; n < fans_size; n++)
					this.fans.get(n).rAddObject(pBase);
				for (n=0; n < treadmills_size; n++)
					this.treadmills.get(n).rAddObject(pBase);
				for (n=0; n < magnets_size; n++)
					this.magnets.get(n).rAddObject(pBase);
			}
			
			var bodyDef:b2BodyDef= new b2BodyDef();
			bodyDef.type = type;
			bodyDef.position.Set(Number(this.xBase+x)/this.factor, Number(this.yBase-y)/this.factor);
			bodyDef.angle = Number(angle * Math.PI / 180.0);
			bodyDef.gravityScale = gravity;
			bodyDef.fixedRotation=false;
			if ((flags & CBFLAG_FIXEDROTATION) != 0)
				bodyDef.fixedRotation=true;
			if ((flags & CBFLAG_BULLET) != 0)
				bodyDef.bullet=true;
			if ((flags & CBFLAG_DAMPING) != 0)
				bodyDef.linearDamping=deceleration;
			
			var pBody:b2Body= this.world.CreateBody(bodyDef);
			if(pBody != null)
				pBody.SetUserData(pBase);
			
			return pBody;
		}
		
		public override function rDestroyBody(pBody:b2Body):void
		{
			if (this.contactListener.bWorking)
			{
				this.bodiesToDestroy.add(pBody);
				return;
			}
			
			var pBase:CRunMBase= CRunMBase(pBody.GetUserData());
			if (pBase != null && pBase.m_type!= CRunMBase.MTYPE_PLATFORM && pBase.m_type!= CRunMBase.MTYPE_OBSTACLE)
			{
				var n:int;
				var fans_size:int= this.fans.size();
				var treadmills_size:int= this.treadmills.size();
				var magnets_size:int= this.magnets.size();
				
				for (n=0; n < fans_size; n++)
					this.fans.get(n).rRemoveObject(pBase);
				for (n=0; n < treadmills_size; n++)
					this.treadmills.get(n).rRemoveObject(pBase);
				for (n=0; n < magnets_size; n++)
					this.magnets.get(n).rRemoveObject(pBase);
			}
			destroyJointsWithBody(pBody);
			rBodyStopForce(pBody);
			rBodyStopTorque(pBody);
			this.world.DestroyBody(pBody);
			pBody = null;
		}
		
		public function rBodyCreateBoxFixture(pBody:b2Body, pMBase:CRunMBase, x:int, y:int, sx:int, sy:int, density:Number, friction:Number, restitution:Number):b2Fixture
		{
			var box:b2PolygonShape= new b2PolygonShape();
			sx-=1;
			sy-=1;
			if (pMBase != null)
			{
				pMBase.rc.left = - sx / 2;
				pMBase.rc.right = sx / 2;
				pMBase.rc.top = - sy / 2;
				pMBase.rc.bottom = sy / 2;
			}
			
			var vect:b2Vec2= new b2Vec2(Number(this.xBase + x) / this.factor, Number(this.yBase - y) / this.factor);
			//box.SetAsBox((sx/2.0/this.factor), (sy/2.0/this.factor), pBody.GetLocalPoint(vect), 0);
			box.SetAsBox((Number(sx)/2.0)/this.factor, (Number(sy)/2.0)/this.factor);
			
			var fixtureDef:b2FixtureDef= new b2FixtureDef();
			fixtureDef.shape = box;
			fixtureDef.density = density;
			fixtureDef.friction = friction;
			fixtureDef.restitution=restitution;
			var pFixture:b2Fixture= pBody.CreateFixture(fixtureDef);
			pFixture.SetUserData(this);
			return pFixture;
		}
		
		public function rBodyCreateCircleFixture(pBody:b2Body, pMBase:CRunMBase, x:int, y:int, radius:int, density:Number, friction:Number, restitution:Number):b2Fixture {
			if (pMBase != null)
			{
				pMBase.rc.left = - radius;
				pMBase.rc.right = radius;
				pMBase.rc.top = - radius;
				pMBase.rc.bottom = radius;
			}
			
			var circle:b2CircleShape= new b2CircleShape();
			circle.SetRadius(radius/this.factor);
			var vect:b2Vec2= new b2Vec2(((this.xBase+x)/this.factor), ((this.yBase-y)/this.factor));
			var local:b2Vec2=pBody.GetLocalPoint(vect);
			circle.SetLocalPosition(local);
			
			var fixtureDef:b2FixtureDef= new b2FixtureDef();
			fixtureDef.shape = circle;
			fixtureDef.density = density;
			fixtureDef.friction = friction;
			fixtureDef.restitution=restitution;
			var pFixture:b2Fixture= pBody.CreateFixture(fixtureDef);
			pFixture.SetUserData(this);
			return pFixture;
		}
		
		public function rCreateDistanceJoint(pBody1:b2Body, pBody2:b2Body, dampingRatio:Number, frequency:Number, x:int, y:int):b2Joint {
			var position1:b2Vec2= new b2Vec2(pBody1.GetPosition().x, pBody1.GetPosition().y);
			position1.x+=x/this.factor;
			position1.y+=y/this.factor;
			var position2:b2Vec2= new b2Vec2(pBody2.GetPosition().x, pBody2.GetPosition().y);
			var JointDef:b2DistanceJointDef= new b2DistanceJointDef();
			JointDef.collideConnected = true;
			JointDef.frequencyHz=frequency;
			JointDef.dampingRatio=dampingRatio;
			JointDef.Initialize(pBody1, pBody2, position1, position2);
			return this.world.CreateJoint(JointDef);
		}
		public function rBodyApplyForce(pBody:b2Body, force:Number, angle:Number):void {
			var kFactor:Number = 1;
			var f:b2Vec2= new b2Vec2((force * kFactor * Math.cos(angle * Math.PI / 180.0)), (force * kFactor * Math.sin(angle * Math.PI / 180.0)));
			var n:int;
			var cForce:CForce;
			var forces_size:int= this.forces.size();
			for (n=0; n<forces_size; n++)
			{
				cForce = CForce(this.forces.get(n));
				if (cForce != null && cForce.m_body == pBody)
				{
					cForce.m_force = f;
					return;
				}
			}
			cForce = new CForce(pBody, f);
			this.forces.add(cForce);
		}
		
		public function rBodyStopForce(pBody:b2Body):void {
			var n:int;
			var cForce:CForce;
			var forces_size:int= this.forces.size();
			for (n=0; n<forces_size; n++)
			{
				cForce = CForce(this.forces.get(n));
				if (cForce != null && cForce.m_body == pBody)
				{
					cForce.m_body.ApplyForceToCenter(new b2Vec2 (0,0));
					this.forces.removeIndex(n);
					break;
				}
			}
		}
		
		public function rBodyApplyAngularImpulse(pBody:b2Body, torque:Number):void {
			pBody.SetAngularVelocity(torque * 100);
		}
		public function rBodyApplyTorque(pBody:b2Body, torque:Number):void {
			var n:int;
			var cTorque:CTorque;
			var torques_size:int= this.torques.size();
			for (n=0; n<torques_size; n++)
			{
				cTorque = CTorque(this.torques.get(n));
				if (cTorque != null && cTorque.m_body == pBody)
				{
					cTorque.m_torque = torque;
					return;
				}
			}
			cTorque = new CTorque(pBody, torque);
			this.torques.add(cTorque);
		}
		public function rBodyStopTorque(pBody:b2Body):void {
			var n:int;
			var cTorque:CTorque;
			var torques_size:int= this.torques.size();
			for (n=0; n<torques_size; n++)
			{
				cTorque = CTorque(this.torques.get(n));
				if (cTorque != null && cTorque.m_body == pBody)
				{
					this.torques.removeIndex(n);
					break;
				}
			}
		}
		
		public function rRJointSetLimits(pJoint:b2RevoluteJoint, angle1:int, angle2:int):void {
			var lAngle:Number=angle1*Math.PI/180.0;
			var uAngle:Number=angle2*Math.PI/180.0;
			if (lAngle>uAngle)
			{
				pJoint.SetLimits(0, 0.0001);
				pJoint.EnableLimit(false);
			}
			else
			{
				pJoint.EnableLimit(true);
				pJoint.SetLimits(lAngle, uAngle);
			}
		}
		
		public function rRJointSetMotor(pJoint:b2RevoluteJoint, t:int, s:int):void {
			var torque:Number=t/100.0*CRunBox2DBase.RMOTORTORQUEMULT*this.RunFactor;
			var speed:Number=s/100.0*CRunBox2DBase.RMOTORSPEEDMULT*this.RunFactor;
			var flag:Boolean=true;
			if (torque==0 && speed==0)
				flag=false;
			pJoint.EnableMotor(flag);
			if(flag == true) {
				pJoint.SetMaxMotorTorque(torque);
				pJoint.SetMotorSpeed(speed);
			}
		}
		
		public function rWorldCreateRevoluteJoint(jointDef:b2RevoluteJointDef, body1:b2Body, body2:b2Body, position:b2Vec2):b2RevoluteJoint 
		{
			jointDef.Initialize(body1, body2, position);
			return b2RevoluteJoint(this.world.CreateJoint(jointDef));
		}
		
		public function rBodySetAngularVelocity(pBody:b2Body, torque:Number):void {
			pBody.SetAngularVelocity(torque);
		}
		public function rBodyAddVelocity(pBody:b2Body, vx:Number, vy:Number):void {
			var velocity:b2Vec2=pBody.GetLinearVelocity();
			velocity.x+=vx;
			velocity.y+=vy;
			pBody.SetLinearVelocity(velocity);
		}
		public function rBodyApplyMMFImpulse(pBody:b2Body, force:Number, angle:Number):void {
			var position:b2Vec2= new b2Vec2(pBody.GetWorldCenter().x, pBody.GetWorldCenter().y);
			angle = angle % 360;
			var f:b2Vec2= new b2Vec2((force * Math.cos(angle * Math.PI / 180.0)), (force * Math.sin(angle * Math.PI / 180.0)));
			pBody.ApplyImpulse(f, position);
		}
		public function rBodyApplyImpulse(pBody:b2Body, force:Number, angle:Number):void {
			var position:b2Vec2= new b2Vec2(pBody.GetPosition().x, pBody.GetPosition().y);
			var f:b2Vec2= new b2Vec2((force * Math.cos(angle * Math.PI / 180.0)), (force * Math.sin(angle * Math.PI / 180.0)));
			pBody.ApplyImpulse(f, position);
		}
		public function rBodyApplyImpulseToCenter(pBody:b2Body, force:Number, angle:Number):void {
			var position:b2Vec2= new b2Vec2(pBody.GetPosition().x, pBody.GetPosition().y);
			var f:b2Vec2= new b2Vec2((force * Math.cos(angle * Math.PI / 180.0)), (force * Math.sin(angle * Math.PI / 180.0)));
			pBody.ApplyForceToCenter(f);
		}
		public function rBodyGetAngle(body:b2Body):Number {
			return body.GetAngle() * 180.0 / Math.PI;
		}
		public function rBodySetPosition(pBody:b2Body, x:int, y:int):void {
			var angle:Number=pBody.GetAngle();
			var position:b2Vec2= new b2Vec2(pBody.GetPosition().x, pBody.GetPosition().y);
			if (x!=POSDEFAULT)
				position.x=(this.xBase+x)/this.factor;
			if (y!=POSDEFAULT)
				position.y=(this.yBase-y)/this.factor;
			pBody.setTransform(position, angle);
		}
		public function rBodySetAngle(pBody:b2Body, angle:Number):void {
			var position:b2Vec2= new b2Vec2(pBody.GetPosition().x, pBody.GetPosition().y);
			pBody.setTransform(position, angle * Math.PI / 180.0);
		}
		public function rBodySetLinearVelocity(pBody:b2Body, force:Number, angle:Number):void {
			var f:b2Vec2= new b2Vec2(force * Math.cos(angle * Math.PI / 180.0), force * Math.sin(angle * Math.PI / 180.0));
			pBody.SetLinearVelocity(f);
		}
		
		public function rBodyAddLinearVelocity(pBody:b2Body, speed:Number, angle:Number):void {
			var v:b2Vec2= new b2Vec2(speed * Math.cos(angle * Math.PI / 180.0), speed * Math.sin(angle * Math.PI / 180.0));
			var velocity:b2Vec2=pBody.GetLinearVelocity();
			velocity.x+=v.x;
			velocity.y+=v.y;
			pBody.SetLinearVelocity(velocity);
		}
		public function rBodySetLinearVelocityAdd(pBody:b2Body, force:Number, angle:Number, vx:Number, vy:Number):void {
			var f:b2Vec2= new b2Vec2(force * Math.cos(angle * Math.PI/ 180.0) + vx, force * Math.sin(angle * Math.PI/ 180.0) + vy);
			pBody.SetLinearVelocity(f);
		}
		public function isPoint(pMask:CMask, x:int, y:int):Boolean {
			return pMask.testPoint(0, 0, x, y);
		}
		public function PointOK(xNew:int, yNew:int, xOld:int, yOld:int, angle:CPointTest):Boolean {
			var deltaX:int=xNew-xOld;
			var deltaY:int=yNew-yOld;
			var a:Number=angle.angle;
			angle.angle=Math.atan2(deltaY, deltaX)*57.2957795;
			if (a==angle.angle)
				return false;
			return true;
		}
		public function rBodyCreateShapeFixture(pBody:b2Body, pMBase:CRunMBase, xp:int, yp:int, img:Number, density:Number, friction:Number, restitution:Number, scaleX:Number, scaleY:Number):b2Fixture {
			var image:CImage= this.rh.rhApp.imageBank.getImageFromHandle(img);
			var pMask:CMask= image.getMask(CMask.GCMF_OBSTACLE, 0, 1.0, 1.0);
			
			var width:int;
			var height:int;
			if(pMask != null)
			{
				width=pMask.width;
				height=pMask.height;				
			}
			var x:int, y:int, xPrevious:int, yPrevious:int;
			var xArray:Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			var yArray:Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			var xPos:int= 0, yPos:int = 0;
			var count:int=0;
			var scaleError:Number= 1.0;    //(()height - 2.0f) / ()height;
			
			if (pMBase != null)
			{
				pMBase.rc.left = - width / 2;
				pMBase.rc.right = width / 2;
				pMBase.rc.top = - height/ 2;
				pMBase.rc.bottom = height / 2;
			}
			
			var bBackground:Boolean= false;
			if (density < 0)
			{
				density = 0;
				bBackground = true;
			}
			
			// Right - bottom
			for (y=height-1, xPos=-1; y>=0; y--)
			{
				for (x=width-1; x>=0; x--)
				{
					if (this.isPoint(pMask, x, y))
					{
						if (x>xPos)
						{
							xPos=x;
							yPos=y;
						}
						break;
					}
				}
			}
			if (xPos<0)
			{
				return this.rBodyCreateBoxFixture(pBody, pMBase, xp, yp, pMask.width, pMask.height, density, friction, restitution);
			}
			xPrevious=xArray[count]=xPos;
			yPrevious=yArray[count]=yPos;
			count++;
			
			// Right - top
			for (y=0, xPos=-1; y<height; y++)
			{
				for (x=width-1; x>=0; x--)
				{
					if (this.isPoint(pMask, x, y))
					{
						if (x>xPos)
						{
							xPos=x;
							yPos=y;
						}
						break;
					}
				}
			}
			var angle:CPointTest= new CPointTest();
			angle.angle=1000;
			var c:int;
			if (this.PointOK(xPos, yPos, xPrevious, yPrevious, angle))
			{
				for (c = 0; c < count; c++)
				{
					if (xArray[c] == xPos && yArray[c] == yPos)
						break;
				}
				if (c == count)
				{
					xPrevious=xArray[count]=xPos;
					yPrevious=yArray[count++]=yPos;
				}
			}
			
			// Top - right
			for (x=width-1, yPos=10000; x>=0; x--)
			{
				for (y=0; y<height; y++)
				{
					if (this.isPoint(pMask, x, y))
					{
						if (y<yPos)
						{
							xPos=x;
							yPos=y;
						}
						break;
					}
				}
			}
			for (c = 0; c < count; c++)
			{
				if (xArray[c] == xPos && yArray[c] == yPos)
					break;
			}
			if (c == count)
			{
				if (!this.PointOK(xPos, yPos, xPrevious, yPrevious, angle))
					count--;
				xPrevious=xArray[count]=xPos;
				yPrevious=yArray[count++]=yPos;
			}
			// Top - left
			for (x=0, yPos=10000; x<width; x++)
			{
				for (y=0; y<height; y++)
				{
					if (this.isPoint(pMask, x, y))
					{
						if (y<yPos)
						{
							xPos=x;
							yPos=y;
						}
						break;
					}
				}
			}
			for (c = 0; c < count; c++)
			{
				if (xArray[c] == xPos && yArray[c] == yPos)
					break;
			}
			if (c == count)
			{
				if (!this.PointOK(xPos, yPos, xPrevious, yPrevious, angle))
					count--;
				xPrevious=xArray[count]=xPos;
				yPrevious=yArray[count++]=yPos;
			}
			// Left - top
			for (y=0, xPos=10000; y<height; y++)
			{
				for (x=0; x<width; x++)
				{
					if (this.isPoint(pMask, x, y))
					{
						if (x<xPos)
						{
							xPos=x;
							yPos=y;
						}
						break;
					}
				}
			}
			for (c = 0; c < count; c++)
			{
				if (xArray[c] == xPos && yArray[c] == yPos)
					break;
			}
			if (c == count)
			{
				if (!this.PointOK(xPos, yPos, xPrevious, yPrevious, angle))
					count--;
				xPrevious=xArray[count]=xPos;
				yPrevious=yArray[count++]=yPos;
			}
			// Left - bottom
			for (y=height-1, xPos=10000; y>=0; y--)
			{
				for (x=0; x<width; x++)
				{
					if (this.isPoint(pMask, x, y))
					{
						if (x<xPos)
						{
							xPos=x;
							yPos=y;
						}
						break;
					}
				}
			}
			for (c = 0; c < count; c++)
			{
				if (xArray[c] == xPos && yArray[c] == yPos)
					break;
			}
			if (c == count)
			{
				if (!this.PointOK(xPos, yPos, xPrevious, yPrevious, angle))
					count--;
				xPrevious=xArray[count]=xPos;
				yPrevious=yArray[count++]=yPos;
			}
			// Bottom - left
			for (x=0, yPos=-1; x<width; x++)
			{
				for (y=height-1; y>=0; y--)
				{
					if (this.isPoint(pMask, x, y))
					{
						if (y>yPos)
						{
							xPos=x;
							yPos=y;
						}
						break;
					}
				}
			}
			for (c = 0; c < count; c++)
			{
				if (xArray[c] == xPos && yArray[c] == yPos)
					break;
			}
			if (c == count)
			{
				if (!this.PointOK(xPos, yPos, xPrevious, yPrevious, angle))
					count--;
				xPrevious=xArray[count]=xPos;
				yPrevious=yArray[count++]=yPos;
			}
			// Bottom - right
			for (x=width-1, yPos=-1; x>=0; x--)
			{
				for (y=height-1; y>=0; y--)
				{
					if (this.isPoint(pMask, x, y))
					{
						if (y>yPos)
						{
							xPos=x;
							yPos=y;
						}
						break;
					}
				}
			}
			for (c = 0; c < count; c++)
			{
				if (xArray[c] == xPos && yArray[c] == yPos)
					break;
			}
			if (c == count)
			{
				if (!this.PointOK(xPos, yPos, xPrevious, yPrevious, angle))
					count--;
				xArray[count]=xPos;
				yArray[count++]=yPos;
			}
			
			var n:int;
			var xMiddle:Number= 0;
			var yMiddle:Number= 0;
			if (!bBackground)
			{
				for (n = 0; n < count; n++)
				{
					xMiddle += xArray[n];
					yMiddle += yArray[n];
				}
				xMiddle /= count;
				yMiddle /= count;
			}
			else
			{
				xMiddle = width / 2;
				yMiddle = height / 2;
			}
			var vertices:Array = new Array(count);
			for (n=0; n<count; n++)
			{
				vertices[n] = new b2Vec2(Number(xArray[n]-xMiddle)/this.factor*scaleX*scaleError, Number(yMiddle-yArray[n])/this.factor*scaleY*scaleError);
			}
			
			var polygon:b2PolygonShape= new b2PolygonShape();
			var fixtureDef:b2FixtureDef= new b2FixtureDef();
			var edge:b2EdgeShape = null;

			if (count >2)
			{
				polygon.SetAsArray(vertices);
				fixtureDef.shape = polygon;
			}
			else if (count == 2)
			{
				edge = new b2EdgeShape(b2Vec2(vertices[0]), b2Vec2(vertices[1]));
				//edge.Set(b2Shape(vertices[0]), vertices[1]);
				fixtureDef.shape = edge;
			}
			else
				return this.rBodyCreateBoxFixture(pBody, pMBase, xp, yp, pMask.width, pMask.height, density, friction, restitution);
			
			fixtureDef.density = density;
			fixtureDef.friction = friction;
			fixtureDef.restitution=restitution;
			var pFixture:b2Fixture= pBody.CreateFixture(fixtureDef);
			if(pFixture)
				pFixture.SetUserData(this);
			return pFixture;
		}
		
		public override function rCreateBullet(angle:Number, speed:Number, pMBase:CRunMBase):b2Body
		{
			if ((this.flags & CRunBox2DBase.B2FLAG_BULLETCREATE)==0)
				return null;
			
			var hoPtr:CObject=pMBase.m_pHo;
			
			var bodyDef:b2BodyDef= new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.position.Set((this.xBase+hoPtr.hoX)*1.0/this.factor, (this.yBase-hoPtr.hoY)*1.0/this.factor);
			bodyDef.angle = (angle * Math.PI) / 180.0;
			bodyDef.gravityScale=this.bulletGravity;
			bodyDef.angularDamping = 0.01;
			bodyDef.linearDamping = 0.01;
			bodyDef.bullet = true;
			var pBody:b2Body=this.world.CreateBody(bodyDef);
			pBody.SetUserData(pMBase);
			
			this.rBodyCreateShapeFixture(pBody, pMBase, hoPtr.hoX, hoPtr.hoY, hoPtr.roc.rcImage, this.bulletDensity, this.bulletFriction, this.bulletRestitution, 1.0, 1.0);
			this.objects.add(pMBase);
			
			speed *= (0.21/this.RunFactor);
			var velocity:b2Vec2= new b2Vec2( (speed * Math.cos(angle * Math.PI / 180.0)),(speed * Math.sin(angle * Math.PI / 180.0)));
			pBody.SetLinearVelocity(velocity);
			
			return pBody;
		}
		public function rBodyResetMassData(pBody:b2Body):void {
			pBody.ResetMassData();
		}
		public function rBodySetTransform(pBody:b2Body, position:b2Vec2, angle:Number):void {
			pBody.setTransform(position, angle);
		}
		public function rDestroyJoint(joint:b2Joint):void {
			this.world.DestroyJoint(joint);
		}
		public override function rGetBodyPosition(pBody:b2Body, o:CRunBox2DBasePosAndAngle):void {
			var vect:b2Vec2= pBody.GetPosition();
			var position:b2Vec2= new b2Vec2(vect.x, vect.y);
			this.rWorldToFrame(position);
			o.x=int(position.x);
			o.y=int(position.y);
			o.angle = int(pBody.GetAngle() * 180.0 / Math.PI);
		}
		public function rGetImageDimensions(img:Number, o:CRunBox2DBaseImageDimension):void {
			var image:CImage= this.rh.rhApp.imageBank.getImageFromHandle(img);
			var pMask:CMask= image.getMask(0, 0, 1.0, 1.0);
			
			var xx:int, yy:int, previousX:int=-1, previousY:int=-1;
			var count:int=1;
			var height:int= pMask.height;
			var width:int= pMask.width;
			o.y1=0;
			o.y2=height-1;
			var quit:Boolean= false;
			for (yy=0, quit=false; yy<height; yy++)
			{
				for (xx=0; xx<width; xx++)
				{
					if (this.isPoint(pMask, xx, yy))
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
					if (this.isPoint(pMask, xx, yy))
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
					if (this.isPoint(pMask, xx, yy))
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
					if (this.isPoint(pMask, xx, yy))
					{
						o.x2=xx;
						quit=true;
						break;
					}
				}
				if (quit) break;
			}
		}
		
		public function rBodyCreatePlatformFixture(pBody:b2Body, pMBase:CRunMBase, img:Number, vertical:int, density:Number, friction:Number, restitution:Number, o:CRunBox2DBaseImageDimension, scaleX:Number, scaleY:Number, maskWidth:Number):b2Fixture {
			var dims:CRunBox2DBaseImageDimension= new CRunBox2DBaseImageDimension();
			this.rGetImageDimensions(img, dims);
			dims.x1 = int((dims.x1 * scaleX));
			dims.x2 = int((dims.x2 * scaleX));
			dims.y1 = int((dims.y1 * scaleY));
			dims.y2 = int((dims.y2 * scaleY));
			maskWidth = Math.max(maskWidth, 0.1);
			
			var image:CImage= this.rh.rhApp.imageBank.getImageFromHandle(img);
			var pMask:CMask= null;
			if(image != null)
				pMask = image.getMask(0, 0, 1.0, 1.0);
			var xx:Number, yy:Number;
			var vertices:Array = new Array(6);
			var n:int;
			var sx:Number=0;
			var middleX:Number=0;
			var middleY:Number=0;
			var sy:Number=0;
			for (n=0; n<6; n++)
				vertices[n] = new b2Vec2(0, 0);
			
			if (vertical == 0)
			{
				sx=dims.x2-dims.x1;
				middleX=(dims.x1+dims.x2)/2;
				middleY=0;
				sy=(dims.y1+dims.y2)/2;
				xx=-sx/4*maskWidth;
				yy=middleY;
				vertices[0].Set(xx / this.factor, yy / this.factor);
				xx=sx/4*maskWidth;
				vertices[1].Set(xx / this.factor, yy / this.factor);
				xx=sx / 2* maskWidth;
				yy=middleY + sy / 8;
				vertices[2].Set(xx / this.factor, yy / this.factor);
				xx=sx/2*maskWidth;
				yy=middleY+sy*2;
				vertices[3].Set(xx / this.factor, yy / this.factor);
				xx=-sx/2*maskWidth;
				vertices[4].Set(xx / this.factor, yy / this.factor);
				xx=- sx / 2* maskWidth;
				yy=middleY + sy / 8;
				vertices[5].Set(xx / this.factor, yy / this.factor);
				o.x1 = int(sx);
				o.y1 = int(sy);
				pMBase.rc.left = -int(middleX);
				pMBase.rc.right = int(middleX);
				pMBase.rc.top = -int(sy);
				pMBase.rc.bottom = int(sy);
			}
			else
			{
				sx=dims.y2-dims.y1;
				sy=dims.x2-dims.x1;
				middleX=sx/2;
				middleY=sy/2;
				xx=middleX;
				yy=0;
				vertices[0].Set(xx / this.factor, yy / this.factor);
				xx=sx;
				yy=middleY-sy/8;
				vertices[1].Set(xx / this.factor, yy / this.factor);
				yy=middleY+sy/8;
				vertices[2].Set(xx / this.factor, yy / this.factor);
				xx=middleX;
				yy=sy;
				vertices[3].Set(xx / this.factor, yy / this.factor);
				xx=0;
				yy=middleY+sy/8;
				vertices[4].Set(xx / this.factor, yy / this.factor);
				yy=middleY-sy/8;
				vertices[5].Set(xx / this.factor, yy / this.factor);
				o.x1 = int(sx);
				o.y1 = int(sy);
				pMBase.rc.left = -int(middleX);
				pMBase.rc.right = int(middleX);
				pMBase.rc.top = -int(middleY);
				pMBase.rc.bottom = int(middleY);
			}
			
			var polygon:b2PolygonShape= new b2PolygonShape();
			polygon.SetAsArray(vertices, 0);
			var fixtureDef:b2FixtureDef= new b2FixtureDef();
			fixtureDef.shape = polygon;
			fixtureDef.density = density;
			fixtureDef.friction = friction;
			fixtureDef.restitution=restitution;
			var pFixture:b2Fixture= pBody.CreateFixture(fixtureDef);
			pFixture.SetUserData(this);
			return pFixture;
		}
		
		public function computeGroundObjects():void {
			var rhPtr:CRun=this.ho.hoAdRunHeader;
			var pOL:int= 0;
			var ocGround:CObjectCommon= null;
			var ocGrounds:CArrayList = new CArrayList();
			for (var nObjects:int=0; nObjects<rhPtr.rhNObjects; nObjects++)
			{
				while(rhPtr.rhObjectList[pOL]==null) pOL++;
				var pHo:CObject=rhPtr.rhObjectList[pOL];
				pOL++;
				if (pHo.hoType>=32)
				{
					if (pHo.hoCommon.ocIdentifier==CRunBox2DBase.GROUNDIDENTIFIER)
					{
						var pGround:CRunBox2DBaseParent= CRunBox2DBaseParent(CExtension(pHo).ext);
						if (pGround.identifier == this.identifier)
						{
							var n:int;
							for (n = 0; n < ocGrounds.size(); n++)
							{
								if (ocGrounds.get(n) == pHo.hoCommon)
									break;
							}
							if (n == ocGrounds.size())
							{
								ocGrounds.add(pHo.hoCommon);
								ocGround = pHo.hoCommon;
								var obstacle:Number= pGround.gObstacle;
								var direction:Number= pGround.gDirection;
								var pOL2:int= pOL;
								var list:CArrayList = new CArrayList();
								list.add(pGround);
								for (var nObjects2:int= nObjects + 1; nObjects2 < rhPtr.rhNObjects; nObjects2++)
								{
									while (rhPtr.rhObjectList[pOL2] == null) pOL2++;
									pHo = rhPtr.rhObjectList[pOL2];
									pOL2++;
									
									if (pHo.hoType>=32)
									{
										if (pHo.hoCommon.ocIdentifier == CRunBox2DBase.GROUNDIDENTIFIER && pHo.hoCommon == ocGround)
										{
											var pGround2:CRunBox2DBaseParent= CRunBox2DBaseParent(CExtension(pHo).ext);
											if (pGround2.identifier == this.identifier && pGround2.gObstacle == obstacle && pGround2.gDirection == direction)
											{
												list.add(pGround2);
											}
										}
									}
								}
								if (list.size() > 1)
								{
									var pos:int;
									var flag:Boolean;
									do
									{
										flag = false;
										pos = 0;
										do
										{
											var pSort1:CRunBox2DBaseParent= CRunBox2DBaseParent(list.get(pos));
											var pSort2:CRunBox2DBaseParent= CRunBox2DBaseParent(list.get(pos + 1));
											var temp:CRunBox2DBaseParent=null;
											var x1:int = pSort1.ho.hoX + 8;
											var x2:int = pSort2.ho.hoX + 8;
											var y1:int = pSort1.ho.hoY + 8;
											var y2:int = pSort2.ho.hoY + 8;
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
									
									var pSort:CRunBox2DBaseParent = CRunBox2DBaseParent(list.get(0));
									x1 = pSort.ho.hoX + 8;
									pSort = CRunBox2DBaseParent(list.get(list.size()-1));
									x2 = pSort.ho.hoX + 8;
									y1 = 10000;
									y2 = -10000;
									for (pos = 0; pos < list.size(); pos++)
									{
										pSort = CRunBox2DBaseParent(list.get(pos));
										y1 = Math.min(pSort.ho.hoY + 8, y1);
										y2 = Math.max(pSort.ho.hoY + 8, y2);
									}
									var middleX:int= (x1 + x2) / 2;
									var middleY:int= (y1 + y2) / 2;
									var height:int = Math.abs(y2 - y1);

									var pMBase:CRunMBase= new CRunMBase();
									pMBase.InitBase(pHo, obstacle==0?CRunMBase.MTYPE_OBSTACLE:CRunMBase.MTYPE_PLATFORM);
									pMBase.m_identifier = this.identifier;
									pMBase.m_subType = CRunMBase.MSUBTYPE_BOTTOM;
									pMBase.m_body = this.rCreateBody(b2Body.b2_staticBody, middleX, middleY, 0, 0, pMBase, 0, 0);
									pMBase.rc.left = -middleX;
									pMBase.rc.right = middleX;
									pMBase.rc.top = height;
									pMBase.rc.bottom = height;
									
									var chain:Array = new Array(list.size());
									var fixtureDef:b2FixtureDef= new b2FixtureDef();
									fixtureDef.density = 1.0;
									fixtureDef.friction = pGround.gFriction;
									fixtureDef.restitution = pGround.gRestitution;
									// CCW for polygon shape
									for (pos = 0; pos < list.size()-1; pos++)
									{
										chain[pos] = new b2Vec2(0,0);
										pSort = CRunBox2DBaseParent(list.get(pos));
										x1 = pSort.ho.hoX + 8;
										y1 = pSort.ho.hoY + 8;
										chain[pos].Set(Number((x1 - middleX)*1.0)/this.factor, -1.0*(Number(y1 - middleY)/this.factor));
										
										chain[pos+1] = new b2Vec2(0,0);
										pSort = CRunBox2DBaseParent(list.get(pos+1));
										x1 = pSort.ho.hoX + 8;
										y1 = pSort.ho.hoY + 8;
										chain[pos+1].Set(Number((x1 - middleX)*1.0)/this.factor, -1.0*(Number(y1 - middleY)/this.factor));
										var shape:b2PolygonShape = new b2PolygonShape();									
										shape.SetAsEdge(chain[pos], chain[pos+1]);
										fixtureDef.shape = shape;
										var fixture:b2Fixture = pMBase.m_body.CreateFixture(fixtureDef);
										fixture.SetUserData(this);
									}
								}
							}
						}
					}
				}
			}
		}
		
		public function createBorders():void {
			var pBase:CRunMBase= new CRunMBase();
			pBase.InitBase(null, CRunMBase.MTYPE_BORDERBOTTOM);
			pBase.m_body = this.rCreateBody(b2Body.b2_staticBody, this.rh.rhLevelSx/2, this.rh.rhLevelSy + 8, 0, 0, pBase, 0, 0);
			this.rBodyCreateBoxFixture(pBase.m_body, pBase, this.rh.rhLevelSx/2, this.rh.rhLevelSy + 8, this.rh.rhLevelSx, 16, 0, 1, 0);
			
			pBase = new CRunMBase();
			pBase.InitBase(null, CRunMBase.MTYPE_BORDERLEFT);
			pBase.m_body = this.rCreateBody(b2Body.b2_staticBody, -8, this.rh.rhLevelSy / 2, 0, 0, pBase, 0, 0);
			this.rBodyCreateBoxFixture(pBase.m_body, pBase, -8, this.rh.rhLevelSy / 2, 16, this.rh.rhLevelSy, 0, 1, 0);
			
			pBase = new CRunMBase();
			pBase.InitBase(null, CRunMBase.MTYPE_BORDERRIGHT);
			pBase.m_body = this.rCreateBody(b2Body.b2_staticBody, this.rh.rhLevelSx + 8, this.rh.rhLevelSy / 2, 0, 0, pBase, 0, 0);
			this.rBodyCreateBoxFixture(pBase.m_body, pBase, this.rh.rhLevelSx + 8, this.rh.rhLevelSy / 2, 16, this.rh.rhLevelSy, 0, 1, 0);
			
			pBase = new CRunMBase();
			pBase.InitBase(null, CRunMBase.MTYPE_BORDERTOP);
			pBase.m_body = this.rCreateBody(b2Body.b2_staticBody, this.rh.rhLevelSx / 2, -8, 0, 0, pBase, 0, 0);
			this.rBodyCreateBoxFixture(pBase.m_body, pBase, this.rh.rhLevelSx / 2, -8, this.rh.rhLevelSx, 16, 0, 1, 0);
		}
		
		public function Find_HeaderObject(hlo:Number):CObject {
			var pOL:int= 0;
			for (var nObjects:int=0; nObjects<this.rh.rhNObjects; nObjects++)
			{
				while(this.rh.rhObjectList[pOL]==null)
					pOL++;
				var pHo:CObject=this.rh.rhObjectList[pOL];
				if (hlo==pHo.hoHFII)
					return pHo;
				pOL++;
			}
			return null;
		}
		
		public function computeBackdropObjects():void {
			var rhPtr:CRun=this.rh;
			var pCurFrame:CRunFrame=rhPtr.rhFrame;
			var pCurApp:CRunApp=rhPtr.rhApp;
			
			var nLayer:int, i:int;
			var plo:CLO;
			var hoPtr:CObject= null;
			var poi:COI= null;
			var poc:COC= null;
			var pOCommon:CObjectCommon= null;
			
			for (nLayer=0; nLayer < pCurFrame.layers.length; nLayer++)
			{
				var pLayer:CLayer= pCurFrame.layers[nLayer];
				
				// Invisible layer? continue
				if ( (pLayer.dwOptions&CLayer.FLOPT_VISIBLE) == 0)
				{
					continue;
				}
				
				var cpt:int;
				for (i=pLayer.nFirstLOIndex, cpt = 0; cpt < pLayer.nBkdLOs; i++, cpt++)
				{
					plo = this.rh.rhFrame.LOList.list[i];
					var x:int, y:int;
					var typeObj:int= plo.loType;
					var width:int, height:int, obstacle:int;
					
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
						pOCommon = CObjectCommon(poi.oiOC);
						if ( (pOCommon.ocOEFlags & CObjectCommon.OEFLAG_BACKGROUND) == 0|| (hoPtr = Find_HeaderObject(plo.loHandle)) == null )
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
						var pBase:CRunMBase= new CRunMBase();
						if (obstacle==COC.OBSTACLE_SOLID)
							pBase.m_type = CRunMBase.MTYPE_OBSTACLE;
						else
							pBase.m_type = CRunMBase.MTYPE_PLATFORM;
						pBase.m_body = this.rCreateBody(b2Body.b2_staticBody, x + width / 2, y + height / 2, 0, 0, pBase, 0, 0);
						if (typeObj==COI.OBJ_BOX || typeObj >= COI.OBJ_SPR)
							this.rBodyCreateBoxFixture(pBase.m_body, pBase, x+width/2, y+height/2, width, height, 0, this.friction, this.restitution);
						else
						{
							var img:Number= (COCBackground(poc)).ocImage;
							this.rBodyCreateShapeFixture(pBase.m_body, pBase, x+width/2, y+height/2, img, -1, this.friction, this.restitution, 1.0, 1.0);
						}
					}
				}
			}
		}
		
		private function CheckOtherEngines():Boolean {
			var pOL:int= 0;
			var nObjects:int= 0;
			for (nObjects = 0; nObjects < this.rh.rhNObjects; pOL++, nObjects++)
			{
				while (this.rh.rhObjectList[pOL] == null) pOL++;
				var pObject:CObject= this.rh.rhObjectList[pOL];
				if (pObject.hoType >= 32)
				{
					if (pObject != this.ho)
					{
						if (pObject.hoCommon.ocIdentifier == CRun.BASEIDENTIFIER)
						{
							var pExt:CExtension= CExtension(pObject);
							var pBase:CRunBaseParent= CRunBaseParent(pExt.ext);
							if (pBase.identifier == this.identifier)
							{
								return true;
							}
						}
					}
				}
			}
			return false;
		}
		
		
		public override function rStartObject():Boolean {
			if (!this.started)
			{
				this.started=true;
				this.GetObjects();
				if ((this.flags & CRunBox2DBase.B2FLAG_ADDBACKDROPS)!=0)
					this.computeBackdropObjects();
				
				this.computeGroundObjects();
			}
			return false;
		}
		
		public function GetHO(fixedValue:int):CObject {
			var hoPtr:CObject=this.rh.rhObjectList[fixedValue&0xFFFF];
			if (hoPtr!=null && hoPtr.hoCreationId==fixedValue>>16)
				return hoPtr;
			return null;
		}
	}
}

import Box2D.Common.Math.b2Vec2;
class CForce
{
	public var m_body:b2Body;
	public var m_force:b2Vec2;
	
	public function CForce(body:b2Body, force:b2Vec2)
	{
		m_body = body;
		m_force = force;
	}
}

import Box2D.Dynamics.b2Body;

class CTorque
{
	public var m_body:b2Body;
	public var m_torque:Number;
	
	public function CTorque(body:b2Body, torque:Number)
	{
		m_body = body;
		m_torque = torque;
	}
}

import Box2D.Dynamics.Joints.b2Joint;
import Extensions.CRunBox2DBase;

internal class CJoint
{
	public var m_rdPtr:CRunBox2DBase= null;
	public var m_name:String= null;
	public var m_type:int= 0;
	public var m_joint:b2Joint=null;
	
	public function CJoint(rdPtr:CRunBox2DBase, name:String)
	{
		m_rdPtr = rdPtr;
		m_name = name;
	}
	public function DestroyJoint():void {
		m_rdPtr.world.DestroyJoint(m_joint);
	}
	public function SetJoint(type:int, joint:b2Joint):void {
		m_type=type;
		m_joint=joint;
	}
}

import Objects.*;
import RunLoop.*;
import Extensions.CRunBox2DBaseParent;
import Extensions.CRunBox2DBaseElementParent;

import Box2D.Dynamics.b2ContactListener;
import Box2D.Dynamics.b2ContactImpulse;
import Box2D.Dynamics.Contacts.b2Contact;
import Box2D.Collision.b2Manifold;
import Box2D.Dynamics.b2Body;
import Box2D.Dynamics.b2Fixture;
import Box2D.Dynamics.Contacts.b2ContactEdge;

internal class CContactListener extends b2ContactListener
{
	private static const CNDL_EXTCOLLISION:int=(-14<<16);
	private static const CNDL_EXTCOLBACK:int= (-13<< 16);
	private static const BORDER_LEFT:int= 1;
	private static const BORDER_RIGHT:int= 2;
	private static const BORDER_TOP:int= 4;
	private static const BORDER_BOTTOM:int= 8;
	private static const CNDL_EXTOUTPLAYFIELD:int= (-12<< 16);
	private static const MAGIC:int= 0x12345678;
	private static const CND_PARTICULECOLLISION:int= 1;
	private static const CND_PARTICULEOUTLEFT:int= 2;
	private static const CND_PARTICULEOUTRIGHT:int= 3;
	private static const CND_PARTICULEOUTTOP:int= 4;
	private static const CND_PARTICULEOUTBOTTOM:int= 5;
	private static const CND_PARTICULESCOLLISION:int= 6;
	private static const CND_PARTICULECOLLISIONBACKDROP:int= 7;
	private static const CND_ELEMENTCOLLISION:int= 1;
	private static const CND_ELEMENTCOLLISIONBACKDROP:int= 7;
	
	public var bWorking:Boolean= false;
	
	public override function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void {
		bWorking = true;
		
		var bodyB:b2Body= contact.GetFixtureB().GetBody();
		var bodyA:b2Body= contact.GetFixtureA().GetBody();
		var rdPtr:CRunBox2DBase=CRunBox2DBase(contact.GetFixtureA().GetUserData());
		var rhPtr:CRun=rdPtr.ho.hoAdRunHeader;
		
		var movement1:CRunMBase=CRunMBase(bodyA.GetUserData());
		var movement2:CRunMBase=CRunMBase(bodyB.GetUserData());
		var movement:CRunMBase;
		var movementB:CRunMBase;
		
		var pHo:CExtension;
		var particule:CRunMBase, element:CRunMBase;
		var parent:CRunBox2DBaseParent;
		if (movement1==null || movement2==null)
		{
			contact.SetEnabled(false);
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
						contact.SetEnabled(false);
					break;
				case CRunMBase.MTYPE_FAKEOBJECT:
					contact.SetEnabled(false);
					break;
				case CRunMBase.MTYPE_PARTICULE:
					parent = (CRunBox2DBaseElementParent(movement)).parent;
					parent.currentParticule1 = CRunBox2DBaseElementParent(movement);
					parent.currentParticule2 = null;
					parent.stopped = false;
					(CExtension(movement.m_pHo)).generateEvent(CND_PARTICULEOUTLEFT, 0);
					if (!parent.stopped)
						contact.SetEnabled(false);
					break;
				case CRunMBase.MTYPE_ELEMENT:
					parent = (CRunBox2DBaseElementParent(movement)).parent;
					parent.currentElement = CRunBox2DBaseElementParent(movement);
					parent.stopped = false;
					(CExtension(movement.m_pHo)).generateEvent(CND_PARTICULEOUTLEFT, 0);
					if (!parent.stopped)
						contact.SetEnabled(false);
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
						contact.SetEnabled(false);
					break;
				case CRunMBase.MTYPE_FAKEOBJECT:
					contact.SetEnabled(false);
					break;
				case CRunMBase.MTYPE_PARTICULE:
					parent = (CRunBox2DBaseElementParent(movement)).parent;
					parent.currentParticule1 = CRunBox2DBaseElementParent(movement);
					parent.currentParticule2 = null;
					parent.stopped = false;
					(CExtension(movement.m_pHo)).generateEvent(CND_PARTICULEOUTRIGHT, 0);
					if (!parent.stopped)
						contact.SetEnabled(false);
					break;
				case CRunMBase.MTYPE_ELEMENT:
					parent = (CRunBox2DBaseElementParent(movement)).parent;
					parent.currentElement = CRunBox2DBaseElementParent(movement);
					parent.stopped = false;
					(CExtension(movement.m_pHo)).generateEvent(CND_PARTICULEOUTRIGHT, 0);
					if (!parent.stopped)
						contact.SetEnabled(false);
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
						contact.SetEnabled(false);
					break;
				case CRunMBase.MTYPE_FAKEOBJECT:
					contact.SetEnabled(false);
					break;
				case CRunMBase.MTYPE_PARTICULE:
					parent = (CRunBox2DBaseElementParent(movement)).parent;
					parent.currentParticule1 = CRunBox2DBaseElementParent(movement);
					parent.currentParticule2 = null;
					parent.stopped = false;
					(CExtension(movement.m_pHo)).generateEvent(CND_PARTICULEOUTTOP, 0);
					if (!parent.stopped)
						contact.SetEnabled(false);
					break;
				case CRunMBase.MTYPE_ELEMENT:
					parent = (CRunBox2DBaseElementParent(movement)).parent;
					parent.currentElement = CRunBox2DBaseElementParent(movement);
					parent.stopped = false;
					(CExtension(movement.m_pHo)).generateEvent(CND_PARTICULEOUTTOP, 0);
					if (!parent.stopped)
						contact.SetEnabled(false);
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
					if(contact.IsTouching())
						rhPtr.rhEvtProg.handle_Event(movement.m_pHo, CNDL_EXTOUTPLAYFIELD);
					if (!movement.IsStop())
						contact.SetEnabled(false);
					break;
				case CRunMBase.MTYPE_FAKEOBJECT:
					contact.SetEnabled(false);
					break;
				case CRunMBase.MTYPE_PARTICULE:
					parent = (CRunBox2DBaseElementParent(movement)).parent;
					parent.currentParticule1 = CRunBox2DBaseElementParent(movement);
					parent.currentParticule2 = null;
					parent.stopped = false;
					if(contact.IsTouching())
						(CExtension(movement.m_pHo)).generateEvent(CND_PARTICULEOUTBOTTOM, 0);
					if (!parent.stopped)
						contact.SetEnabled(false);
					break;
				case CRunMBase.MTYPE_ELEMENT:
					parent = (CRunBox2DBaseElementParent(movement)).parent;
					parent.currentElement = CRunBox2DBaseElementParent(movement);
					parent.stopped = false;
					if(contact.IsTouching())
						(CExtension(movement.m_pHo)).generateEvent(CND_PARTICULEOUTBOTTOM, 0);
					if (!parent.stopped)
						contact.SetEnabled(false);
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
					if(contact.IsTouching())
						rhPtr.rhEvtProg.handle_Event(movement.m_pHo, CNDL_EXTCOLBACK);
					if (!movement.IsStop())
						contact.SetEnabled(false);
					break;
				case CRunMBase.MTYPE_FAKEOBJECT:
					contact.SetEnabled(false);
					break;
				case CRunMBase.MTYPE_PARTICULE:
					parent = (CRunBox2DBaseElementParent(movement)).parent;
					parent.currentParticule1 = CRunBox2DBaseElementParent(movement);
					parent.currentParticule2 = null;
					parent.stopped = false;
					if(contact.IsTouching())
						(CExtension(movement.m_pHo)).generateEvent(CND_PARTICULECOLLISIONBACKDROP, 0);
					if (!parent.stopped)
						contact.SetEnabled(false);
					break;
				case CRunMBase.MTYPE_ELEMENT:
					parent = (CRunBox2DBaseElementParent(movement)).parent;
					parent.currentElement = CRunBox2DBaseElementParent(movement);
					parent.stopped = false;
					if(contact.IsTouching())
						(CExtension(movement.m_pHo)).generateEvent(CND_ELEMENTCOLLISIONBACKDROP, 0);
					if (!parent.stopped)
						contact.SetEnabled(false);
					break;
			}
		}
		else if (movement1.m_type == CRunMBase.MTYPE_PLATFORM || movement2.m_type == CRunMBase.MTYPE_PLATFORM )
		{
			var velocity:b2Vec2;
			if (movement1.m_type==CRunMBase.MTYPE_PLATFORM)
			{
				movement = movement2;
				movementB = movement1;
				velocity=bodyB.GetLinearVelocity();
			}
			else
			{
				movement = movement1;
				movementB = movement2;
				velocity=bodyA.GetLinearVelocity();
			}
			switch (movement.m_type)
			{
				case CRunMBase.MTYPE_OBJECT:
					movement.PrepareCondition();
					movement.SetCollidingObject(movementB);
					rhPtr.rhEvtProg.handle_Event(movement.m_pHo, CNDL_EXTCOLBACK);
					if (!movement.IsStop())
						contact.SetEnabled(false);
					else
					{
						if (velocity.y>=0)
							contact.SetEnabled(false);
					}
					break;
				case CRunMBase.MTYPE_FAKEOBJECT:
					contact.SetEnabled(false);
					break;
				case CRunMBase.MTYPE_PARTICULE:
					parent = (CRunBox2DBaseElementParent(movement)).parent;
					parent.currentParticule1 = CRunBox2DBaseElementParent(movement);
					parent.currentParticule2 = null;
					parent.stopped = false;
					//velocity = movement.m_body.GetLinearVelocity();
					if(contact.IsTouching())
						(CExtension(movement.m_pHo)).generateEvent(CND_PARTICULECOLLISIONBACKDROP, 0);
					if (!parent.stopped)
						contact.SetEnabled(false);
					else
					{
						if (velocity.y >= 0)
							contact.SetEnabled(false);
					}
					break;
				case CRunMBase.MTYPE_ELEMENT:
					parent = (CRunBox2DBaseElementParent(movement)).parent;
					parent.currentElement = CRunBox2DBaseElementParent(movement);
					parent.stopped = false;
					//velocity = movement.m_body.GetLinearVelocity();
					if(contact.IsTouching())
						(CExtension(movement.m_pHo)).generateEvent(CND_ELEMENTCOLLISIONBACKDROP, 0);
					if (!parent.stopped)
						contact.SetEnabled(false);
					else
					{
						if (velocity.y >= 0)
							contact.SetEnabled(false);
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
								var temp:CRunMBase= movement;
								movement = movement2;
								movement2 = temp;
							}
							movement.PrepareCondition();
							movement2.PrepareCondition();
							movement.SetCollidingObject(movement2);
							movement2.SetCollidingObject(movement);
							rhPtr.rhEvtProg.rh1stObjectNumber = movement2.m_pHo.hoNumber;
							if(contact.IsTouching())
								rhPtr.rhEvtProg.handle_Event(movement.m_pHo, CNDL_EXTCOLLISION);
							if (!movement1.IsStop() && !movement2.IsStop())
								contact.SetEnabled(false);
							break;
						case CRunMBase.MTYPE_FAKEOBJECT:
							movement.PrepareCondition();
							movement2.PrepareCondition();
							movement.SetCollidingObject(movement2);
							rhPtr.rhEvtProg.rh1stObjectNumber = movement2.m_pHo.hoNumber;
							if(contact.IsTouching())
								rhPtr.rhEvtProg.handle_Event(movement.m_pHo, CNDL_EXTCOLLISION);
							if (!movement1.IsStop())
								contact.SetEnabled(false);
							break;
						case CRunMBase.MTYPE_PARTICULE:
							parent = (CRunBox2DBaseElementParent(movement2)).parent;
							parent.currentParticule1 = CRunBox2DBaseElementParent(movement2);
							parent.currentParticule2 = null;
							parent.stopped = false;
							parent.collidingHO = movement.m_pHo;
							movement.PrepareCondition();
							movement.SetCollidingObject(movement2);
							if(contact.IsTouching())
								(CExtension(movement2.m_pHo)).generateEvent(CND_PARTICULECOLLISION, movement.m_pHo.hoOi);
							if (!parent.stopped)
								contact.SetEnabled(false);
							break;
						case CRunMBase.MTYPE_ELEMENT:
							parent = (CRunBox2DBaseElementParent(movement2)).parent;
							//                            parent.currentObject = obstacle;
							parent.currentElement = CRunBox2DBaseElementParent(movement2);
							parent.stopped = false;
							parent.collidingHO = movement.m_pHo;
							movement.PrepareCondition();
							movement.SetCollidingObject(movement2);
							if(contact.IsTouching())
								(CExtension(movement2.m_pHo)).generateEvent(CND_ELEMENTCOLLISION, movement.m_pHo.hoOi);
							if (!parent.stopped)
								contact.SetEnabled(false);
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
							if(contact.IsTouching())
								rhPtr.rhEvtProg.handle_Event(movement2.m_pHo, CNDL_EXTCOLLISION);
							if (!movement2.IsStop())
								contact.SetEnabled(false);
							break;
						case CRunMBase.MTYPE_FAKEOBJECT:
							//                          rhPtr.rhEvtProg.rh1stObjectNumber = movement2.m_pHo.hoNumber;
							//                          rhPtr.rhEvtProg.handle_Event(movement1.m_pHo, CNDL_EXTCOLLISION);
							contact.SetEnabled(false);
							break;
						case CRunMBase.MTYPE_PARTICULE:
							parent = (CRunBox2DBaseElementParent(movement2)).parent;
							parent.currentParticule1 = CRunBox2DBaseElementParent(movement2);
							parent.currentParticule2 = null;
							parent.stopped = false;
							parent.collidingHO = movement.m_pHo;
							movement.PrepareCondition();
							if(contact.IsTouching())
								(CExtension(movement2.m_pHo)).generateEvent(CND_PARTICULECOLLISION, movement.m_pHo.hoOi);
							if (!parent.stopped)
								contact.SetEnabled(false);
							break;
						case CRunMBase.MTYPE_ELEMENT:
							parent = (CRunBox2DBaseElementParent(movement2)).parent;
							//                            parent.currentObject = obstacle;
							parent.currentElement = CRunBox2DBaseElementParent(movement2);
							parent.stopped = false;
							movement1.PrepareCondition();
							parent.stopped = false;
							parent.collidingHO = movement.m_pHo;
							if(contact.IsTouching())
								(CExtension(movement2.m_pHo)).generateEvent(CND_ELEMENTCOLLISION, movement.m_pHo.hoOi);
							if (!parent.stopped)
								contact.SetEnabled(false);
							break;
					}
					break;
				case CRunMBase.MTYPE_PARTICULE:
					switch (movement2.m_type)
					{
						case CRunMBase.MTYPE_OBJECT:
							parent = (CRunBox2DBaseElementParent(movement)).parent;
							parent.currentParticule1 = CRunBox2DBaseElementParent(movement);
							parent.currentParticule2 = null;
							parent.stopped = false;
							parent.collidingHO = movement2.m_pHo;
							movement2.PrepareCondition();
							movement2.SetCollidingObject(movement);
							parent.stopped = false;
							if(contact.IsTouching())
								(CExtension(movement1.m_pHo)).generateEvent(CND_PARTICULECOLLISION, movement2.m_pHo.hoOi);
							if (!!movement2.IsStop() && !parent.stopped)
								contact.SetEnabled(false);
							break;
						case CRunMBase.MTYPE_FAKEOBJECT:
							parent = (CRunBox2DBaseElementParent(movement)).parent;
							parent.currentParticule1 = CRunBox2DBaseElementParent(movement);
							parent.currentParticule2 = null;
							parent.stopped = false;
							movement2.PrepareCondition();
							parent.stopped = false;
							//(CExtension(movement.m_pHo)).generateEvent(CND_PARTICULECOLLISION, movement2.m_pHo.hoOi);
							if(contact.IsTouching())
								(CExtension(movement.m_pHo)).generateEvent(CND_PARTICULECOLLISION, 0);
							if (!!movement2.IsStop() && !parent.stopped)
								contact.SetEnabled(false);
							break;
						case CRunMBase.MTYPE_PARTICULE:
							parent = (CRunBox2DBaseElementParent(movement)).parent;
							parent.currentParticule1 = CRunBox2DBaseElementParent(movement);
							parent.currentParticule2 = CRunBox2DBaseElementParent(movement2);
							parent.stopped = false;
							if(contact.IsTouching())
								(CExtension(movement.m_pHo)).generateEvent(CND_PARTICULESCOLLISION, 0);
							if (!parent.stopped)
								contact.SetEnabled(false);
							break;
						case CRunMBase.MTYPE_ELEMENT:
							contact.SetEnabled(false);
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
							parent = (CRunBox2DBaseElementParent(movement)).parent;
							parent.currentElement = CRunBox2DBaseElementParent(movement);
							parent.stopped = false;
							parent.collidingHO = movement2.m_pHo;
							movement2.PrepareCondition();
							if(contact.IsTouching())
								movement2.SetCollidingObject(movement);
							(CExtension(movement.m_pHo)).generateEvent(CND_ELEMENTCOLLISION, movement2.m_pHo.hoOi);
							if (!movement2.IsStop() && !parent.stopped)
								contact.SetEnabled(false);
							break;
						case CRunMBase.MTYPE_FAKEOBJECT:
							parent = (CRunBox2DBaseElementParent(movement1)).parent;
							parent.currentElement = CRunBox2DBaseElementParent(movement1);
							parent.stopped = false;
							parent.collidingHO = movement2.m_pHo;
							movement2.PrepareCondition();
							if(contact.IsTouching())
								(CExtension(movement1.m_pHo)).generateEvent(CND_ELEMENTCOLLISION, movement2.m_pHo.hoOi);
							if (!movement2.IsStop() && !parent.stopped)
								contact.SetEnabled(false);
							break;
						case CRunMBase.MTYPE_PARTICULE:
							contact.SetEnabled(false);
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
							contact.SetEnabled(false);
							break;
					}
					break;
			}
		}
		bWorking = false;
	}
	public override function BeginContact(c:b2Contact):void {
	}
	public override function EndContact(c:b2Contact):void {
		
	}
	public override function PostSolve(c:b2Contact, ci:b2ContactImpulse):void
	{
		
	}
	
	private function RealTouch(a:b2Body, b:b2Body):Boolean {
		if(a == null || b == null)
			return false;
		
		for (var ce:b2ContactEdge = a.GetContactList(); ce != null; ce = ce.next)
		{
			if (ce.other == b && ce.contact.IsTouching())
			{
				return true;
			}
		}
		return false;
	}
	
}


internal class CPointTest
{
	public var angle:Number;
}
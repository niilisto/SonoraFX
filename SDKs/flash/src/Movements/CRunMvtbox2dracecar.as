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
// 8 directions box 2d movement
//
//----------------------------------------------------------------------------------
package Movements {
	import Actions.CAct;
	import Banks.CImage;
	import Expressions.CExp;
	import Extensions.CRunBox2DBase;
	import Extensions.CRunBox2DBasePosAndAngle;
	import Objects.CExtension;
	import Objects.CObject;
	import RunLoop.CRun;
	import RunLoop.CRunMBase;
	import Services.*;
	import Animations.*;
	
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	
	public class CRunMvtbox2dracecar extends CRunMBase
	{
		public static const B2FLAG_ROTATE:int=0x0001;
		public static const RCFLAG_REVERSE:int= 0x0002;
		public static const RCFLAG_FINECOLLISIONS:int= 0x0008;
		public static const ACCMULT:Number=1.0;
		public static const DECMULT:Number=1.0;
		public static const ROTMULT:Number=0.5; //Divided by 10 comparing to Windows
		public static const SPEEDMULT:Number=0.20;
		public static const FORCEMULT:Number=2.0; // factor to make force act like windows version
		
		public var m_base:CRunBox2DBase;
		public var m_friction:Number= 0;
		public var m_gravity:Number= 0;
		public var m_density:Number= 0;
		public var m_restitution:Number= 0;
		public var m_shape:int= 0;
		public var m_flags:int= 0;
		public var m_previousX:Number= 0;
		public var m_previousY:Number= 0;
		public var m_fixture:b2Fixture= null;
		public var m_previousAngle:Number= 0;
		public var m_speed:Number= 0;
		public var m_acceleration:Number= 0;
		public var m_deceleration:Number= 0;
		public var m_player:int= 0;
		public var m_dirs:int= 0;
		public var m_currentSpeed:Number= 0;
		public var m_angleSpeed:Number= 0;
		public var m_angleCalculation:Number= 0;
		public var m_posAndAngle:CRunBox2DBasePosAndAngle = null;
		public var m_imgWidth:int= 0;
		public var m_imgHeight:int= 0;
		public var m_scaleX:Number= 1.0;
		public var m_scaleY:Number= 1.0;
		public var m_jointType:Number= 0;
		public var m_jointAnchor:Number= 0;
		public var m_rJointLLimit:Number= 0;
		public var m_rJointULimit:Number= 0;
		public var m_dJointFrequency:Number= 0;
		public var m_dJointDamping:Number= 0;
		public var m_pJointLLimit:Number= 0;
		public var m_pJointULimit:Number= 0;
		public var m_jointName:String= null;
		public var m_jointObject:String= null;
		public var m_started:Boolean= false;
		
		private function GetBase():CRunBox2DBase {
			var pOL:int=0;
			var nObjects:int= 0;
			for (nObjects=0; nObjects<this.rh.rhNObjects; pOL++, nObjects++)
			{
				while(this.rh.rhObjectList[pOL]==null) pOL++;
				var pObject:CObject=this.rh.rhObjectList[pOL];
				if (pObject.hoType>=32)
				{
					if (pObject.hoCommon.ocIdentifier == CRun.BASEIDENTIFIER)
					{
						var pBase:CRunBox2DBase= CRunBox2DBase((CExtension(pObject)).ext);
						if (pBase.identifier == this.m_identifier)
						{
							return pBase;
						}
					}
				}
			}
			return null;
		}
		
		public function CRunMvtbox2dracecar() 
		{
			m_posAndAngle = new CRunBox2DBasePosAndAngle();
		}
		
		public override function initialize(file:CBinaryFile):void {
			file.skipBytes(1);
			this.m_angleCalculation=this.dirAtStart(file.readInt())*180.0/16.0;
			this.m_friction=Number(file.readInt())/100.0;
			this.m_gravity=0;
			file.skipBytes(4);
			this.m_density=Number(file.readInt())/100.0;
			this.m_restitution=Number(file.readInt())/100.0;
			this.m_flags=file.readInt();
			this.m_shape=file.readShort();
			var speed:int= file.readInt();
			this.m_speed=((speed*SPEEDMULT));
			this.m_acceleration=Number(file.readInt())/(100.0*CRunMvtbox2dracecar.ACCMULT);
			this.m_deceleration=Number(file.readInt())/(100.0*CRunMvtbox2dracecar.DECMULT);
			this.m_angleSpeed=Number(file.readInt())/(100.0*CRunMvtbox2dracecar.ROTMULT);
			this.m_identifier=file.readInt();
			this.m_player = file.readInt();
			this.m_jointType = file.readShort();
			this.m_jointAnchor = file.readShort();
			this.m_jointName = file.readStringSize(CRunBox2DBase.MAX_JOINTNAME);
			this.m_jointObject = file.readStringSize(CRunBox2DBase.MAX_JOINTOBJECT);
			this.m_rJointLLimit = file.readInt() * Math.PI / 180.0;
			this.m_rJointULimit = file.readInt() * Math.PI / 180.0;
			this.m_dJointFrequency = Number(file.readInt());
			this.m_dJointDamping = Number(file.readInt()) / 100.0;
			this.m_pJointLLimit = Number(file.readInt());
			this.m_pJointULimit = Number(file.readInt());
			
			this.m_started = false;
			this.m_currentSpeed=0;
			this.m_currentAngle=Math.floor(this.m_angleCalculation/11.25)*11.25;
			this.ho.roc.rcMinSpeed=0;
			this.ho.roc.rcMinSpeed=speed;
			this.m_addVX=0;
			this.m_addVY=0;
			this.m_addVFlag=false;
			this.m_previousAngle=-1;
			
			this.m_base=this.GetBase();
			this.m_body=null;
			this.InitBase(this.ho, CRunMBase.MTYPE_OBJECT);
		}
		
		
		public override function kill():void {
			var pBase:CRunBox2DBase=this.GetBase();
			if (pBase!=null)
			{
				this.m_body.SetUserData(null);
				pBase.rDestroyBody(this.m_body);
			}
		}
		
		
		public override function CreateBody():Boolean {
			if (this.m_body!=null)
				return true;
			
			if (this.m_base==null)
			{
				this.m_base=this.GetBase();
				if (this.m_base == null)
					return false;
			}
			
			this.m_body = this.m_base.rCreateBody(b2Body.b2_dynamicBody, this.ho.hoX, this.ho.hoY, this.m_angle, this.m_gravity, this, 0, 0);
			if (this.ho.roa == null)
			{
				this.m_shape = 0;
				this.m_imgWidth = this.ho.hoImgWidth;
				this.m_imgHeight = this.ho.hoImgHeight;
			}
			else
			{
				this.m_image = this.ho.roc.rcImage;
				var img:CImage= this.rh.rhApp.imageBank.getImageFromHandle(this.m_image);
				this.m_imgWidth = img.width;
				this.m_imgHeight = img.height;
			}
			this.CreateFixture();
			
			var position:b2Vec2=this.m_body.GetPosition();
			this.m_previousX=position.x;
			this.m_previousY=position.y;
			
			return true;
		}
		
		private function CreateFixture():void {
			if (this.m_fixture != null)
			{
				this.m_body.DestroyFixture(this.m_fixture);
			}
			this.m_scaleX = this.ho.roc.rcScaleX;
			this.m_scaleY = this.ho.roc.rcScaleY;
			switch (this.m_shape)
			{
				case 0:
					this.m_fixture = this.m_base.rBodyCreateBoxFixture(this.m_body, this, this.ho.hoX, this.ho.hoY, int((this.m_imgWidth * this.m_scaleX)), int((this.m_imgHeight * this.m_scaleY)), this.m_density, this.m_friction, this.m_restitution);
					break;
				case 1:
					this.m_fixture = this.m_base.rBodyCreateCircleFixture(this.m_body, this, this.ho.hoX, this.ho.hoY, int((Number(this.ho.hoImgWidth + this.ho.hoImgHeight) / 4 * Number(this.m_scaleX + this.m_scaleY) / 2)), this.m_density, this.m_friction, this.m_restitution);
					break;
				case 2:
					this.m_fixture = this.m_base.rBodyCreateShapeFixture(this.m_body, this, this.ho.hoX, this.ho.hoY, this.ho.roc.rcImage, this.m_density, this.m_friction, this.m_restitution, this.m_scaleX, this.m_scaleY);
					break;
			}
		}
		
		public override function CreateJoint():void {
			switch (this.m_jointType)
			{
				case CRunBox2DBase.JTYPE_REVOLUTE:
					this.m_base.rJointCreate(this, this.m_jointType, this.m_jointAnchor, this.m_jointName, this.m_jointObject, this.m_rJointLLimit, this.m_rJointULimit);
					break;
				case CRunBox2DBase.JTYPE_DISTANCE:
					this.m_base.rJointCreate(this, this.m_jointType, this.m_jointAnchor, this.m_jointName, this.m_jointObject, this.m_dJointFrequency, this.m_dJointDamping);
					break;
				case CRunBox2DBase.JTYPE_PRISMATIC:
					this.m_base.rJointCreate(this, this.m_jointType, this.m_jointAnchor, this.m_jointName, this.m_jointObject, this.m_pJointLLimit, this.m_pJointULimit);
					break;
				default:
					break;
			}
		}
		
		
		public override function move():Boolean {
			if (!this.CreateBody())
				return false;
			
			// Scale changed?
			if (this.ho.roc.rcScaleX != this.m_scaleX || this.ho.roc.rcScaleY != this.m_scaleY)
				this.CreateFixture();
			
			// Get the joystick
			var j:uint=this.rh.rhPlayer[this.m_player];
			
			// Rotation of the ship
			var anim:int=CAnim.ANIMID_STOP;
			if ((j&1)!=0)
			{
				if (this.m_currentSpeed<this.m_speed)
				{
					if (this.m_acceleration==1.0)
						this.m_currentSpeed=this.m_speed;
					else
						this.m_currentSpeed=Math.min(this.m_speed, this.m_currentSpeed+this.m_acceleration);
				}
				anim=CAnim.ANIMID_WALK;
			}
			if ((j&2)!=0)
			{
				var baseSpeed:Number=0;
				if ((this.m_flags&RCFLAG_REVERSE)!=0)
					baseSpeed=-this.m_speed;
				if (this.m_currentSpeed>baseSpeed)
				{
					if (this.m_deceleration==1.0)
						this.m_currentSpeed=baseSpeed;
					else
						this.m_currentSpeed=Math.max(baseSpeed, this.m_currentSpeed-this.m_deceleration);
				}
			}
			if ((j&4)!=0)
			{
				this.m_angleCalculation+=this.m_angleSpeed*180/Math.PI;
				this.m_angleCalculation = this.m_angleCalculation % 360;
			}
			if ((j&8)!=0)
			{
				this.m_angleCalculation-=this.m_angleSpeed*180/Math.PI;
				this.m_angleCalculation = this.m_angleCalculation % 360;
			}
			this.m_currentAngle=this.m_angleCalculation;
			this.m_base.rBodySetLinearVelocity(this.m_body, this.m_currentSpeed, this.m_currentAngle);
			m_base.rBodyAddVelocity(m_body, m_addVX, m_addVY);
			ResetAddVelocity();
			m_base.rBodySetAngle(m_body, m_currentAngle);
			
			this.m_base.rGetBodyPosition(this.m_body, this.m_posAndAngle);
			if (this.m_posAndAngle.x!=this.ho.hoX || this.m_posAndAngle.y!=this.ho.hoY)
			{
				this.ho.hoX=this.m_posAndAngle.x;
				this.ho.hoY=this.m_posAndAngle.y;
				this.m_started = true;
				this.ho.roc.rcChanged=true;
			}
			SetCurrentAngle();
			
			var position:b2Vec2=this.m_body.GetPosition();
			var deltaX:Number=(position.x-this.m_previousX)*this.m_base.factor;
			var deltaY:Number=(position.y-this.m_previousY)*this.m_base.factor;
			this.m_previousX=position.x;
			this.m_previousY=position.y;
			var length:Number=(Math.sqrt(deltaX*deltaX+deltaY*deltaY));
			this.ho.roc.rcSpeed=int(Math.floor((50.0*length/7.0)*this.rh.rh4MvtTimerCoef));
			this.ho.roc.rcSpeed=Math.min(this.ho.roc.rcSpeed, 250);
			
			this.animations(anim);
			if ((m_flags & RCFLAG_FINECOLLISIONS) != 0)
				this.collisions();
			
			// The object has been moved
			return this.ho.roc.rcChanged;
		}
		public function SetCurrentAngle():void {
			if (this.m_currentAngle!=this.m_previousAngle)
			{
				this.m_previousAngle=this.m_currentAngle;
				this.ho.roc.rcChanged=true;
				if ((this.m_flags&B2FLAG_ROTATE)!=0)
				{
					this.ho.roc.rcAngle=this.m_currentAngle;
					this.ho.roc.rcDir=0;
				}
				else
				{
					this.ho.roc.rcDir=AngleToDir(this.m_currentAngle);
				}
			}
		}
		
		public override function SetFriction(friction:int):void {
			this.m_friction=Number(friction)/100.0;
			this.m_fixture.SetFriction(this.m_friction);
		}
		
		public override function SetGravity(gravity:int):void {
			this.m_gravity=Number(gravity)/100.0;
			this.m_body.SetGravityScale(this.m_gravity);
		}
		
		public override function SetDensity(density:int):void {
			this.m_density=Number(density)/100.0;
			this.m_fixture.SetDensity(this.m_density);
			this.m_base.rBodyResetMassData(this.m_body);
		}
		
		public override function SetRestitution(restitution:int):void {
			this.m_restitution=Number(restitution)/100.0;
			this.m_fixture.SetRestitution(this.m_restitution);
		}
		
		
		public override function setAngle(angle:Number):void {
			this.m_angleCalculation = angle;
			if (!m_started)
			{
				this.m_currentAngle = angle;
				SetCurrentAngle();
			}
		}
		
		
		public override function getAngle():Number {
			if ((this.m_flags&CRunMvtbox2dracecar.B2FLAG_ROTATE)!=0)
			{
				var angle:Number= this.m_currentAngle;
				while (angle >= 360.0)
					angle -= 360.0;
				while (angle < 0)
					angle += 360;
				return angle;
			}
			return CRunMBase.ANGLE_MAGIC;
		}
		
		
		public override function setPosition(x:int, y:int):void {
			if (x!=this.ho.hoX || y!=this.ho.hoY)
			{
				if (!m_started)
				{
					this.ho.hoX = x;
					this.ho.hoY = y;
				}
				this.m_base.rBodySetPosition(this.m_body, x, y);
			}
		}
		
		public override function setXPosition(x:int):void {
			if (x!=this.ho.hoX)
			{
				if (!m_started)
					this.ho.hoX = x;
				this.m_base.rBodySetPosition(this.m_body, x, CRunBox2DBase.POSDEFAULT);
			}
		}
		
		public override function setYPosition(y:int):void {
			if (y!=this.ho.hoY)
			{
				if (!m_started)
					this.ho.hoY = y;
				this.m_base.rBodySetPosition(this.m_body, CRunBox2DBase.POSDEFAULT, y);
			}
		}
		
		public override function stop(bCurrent:Boolean):void {
			this.SetStopFlag(true);
			if (this.m_eventCount!=this.rh.rh4EventCount)
			{
				this.m_base.rBodySetLinearVelocityAdd(this.m_body, 0, 0, 0, 0);
			}
		}
		
		public override function setSpeed(speed:int):void {
			var speedf:Number= (speed )* CRunMvtbox2dracecar.SPEEDMULT;
			speedf = Math.min(m_speed, speedf);
			speedf = Math.max(m_speed, 0);
			m_currentSpeed = speedf;
		}
		
		
		public override function setMaxSpeed(speed:int):void {}
		
		
		public override function setDir(dir:int):void {
			this.m_angleCalculation=((dir*11.25));
			this.m_currentAngle=(((Math.floor(this.m_angleCalculation/11.25))*11.25));
			if (!m_started)
				SetCurrentAngle();
		}
		
		
		public override function getDir():int {
			if ((this.m_flags&B2FLAG_ROTATE)!=0) {
				return AngleToDir(this.m_currentAngle);
			}
			else
				return this.ho.roc.rcDir;
		}
		
		public override function setGravity(gravity:int):void {
			this.m_gravity=Number(gravity)/100.0;
			this.m_body.SetGravityScale(this.m_gravity);
		}
		
		
		public override function getSpeed():int {
			return this.ho.roc.rcSpeed;
		}
		
		
		public override function getGravity():int {
			return int(this.m_gravity*100.0);
		}
		
		
		public override function setAcc(acc:int):void {
			this.m_acceleration=((acc/(100.0*CRunMvtbox2dracecar.ACCMULT)));
		}
		
		
		public override function setDec(dec:int):void {
			this.m_deceleration=(dec/(100.0*CRunMvtbox2dracecar.DECMULT));
		}
		
		
		public override function setRotSpeed(speed:int):void {
			this.m_angleSpeed=(speed/100.0*CRunMvtbox2dracecar.ROTMULT);
		}
		
		
		public override function getAcceleration():int {
			return int((this.m_acceleration*(100.0*CRunMvtbox2dracecar.ACCMULT)));
		}
		
		
		public override function getDeceleration():int {
			return int((this.m_deceleration*(100.0*CRunMvtbox2dracecar.DECMULT)));
		}
		
		
		public override function actionEntry(action:int):Number {
			if (this.m_base == null)
				return 0;
			
			var force:Number;
			var angle:Number;
			var torque:Number;
			var v:b2Vec2;
			switch (action)
			{
				case CAct.NACT_EXTSETGRAVITYSCALE:
					this.SetGravity(int(this.getParam1()));
					break;
				case CAct.NACT_EXTSETFRICTION:
					this.SetFriction(int(this.getParam1()));
					break;
				case CAct.NACT_EXTSETELASTICITY:
					this.SetRestitution(int(this.getParam1()));
					break;
				case CAct.NACT_EXTSETDENSITY:
					this.SetDensity(int(this.getParam1()));
					break;
				case CAct.NACT_EXTAPPLYIMPULSE:
					force=((this.getParam1()/100.0*CRunBox2DBase.APPLYIMPULSE_MULT*this.m_base.RunFactor));
					angle=(this.getParam2());
					this.m_base.rBodyApplyMMFImpulse(this.m_body, force, angle);
					break;
				case CAct.NACT_EXTAPPLYFORCE:
					force=((this.getParam1()/100.0*CRunBox2DBase.APPLYFORCE_MULT * FORCEMULT));
					angle=(this.getParam2());
					this.m_base.rBodyApplyForce(this.m_body, force, angle);
					break;
				case CAct.NACT_EXTSETLINEARVELOCITY:
					force=((this.getParam1()/100.0*CRunBox2DBase.SETVELOCITY_MULT));
					angle=(this.getParam2());
					this.m_base.rBodySetLinearVelocity(this.m_body, force, angle);
					break;
				case CAct.NACT_EXTSTOPFORCE:
					this.m_base.rBodyStopForce(this.m_body);
					break;
				case CExp.NEXP_EXTGETFRICTION:
					return this.m_friction * 100;
				case CExp.NEXP_EXTGETRESTITUTION:
					return this.m_restitution * 100;
				case CExp.NEXP_EXTGETDENSITY:
					return this.m_density * 100;
				case CExp.NEXP_EXTGETVELOCITY:
					v = this.m_body.GetLinearVelocity();
					var velocity:Number=  Math.sqrt(v.x * v.x + v.y * v.y)*100.0/CRunBox2DBase.SETVELOCITY_MULT;
					if (velocity < 0.001)
						return 0;
					return velocity;
				case CExp.NEXP_EXTGETANGLE:
					v = m_body.GetLinearVelocity();
					if (Math.abs(v.x) < 0.001&& Math.abs(v.y) < 0.001)
						return -1;
					angle=((Math.atan2(v.y, v.x)*180.0/Math.PI));
					if (angle<0)
						angle=360+angle;
					return Number(angle);
				case CExp.NEXP_EXTGETMASS:
					return m_body.GetMass();
				default:
					break;
			}
			return 0;
		}
	}
}
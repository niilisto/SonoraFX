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
	import Expressions.CExp;
	import Extensions.CRunBox2DBase;
	import Extensions.CRunBox2DBaseImageDimension;
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
	
	public class CRunMvtbox2dplatform extends CRunMBase
	{
		public static const MPFLAG_CONTROLJUMP:int=0x0001;
		public static const MPFLAG_ALLOWCROUCH:int=0x0002;
		public static const MPFLAG_JUMPCROUCHED:int=0x0004;
		public static const MPFLAG_ACCMOVEMENTS:int=0x0008;
		public static const MPFLAG_FINECOLLISIONS:int=0x0010;
		public static const ACCMULT:Number=1.0;
		public static const DECMULT:Number=1.0;
		private static const GDIR_BOTTOM:int= 0;
		private static const GDIR_TOP:int= 1;
		private static const GDIR_LEFT:int= 2;
		private static const GDIR_RIGHT:int= 3;
		
		public var m_base:CRunBox2DBase;
		public var m_friction:Number= 0;
		public var m_gravity:Number= 0;
		public var m_density:Number= 0;
		public var m_restitution:Number= 0;
		public var m_flags:int= 0;
		public var m_previousX:Number= 0;
		public var m_previousY:Number= 0;
		public var m_fixture:b2Fixture= null;
		public var m_previousAngle:Number= 0;
		public var m_speed:Number= 0;
		public var m_acceleration:Number= 0;
		public var m_deceleration:Number= 0;
		public var m_player:int= 0;
		public var m_currentSpeed:Number= 0;
		public var m_strength:Number= 0;
		public var m_strength2:Number= 0;
		public var m_jumps:int= 0;
		public var m_control:int= 0;
		public var m_offsetY:int= 0;
		public var m_previousJump:Boolean= false;
		public var m_jump:int= 0;
		public var m_jumpCounter:int= 0;
		public var m_crouchSpeed:Number= 0;
		public var m_deltaX:Number= 0;
		public var m_deltaY:Number= 0;
		public var m_climbingSpeed:Number= 0;
		public var m_offsetX:int= 0;
		//public var m_angle:int= 0;
		public var m_scaleX:Number= 1.0;
		public var m_scaleY:Number= 1.0;
		public var m_imgWidth:int= 0;
		public var m_imgHeight:int= 0;
		public var m_posAndAngle:CRunBox2DBasePosAndAngle=null;
		public var m_maskWidth:Number;
		public var m_platformUnder:CRunMBase;
		public var m_previousPlatformUnder:CRunMBase;
		public var m_platformPositionX:int;
		public var m_platformPositionY:int;
		public var m_loopCollision:int= -10;
		public var m_previousLadder:Boolean= false;
		public var m_previousLadderDir:int= 0;
		public var m_previousLadderEnd:int= 0;
		public var m_onLadder:Boolean= false;
		public var m_noStop:Boolean= false;
		public var m_falling:int= 0;
		
		public function CRunMvtbox2dplatform ()
		{
			m_posAndAngle = new CRunBox2DBasePosAndAngle();

		}
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
		
		
		public override function initialize(file:CBinaryFile):void {
			// Store pointer to edit data
			file.skipBytes(1);
			this.m_angle=file.readInt();
			this.m_strength2=Number(file.readInt())/100.0*25.0;
			this.m_gravity=Number(file.readInt())/100.0;
			this.m_density=Number(file.readInt())/100.0;
			this.m_restitution=Number(file.readInt())/100.0;
			this.m_flags=file.readInt();
			var speed:int= file.readInt();
			this.m_speed=Number(speed)/100.0*10.0;
			this.m_acceleration=Number(file.readInt())/(100.0*ACCMULT);
			this.m_deceleration=Number(file.readInt())/(100.0*DECMULT);
			this.m_strength=Number(file.readInt())/100.0*25.0;
			this.m_jumps=file.readInt();
			this.m_control=int(file.readShort());
			this.m_crouchSpeed = Number(file.readInt()) / (100.0 * 10.0);
			this.m_friction=0;
			this.m_player = file.readInt();
			this.m_identifier=file.readInt();
			this.m_climbingSpeed = Number(file.readInt()) / (100.0 * 10.0);
			this.m_maskWidth = Number(file.readInt()) / 100.0;
			
			this.m_platformUnder = null;
			this.m_currentSpeed=0;
			this.m_previousJump=false;
			this.m_jump=0;
			this.ho.roc.rcMinSpeed=0;
			this.ho.roc.rcMaxSpeed=speed;
			this.m_previousAngle=-1;
			
			this.m_base=this.GetBase();
			this.m_body=null;
			this.InitBase(this.ho, CRunMBase.MTYPE_OBJECT);
			this.m_platform = true;
			m_previousLadder = false;
			m_previousLadderDir = 0;
			m_previousLadderEnd = 0;
			m_onLadder = false;
			m_noStop = false;
			m_falling = 0;
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
			if (this.ho.roa == null)
				return false;
			
			if (this.m_base==null)
			{
				this.m_base=this.GetBase();
				if (this.m_base==null)
					return false;
			}
			
			this.ho.roc.rcDir=(this.m_angle&31/16)*16;
			this.ho.roc.rcSpeed=0;
			this.animations(CAnim.ANIMID_STOP);
			
			this.m_body = this.m_base.rCreateBody(b2Body.b2_dynamicBody, this.ho.hoX, this.ho.hoY, 0, this.m_gravity, this, CRunBox2DBase.CBFLAG_FIXEDROTATION, 0);
			this.CreateFixture();
			
			var position:b2Vec2= this.m_body.GetPosition();
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
			
			var o:CRunBox2DBaseImageDimension= new CRunBox2DBaseImageDimension();
			this.m_fixture = this.m_base.rBodyCreatePlatformFixture(this.m_body, this, this.ho.roc.rcImage, 0, this.m_density, this.m_friction, this.m_restitution, o, this.m_scaleX, this.m_scaleY, this.m_maskWidth);
			
			this.m_offsetX = 0;
			this.m_offsetY = 0;
		}
		
		
		public override function move():Boolean {
			if (!this.CreateBody())
				return false;
			
			// Scale changed?
			if (this.ho.roc.rcScaleX != this.m_scaleX || this.ho.roc.rcScaleY != this.m_scaleY)
				this.CreateFixture();
			
			// Get the joystick
			var joyDir:uint=this.rh.rhPlayer[this.m_player];
			var anim:int=CAnim.ANIMID_STOP;
			var flag:Boolean=false;
			var velocity:b2Vec2=this.m_body.GetLinearVelocity();
			
			
			// Previous position
			var position:b2Vec2=m_body.GetPosition();
			m_deltaX=(position.x-m_previousX)*m_base.factor;
			m_deltaY=(position.y-m_previousY)*m_base.factor;
			m_previousX=position.x;
			m_previousY=position.y;
			
			var length:Number=Math.sqrt(m_deltaX*m_deltaX+m_deltaY*m_deltaY);
			ho.roc.rcSpeed=int((50.0*length/7.0)*rh.rh4MvtTimerCoef);
			ho.roc.rcSpeed=Math.min(ho.roc.rcSpeed, 250);
			animations(anim);
			
			this.m_base.rGetBodyPosition(this.m_body, this.m_posAndAngle);
			//if (this.m_posAndAngle.x + m_offsetX!=ho.hoX || this.m_posAndAngle.y + m_offsetY != ho.hoY)
			if (this.m_posAndAngle.x != ho.hoX || this.m_posAndAngle.y != ho.hoY)
			{
				ho.hoX = this.m_posAndAngle.x + m_offsetX;
				ho.hoY = this.m_posAndAngle.y + m_offsetY;
				ho.roc.rcChanged=true;
			}
			
			ho.roc.rcDir=AngleToDir(this.m_currentAngle);
			
			if (m_currentAngle!=m_previousAngle)
			{
				m_previousAngle=m_currentAngle;
				ho.roc.rcChanged=true;
			}
			
			var bCrouching:Boolean=false;
			var yLadder:int= 0;
			var rc:CRect= rh.y_GetLadderAt(-1, ho.hoX-rh.rhWindowX, ho.hoY-rh.rhWindowY);
			var bLadder:Boolean = (rc != null ? true : false);
			if (rc != null)
				yLadder = rc.top;
			
			var ySpeed:Number=0;
			var xSpeed:Number=0;
			var speed:Number=m_speed;
			var ladderDir:int= 0;
			var ladderEnd:int= 0;
			
			if (m_jump == 0)
				m_jumpCounter = m_jumps;
			
			if ((joyDir&2)!=0 && m_jump==0)
			{
				if (!bLadder)
				{
					if ((m_flags&MPFLAG_ALLOWCROUCH)!=0)
					{
						speed=m_crouchSpeed;
						bCrouching=true;
					}
				}
				else
				{
					if (rh.y_GetLadderAt(-1, ho.hoX-rh.rhWindowX, ho.hoY - rh.rhWindowY + 2) != null)
					{
						ySpeed=-m_climbingSpeed;
						ladderDir = 24;
						m_onLadder = true;
					}
				}
			}
			if ((joyDir&1)!=0 && m_jump==0)
			{
				if (bLadder)
				{
					if (rh.y_GetLadderAt(-1, ho.hoX-rh.rhWindowX, ho.hoY-rh.rhWindowY - 2) != null)
					{
						ySpeed=m_climbingSpeed;
						ladderDir = 8;
						m_onLadder = true;
					}
				}
				else
				{
					if (Math.abs(velocity.x) < 0.01 && m_previousLadder)
					{
						m_base.rBodySetPosition(m_body, CRunBox2DBase.POSDEFAULT, m_previousLadderEnd);
						velocity.y = 0;
					}
				}
			}
			if (bLadder)
			{
				ladderEnd = yLadder;
				if (m_jump==0)
				{
					m_body.SetGravityScale(0);
					velocity.y=ySpeed;
				}
				else
				{
					if (m_deltaY>0)
						m_body.SetGravityScale(this.m_gravity);
					else
					{
						velocity.y=0;
						m_body.SetGravityScale(0);
						m_jump=0;
					}
				}
			}
			else
			{
				m_body.SetGravityScale(this.m_gravity);
				m_onLadder = false;
			}
			
			flag=false;
			if ((joyDir & (4|8)) != 0)			// Gauche
			{
				m_onLadder = false;
				if (this.m_jump == 0 || (this.m_jump > 0 && (this.m_flags & CRunMvtbox2dplatform.MPFLAG_CONTROLJUMP) != 0))
				{
					if ((this.m_flags & CRunMvtbox2dplatform.MPFLAG_ACCMOVEMENTS) == 0)
					{
						if (this.m_currentSpeed < speed)
						{
							this.m_currentSpeed += this.m_acceleration;
						}
						if (this.m_currentSpeed > speed)
						{
							this.m_currentSpeed -= this.m_deceleration;
						}
						if ((joyDir & 4)!=0)
						{
							this.m_currentAngle = 180.0;
							velocity.x = -this.m_currentSpeed;
							flag = true;
						}
						if ((joyDir & 8)!=0)
						{
							this.m_currentAngle = 0.0;
							velocity.x = this.m_currentSpeed;
							flag = true;
						}
					}
					else
					{
						if (velocity.x >= -0.01 && velocity.x <= 0.01)
							this.m_currentSpeed = 0;
						if ((joyDir & 4)!=0)
						{
							if (this.m_currentAngle == 180.0)
							{
								this.m_currentSpeed += this.m_acceleration;
								this.m_currentSpeed = Math.min(speed, this.m_currentSpeed);
								velocity.x = -this.m_currentSpeed;
							}
							else
							{
								this.m_currentSpeed -= this.m_deceleration;
								if (this.m_currentSpeed < 0)
								{
									this.m_currentAngle = 180.0;
									this.m_currentSpeed = 0;
								}
								velocity.x = this.m_currentSpeed;
							}
							flag = true;
						}
						if ((joyDir & 8)!=0)
						{
							if (this.m_currentAngle == 0.0)
							{
								this.m_currentSpeed += this.m_acceleration;
								this.m_currentSpeed = Math.min(speed, this.m_currentSpeed);
								velocity.x = this.m_currentSpeed;
							}
							else
							{
								this.m_currentSpeed -= this.m_deceleration;
								if (this.m_currentSpeed < 0)
								{
									this.m_currentAngle = 0.0;
									this.m_currentSpeed = 0;
								}
								velocity.x = -this.m_currentSpeed;
							}
							flag = true;
						}
					}
					anim = CAnim.ANIMID_WALK;
				}
			}
			if (!flag)
			{
				if (m_jump==0 && ladderDir == 0)
				{
					if (m_currentSpeed>0)
					{
						m_currentSpeed-=m_deceleration;
						m_currentSpeed=Math.max(m_currentSpeed, 0);
					}
					if (m_currentAngle==180.0)
						velocity.x=-m_currentSpeed;
					else
						velocity.x=m_currentSpeed;
					if (m_currentSpeed != 0)
						anim = CAnim.ANIMID_WALK;
				}
			}
			else
				m_previousLadder = false;
			
			// En train de tomber?
			if (bLadder == false && Math.abs(this.rh.rhLoopCount - m_loopCollision) > 5)
			{
				if (velocity.y < -0.5)
				{
					m_falling = 2;
				}
			}
			
			// Teste le saut
			var bJump:Boolean=false;
			var j:int=m_control;
			if (j!=0)
			{
				j--;
				if (j==0)
				{
					if ( (joyDir&5)==5)
						bJump=true;							// Haut gauche
					if ( (joyDir&9)==9)
						bJump=true;							// Haut droite
				}
				else
				{
					j<<=4;
					if ((joyDir&j)!=0)
						bJump=true;
				}
			}
			var jumpVY:Number=0;
			if (bCrouching && (this.m_flags & CRunMvtbox2dplatform.MPFLAG_JUMPCROUCHED) == 0)
				bJump = false;
			if (m_falling > 0&& m_jumps <= 1)
				bJump = false;
			if (bJump)
			{
				if (!m_previousJump)
				{
					m_previousJump=true;
					if (m_jump==0)
					{
						m_jump=4;
						jumpVY=m_strength;
						m_jumpCounter=m_jumps - 1;
					}
					else
					{
						if (m_jumpCounter>=0)
						{
							m_jumpCounter--;
							if (m_jumpCounter>=0)
							{
								jumpVY=m_strength2;
							}
						}
					}
				}
			}
			else
			{
				m_previousJump=false;
			}
			if (jumpVY != 0)
				velocity.y = jumpVY;
			m_body.SetLinearVelocity(velocity);
			m_base.rBodyAddVelocity(m_body, m_addVX+m_setVX, m_addVY+m_setVY);
			ResetAddVelocity();
			
			if (this.m_platformUnder != null && bJump == 0)
			{
				if (this.m_platformUnder != this.m_previousPlatformUnder)
				{
					this.m_previousPlatformUnder = this.m_platformUnder;
					this.m_platformPositionX = this.m_platformUnder.m_pHo.hoX;
				}
				var positionChar:b2Vec2= this.m_body.GetPosition();
				positionChar.x += (this.m_platformUnder.m_pHo.hoX - this.m_platformPositionX) / this.m_base.factor;
				var angle:Number= this.m_body.GetAngle();
				this.m_base.rBodySetTransform(this.m_body, positionChar, angle);
				this.m_platformPositionX = this.m_platformUnder.m_pHo.hoX;
			}
			else
			{
				this.m_previousPlatformUnder = null;
			}
			this.m_platformUnder = null;
			
			m_previousLadder = bLadder;
			m_previousLadderEnd = ladderEnd;
			
			if (bCrouching)
				anim=CAnim.ANIMID_CROUCH;
			if (bLadder)
			{
				if (ladderDir != 0)
				{
					anim=CAnim.ANIMID_CLIMB;
					ho.roc.rcDir = ladderDir;
					m_previousLadderDir = ladderDir;
				}
				else if (m_onLadder && m_previousLadder)
				{
					anim=CAnim.ANIMID_CLIMB;
					ho.roc.rcDir = m_previousLadderDir;
				}
			}
			if (m_jump>0)
			{
				anim=CAnim.ANIMID_JUMP;
				m_previousLadder = false;
			}
			if (m_falling > 0)
			{
				anim = CAnim.ANIMID_FALL;
				m_previousLadder = false;
				m_falling--;
			}
			animations(anim);
			if ((m_flags & MPFLAG_FINECOLLISIONS) != 0)
			{
				this.m_noStop = true;
				this.collisions();
				this.m_noStop = false;
			}
			
			return this.ho.roc.rcChanged;
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
		
		
		
		public override function setPosition(x:int, y:int):void {
			if (x!=this.ho.hoX || y!=this.ho.hoY)
				this.m_base.rBodySetPosition(this.m_body, x, y);
		}
		
		public override function setXPosition(x:int):void {
			if (x!=this.ho.hoX)
				this.m_base.rBodySetPosition(this.m_body, x, CRunBox2DBase.POSDEFAULT);
		}
		
		public override function setYPosition(y:int):void {
			if (y!=this.ho.hoY)
				this.m_base.rBodySetPosition(this.m_body, CRunBox2DBase.POSDEFAULT, y);
		}

		///////////////////
		// Stop the Objets
		///////////////////
		public override function SetCollidingObject(object:CRunMBase):void {
			m_collidingObject = object;
		}
		
		public override function stop(bCurrent:Boolean):void {
			if (this.m_eventCount == this.rh.rh4EventCount)
			{
				if (this.m_noStop)
					return;
				
				if (this.rh.y_GetLadderAt(-1, this.ho.hoX-rh.rhWindowX, this.ho.hoY-rh.rhWindowY) == null)
				{
					this.SetStopFlag(true);
				}
				
				this.m_base.rGetBodyPosition(this.m_collidingObject.m_body, this.m_posAndAngle);
				var left:int= this.m_posAndAngle.x + this.m_collidingObject.rc.left;
				var right:int= this.m_posAndAngle.x + this.m_collidingObject.rc.right;
				var top:int= this.m_posAndAngle.y + this.m_collidingObject.rc.top;
				var bottom:int= this.m_posAndAngle.y + this.m_collidingObject.rc.bottom;
				
				if (m_collidingObject.m_subType == MSUBTYPE_BOTTOM)
				{
					m_loopCollision = this.rh.rhLoopCount;
					this.m_jump = Math.max(m_jump-1, 0);
				}
				else if ((this.ho.hoX >=left && this.ho.hoX <= right && this.ho.hoY <= bottom))
				{
					m_loopCollision = this.rh.rhLoopCount;
					this.m_jump = Math.max(m_jump-1, 0);
					if (this.m_collidingObject.m_type == CRunMBase.MTYPE_FAKEOBJECT)
						this.m_platformUnder = this.m_collidingObject;
				}
			}
			else
			{
				this.m_base.rBodySetLinearVelocityAdd(this.m_body, 0, 0, 0, 0);
			}
		}
		
		
		public override function getDir():int {
			return this.ho.roc.rcDir;
		}
		
		public override function getAngle():Number {
			return 0;
		}
		
		
		public override function setGravity(gravity:int):void {
			this.m_gravity=Number(gravity)/100.0;
			this.m_body.SetGravityScale(this.m_gravity);
		}
		
		public override function setAcc(acc:int):void
		{
			this.m_acceleration=Number(acc)/(100.0*ACCMULT);
		}
		
		public override function setDec(dec:int):void
		{
			this.m_deceleration=Number(dec)/(100.0*DECMULT);
		}
		
		public override function setSpeed(speed:int):void {
			this.m_currentSpeed = Number(speed) / 100.0 * 10.0;
		}
		
		
		public override function getSpeed():int {
			return this.ho.roc.rcSpeed;
		}
		
		
		public override function getGravity():int {
			return int((this.m_gravity*100.0));
		}
		
		
		public override function getAcceleration():int {
			return int((this.m_acceleration*(100.0*ACCMULT)));
		}
		
		
		public override function getDeceleration():int {
			return int((this.m_deceleration*(100.0*DECMULT)));
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
				case CExp.NEXP_EXTGETFRICTION:
					return this.m_friction * 100;
				case CExp.NEXP_EXTGETRESTITUTION:
					return this.m_restitution * 100;
				case CExp.NEXP_EXTGETDENSITY:
					return this.m_density * 100;
				case CExp.NEXP_EXTGETVELOCITY:
					v = this.m_body.GetLinearVelocity();
					return Math.sqrt(v.x * v.x + v.y * v.y)*100.0/CRunBox2DBase.SETVELOCITY_MULT;
				case CExp.NEXP_EXTGETANGLE:
					v = m_body.GetLinearVelocity();
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
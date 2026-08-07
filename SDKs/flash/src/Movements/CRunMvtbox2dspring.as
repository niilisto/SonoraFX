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
// Spring movement
//
//----------------------------------------------------------------------------------
package Movements {
	import Actions.CAct;
	
	import Animations.CAnim;
	
	import Banks.CImage;
	
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	
	import Expressions.CExp;
	
	import Extensions.CRunBox2DBase;
	import Extensions.CRunBox2DBasePosAndAngle;
	
	import Objects.CExtension;
	import Objects.CObject;
	
	import RunLoop.CRun;
	import RunLoop.CRunMBase;
	
	import Services.*;
	
	public class CRunMvtbox2dspring extends CRunMBase
	{
		public static const B2FLAG_ROTATE:int=0x0001;
		public static const SPFLAG_ACTIVE:int= 0x0001;
		public static const SPFLAG_WORKING:int= 0x0002;
		public static const SPFLAG_ROTATE:int= 0x0004;
		
		public var m_base:CRunBox2DBase;
		public var m_friction:Number= 0;
		public var m_restitution:Number= 0;
		public var m_shape:int= 0;
		public var m_flags:int= 0;
		public var m_fixture:b2Fixture= null;
		public var m_strength:Number= 0;
		public var m_posAndAngle:CRunBox2DBasePosAndAngle;
		public var m_anim:int= 0;
		public var m_actionCounter:int= 0;
		public var m_actionObject:CRunMBase= null;
		public var m_imgWidth:int= 0;
		public var m_imgHeight:int= 0;
		public var m_scaleX:Number= 1.0;
		public var m_scaleY:Number= 1.0;
		public var m_previousAngle:Number= -1;
		public var m_changed:Boolean;
		public var m_started:Boolean= false;
		
		public function CRunMvtbox2dspring()
		{
			m_posAndAngle = new CRunBox2DBasePosAndAngle();			
		}
		
		private function GetBase():CRunBox2DBase {
			var pOL:int=0;
			var nObjects:int= 0;
			for (nObjects=0; nObjects<this.rh.rhNObjects; pOL++, nObjects++)
			{
				while(this.rh.rhObjectList[pOL]==null) pOL++;
				var pObject:CObject=CObject(this.rh.rhObjectList[pOL]);
				if (pObject.hoType>=32)
				{
					if (pObject.hoCommon.ocIdentifier == CRun.BASEIDENTIFIER)
					{
						var pBase:CRunBox2DBase= CRunBox2DBase(CExtension(pObject).ext);
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
			file.skipBytes(1);
			this.m_angle = Number(this.dirAtStart(file.readInt())) * 180.0 / 16.0;
			this.m_currentAngle=this.m_angle;
			this.m_strength=Number(file.readInt())/100.0*10.0;
			this.m_flags=file.readInt();
			this.m_shape=file.readShort();
			this.m_identifier=file.readInt();
			
			this.m_changed=false;
			this.m_anim= CAnim.ANIMID_STOP;
			this.m_actionCounter=0;
			this.m_actionObject=null;
			this.m_started = false;
			this.m_restitution = 0.01;
			this.m_friction=0.1;
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
		
		public override function SetCollidingObject(object:CRunMBase):void {
			if ((this.m_flags&CRunMvtbox2dspring.SPFLAG_ACTIVE)!=0 && object!=this)
			{
				if (RealTouch(this.m_body, object.m_body))
				{
					//this.m_actionCounter=14;
					this.m_actionObject=object;
					var velocity:b2Vec2=object.m_body.GetLinearVelocity();
					var v:Number=Math.sqrt(velocity.x*velocity.x+velocity.y*velocity.y);
					this.m_base.rBodyAddLinearVelocity(object.m_body, (this.m_strength+v), this.m_currentAngle);
					this.m_flags|=CRunMvtbox2dspring.SPFLAG_WORKING;
					this.m_anim=CAnim.ANIMID_WALK;
					this.ho.roa.raAnimForced=this.m_anim+1;
					this.ho.roa.raAnimRepeat=1;
					this.ho.roc.rcSpeed=50;
					this.animations(this.m_anim);
					this.ho.roc.rcSpeed=0;
				}
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
			
			this.m_currentAngle = this.m_angle;
			var angle:Number= this.m_angle;
			if ((this.m_flags & SPFLAG_ROTATE) == 0)
				angle = 0;
			this.m_body = this.m_base.rCreateBody(b2Body.b2_staticBody, this.ho.hoX, this.ho.hoY, angle, 0, this, 0, 0);
			if (this.ho.roa == null)
			{
				this.m_shape = 0;
				this.m_imgWidth = this.ho.hoImgWidth;
				this.m_imgHeight = this.ho.hoImgHeight;
			}
			else
			{
				if ((this.m_flags & SPFLAG_ROTATE) == 0)
				{
					this.ho.roc.rcDir = int(this.m_currentAngle / 11.25);
					this.animations(CAnim.ANIMID_STOP);
				}
				this.m_image = this.ho.roc.rcImage;
				var img:CImage= this.rh.rhApp.imageBank.getImageFromHandle(this.m_image);
				this.m_imgWidth = img.width;
				this.m_imgHeight = img.height;
			}
			this.CreateFixture();
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
					this.m_fixture = this.m_base.rBodyCreateBoxFixture(this.m_body, this, this.ho.hoX, this.ho.hoY, (this.m_imgWidth * this.m_scaleX), (this.m_imgHeight * this.m_scaleY), 0, this.m_friction, this.m_restitution);
					break;
				case 1:
					this.m_fixture = this.m_base.rBodyCreateCircleFixture(this.m_body, this, this.ho.hoX, this.ho.hoY, int((Number(this.ho.hoImgWidth + this.ho.hoImgHeight) / 4 * Number(this.m_scaleX + this.m_scaleY) / 2)), 0, this.m_friction, this.m_restitution);
					break;
				case 2:
					this.m_fixture = this.m_base.rBodyCreateShapeFixture(this.m_body, this, this.ho.hoX, this.ho.hoY, this.ho.roc.rcImage, 1, this.m_friction, this.m_restitution, this.m_scaleX, this.m_scaleY);
					break;
			}
		}
		
		
		public override function move():Boolean {
			if (!this.CreateBody())
				return false;
			
			// Scale changed?
			if (this.ho.roc.rcScaleX != this.m_scaleX || this.ho.roc.rcScaleY != this.m_scaleY)
				this.CreateFixture();
			
			/*
			if (this.m_actionCounter > 0)
			{
				this.m_actionCounter--;
				if (this.m_actionCounter == 0)
					this.m_actionObject = null;
			}
			*/
			
			this.m_base.rGetBodyPosition(this.m_body, this.m_posAndAngle);
			if (this.m_posAndAngle.x!=this.ho.hoX || this.m_posAndAngle.y!=this.ho.hoY)
			{
				this.ho.hoX=this.m_posAndAngle.x;
				this.ho.hoY=this.m_posAndAngle.y;
				this.m_started = true;
				this.ho.roc.rcChanged=true;
			}
			SetCurrentAngle(this.m_posAndAngle.angle);
			if ((this.m_flags&CRunMvtbox2dspring.SPFLAG_WORKING)!=0 && this.ho.roa != null)
			{
				if (this.ho.roa.raAnimOn!=CAnim.ANIMID_WALK || this.ho.roa.raAnimFrame>=this.ho.roa.raAnimNumberOfFrame)
				{
					this.m_flags&=~CRunMvtbox2dspring.SPFLAG_WORKING;
					this.m_anim=CAnim.ANIMID_STOP;
					this.ho.roa.raAnimForced=0;
					this.ho.roa.raAnimFrame=0;
				}
			}
			this.ho.roc.rcSpeed=50;
			this.animations(this.m_anim);
			this.ho.roc.rcSpeed=0;
			
			this.ho.roc.rcChanged = this.m_changed;
			this.m_changed=false;
			
			return this.ho.roc.rcChanged;
		}
		private function SetCurrentAngle(angle:Number):void {
			if ((this.m_flags & SPFLAG_ROTATE) !=0)
			{
				if (angle!=this.m_previousAngle)
				{
					this.m_currentAngle = angle;
					this.m_previousAngle=angle;
					this.ho.roc.rcChanged=true;
					this.ho.roc.rcAngle=angle;
					this.ho.roc.rcDir=0;
				}
			}
		}
		
		public override function setAngle(angle:Number):void {
			this.m_currentAngle = angle;
			this.m_base.rBodySetAngle(this.m_body, angle);
			if ((this.m_flags & SPFLAG_ROTATE) == 0)
				this.ho.roc.rcDir=AngleToDir(angle);
		}
		
		
		public override function getAngle():Number {
			if ((this.m_flags&SPFLAG_ROTATE)!=0)
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
		
		public override function stop(bCurrent:Boolean):void {
			this.m_flags&=~CRunMvtbox2dspring.SPFLAG_ACTIVE;
		}
		
		public override function start():void {
			this.m_flags|=CRunMvtbox2dspring.SPFLAG_ACTIVE;
		}
		
		public override function setSpeed(speed:int):void {
			this.m_strength=((speed)/100.0*30.0);
		}
		
		public override function setDir(dir:int):void {
			this.m_currentAngle = dir * 11.25;
			this.m_base.rBodySetAngle(this.m_body, (dir * 11.25));
			if ((this.m_flags & SPFLAG_ROTATE) == 0)
				this.ho.roc.rcDir = dir;
		}
		
		public override function getDir():int {
			if ((this.m_flags&B2FLAG_ROTATE)!=0) {
				return AngleToDir(this.m_currentAngle);
			}
			else
				return this.ho.roc.rcDir;
		}

		public override function getSpeed():int {
			return int(this.m_strength * 100.0 / 30.0);
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
				
	}
}
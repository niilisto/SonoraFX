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
	import Animations.CAnim;
	import Banks.CImage;
	import Expressions.CExp;
	import Extensions.CRunBox2DBase;
	import Extensions.CRunBox2DBasePosAndAngle;
	import Objects.CExtension;
	import Objects.CObject;
	import RunLoop.CRun;
	import RunLoop.CRunMBase;
	import Services.*;
	
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	
	public class CRunMvtbox2dbackground extends CRunMBase
	{
		public static const B2FLAG_ROTATE:int=0x0001;
		
		public var m_base:CRunBox2DBase=null;
		public var m_friction:Number= 0;
		public var m_restitution:Number= 0;
		public var m_shape:int= 0;
		public var m_flags:int= 0;
		public var m_fixture:b2Fixture= null;
		public var m_obstacle:int= 0;
		public var m_posAndAngle:CRunBox2DBasePosAndAngle;
		public var m_imgWidth:int= 0;
		public var m_imgHeight:int= 0;
		public var m_scaleX:Number= 1.0;
		public var m_scaleY:Number= 1.0;
		public var m_previousAngle:Number= -1;
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
		public var m_moved:int= 0;
		
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
		
		public function CRunMvtbox2dbackground ()
		{
			m_posAndAngle = new CRunBox2DBasePosAndAngle();
			
		}
		public override function initialize(file:CBinaryFile):void {
			file.skipBytes(1);
			this.m_friction=Number(file.readInt())/100.0;
			this.m_restitution=Number(file.readInt())/100.0;
			this.m_flags=file.readInt();
			this.m_angle=Number(this.dirAtStart(file.readInt())*180.0/16.0);
			this.m_shape=file.readShort();
			this.m_obstacle=file.readShort();
			this.m_identifier=file.readInt();
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
			
			this.m_base=this.GetBase();
			this.m_body=null;
			this.InitBase(this.ho, CRunMBase.MTYPE_OBJECT);
			this.m_background = true;
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
			
			var obstacle:int;
			switch (this.m_obstacle)
			{
				case 1:
					obstacle=CRunMBase.MTYPE_OBSTACLE;
					break;
				case 2:
					obstacle= CRunMBase.MTYPE_PLATFORM;
					break;
				default:
					obstacle = CRunMBase.MTYPE_OBJECT;
					break;
			}
			this.m_type = obstacle;
			
			this.m_body = this.m_base.rCreateBody(b2Body.b2_staticBody, this.ho.hoX, this.ho.hoY, this.m_angle, 0, this, 0, 0);
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
			m_moved = 2;
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
					this.m_fixture = this.m_base.rBodyCreateBoxFixture(this.m_body, this, this.ho.hoX, this.ho.hoY, int((this.m_imgWidth * this.m_scaleX)), int((this.m_imgHeight * this.m_scaleY)), 0, this.m_friction, this.m_restitution);
					break;
				case 1:
					this.m_fixture = this.m_base.rBodyCreateCircleFixture(this.m_body, this, this.ho.hoX, this.ho.hoY, int((Number(this.ho.hoImgWidth + this.ho.hoImgHeight) / 4 * Number(this.m_scaleX + this.m_scaleY) / 2)), 0, this.m_friction, this.m_restitution);
					break;
				case 2:
					this.m_fixture = this.m_base.rBodyCreateShapeFixture(this.m_body, this, this.ho.hoX, this.ho.hoY, this.ho.roc.rcImage, 0, this.m_friction, this.m_restitution, this.m_scaleX, this.m_scaleY);
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
			
			this.m_base.rGetBodyPosition(this.m_body, this.m_posAndAngle);
			this.m_currentAngle = this.m_posAndAngle.angle % 360;
			if (this.m_moved > 0)
			{
				if (this.m_posAndAngle.x!=this.ho.hoX || this.m_posAndAngle.y!=this.ho.hoY)
				{
					this.ho.hoX=this.m_posAndAngle.x;
					this.ho.hoY=this.m_posAndAngle.y;
					this.ho.roc.rcChanged=true;
				}
				m_moved--;
			}
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
			animations(CAnim.ANIMID_STOP);
			return this.ho.roc.rcChanged;
		}
		
		public override function SetFriction(friction:int):void {
			this.m_friction=Number(friction)/100.0;
			this.m_fixture.SetFriction(this.m_friction);
		}
		public override function SetRestitution(restitution:int):void {
			this.m_restitution=Number(restitution)/100.0;
			this.m_fixture.SetRestitution(this.m_restitution);
		}
		
		
		public override function setAngle(angle:Number):void {
			this.m_base.rBodySetAngle(this.m_body, angle);
		}
		
		
		public override function getAngle():Number {
			if ((this.m_flags&B2FLAG_ROTATE)!=0)
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
				this.m_base.rBodySetPosition(this.m_body, x, y);
				this.m_moved = 10;
			}
		}
		
		public override function setXPosition(x:int):void {
			if (x!=this.ho.hoX)
			{
				this.m_base.rBodySetPosition(this.m_body, x, CRunBox2DBase.POSDEFAULT);
				this.m_moved = 10;
			}
		}
		
		public override function setYPosition(y:int):void {
			if (y!=this.ho.hoY)
			{
				this.m_base.rBodySetPosition(this.m_body, CRunBox2DBase.POSDEFAULT, y);
				this.m_moved = 10;
			}
		}
		
		
		public override function actionEntry(action:int):Number {
			if (this.m_base == null)
				return 0;
			
			switch (action)
			{
				case CAct.NACT_EXTSETFRICTION:
					this.SetFriction(int(this.getParam1()));
					break;
				case CAct.NACT_EXTSETELASTICITY:
					this.SetRestitution(int(this.getParam1()));
					break;
				case CExp.NEXP_EXTGETFRICTION:
					return this.m_friction * 100;
				case CExp.NEXP_EXTGETRESTITUTION:
					return this.m_restitution * 100;
				default:
					break;
			}
			return 0;
		}
	}
}
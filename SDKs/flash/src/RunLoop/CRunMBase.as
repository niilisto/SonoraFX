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
package RunLoop {
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import Movements.*;
	
	import Objects.CObject;
	
	import Services.CBinaryFile;
	import Services.CRect;
	
	public class CRunMBase extends CRunMvtExtension
	{
		public static const MTYPE_PLATFORM:int= 1;
		public static const MTYPE_OBSTACLE:int= 2;
		public static const MTYPE_OBJECT:int= 3;
		public static const MTYPE_PARTICULE:int= 4;
		public static const MTYPE_ELEMENT:int= 5;
		public static const MTYPE_BORDERBOTTOM:int= 6;
		public static const MTYPE_BORDERLEFT:int= 7;
		public static const MTYPE_BORDERRIGHT:int= 8;
		public static const MTYPE_BORDERTOP:int= 9;
		public static const MTYPE_FAKEOBJECT:int= 10;
		public static const ANGLE_MAGIC:int= 123456789;
		public static const MSUBTYPE_OBJECT:int= 0;
		public static const MSUBTYPE_BOTTOM:int= 1;
		public static const MSUBTYPE_TOP:int= 2;
		public static const MSUBTYPE_LEFT:int= 3;
		public static const MSUBTYPE_RIGHT:int= 4;
		
		public var m_pHo:CObject= null;
		public var m_body:b2Body= null;
		public var m_angle:Number= 0;
		public var m_addVX:Number= 0;
		public var m_addVY:Number= 0;
		public var m_addVFlag:Boolean= false;
		public var m_identifier:int= 0;
		public var m_stopFlag:Boolean= false;
		public var m_currentAngle:Number= 0;
		public var m_eventCount:int= 0;
		public var m_image:Number= 0;
		public var m_stopped:Boolean= false;
		public var m_setVX:Number= 0;
		public var m_setVY:Number= 0;
		public var m_setVFlag:Boolean= false;
		public var m_platform:Boolean= false;
		public var x:int= 0;
		public var y:int= 0;
		public var rc:CRect= new CRect();
		public var m_type:int= 0;
		public var m_subType:int= MSUBTYPE_OBJECT;
		public var m_collidingObject:CRunMBase;
		public var m_background:Boolean= false;
		
		public var RunFactor:Number = 1.0;

		public function InitBase(pHo:CObject, type:int):void {
			m_pHo = pHo;
			this.m_stopFlag=false;
			m_currentAngle=0;
			this.m_type = type;
		}
		public function CreateBody():Boolean {return false;}
		public function CreateJoint():void {}
		public function setAngle(angle:Number):void {}
		public function getAngle():Number {return 0;}
		
		public function SetCollidingObject(object:CRunMBase):void {
			m_collidingObject = object;
		}
		public function PrepareCondition():void {
			this.m_stopFlag=false;
			this.m_eventCount=this.m_pHo.hoAdRunHeader.rh4EventCount;
		}
		
		public function IsStop():Boolean {
			return this.m_stopFlag;
		}
		
		public function SetStopFlag(flag:Boolean):void {
			this.m_stopFlag=flag;
		}
		
		public function SetVelocity(vx:Number, vy:Number):void {
			if (!m_platform)
			{
				var angle:Number=m_body.GetAngle();
				var position:b2Vec2=m_body.GetPosition();
				
				position.x+=vx/2.56;
				position.y+=vy/2.56;
				
				m_body.setTransform(position, angle);
			}
			else
			{
				m_setVX=vx*22.5;
				m_setVY=vy*22.5;
				m_setVFlag=true;
			}
		}
		
		public function AddVelocity(vx:Number, vy:Number):void {
			m_addVX=vx;
			m_addVY=vy;
			m_addVFlag=true;
		}
		
		public function ResetAddVelocity():void {
			if (m_addVFlag)
			{
				m_addVFlag=false;
				m_addVX=0;
				m_addVY=0;
			}
			if (m_setVFlag)
			{
				m_setVFlag=false;
				m_setVX=0;
				m_setVY=0;
			}
		}
		public function SetDensity(density:int):void {}
		public function SetFriction(friction:int):void {}
		public function SetRestitution(restitution:int):void {}
		public function SetGravity(gravity:int):void {}
		
		public override function initialize(file:CBinaryFile):void {}
		
		public override function kill():void {}
		
		public override function move():Boolean {return false;}
		
		public override function setPosition(x:int, y:int):void {}
		
		public override function setXPosition(x:int):void {}
		
		public override function setYPosition(y:int):void {}
		
		public override function stop(bCurrent:Boolean):void {}
		
		public override function bounce(bCurrent:Boolean):void {}
		
		public override function reverse():void {}
		
		public override function start():void {}
		
		public override function setSpeed(speed:int):void {}
		
		public override function setMaxSpeed(speed:int):void {}
		
		public override function setDir(dir:int):void {}
		
		public override function setAcc(acc:int):void {}
		
		public override function setDec(dec:int):void {}
		
		public override function setRotSpeed(speed:int):void {}
		
		public override function set8Dirs(dirs:int):void {}
		
		public override function setGravity(gravity:int):void {}
		
		public override function extension(xfunction:int, param:int):int {return 0;}
		
		public override function actionEntry(action:int):Number {return 0;}
		
		public override function getSpeed():int {return 0;}
		
		public override function getAcceleration():int {return 0;}
		
		public override function getDeceleration():int {return 0;}
		
		public override function getGravity():int {return 0;}
	}
}
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
package Extensions {
	import Actions.*;
	
	import Banks.CImage;
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Joints.*;
	
	import Conditions.*;
	
	import Events.CQualToOiList;
	
	import Expressions.*;
	
	import Objects.CExtension;
	import Objects.CObject;
	
	import Params.CPositionInfo;
	import Params.PARAM_OBJECT;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.CRSpr;
	
	public class CRunBox2DRopeAndChain extends CRunBox2DBaseParent
	{
		private static const MAX_IMAGES:int= 8;
		private static const RCFLAG_ATTACHED:int= 0x0001;
		
		private static const CND_ONEACH:int= 0;
		private static const CND_ELEMENTCOLLISION:int= 1;
		private static const CND_ELEMENTOUTLEFT:int= 2;
		private static const CND_ELEMENTOUTRIGHT:int= 3;
		private static const CND_ELEMENTOUTTOP:int= 4;
		private static const CND_ELEMENTOUTBOTTOM:int= 5;
		private static const CND_NONE:int= 6;
		private static const CND_ELEMENTCOLLISIONBACKDROP:int= 7;
		private static const CND_LAST:int= 8;
		
		private static const ACT_FOREACH:int= 0;
		private static const ACT_STOP:int= 1;
		private static const ACT_CLIMBUP:int= 2;
		private static const ACT_CLIMBDOWN:int= 3;
		private static const ACT_ATTACH:int= 4;
		private static const ACT_RELEASE:int= 5;
		private static const ACT_STOPLOOP:int= 6;
		private static const ACT_CUT:int= 7;
		private static const ACT_ATTACHNUMBER:int= 8;
		
		private static const EXP_LOOPINDEX:int= 0;
		private static const EXP_GETX1:int= 1;
		private static const EXP_GETY1:int= 2;
		private static const EXP_GETX2:int= 3;
		private static const EXP_GETY2:int= 4;
		private static const EXP_GETXMIDDLE:int= 5;
		private static const EXP_GETYMIDDLE:int= 6;
		private static const EXP_GETANGLE:int= 7;
		private static const EXP_GETELEMENT:int= 8;
		
		// Inherited
		// public var base:CRunBox2DBase;
		private var flags:int;
		private var number:int;
		private var angle:Number;
		private var friction:Number;
		private var restitution:Number;
		private var density:Number;
		private var gravity:Number;
		private var nImages:int;
		private var imageStart:Array;
		private var images:Array;
		private var imageEnd:Array;
		private var bodyStart:b2Body;
		private var bodyEnd:b2Body;
		private var stopLoop:Boolean;
		private var loopIndex:int;
		private var elements:CArrayList;
		private var joints:CArrayList;
		private var ropeJoints:CArrayList;
		private var loopName:String;
		private var oldX:int;
		private var oldY:int;
		private var lastElement:int;
		private var effect:int;
		private var effectParam:int;
		private var visible:Boolean;
		public var posAndAngle:CRunBox2DBasePosAndAngle= null;
		
		public function CRunBox2DRopeAndChain()
		{
			posAndAngle = new CRunBox2DBasePosAndAngle();
			
		}
		
		public override function rStartObject():Boolean {
			if (this.base == null)
			{
				this.base= this.GetBase();
				if (this.base == null)
					return false;
			}
			return this.base.started;
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
						var pBase:CRunBox2DBase= CRunBox2DBase(CExtension(pObject).ext);
						if (pBase.identifier == this.identifier)
						{
							return pBase;
						}
					}
				}
			}
			return null;
		}
		
		public override function getNumberOfConditions():int {
			return CND_LAST;
		}
		
		public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean {
			this.ho.hoImgWidth = file.readInt();
			this.ho.hoImgHeight = file.readInt();
			this.flags = file.readInt();
			this.angle = Number(file.readInt() * 11.25);
			this.number = file.readInt();
			this.friction = Number(file.readInt()) / 100.0;
			this.restitution = Number(file.readInt()) / 100.0;
			this.density = Number(file.readInt()) / 100.0;
			this.gravity = Number(file.readInt()) / 100.0;
			this.identifier = file.readInt();
			this.nImages = file.readShort();
			this.imageStart = [0];
			this.imageStart[0] = file.readShort();
			this.ho.loadImageList(this.imageStart);
			this.images = new Array(this.nImages);
			
			var n:int;			
			for (n = 0; n < this.nImages; n++)
				this.images[n] = file.readShort();
			
			file.skipBytes((MAX_IMAGES - n) * 2);
			
			this.ho.loadImageList(this.images);
			this.imageEnd = [0];
			this.imageEnd[0] = file.readShort();
			this.ho.loadImageList(this.imageEnd);
			this.effect = this.ho.ros.rsEffect;
			this.effectParam = this.ho.ros.rsEffectParam;
			this.visible = (this.ho.ros.rsFlags & CRSpr.RSFLAG_VISIBLE)!=0;
			
			this.elements = new CArrayList();
			this.joints = new CArrayList();
			this.ropeJoints = new CArrayList();
			this.oldX = this.ho.hoX;
			this.oldY = this.ho.hoY;
			
			return false;
		}
		
		public override function destroyRunObject(bFast:Boolean):void {
			var base:CRunBox2DBase= GetBase();
			var n:int;
			var elements_size:int= elements.size();
			for (n = 0; n < elements_size; n++)
			{
				var element:CElement= CElement(elements.get(n));
				if(element != null)
					element.destroy(base);
			}
			elements.clear();
			elements = null;
			
			if (base != null)
			{
				base.rDestroyBody(bodyStart);
				if (bodyEnd != null)
					base.rDestroyBody(bodyEnd);
			}
		}

		public override function handleRunObject():int {
			if (!this.rStartObject())
				return 0;
			
			var element:CElement;
			var angle:Number;
			if (this.elements.size() == 0)
			{
				var x:int, y:int;
				var deltaX:int= 0;
				var deltaY:int= 0;
				var plusX:int= 0;
				var plusY:int= 0;
				
				x = this.ho.hoX;
				y = this.ho.hoY;
				
				this.bodyStart = this.base.rCreateBody(b2Body.b2_staticBody, x, y, 0, 0, null, 0, 0);
				this.base.rBodyCreateBoxFixture(this.bodyStart, null, x, y, 16, 16, 0, 0, 0);
				var previousBody:b2Body= this.bodyStart;
				
				angle = -1 * (this.angle * Math.PI / 180);

				var image:CImage= this.rh.rhApp.imageBank.getImageFromHandle(this.imageStart[0]);
				
				
				element = new CElement(this, this.imageStart[0], 0, x, y, visible);
				element.m_body = this.base.rCreateBody(b2Body.b2_dynamicBody, x, y, this.angle, this.gravity, element, 0, 0);
				this.base.rBodyCreateBoxFixture(element.m_body, element, x, y, image.width, image.height,this.density, this.friction, this.restitution);
								
				var JointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
				JointDef.collideConnected = false;
				JointDef.enableLimit = false;
				JointDef.enableMotor = false;
				JointDef.motorSpeed = 0;
				JointDef.Initialize(element.m_body, previousBody, element.m_body.GetPosition());
				var joint:b2Joint= this.base.world.CreateJoint(JointDef);

				this.ropeJoints.add(joint);
				previousBody = element.m_body;
				
				deltaX = image.xAP - image.xSpot;
				deltaY = image.yAP - image.ySpot;
				plusX = int(deltaX * Math.cos(angle) - deltaX * Math.sin(angle));
				plusY = int(deltaX * Math.sin(angle) + deltaY * Math.cos(angle));
				x += plusX;
				y += plusY;
				
				this.elements.add(element);
				
				var n:int;
				var nImage:int= 0;
				for (n=1; n<this.number - 1; n++)
				{
					element = new CElement(this, this.images[nImage], n, x, y, visible);
					
					image = this.rh.rhApp.imageBank.getImageFromHandle(this.images[nImage]);
					
					if(image == null)
						continue;
					
					element.m_body = this.base.rCreateBody(b2Body.b2_dynamicBody, x, y, this.angle, this.gravity, element, 0, 0);
					this.base.rBodyCreateBoxFixture(element.m_body, element, x, y, image.width, image.height, this.density, this.friction, this.restitution);
					
					JointDef.Initialize(element.m_body, previousBody, element.m_body.GetPosition());
					joint = this.base.world.CreateJoint(JointDef);

					this.ropeJoints.add(joint);
					previousBody = element.m_body;
					
					deltaX = image.xAP - image.xSpot;
					deltaY = image.yAP - image.ySpot;
					plusX = int(deltaX * Math.cos(angle) - deltaX * Math.sin(angle));
					plusY = int(deltaX * Math.sin(angle) + deltaY * Math.cos(angle));
					x += plusX;
					y += plusY;
					
					nImage++;
					
					if (nImage >= this.nImages)
						nImage = 0;
					
					this.elements.add(element);
				}
				
				image = this.rh.rhApp.imageBank.getImageFromHandle(this.imageEnd[0]);
				
				x -= image.xAP;
				y -= image.yAP;
				
				element = new CElement(this, this.imageEnd[0], n, x, y, visible);
				element.m_body = this.base.rCreateBody(b2Body.b2_dynamicBody, x, y, this.angle, this.gravity, element, 0, 0);
				this.base.rBodyCreateBoxFixture(element.m_body, element, x, y, image.width, image.height, this.density, this.friction, this.restitution);
				
				
				JointDef.enableMotor = true;
				JointDef.maxMotorTorque = 100000;
				JointDef.motorSpeed = 0;
				JointDef.Initialize(element.m_body, previousBody, element.m_body.GetPosition());
				joint = this.base.world.CreateJoint(JointDef);
				this.ropeJoints.add(joint);
				this.elements.add(element);
				previousBody = element.m_body;
				
				if ((this.flags & CRunBox2DRopeAndChain.RCFLAG_ATTACHED)!=0)
				{
					
					x += image.xAP;
					y += image.yAP;
					deltaX = image.xAP - image.xSpot;
					deltaY = image.yAP - image.ySpot;
					plusX = int(deltaX * Math.cos(angle) - deltaX * Math.sin(angle));
					plusY = int(deltaX * Math.sin(angle) + deltaY * Math.cos(angle));
					x += plusX;
					y += plusY;
					
					this.bodyEnd = this.base.rCreateBody(b2Body.b2_staticBody, x, y, 0, 0, null, 0, 0);
					this.base.rBodyCreateBoxFixture(this.bodyEnd, null, x, y, 16, 16, 0, 0, 0);

					JointDef.collideConnected = false;
					JointDef.enableLimit = false;
					JointDef.enableMotor = false;
					JointDef.Initialize(this.bodyEnd, previousBody, element.m_body.GetPosition());
					joint = this.base.world.CreateJoint(JointDef);
					this.ropeJoints.add(joint);
				}
			}
			
			if (this.ho.hoX != this.oldX || this.ho.hoY != this.oldY)
			{
				var deltaXr:Number= (Number(this.ho.hoX - this.oldX) / this.base.factor);
				var deltaYr:Number= -(Number(this.ho.hoY - this.oldY) / this.base.factor);
				this.oldX = this.ho.hoX;
				this.oldY = this.ho.hoY;
				
				var pos:b2Vec2= this.bodyStart.GetPosition();
				angle = this.bodyStart.GetAngle();
				pos.x += deltaXr;
				pos.y += deltaYr;
				this.bodyStart.setTransform(pos, angle);
				
				//var n:int;
				var _size:int= this.elements.size() ;
				for (n = 0; n < _size ; n++)
				{
					element = CElement(this.elements.get(n));
					if(element == null)
						continue;
					pos = element.m_body.GetPosition();
					angle = element.m_body.GetAngle();
					pos.x += deltaXr;
					pos.y += deltaYr;
					element.m_body.setTransform(pos, angle);
				}
				
				if (this.bodyEnd!=null)
				{
					pos = this.bodyEnd.GetPosition();
					angle = this.bodyEnd.GetAngle();
					pos.x += deltaXr;
					pos.y += deltaYr;
					this.bodyEnd.setTransform(pos, angle);
				}
			}
			
			//var n:int;
			var elements_size:int= elements.size();
			for (n = 0; n < elements_size; n++)
			{
				element = CElement(this.elements.get(n));
				// position could be any number, nonoverload possible in as3
				if(element != null)
					element.setPosition(0,0);
			}
			
			if (this.elements.size() >= 2&& this.bodyEnd == null)
			{
				var position:b2Vec2= this.elements.get(this.elements.size() - 1).m_body.GetPosition();
				angle = this.elements.get(this.elements.size() - 2).m_body.GetAngle();
				this.elements.get(this.elements.size() - 1).m_body.setTransform(position, angle);
			}
			
			var joints_size:int= this.joints.size();
			for (n = 0; n < joints_size ; n++)
			{
				var cjoint:CJointRC= CJointRC(this.joints.get(n));
				if (cjoint != null && cjoint.counter > 0)
				{
					cjoint.counter--;
					if (cjoint.counter == 0)
					{
						this.joints.removeIndex(n);
						joints_size = this.joints.size();
						n--;
					}
				}
			}
			
			if (this.ho.ros.rsEffect != this.effect || this.ho.ros.rsEffectParam != this.effectParam)
			{
				this.effect = this.ho.ros.rsEffect;
				this.effectParam = this.ho.ros.rsEffectParam;
				for (n = 0; n < this.elements.size() ; n++)
				{
					this.elements.get(n).setEffect(this.effect, this.effectParam);
				}
			}
			var v:Boolean= (this.ho.ros.rsFlags & CRSpr.RSFLAG_VISIBLE)!=0;
			if (v != this.visible)
			{
				this.visible = v;
				for (n = 0; n < this.elements.size() ; n++)
				{
					this.elements.get(n).show(visible);
				}
			}
			return 0;
		}
		
		// Conditions
		// --------------------------------------------------
		public override function condition(num:int, cnd:CCndExtension):Boolean {
			switch (num)
			{
				case CRunBox2DRopeAndChain.CND_ONEACH:
					var name:String= cnd.getParamExpString(this.rh, 0);
					return CServices.compareStringsIgnoreCase(name, this.loopName);
				case CRunBox2DRopeAndChain.CND_ELEMENTCOLLISION:
					var param:PARAM_OBJECT= cnd.getParamObject(this.rh, 0);
					if(param == null)
						break;
					if (param.oi == this.rh.rhEvtProg.rhCurParam0 && this.collidingHO != null)
					{
						this.rh.rhEvtProg.evt_AddCurrentObject(this.collidingHO);
						return true;
					}
					else
					{
						var oil:int = param.oiList;
						if ((oil & 0x00008000) != 0)
						{
							var pq:CQualToOiList= this.rh.rhEvtProg.qualToOiList[oil & 0x7FFF];
							var numOi:int= 0;
							var pq_length:int= pq.qoiList.length;
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
		public override function action(num:int, act:CActExtension):void {
			var n:int;
			var pHo:CObject;
			var object:CRunMBase;
			var joints_size:int;
			var cjoint:CJointRC = null;
			switch (num)
			{
				case CRunBox2DRopeAndChain.ACT_FOREACH:
					this.loopName = act.getParamExpString(this.rh, 0);
					this.stopLoop = false;
					var elements_size:int= this.elements.size();
					for (n = 0; n < elements_size ; n++)
					{
						if (this.stopLoop)
							break;
						var element:CElement= CElement(this.elements.get(n));
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
						joints_size = this.joints.size();
						for (n = 0; n < joints_size ; n++)
						{
							cjoint = CJointRC(this.joints.get(n));
							if (cjoint != null && cjoint.object == object)
							{
								n = cjoint.element.number;
								if (n > 0)
								{
									this.base.world.DestroyJoint(cjoint.joint);
									
									var pos1:b2Vec2= cjoint.element.m_body.GetPosition();
									var nextElement:CElement= CElement(this.elements.get(n - 1));
									var pos2:b2Vec2= nextElement.m_body.GetPosition();
									var angle:Number= cjoint.object.m_body.GetAngle();
									var pos3:b2Vec2= cjoint.object.m_body.GetPosition();
									pos3.x += pos2.x - pos1.x;
									pos3.y += pos2.y - pos1.y;
									cjoint.object.m_body.setTransform(pos3, angle);
									
									var JointDef:b2RevoluteJointDef= new b2RevoluteJointDef();
									JointDef.collideConnected = false;
									JointDef.enableMotor = true;
									JointDef.maxMotorTorque = 100000;
									JointDef.motorSpeed = 0;
									JointDef.Initialize(cjoint.object.m_body, nextElement.m_body, nextElement.m_body.GetPosition());
									var joint:b2Joint= this.base.world.CreateJoint(JointDef);
									
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
						joints_size = this.joints.size();
						for (n = 0; n < joints_size ; n++)
						{
							cjoint = CJointRC(this.joints.get(n));
							if (cjoint != null && cjoint.object == object)
							{
								n = cjoint.element.number;
								if (n < this.elements.size() - 1)
								{
									this.base.world.DestroyJoint(cjoint.joint);
									
									var pos1:b2Vec2= cjoint.element.m_body.GetPosition();
									var nextElement:CElement= CElement(this.elements.get(n + 1));
									var pos2:b2Vec2= nextElement.m_body.GetPosition();
									angle = cjoint.object.m_body.GetAngle();
									var pos3:b2Vec2= cjoint.object.m_body.GetPosition();
									pos3.x += pos2.x - pos1.x;
									pos3.y += pos2.y - pos1.y;
									cjoint.object.m_body.setTransform(pos3, angle);
									
									var JointDef:b2RevoluteJointDef= new b2RevoluteJointDef();
									JointDef.collideConnected = false;
									JointDef.enableMotor = true;
									JointDef.maxMotorTorque = 100000;
									JointDef.motorSpeed = 0;
									JointDef.Initialize(cjoint.object.m_body, nextElement.m_body, nextElement.m_body.GetPosition());
									var joint:b2Joint= this.base.world.CreateJoint(JointDef);
									
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
						joints_size = this.joints.size();
						for (n = 0; n < joints_size ; n++)
						{
							cjoint = CJointRC(this.joints.get(n));
							if(cjoint == null)
								continue;
							
							if (cjoint.object == object)
								break;
						}
						if (n == joints_size)
						{
							angle = object.m_body.GetAngle();
							var posObject:b2Vec2= object.m_body.GetPosition();
							var distance:int= act.getParamExpression(this.rh, 1);
							var position:b2Vec2= this.currentElement.m_body.GetPosition();
							if (posObject.x > position.x)
								posObject.x = position.x + distance / this.base.factor;
							else
								posObject.x = position.x - distance / this.base.factor;
							object.m_body.setTransform(posObject, angle);
							var JointDef:b2RevoluteJointDef= new b2RevoluteJointDef();
							JointDef.collideConnected = false;
							JointDef.enableMotor = true;
							JointDef.maxMotorTorque = 100000;
							JointDef.motorSpeed = 0;
							JointDef.Initialize(object.m_body, this.currentElement.m_body, position);
							var joint:b2Joint= this.base.world.CreateJoint(JointDef);
							this.joints.add(new CJointRC(object, CElement(this.currentElement), joint));
						}
					}
					break;
				case CRunBox2DRopeAndChain.ACT_CUT:
				{
					var number:int= act.getParamExpression(this.rh, 0);
					if (this.ropeJoints != null && number >= 0&& number < this.ropeJoints.size())
					{
						var joint:b2Joint= b2Joint(this.ropeJoints.get(number));
						this.base.world.DestroyJoint(joint);
						this.ropeJoints.removeIndex(number);
					}
					this.stopLoop = true;
					break;
				}
				case CRunBox2DRopeAndChain.ACT_ATTACHNUMBER:
					pHo = act.getParamObject(this.rh, 0);
					object = this.base.GetMBase(pHo);
					if (object != null && this.joints != null)
					{
						joints_size = this.joints.size();
						for (n = 0; n < joints_size ; n++)
						{
							cjoint = CJointRC(this.joints.get(n));
							if (cjoint.object == object)
								break;
						}
						if (n == joints_size)
						{
							// angle = object.m_body.getAngle();
							//b2Vec2 posObject = object.m_body.getPosition();
							var number:int= act.getParamExpression(this.rh, 1);
							if (number >= 0 && number < this.elements.size())
							{
								var element:CElement= CElement(this.elements.get(number));
								//int distance = act.getParamExpression(this.rh, 2);
								var position:b2Vec2= element.m_body.GetPosition();
								this.base.rGetBodyPosition(element.m_body, this.posAndAngle);
								this.base.rBodySetPosition(object.m_body, this.posAndAngle.x, this.posAndAngle.y);
								var JointDef:b2RevoluteJointDef= new b2RevoluteJointDef();
								JointDef.collideConnected = false;
								JointDef.enableMotor = true;
								JointDef.maxMotorTorque = 100000;
								JointDef.motorSpeed = 0;
								//JointDef.Initialize(object.m_body, element.m_body, element.m_body.GetPosition());
								JointDef.Initialize(element.m_body, object.m_body, element.m_body.GetPosition());
								var joint:b2Joint= this.base.world.CreateJoint(JointDef);
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
							joints_size = this.joints.size();
							for (n = 0; n < joints_size ; n++)
							{
								cjoint = CJointRC(this.joints.get(n));
								if (cjoint != null && cjoint.object == object)
								{
									this.base.world.DestroyJoint(cjoint.joint);
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
		private function getElement(index:int):CElement {
			if (index >= 0&& index < this.elements.size())
				return CElement(this.elements.get(index));
			return null;
		}
		
		private function getX2(element:CElement):int {
			this.base.rGetBodyPosition(element.m_body, this.posAndAngle);
			var angle:Number= ((-this.posAndAngle.angle / 180 * Math.PI));
			var image:CImage= this.rh.rhApp.imageBank.getImageFromHandle(element.image);
			var deltaX:int= image.xAP - image.xSpot;
			var deltaY:int= image.yAP - image.ySpot;
			var plusX:int= int((deltaX * Math.cos(angle) - deltaY * Math.sin(angle)));
			return this.posAndAngle.x + plusX;
		}
		private function getY2(element:CElement):int {
			this.base.rGetBodyPosition(element.m_body, this.posAndAngle);
			var angle:Number= ((-this.posAndAngle.angle / 180 * Math.PI));
			var image:CImage= this.rh.rhApp.imageBank.getImageFromHandle(element.image);
			var deltaX:int= image.xAP - image.xSpot;
			var deltaY:int= image.yAP - image.ySpot;
			var plusY:int= int((deltaX * Math.sin(angle) + deltaY * Math.cos(angle)));
			return this.posAndAngle.y + plusY;
		}
		public override function expression(num:int):CValue {
			var ret:CValue= new CValue(0);
			var element:CElement;
			switch (num)
			{
				case CRunBox2DRopeAndChain.EXP_GETELEMENT:
					if (this.currentElement != null)
						ret.forceInt((CElement(this.currentElement)).number);
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
						var x2:int= this.getX2(element);
						ret.forceInt((this.posAndAngle.x + x2) / 2);
					}
					break;
				case CRunBox2DRopeAndChain.EXP_GETYMIDDLE:
					element = this.getElement(this.ho.getExpParam().getInt());
					if (element != null)
					{
						this.base.rGetBodyPosition(element.m_body, this.posAndAngle);
						var y2:int= this.getY2(element);
						ret.forceInt(int(((this.posAndAngle.y + y2) / 2)));
					}
					break;
				case CRunBox2DRopeAndChain.EXP_GETANGLE:
					element = CElement(this.getElement(int(this.ho.getExpParam())));
					if (element != null)
					{
						var angle:Number= ((element.m_body.GetAngle() * 180 / Math.PI));
						ret.forceInt(int(angle));
					}
					break;
			}
			return ret;
		}
	}
}

import Box2D.Dynamics.Joints.*;

import Expressions.*;

import RunLoop.*;

internal class CJointRC
{
	public var object:CRunMBase;
	public var element:CElement;
	public var joint:b2Joint;
	public var counter:int;
	
	public function CJointRC(o:CRunMBase, e:CElement, j:b2Joint)
	{
		object = o;
		element = e;
		joint = j;
		counter = 0;
	}
	
}

import Banks.*;
import Expressions.*;
import Extensions.*;
import Frame.*;
import Sprites.*;
import Objects.*;
import Services.*;
import flash.display.*;
import flash.geom.ColorTransform;

internal class CElement extends CRunBox2DBaseElementParent
{
	public var number:int;
	//public var x:int;
	//public var y:int;
	public var angle:Number;
	public var image:int;
	public var sprite:CSprites;
	
	public function CElement(p:CRunBox2DRopeAndChain, i:int, n:int, xx:int, yy:int, visible:Boolean)
	{
		parent = p;
		image = i;
		number = n;
		x = xx;
		y = yy;
		
		this.ho = parent.ho;
		this.angle = 0.0;
		sprite = new CSprites(parent.ho);		
		this.InitBase(parent.ho, CRunMBase.MTYPE_ELEMENT);
		m_identifier = parent.identifier;
		
		var rhPtr:CRun= parent.ho.hoAdRunHeader;
		//sprite = rhPtr.spriteGen.addSprite(x - rhPtr.rhWindowX, y - rhPtr.rhWindowY,
		//        image, parent.ho.ros.rsLayer, parent.ho.ros.rsZOrder, parent.ho.ros.rsBackColor, visible ? 0: CSprite.SF_HIDDEN, null);
		sprite.addSprite(x - rhPtr.rhWindowX, y - rhPtr.rhWindowY, image, parent.ho.ros.rsLayer, visible);
	}
	
	public function destroy(pBase:CRunBox2DBase):void {
		//var rhPtr:CRun= parent.ho.hoAdRunHeader;
		//rhPtr.spriteGen.delSprite(sprite);
		sprite.delSprite();
		if (pBase != null)
			pBase.rDestroyBody(m_body);
	}
	
	public override function setPosition(x:int, y:int):void {
		// Do nothing with x, y just for override CRunMBase 
		var father:CRunBox2DRopeAndChain= CRunBox2DRopeAndChain(this.parent);
		
		father.base.rBodyAddVelocity(m_body, m_addVX, m_addVY);
		ResetAddVelocity();
		father.base.rGetBodyPosition(m_body, father.posAndAngle);
		
		var rhPtr:CRun= parent.ho.hoAdRunHeader;
		//rhPtr.spriteGen.modifSpriteEx(sprite, father.posAndAngle.x - rhPtr.rhWindowX, father.posAndAngle.y - rhPtr.rhWindowY, image, 1.0, 1.0, true, father.posAndAngle.angle, false);
		sprite.modifSprite(father.posAndAngle.x - rhPtr.rhWindowX, father.posAndAngle.y - rhPtr.rhWindowY, image, 1.0, 1.0, father.posAndAngle.angle);
		
	}
	
	public function setEffect(effect:int, effectParam:int):void {
		var rhPtr:CRun= parent.ho.hoAdRunHeader;
		//rhPtr.spriteGen.modifSpriteEffect(sprite, effect, effectParam);
		sprite.setEffect(effect, effectParam);
	}
	public function show(visible:Boolean):void {
		//var rhPtr:CRun= parent.ho.hoAdRunHeader;
		if(visible)
			sprite.showSprite();
		else
			sprite.hideSprite();
	}
	
}
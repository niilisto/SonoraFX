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
package Extensions {
	import Banks.CImage;
	import Events.CQualToOiList;
	import Frame.CLayer;
	import Objects.CExtension;
	import Objects.CObject;
	import Params.PARAM_OBJECT;
	import Services.*;
	import RunLoop.*;
	import Conditions.*;
	import Actions.*;
	import Expressions.*;
	import Sprites.CRSpr;
	//import Sprites.CSprite;
	
	import Box2D.Dynamics.*;
	
	public class CRunBox2DParticules extends CRunBox2DBaseParent
	{
		public static const PATYPE_POINT:int= 0;
		public static const PATYPE_ZONE:int= 1;
		public static const PAFLAG_CREATEATSTART:int= 0x0001;
		public static const PAFLAG_LOOP:int= 0x0002;
		public static const PAFLAG_DESTROYANIM:int= 0x0004;
		public static const ANGLENONE:int= 5666565;
		
		private static const CND_ONEACH:int= 0;
		private static const CND_PARTICULECOLLISION:int= 1;
		private static const CND_PARTICULEOUTLEFT:int= 2;
		private static const CND_PARTICULEOUTRIGHT:int= 3;
		private static const CND_PARTICULEOUTTOP:int= 4;
		private static const CND_PARTICULEOUTBOTTOM:int= 5;
		private static const CND_PARTICULESCOLLISION:int= 6;
		private static const CND_PARTICULECOLLISIONBACKDROP:int= 7;
		private static const CND_LAST:int= 8;
		
		private static const ACT_CREATEPARTICULES:int= 0;
		private static const ACT_STOPPARTICULE:int= 1;
		private static const ACT_FOREACH:int= 2;
		private static const ACT_SETSPEED:int= 3;
		private static const ACT_SETROTATION:int= 4;
		private static const ACT_SETINTERVAL:int= 5;
		private static const ACT_SETANGLE:int= 6;
		private static const ACT_DESTROYPARTICULE:int= 7;
		private static const ACT_DESTROYPARTICULES:int= 8;
		private static const ACT_SETSPEEDINTERVAL:int= 9;
		private static const ACT_SETCREATIONSPEED:int= 10;
		private static const ACT_SETCREATIONON:int= 11;
		private static const ACT_STOPLOOP:int= 12;
		private static const ACT_SETAPPLYFORCE:int= 13;
		private static const ACT_SETAPPLYTORQUE:int= 14;
		private static const ACT_SETASPEED:int= 15;
		private static const ACT_SETALOOP:int= 16;
		private static const ACT_SETSCALE:int= 17;
		private static const ACT_SETFRICTION:int= 18;
		private static const ACT_SETELASTICITY:int= 19;
		private static const ACT_SETDENSITY:int= 20;
		private static const ACT_SETGRAVITY:int= 21;
		private static const ACT_SETDESTROYDISTANCE:int= 22;
		private static const ACT_SETDESTROYANIM:int= 23;
		
		private static const EXP_PARTICULENUMBER:int= 0;
		private static const EXP_GETPARTICULEX:int= 1;
		private static const EXP_GETPARTICULEY:int= 2;
		private static const EXP_GETPARTICULEANGLE:int= 3;
		private static const EXP_GETSPEED:int= 4;
		private static const EXP_GETSPEEDINTERVAL:int= 5;
		private static const EXP_GETANGLE:int= 6;
		private static const EXP_GETANGLEINTERVAL:int= 7;
		private static const EXP_GETROTATION:int= 8;
		private static const EXP_GETLOOPINDEX:int= 9;
		private static const EXP_GETAPPLIEDFORCE:int= 10;
		private static const EXP_GETAPPLIEDTORQUE:int= 11;
		
		private static const APPLYFORCE_MULT:Number= 5.0;
		private static const APPLYTORQUE_MULT:Number= 0.1;
		private static const ROTATION_MULT:Number= 20;
		
		public var type:Number;
		public var flags:int;
		public var number:int;
		public var animationSpeed:int;
		public var angleDWORD:int;
		public var speed:int;
		public var speedInterval:int;
		public var friction:Number;
		public var restitution:Number;
		public var density:Number;
		public var angleInterval:int;
		public var gravity:Number;
		public var rotation:Number;
		public var nImages:int;
		public var images:Array;
		public var creationSpeed:int;
		public var creationSpeedCounter:int;
		public var angle:Number= CRunBox2DParticules.ANGLENONE;
		public var stopLoop:Boolean;
		public var loopIndex:int;
		public var applyForce:Number;
		public var applyTorque:Number;
		public var scaleSpeed:Number;
		public var destroyDistance:int;
		public var loopName:String;
		public var effect:int;
		public var effectParam:int;
		public var visible:Boolean;
		public var m_posAndAngle:CRunBox2DBasePosAndAngle;
		
		public function CRunBox2DParticules()
		{
			m_posAndAngle = new CRunBox2DBasePosAndAngle();
		}
		
		public override function rStartObject():Boolean {
			if (this.base==null)
			{
				this.base=CRunBox2DBase(this.GetBase());
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
		
		private function dirAtStart(dirAtStart:int):int {
			var dir:int;
			
			// Compte le nombre de directions demandees
			var cpt:int= 0;
			var das:int= dirAtStart;
			var das2:int;
			for (var n:int= 0; n < 32; n++)
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
				cpt = this.rh.random(cpt);
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
		
		public override function getNumberOfConditions():int {
			return CND_LAST;
		}
		
		public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean {
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
			this.friction = Number(file.readInt()) / 100.0;
			this.restitution=Number(file.readInt())/100.0;
			this.density=Number(file.readInt())/100.0;
			this.angleInterval=file.readInt();
			this.identifier=file.readInt();
			this.gravity=Number(file.readInt())/100.0;
			this.rotation = Number(file.readInt()) / 100.0 * CRunBox2DParticules.ROTATION_MULT*this.RunFactor;
			this.applyForce = Number(file.readInt()) / 100.0 * CRunBox2DParticules.APPLYFORCE_MULT*this.RunFactor;
			this.applyTorque = Number(file.readInt()) / 100.0 * CRunBox2DParticules.APPLYTORQUE_MULT*this.RunFactor;
			this.scaleSpeed = Number(file.readInt()) / 400.0;
			this.destroyDistance = file.readInt();
			this.nImages = file.readShort();
			var n:int;
			
			this.images = new Array(nImages);
			
			for (n=0; n<this.nImages; n++)
				this.images[n] = file.readShort();
			
			this.ho.loadImageList(this.images);
			this.particules = new CArrayList();
			this.toDestroy = new CArrayList();
			
			return false;
		}
		
		public override function destroyRunObject(bFast:Boolean):void {
			var base:CRunBox2DBase= GetBase();
			var n:int;
			var particules_size:int= this.particules.size() ;
			for (n = 0; n < particules_size ; n++)
			{
				var particule:CParticule= CParticule(this.particules.get(n));
				particule.destroy(base);
			}
		}
		
		public override function handleRunObject():int {
			if (!this.rStartObject())
				return 0;
			
			var n:int;
			var particule:CParticule;
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
				particule = CParticule(toDestroy.get(n));
				particule.destroy(this.base);
				toDestroy.removeIndex(n);
				particules.removeObject(particule);
				particule = null;
				n--;
			}
			
			var rhPtr:CRun= ho.hoAdRunHeader;
			var particules_size:int= particules.size() ;
			for (n = 0; n < particules_size ; n++)
			{
				particule = CParticule(particules.get(n));
				if(particule == null)
					continue;
				
				//int x, y;
				// angle;
				base.rGetBodyPosition(particule.m_body, m_posAndAngle);
				if (m_posAndAngle.x < rhPtr.rh3XMinimumKill || m_posAndAngle.x > rhPtr.rh3XMaximumKill
					|| m_posAndAngle.y < rhPtr.rh3YMinimumKill || m_posAndAngle.y > rhPtr.rh3YMaximumKill)
				{
					toDestroy.add(CRunBox2DBaseElementParent(particule));
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
					particule = CParticule(particules.get(n));
					if (!particule.bDestroyed)
						particule.setEffect(effect, effectParam);
				}
			}
			var v:Boolean= (ho.ros.rsFlags & CRSpr.RSFLAG_VISIBLE) != 0;
			if (v != visible)
			{
				visible = v;
				for (n = 0; n < particules.size() ; n++)
				{
					particule = CParticule(particules.get(n));
					if (!particule.bDestroyed)
						particule.show(visible);
				}
			}
			return 0;
		}
		
		private function createParticules(number:int):void {
			var n:int;
			var particule:CParticule;
			for (n = 0; n < number; n++)
			{
				var x:int, y:int;
				if (this.type == CRunBox2DParticules.PATYPE_POINT)
				{
					x = this.ho.hoX;
					y = this.ho.hoY;
				}
				else
				{
					x = this.ho.hoX + this.rh.random(this.ho.hoImgWidth);
					y = this.ho.hoY + this.rh.random(this.ho.hoImgHeight);
				}
				
				var angle:Number, interval:Number;
				if (this.angle == CRunBox2DParticules.ANGLENONE)
					angle = dirAtStart(this.angleDWORD) * 11.25;
				else
					angle = this.angle;
				if (this.angleInterval > 0)
				{
					interval = this.rh.random(this.angleInterval * 2);
					angle += interval - this.angleInterval;
				}
				
				particule = new CParticule(this, x, y);
				particule.InitBase(this.ho, CRunMBase.MTYPE_PARTICULE);
				particule.setScale(scaleSpeed);
				particule.setAnimation(images, nImages, animationSpeed, flags, visible);
				particule.setForce(applyForce, applyTorque, angle);
				particule.setEffect(effect, effectParam);
				
				var image:CImage= this.rh.rhApp.imageBank.getImageFromHandle(this.images[0]);
				particule.m_body = base.rCreateBody(b2Body.b2_dynamicBody, x, y, angle, gravity, particule, 0, 0);
				particule.fixture = base.rBodyCreateCircleFixture(particule.m_body, particule, x, y, int(((image.width + image.height) / 4)), density, friction, restitution);
				
				var mass:Number= particule.m_body.GetMass();
				interval = this.rh.random(speedInterval * 2);
				var s:int= int((speed + interval - speedInterval));
				s = Math.max(s, 1);
				var speed:Number= ((s / 100.0 * 20.0));
				base.rBodyApplyImpulse(particule.m_body, ((Math.max(1.0, speed * mass))), angle);
				base.rBodyApplyAngularImpulse(particule.m_body, rotation);
				
				this.particules.add(CRunBox2DBaseElementParent(particule));
			}
		}
		
		private function destroyParticule(particule:CParticule):void {
			particule.destroy(this.base);
			this.particules.removeObject(particule);
			particule = null;
		}
		
		// Conditions
		// --------------------------------------------------
		public override function condition(num:int, cnd:CCndExtension):Boolean {
			switch (num)
			{
				case CRunBox2DParticules.CND_ONEACH:
					var name:String= cnd.getParamExpString(this.rh, 0);
					return CServices.compareStringsIgnoreCase(name, this.loopName);
				case CRunBox2DParticules.CND_PARTICULECOLLISION:
					var param:PARAM_OBJECT= cnd.getParamObject(this.rh, 0);
					if (param.oi == this.rh.rhEvtProg.rhCurParam0)
					{
						this.rh.rhEvtProg.evt_AddCurrentObject(this.collidingHO);
						return true;
					}
					else
					{
						var oil:Number= param.oiList;
						if ((oil & 0x8000) != 0)
						{
							var pq:CQualToOiList= this.rh.rhEvtProg.qualToOiList[oil & 0x7FFF];
							var numOi:int= 0;
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
		public override function action(num:int, act:CActExtension):void {
			switch (num)
			{
				case CRunBox2DParticules.ACT_CREATEPARTICULES:
					var number:int= act.getParamExpression(this.rh, 0);
					this.createParticules(number);
					break;
				case CRunBox2DParticules.ACT_STOPPARTICULE:
					this.stopped = true;
					break;
				case CRunBox2DParticules.ACT_FOREACH:
					this.loopName = act.getParamExpString(this.rh, 0);
					var n:int;
					this.stopLoop = false;
					var particules_size:int= this.particules.size();
					for (n = 0; n < particules_size ; n++)
					{
						if (this.stopLoop)
							break;
						var particule:CParticule= CParticule(this.particules.get(n));
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
						if (!(CParticule(this.currentParticule1)).bDestroyed && this.particules.indexOf(this.currentParticule1) >= 0)
							this.toDestroy.add(this.currentParticule1);
					}
					break;
				case CRunBox2DParticules.ACT_DESTROYPARTICULES:
					if (this.currentParticule1 != null)
						if (!(CParticule(this.currentParticule1)).bDestroyed && this.particules.indexOf(this.currentParticule1) >= 0)
							this.toDestroy.add(CParticule(this.currentParticule1));
					if (this.currentParticule2 != null)
						if (!(CParticule(this.currentParticule2)).bDestroyed && this.particules.indexOf(this.currentParticule2) >= 0)
							this.toDestroy.add(this.currentParticule2);
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
					this.applyForce = act.getParamExpression(this.rh, 0) / 100 * CRunBox2DParticules.APPLYFORCE_MULT*this.RunFactor;
					break;
				case CRunBox2DParticules.ACT_SETAPPLYTORQUE:
					this.applyTorque = act.getParamExpression(this.rh, 0) / 100 * CRunBox2DParticules.APPLYTORQUE_MULT*this.RunFactor;
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
					this.scaleSpeed = act.getParamExpression(this.rh, 0) / 400;
					break;
				case CRunBox2DParticules.ACT_SETFRICTION:
					this.friction = act.getParamExpression(this.rh, 0) / 100;
					break;
				case CRunBox2DParticules.ACT_SETELASTICITY:
					this.restitution = act.getParamExpression(this.rh, 0) / 100;
					break;
				case CRunBox2DParticules.ACT_SETDENSITY:
					this.density = act.getParamExpression(this.rh, 0) / 100;
					break;
				case CRunBox2DParticules.ACT_SETGRAVITY:
					this.gravity = act.getParamExpression(this.rh, 0) / 100;
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
		public override function expression(num:int):CValue {
			var ret:CValue= new CValue(0);
			switch (num)
			{
				case CRunBox2DParticules.EXP_PARTICULENUMBER:
					ret.forceInt(this.particules.size());
					break;
				case CRunBox2DParticules.EXP_GETPARTICULEX:
					if (this.currentParticule1!=null)
						ret.forceInt((CParticule(this.currentParticule1)).x);
					break;
				case CRunBox2DParticules.EXP_GETPARTICULEY:
					if (this.currentParticule1!=null)
						ret.forceInt((CParticule(this.currentParticule1)).y);
					break;
				case CRunBox2DParticules.EXP_GETPARTICULEANGLE:
					if (this.currentParticule1!=null) {
						ret.forceInt(int(CParticule(this.currentParticule1).angle));
					}
					break;
				case CRunBox2DParticules.EXP_GETSPEED:
					ret.forceInt(this.speed);
					break;
				case CRunBox2DParticules.EXP_GETSPEEDINTERVAL:
					ret.forceInt(this.speedInterval);
					break;
				case CRunBox2DParticules.EXP_GETANGLE:
					ret.forceInt(int(this.angle));
					break;
				case CRunBox2DParticules.EXP_GETANGLEINTERVAL:
					ret.forceInt(this.angleInterval);
					break;
				case CRunBox2DParticules.EXP_GETROTATION:
					ret.forceInt(int(this.rotation));
					break;
				case CRunBox2DParticules.EXP_GETLOOPINDEX:
					ret.forceInt(this.loopIndex);
					break;
				case CRunBox2DParticules.EXP_GETAPPLIEDFORCE:
					ret.forceInt(int(this.applyForce * 100 / CRunBox2DParticules.APPLYFORCE_MULT/this.RunFactor));
					break;
				case CRunBox2DParticules.EXP_GETAPPLIEDTORQUE:
					ret.forceInt(int(this.applyTorque * 100 / CRunBox2DParticules.APPLYTORQUE_MULT/this.RunFactor));
					break;
				default:
					break;
			}
			return ret;
		}
		
	}
}

import Banks.CImage;

import Box2D.Dynamics.b2Fixture;

import Expressions.*;

import Extensions.*;

import Frame.CLayer;

import Objects.CObject;

import RunLoop.*;

import Sprites.CRSpr;
import Sprites.CSprites;

internal class CParticule extends CRunBox2DBaseElementParent
{
	private var nLayer:int;
	private var pLayer:CLayer;
	private var initialX:int;
	private var initialY:int;
	public var xp:int;
	public var yp:int;
	public var angle:Number;
	private var nImages:int;
	private var images:Array;
	private var image:int;
	private var animationSpeed:int= 0;
	private var animationSpeedCounter:int= 0;
	public var bDestroyed:Boolean= false;
	private var oldWidth:Number= 0;
	private var oldHeight:Number= 0;
	public var fixture:b2Fixture= null;
	private var scaleSpeed:Number= 0;
	private var scale:Number= 0;
	private var sprite:CSprites;
	private var m_force:Number;
	private var m_torque:Number;
	private var m_direction:Number;
	private var pstopped:Boolean=false;
	private var flags:int;
	
	public function CParticule(pp:CRunBox2DParticules, xx:int, yy:int)
	{
		parent = CRunBox2DBaseParent(pp);
		initialX = xx;
		initialY= yy;
		xp = xx;
		yp = yy;
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
		scale = 1.0;
		sprite = new CSprites(parent.ho);
	}
	public function destroy(pBase:CRunBox2DBase):void {
		//var rhPtr:CRun= parent.ho.hoAdRunHeader;
		sprite.delSprite();
		if (pBase != null)
			pBase.rDestroyBody(m_body);
	}
	public function setForce(force:Number, torque:Number, direction:Number):void {
		m_force = force;
		m_torque = torque;
		m_direction = direction;
	}
	public function setAnimation(pImages:Array, nI:int, aSpeed:int, f:int, visible:Boolean):void {
		images = pImages;
		nImages = nI;
		animationSpeed = aSpeed;
		animationSpeedCounter = 0;
		flags = f;
		pstopped = false;
		
		var image:CImage= parent.rh.rhApp.imageBank.getImageFromHandle(images[0]);
		oldWidth = image.width * scale;
		oldHeight = image.height * scale;
		
		var rhPtr:CRun= parent.ho.hoAdRunHeader;
		//sprite = rhPtr.spriteGen.addSprite(x-rhPtr.rhWindowX, y-rhPtr.rhWindowY,
		//        images[0], parent.ho.ros.rsLayer, parent.ho.ros.rsZOrder, parent.ho.ros.rsBackColor, visible?0:CSprite.SF_HIDDEN, null);
		sprite.addSprite(x-rhPtr.rhWindowX, y-rhPtr.rhWindowY, images[0], parent.ho.ros.rsLayer, (parent.ho.ros.rsFlags&CRSpr.RSFLAG_HIDDEN)==0);
	}
	public function setScale(scaleSpeed:Number):void {
		this.scaleSpeed = scaleSpeed;
		this.scale = 1;
	}
	public function setEffect(effect:int, effectParam:int):void {
		//var rhPtr:CRun= parent.ho.hoAdRunHeader;
		sprite.setEffect(effect, effectParam);
	}
	public function show(visible:Boolean):void {
		//var rhPtr:CRun= parent.ho.hoAdRunHeader;
		if(visible)
			sprite.showSprite();
		else
			sprite.hideSprite();
	}
	public function animate():void {
		if (!this.pstopped)
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
						this.pstopped = true;
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
		var oldScale:Number= this.scale;
		this.scale += this.scaleSpeed;
		
		var father:CRunBox2DParticules= CRunBox2DParticules(this.parent);
		var cImage:CImage= this.parent.rh.rhApp.imageBank.getImageFromHandle(this.images[this.image]);
		var width:Number= cImage.width * this.scale;
		var height:Number= cImage.height * this.scale;
		if (width < 1|| height < 1)
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
				this.oldWidth = int(width);
				this.oldHeight = int(height);
				this.m_body.DestroyFixture(this.fixture);
				this.fixture = this.parent.base.rBodyCreateCircleFixture(this.m_body, this, this.xp, this.yp, int(((width + height) / 4)), father.density, father.friction, father.restitution);
			}
		}
		
		this.parent.base.rBodyAddVelocity(this.m_body, this.m_addVX, this.m_addVY);
		this.ResetAddVelocity();
		
		parent.base.rBodyApplyImpulse(m_body, m_force, m_direction);
		parent.base.rBodyApplyAngularImpulse(m_body, m_torque);
		
		parent.base.rGetBodyPosition(m_body, father.m_posAndAngle);
		
		var dx:int= father.m_posAndAngle.x - initialX;
		var dy:int= father.m_posAndAngle.y - initialY;
		var distance:int= int((Math.sqrt(dx * dx + dy * dy)));
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
			var rhPtr:CRun= parent.ho.hoAdRunHeader;
			//rhPtr.spriteGen.modifSpriteEx(sprite, father.m_posAndAngle.x - rhPtr.rhWindowX, father.m_posAndAngle.y - rhPtr.rhWindowY, images[image],
			//        scale, scale, true, angle, true);
			sprite.modifSprite(father.m_posAndAngle.x - rhPtr.rhWindowX, father.m_posAndAngle.y - rhPtr.rhWindowY, images[image],
				scale, scale, angle);
		}
	}
}
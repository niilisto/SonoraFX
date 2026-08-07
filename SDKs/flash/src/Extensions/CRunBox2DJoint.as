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
// CRUNBOX2DJOINT : easy revolute joint creation
//
//----------------------------------------------------------------------------------
package Extensions {
	import Actions.*;
	
	import Banks.*;
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Joints.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import OI.*;
	
	import Objects.CActive;
	import Objects.CExtension;
	import Objects.CObject;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	public class CRunBox2DJoint extends CRunBox2DBaseParent
	{
		// Inherited
		// public override var base:CRunBox2DBase;
		private var flags:int= 0;
		private var number:int= 0;
		private var angle1:int= 0;
		private var angle2:int= 0;
		private var speed:int= 0;
		private var torque:int= 0;
		private var bodyStatic:b2Body= null;
		private var joints:CArrayList = new CArrayList();
		private static const PINFLAG_LINK:int= 0x0001;
		private static const ACT_SETLIMITS:int= 0;
		private static const ACT_SETMOTOR:int= 1;
		private static const ACT_DESTROY:int= 2;
		private static const EXP_ANGLE1:int=0;
		private static const EXP_ANGLE2:int=1;
		private static const EXP_TORQUE:int=2;
		private static const EXP_SPEED:int=3;
		
		public override function rStartObject():Boolean {
			if (this.base==null)
			{
				this.base=CRunBox2DBase(this.GetBase());
				if (this.base == null)
					return false;
			}
			return base.started;
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
			return 0;
		}
		
		public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean {
			this.ho.hoX = cob.cobX;
			this.ho.hoY = cob.cobY;
			if ((cob.cobFlags & CRun.COF_CREATEDATSTART) != 0)
			{
				this.ho.hoX += 16;
				this.ho.hoY += 16;
			}
			this.flags = file.readInt();
			this.number = file.readShort();
			this.angle1 = file.readInt();
			this.angle2 = file.readInt();
			this.torque = file.readInt();
			this.speed = file.readInt();
			this.identifier = file.readInt();
			return false;
		}
		
		public override function destroyRunObject(bFast:Boolean):void {
			if (bodyStatic != null)
			{
				var pBase:CRunBox2DBase= GetBase();
				if (pBase != null)
					pBase.rDestroyBody(bodyStatic);
			}
		}
		
		private function ListSort(array:CArrayList): void
		{
			var sorted:Boolean;
			
			if(array == null)
				return;
			do
			{
				sorted = true; // Everything sorted
				for (var i:int=0; i < array.size()-1; i++) {
					if (array.get(i+1).m_pHo.ros.rsZOrder < array.get(i).m_pHo.ros.rsZOrder) 
					{
						array.swapindex(i, i+1);
						sorted = false; // Not everything sorted yet 
					}
				}
			} while (!sorted); //repeat do...while until there`s nothing left to be sorted
		}
		
		private function AddToList(list:CArrayList, pHox:CObject):void {
			// Active object ?
			if ( pHox != null  && pHox is CActive )
			{
				var pMBase:CRunMBase= base.GetMBase(pHox);
				if (pMBase != null && pMBase.m_identifier == identifier) {
					list.add(pMBase);
				}
			}
		}
		
		private function GetTopMostObjects(list:CArrayList, x:int, y:int):void {

			var rhPtr:CRun = this.rh;
			var count:int=0;
			var i:int;
			var pHox:CObject;
			var x1:int, y1:int, x2:int, y2:int;
			var topindex:int = -1;
			
			x -= this.rh.rhWindowX;
			y -= this.rh.rhWindowY;
			
			for (i=0; i<rhPtr.rhNObjects; i++)
			{
				while(rhPtr.rhObjectList[count]==null)
					count++;
				pHox=rhPtr.rhObjectList[count];
				count++;
				
				x1=pHox.hoX-pHox.hoImgXSpot;
				y1=pHox.hoY-pHox.hoImgYSpot;
				x2=x1+pHox.hoImgWidth;
				y2=y1+pHox.hoImgHeight;
				
				if(x >= x1 && x <= x2 && y > y1 && y <= y2) {
					
					if ((pHox.hoFlags & CObject.HOF_DESTROYED) == 0)
					{
						if (pHox.hoType==COI.OBJ_SPR)
						{
							if ((pHox.ros.rsFlags&CRSpr.RSFLAG_COLBOX)==0)
							{
								var image:CImage=rhPtr.rhApp.imageBank.getImageFromHandle(pHox.roc.rcImage);
								var mask:CMask=image.getMask(CMask.GCMF_OBSTACLE, pHox.roc.rcAngle, pHox.roc.rcScaleX, pHox.roc.rcScaleY);
								if (mask.testPoint(x1, y1, x, y))
								{
									AddToList(list, pHox);
								}
							}
							else
							{
								AddToList(list, pHox);
							}
						}
					}
				}
			}
			//ListSort(list);
		}
		
		public override function handleRunObject():int {
			if (!this.rStartObject())
				return 0;
			
			var list:CArrayList = new CArrayList();
			var x:int= this.ho.hoX;
			var y:int= this.ho.hoY;
			this.GetTopMostObjects(list, this.ho.hoX, this.ho.hoY);
			
			if (list.size() > 0)
			{
				if ((this.flags & CRunBox2DJoint.PINFLAG_LINK) != 0 || list.size() == 1)
				{
					this.bodyStatic = this.base.rCreateBody(b2Body.b2_staticBody, x, y, 0, 0, null, 0, 0);
					this.base.rBodyCreateBoxFixture(this.bodyStatic, null, x, y, 16, 16, 0, 0, 0);
				}
				var jointDef:b2RevoluteJointDef= new b2RevoluteJointDef();
				jointDef.collideConnected=true;
				var position:b2Vec2= new b2Vec2(x, y);
				this.base.rFrameToWorld(position);
				var joint:b2RevoluteJoint;
				if (list.size() == 1)
				{
					var pMBase:CRunMBase= CRunMBase(list.get(0));
					if(pMBase != null) {
						joint = this.base.rWorldCreateRevoluteJoint(jointDef, this.bodyStatic, pMBase.m_body, position);
						if(joint != null) {
							this.base.rRJointSetLimits(joint, this.angle1, this.angle2);
							this.base.rRJointSetMotor(joint, this.torque, this.speed);
							this.joints.add(new CJointO(null, pMBase, joint));
						}
					}
				}
				if (list.size() >= 2)
				{
					var numbers:int= 1;
					if (this.number == 1)
						numbers = 10000;
					var n:int;
					var pMBase1:CRunMBase= null;
					var pMBase2:CRunMBase= null;
					for (n = 0; n < numbers; n++)
					{
						var index:int= list.size() - 1- n;
						pMBase1 = CRunMBase(list.get(index));
						pMBase2 = CRunMBase(list.get(index - 1));
						if(pMBase1 != null && pMBase2 != null) {
							joint = this.base.rWorldCreateRevoluteJoint(jointDef, pMBase1.m_body, pMBase2.m_body, position);
							if(joint != null) {
								this.base.rRJointSetLimits(joint, this.angle1, this.angle2);
								this.base.rRJointSetMotor(joint, this.torque, this.speed);
								this.joints.add(new CJointO(pMBase1, pMBase2, joint));
							}
						}
						if (index == 1)
							break;
					}
					if ((this.flags & CRunBox2DJoint.PINFLAG_LINK) != 0)
					{
						joint = this.base.rWorldCreateRevoluteJoint(jointDef, this.bodyStatic, pMBase2.m_body, position);
						this.joints.add(new CJointO(null, pMBase2, joint));
					}
				}
			}
			return CRunExtension.REFLAG_ONESHOT;
		}
		
		public function GetHO(fixedValue:int):CObject {
			var hoPtr:CObject=this.rh.rhObjectList[fixedValue&0xFFFF];
			if (hoPtr!=null && hoPtr.hoCreationId==fixedValue>>16)
				return hoPtr;
			return null;
		}
		
		private function VerifyJoints():void {
			var n:int;
			var joints_size:int= this.joints.size();
			for (n = 0; n < joints_size; n++)
			{
				var pJointO:CJointO= CJointO(this.joints.get(n));
				if(pJointO == null)
					continue;
				
				var pHo:CObject;
				var bFlag:Boolean= true;
				if (pJointO.m_fv1 != -1)
				{
					pHo = this.GetHO(pJointO.m_fv1);
					if (pHo == null)
						bFlag = false;
				}
				if (pJointO.m_fv2 != -1)
				{
					pHo = this.GetHO(pJointO.m_fv2);
					if (pHo == null)
						bFlag = false;
				}
				if (!bFlag)
				{
					this.joints.removeIndex(n);
					joints_size = this.joints.size();
					n--;
				}
			}
		}
		
		public override function action(num:int, act:CActExtension):void {
			var n:int, param1:int, param2:int;
			var joints_size:int= this.joints.size();
			var pJointO:CJointO= null;
			switch (num)
			{
				case CRunBox2DJoint.ACT_SETLIMITS:
					this.angle1 = act.getParamExpression(this.rh, 0);
					this.angle2 = act.getParamExpression(this.rh, 1);
					this.VerifyJoints();
					for (n = 0; n < joints_size; n++)
					{
						pJointO = CJointO(this.joints.get(n));
						this.base.rRJointSetLimits(pJointO.m_joint, this.angle1, this.angle2);
					}
					break;
				case CRunBox2DJoint.ACT_SETMOTOR:
					this.torque = act.getParamExpression(this.rh, 0);
					this.speed = act.getParamExpression(this.rh, 1);
					this.VerifyJoints();
					for (n = 0; n < joints_size; n++)
					{
						pJointO = CJointO(this.joints.get(n));
						this.base.rRJointSetMotor(pJointO.m_joint, this.torque, this.speed);
					}
					break;
				case CRunBox2DJoint.ACT_DESTROY:
					this.VerifyJoints();
					for (n = 0; n < this.joints.size(); n++)
					{
						pJointO = CJointO(this.joints.get(n));
						this.base.rDestroyJoint(pJointO.m_joint);
						this.joints.removeIndex(n);
						n--;
					}
					break;
			}
		}
		public override function expression(num:int):CValue {
			switch (num)
			{
				case EXP_ANGLE1:
					return new CValue(this.angle1);
				case EXP_ANGLE2:
					return new CValue(this.angle2);
				case EXP_TORQUE:
					return new CValue(this.torque);
				case EXP_SPEED:
					return new CValue(this.speed);
			}
			return null;
		}
	}
}

import Expressions.*
import RunLoop.*;
import Objects.CObject;
import Box2D.Dynamics.Joints.*;

internal class CJointO
{
	public var m_fv1:int;
	public var m_fv2:int;
	public var m_joint:b2RevoluteJoint;
	
	public function CJointO(pBase1:CRunMBase, pBase2:CRunMBase, joint:b2RevoluteJoint)
	{
		var pHo:CObject;
		this.m_fv1 = -1;
		if (pBase1 != null)
		{
			pHo = pBase1.m_pHo;
			this.m_fv1 = (pHo.hoCreationId<<16)|(pHo.hoNumber&0xFFFF);
		}
		this.m_fv2 = -1;
		if (pBase2 != null)
		{
			pHo = pBase2.m_pHo;
			this.m_fv2 = (pHo.hoCreationId<<16)|(pHo.hoNumber&0xFFFF);
		}
		this.m_joint = joint;
	}
}
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
// CRUNBOX2DFAN
//
//----------------------------------------------------------------------------------
package Extensions {
	import Actions.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Objects.CExtension;
	import Objects.CObject;
	
	import RunLoop.*;
	
	import Services.*;
	
	public class CRunBox2DMagnet extends CRunBaseParent
	{
		private static const CND_ISACTIVE:int=0;
		private static const CND_LAST:int=1;
		private static const ACT_SETSTRENGTH:int=0;
		private static const ACT_SETANGLE:int=1;
		private static const ACT_SETWIDTH:int=2;
		private static const ACT_SETHEIGHT:int=3;
		private static const ACT_ONOFF:int=4;
		private static const EXP_STRENGTH:int=0;
		private static const EXP_WIDTH:int=1;
		private static const EXP_HEIGHT:int=2;
		private static const MAGNETFLAG_ON:int=0x0001;
		private static const STRENGTHMULT:Number= 0.001;
		
		private var base:CRunBox2DBase= null;
		private var objects:CArrayList = new CArrayList();
		private var flags:int= 0;
		private var strength:Number= 0;
		private var strengthBase:int= 0;
		private var angle:int= 0;
		private var radius:int= 0;
		
		public function CRunBox2DMagnet()
		{
		}
		
		public override function rAddObject(movement:CRunMBase):void {
			if (movement.m_identifier==this.identifier)
			{
				this.objects.add(movement);
			}
		}
		
		public override function rRemoveObject(movement:CRunMBase):void {
			this.objects.removeObject(movement);
		}
		
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
			return CND_LAST;
		}
		
		public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean {
			this.flags=file.readInt();
			this.angle=file.readInt();
			this.strengthBase=file.readInt();
			this.strength=this.strengthBase*STRENGTHMULT*this.RunFactor;
			this.ho.hoImgWidth=file.readInt();
			this.ho.hoImgHeight=file.readInt();
			this.identifier=file.readInt();
			
			var sx:int=this.ho.hoImgWidth/2;
			var sy:int=this.ho.hoImgHeight/2;
			this.radius=int((Math.sqrt(sx*sx+sy*sy)));
			
			return false;
		}
		
		public override function destroyRunObject(bFast:Boolean):void {
		}
		
		public override function handleRunObject():int {
			if (!this.rStartObject())
				return 0;
			
			if ((this.flags&MAGNETFLAG_ON)!=0)
			{
				var n:int;
				var objects_size:int= this.objects.size();
				for (n=0; n<objects_size; n++)
				{
					var pMovement:CRunMBase=CRunMBase(this.objects.get(n));
					if(pMovement == null)
						continue;
					
					var x:int= -1000000;
					var y:int= -1000000;
					if (pMovement.m_type ==CRunMBase.MTYPE_PARTICULE || pMovement.m_type == CRunMBase.MTYPE_ELEMENT)
					{
						x = pMovement.x;
						y = pMovement.y;
					}
					else if (pMovement.m_type == CRunMBase.MTYPE_OBJECT)
					{
						x = pMovement.m_pHo.hoX;
						y = pMovement.m_pHo.hoY;
					}
					if (x>=this.ho.hoX && x<this.ho.hoX+this.ho.hoImgWidth && y>=this.ho.hoY && y<this.ho.hoY+this.ho.hoImgHeight)
					{
						var dx:int=x-(this.ho.hoX+this.ho.hoImgWidth/2);
						var dy:int=y-(this.ho.hoY+this.ho.hoImgHeight/2);
						var distance:int=int((Math.sqrt(dx*dx+dy*dy)));
						if (distance<this.radius)
						{
							var angle:Number= Math.atan2(-dy, dx) * 180.0 / Math.PI;
							if (angle<0)
								angle=360.0+angle;
							var a:int=int((angle/11.25));
							var mask:int=1<<a;
							if ((this.angle&mask)!=0)
							{
								this.base.rBodyApplyImpulse(pMovement.m_body, this.strength, angle+180.0);
							}
						}
					}
				}
			}
			return 0;
		}
		
		// Conditions
		// --------------------------------------------------
		public override function condition(num:int, cnd:CCndExtension):Boolean {
			if (num == CRunBox2DMagnet.CND_ISACTIVE)
			{
				return (this.flags&CRunBox2DMagnet.MAGNETFLAG_ON)!=0;
			}
			return false;
		}
		
		// Actions
		// -------------------------------------------------
		public override function action(num:int, act:CActExtension):void {
			switch (num)
			{
				case CRunBox2DMagnet.ACT_SETSTRENGTH:
					this.strengthBase=act.getParamExpression(this.rh, 0);
					this.strength=Number(this.strengthBase)/100.0*STRENGTHMULT*this.RunFactor;
					break;
				case CRunBox2DMagnet.ACT_SETANGLE:
					this.angle=act.getParamNewDirection(this.rh, 0);
					break;
				case CRunBox2DMagnet.ACT_SETWIDTH:
					var width:int= act.getParamExpression(this.rh, 0);
					if (width>0)
						this.ho.hoImgWidth=width;
					break;
				case CRunBox2DMagnet.ACT_SETHEIGHT:
					var height:int= act.getParamExpression(this.rh, 0);
					if (height>0)
						this.ho.hoImgHeight=height;
					break;
				case CRunBox2DMagnet.ACT_ONOFF:
					var on:int= act.getParamExpression(this.rh, 0);
					if (on!=0)
						this.flags|=CRunBox2DMagnet.MAGNETFLAG_ON;
					else
						this.flags&=~CRunBox2DMagnet.MAGNETFLAG_ON;
					break;
			}
		}
		
		
		// Expressions
		// --------------------------------------------
		public override function expression(num:int):CValue {
			var ret:CValue= new CValue(0);
			switch (num)
			{
				case CRunBox2DMagnet.EXP_STRENGTH:
					ret.forceInt(this.strengthBase);
					break;
				case CRunBox2DMagnet.EXP_WIDTH:
					ret.forceInt(this.ho.hoImgWidth);
					break;
				case CRunBox2DMagnet.EXP_HEIGHT:
					ret.forceInt(this.ho.hoImgHeight);
					break;
			}
			return ret;
		}
	}
}
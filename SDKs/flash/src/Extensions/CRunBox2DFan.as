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
	import Objects.CExtension;
	import Objects.CObject;
	import Services.*;
	import RunLoop.*;
	import Conditions.*;
	import Actions.*;
	import Expressions.*;
	
	
	
	public class CRunBox2DFan extends CRunBaseParent
	{
		public static const CND_ISACTIVE:int=0;
		public static const CND_LAST:int=1;
		public static const ACT_SETSTRENGTH:int=0;
		public static const ACT_SETANGLE:int=1;
		public static const ACT_SETWIDTH:int=2;
		public static const ACT_SETHEIGHT:int=3;
		public static const ACT_ONOFF:int=4;
		public static const EXP_STRENGTH:int=0;
		public static const EXP_ANGLE:int=1;
		public static const EXP_WIDTH:int=2;
		public static const EXP_HEIGHT:int=3;
		public static const FANFLAG_PROPORTIONAL:int=0x0001;
		public static const FANFLAG_ON:int=0x0002;
		
		public var base:CRunBox2DBase;
		public var objects:CArrayList;
		public var flags:int= 0;
		public var strength:Number= 0;
		public var strengthBase:int= 0;
		public var angle:Number= 0;
		public var check:Boolean= false;
		
		public static const STRENGTH:Number = 0.5;

		public function CRunBox2DFan()
		{
			objects = new CArrayList();

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
			this.angle = file.readInt() * Math.PI / 16.0;
			this.strengthBase=file.readInt();
			this.ho.hoImgWidth=file.readInt();
			this.ho.hoImgHeight=file.readInt();
			this.identifier=file.readInt();
			
			this.strength=(this.strengthBase/100.0/STRENGTH/this.RunFactor);
			this.base=null;
			this.check=true;
			
			return false;
		}
		
		public override function destroyRunObject(bFast:Boolean):void {
		}
		
		public override function handleRunObject():int {
			if (!this.rStartObject())
				return 0;
			
			if ((this.flags&FANFLAG_ON)!=0)
			{
				var n:int;
				var objects_size:int= this.objects.size();
				for (n=0; n<objects_size; n++)
				{
					var pMovement:CRunMBase=CRunMBase(this.objects.get(n));
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
						pMovement.AddVelocity((this.strength*Math.cos(this.angle)), (this.strength*Math.sin(this.angle)));
					}
				}
			}
			return 0;
		}
		
		// Conditions
		// --------------------------------------------------
		public override function condition(num:int, cnd:CCndExtension):Boolean {
			if (num == CND_ISACTIVE)
			{
				return (this.flags&FANFLAG_ON)!=0;
			}
			return false;
		}
		
		// Actions
		// -------------------------------------------------
		public override function action(num:int, act:CActExtension):void {
			switch (num)
			{
				case CRunBox2DFan.ACT_SETSTRENGTH:
					this.strengthBase=act.getParamExpression(this.rh, 0);
					this.strength=Number(this.strengthBase)/100.0*STRENGTH*this.RunFactor;
					break;
				case CRunBox2DFan.ACT_SETANGLE:
					this.angle = (act.getParamExpression(this.rh, 0) * Math.PI / 180.0);
					break;
				case CRunBox2DFan.ACT_SETWIDTH:
					var width:int= act.getParamExpression(this.rh, 0);
					if (width>0)
						this.ho.hoImgWidth=width;
					break;
				case CRunBox2DFan.ACT_SETHEIGHT:
					var height:int= act.getParamExpression(this.rh, 0);
					if (height>0)
						this.ho.hoImgHeight=height;
					break;
				case CRunBox2DFan.ACT_ONOFF:
					var on:int= act.getParamExpression(this.rh, 0);
					if (on != 0)
						this.flags|=CRunBox2DFan.FANFLAG_ON;
					else
						this.flags&=~CRunBox2DFan.FANFLAG_ON;
					break;
			}
		}
		
		
		// Expressions
		// --------------------------------------------
		public override function expression(num:int):CValue {
			var ret:CValue= new CValue(0);
			switch (num)
			{
				case CRunBox2DFan.EXP_STRENGTH:
					ret.forceInt(this.strengthBase);
					break;
				case CRunBox2DFan.EXP_ANGLE:
					ret.forceInt(int((this.angle*180/Math.PI)));
					break;
				case CRunBox2DFan.EXP_WIDTH:
					ret.forceInt(this.ho.hoImgWidth);
					break;
				case CRunBox2DFan.EXP_HEIGHT:
					ret.forceInt(this.ho.hoImgHeight);
					break;
			}
			return ret;
		}
	}
}
//----------------------------------------------------------------------------------
//
// CRunAccelerometer: advanced accelerometer object
//
//----------------------------------------------------------------------------------

package Extensions
{
	import Actions.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Objects.CObject;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;	

	
	public class CRunAccelerometer extends CRunExtension
	{
		// Condition identifiers
		public static var CND_ROTATE:int = 0;
		public static var CND_LAST:int = 1;
		// Expression identifiers
		public static var EXP_GETDIRECT_X:int = 0;
		public static var EXP_GETDIRECT_Y:int = 1;
		public static var EXP_GETDIRECT_Z:int = 2;
		public static var EXP_GETGRAVITY_X:int = 3;
		public static var EXP_GETGRAVITY_Y:int = 4;
		public static var EXP_GETGRAVITY_Z:int = 5;
		public static var EXP_GETINSTANT_X:int = 6;
		public static var EXP_GETINSTANT_Y:int = 7;
		public static var EXP_GETINSTANT_Z:int = 8;
		public static var EXP_GETORIENTATION:int = 9;
		public static var EXP_LAST:int = 10;
		
		
		public var MyAccel:Accelerometer;
		public var MyEvent:AccelerometerEvent;
		public var filteringFactor:Number = 0.1;
		public var accelerometerSupported:Boolean;
		public var direct:Array = [0.0,0.0,0.0];
		public var filtered:Array = [0.0,0.0,0.0];
		public var instant:Array = [0,0,0];
		public var orientation:int = 0;
		public var oldOrientation:int = 0;
		public var oldWidth:int = 0;
		public var oldHeight:int = 0;

		private var MyStage:Stage;
		
			public function CRunAccelerometer()
			{
			}
			
			public override function getNumberOfConditions():int
			{
				return CND_LAST;
			}
	
			//private final function accUpdateHandler(MyEvent:AccelerometerEvent):void
			private final function accUpdateHandler(MyEvent:AccelerometerEvent):void
			{
				direct[0] = MyEvent.accelerationX * 10.0;
				direct[1] = MyEvent.accelerationY * 10.0;
				direct[2] = MyEvent.accelerationZ * 10.0;
				
				filtered[0] = ((direct[0] * filteringFactor) + (filtered[0] * (1.0 - filteringFactor)));
				filtered[1] = ((direct[1] * filteringFactor) + (filtered[1] * (1.0 - filteringFactor)));
				filtered[2] = ((direct[2] * filteringFactor) + (filtered[2] * (1.0 - filteringFactor)));
				
				instant[0] = direct[0] - ((direct[0] * filteringFactor) + (instant[0] * (1.0 - filteringFactor)));
				instant[1] = direct[1] - ((direct[1] * filteringFactor) + (instant[1] * (1.0 - filteringFactor)));
				instant[2] = direct[2] - ((direct[2] * filteringFactor) + (instant[2] * (1.0 - filteringFactor)));
				
				if( direct[0] > 0.5 )
				{
					orientation = 1;
				}
				else if( direct[0] < -0.5 )
				{
					orientation = 0;
				}
				else if( direct[1] > 0.5 )
				{
					orientation = 3;
				}
				else if( direct[1] < -0.5 )
				{
					orientation = 2;
				}
				else if( direct[2] > 0.5 )
				{
					orientation = orientation;
				}
				else if( direct[2] < -0.5 )
				{
					orientation = orientation;
				}
				
			}
			
			public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
			{
				try {
					if (Accelerometer.isSupported)
					{
						MyAccel = new Accelerometer();
						MyAccel.addEventListener(AccelerometerEvent.UPDATE, accUpdateHandler);
					}
				}
				catch (errObject:Error)
				{
					return false;
				}
				MyStage = (ho.hoAdRunHeader.rhApp.stage);
				// listen for orientation changes and prevent unwanted ones
				return true;
			}

			public override function destroyRunObject(bFast:Boolean):void
			{
				// stop listening for the initial rotation
				MyAccel.removeEventListener(AccelerometerEvent.UPDATE, accUpdateHandler);
			}
			
			
			public override function handleRunObject():int
			{
				/*
				var oldOrientation:int = orientation;
				if((oldWidth + oldHeight) >=0)
					orientation = MyStage.stageWidth >= MyStage.stageHeight ? 3 : 0;
					*/
				if(oldOrientation != orientation)
					ho.pushEvent(CND_ROTATE, 0);
					
				oldOrientation = orientation;	
				oldWidth = MyStage.stageWidth;
				oldHeight= MyStage.stageHeight;
				return 0;	
			}						
			// Conditions
			// --------------------------------------------------
			public override function condition(num:int, cnd:CCndExtension):Boolean
			{
				switch (num)
				{
					case CND_ROTATE:
						return cndRotate(cnd);
				}
				return false;
			}
			
			public function cndRotate(cnd:CCndExtension):Boolean
			{
				return true;
			}	
	
			// Expressions
			// --------------------------------------------
			public override function expression(num:int):CValue
			{
				switch (num)
				{
					case EXP_GETDIRECT_X:
						return ValueDirect(0);
					case EXP_GETDIRECT_Y:
						return ValueDirect(1);
					case EXP_GETDIRECT_Z:
						return ValueDirect(2);
					case EXP_GETGRAVITY_X:
						return ValueGravity(0);
					case EXP_GETGRAVITY_Y:
						return ValueGravity(1);
					case EXP_GETGRAVITY_Z:
						return ValueGravity(2);
					case EXP_GETINSTANT_X:
						return ValueInstant(0);
					case EXP_GETINSTANT_Y:
						return ValueInstant(1);
					case EXP_GETINSTANT_Z:
						return ValueInstant(2);
					case EXP_GETORIENTATION:
						return ValueOrientation();
				}
				return new CValue(0);//won't be used
			}
			
			private function ValueDirect(x:int):CValue
			{
				var ret:CValue=new CValue(0);
				ret.forceDouble(direct[x]);
				return ret;
			}	
			
			private function ValueGravity(x:int):CValue
			{
				var ret:CValue=new CValue(0);
				ret.forceDouble(filtered[x]);
				return ret;
			}
			
			private function ValueInstant(x:int):CValue
			{
				var ret:CValue=new CValue(0);
				ret.forceDouble(instant[x]);
				return ret;
			}
			private function ValueOrientation():CValue
			{
				var ret:CValue=new CValue(0);
				ret.intValue = orientation;
				return ret;
			}
	
	}
}
package {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import mx.core.BitmapAsset;
	import mx.events.FlexEvent;
	import mx.preloaders.IPreloaderDisplay;
	import mx.preloaders.Preloader;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	public class CPreloader extends Sprite implements IPreloaderDisplay 
	{

		private var _progress:Shape;
		private var _preloader:Preloader;
		private var _backgroundAlpha:Number;
		private var _backgroundColor:uint;
		private var _backgroundImage:Object;
		private var _backgroundSize:String;
		private var _stageHeight:Number;
		private var _stageWidth:Number;
		private var backImage:BitmapAsset;
		private var xCenter:int;
		private var yCenter:int;
		private var radius:Number;
		private var size:Number;
		private var color:int;
		private var xImage:int;
		private var yImage:int;
		private var currentAngle:Number;
		private var colorBack:int;
		
		[Embed(source="Preloader%s")]
		private var backImageClass:Class;

		public function set preloader(value:Sprite):void
		{
			_preloader = value as Preloader;
			value.addEventListener(ProgressEvent.PROGRESS, progressEventHandler);
			value.addEventListener(FlexEvent.INIT_COMPLETE, initCompleteEventHandler);
		}

		public function set backgroundAlpha(value:Number):void
		{
			_backgroundAlpha = value;
		}
		public function get backgroundAlpha():Number
		{
			return _backgroundAlpha;
		}

		public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
		}
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}

		public function set backgroundImage(value:Object):void
		{
			_backgroundImage = value;
		}
		public function get backgroundImage():Object
		{
			return _backgroundImage;
		}

		public function set backgroundSize(value:String):void
		{
			_backgroundSize = value;
		}
		public function get backgroundSize():String
		{
			return _backgroundSize;
		}

		public function set stageHeight(value:Number):void
		{
			_stageHeight = value;
		}
		public function get stageHeight():Number
		{
			return _stageHeight;
		}

		public function set stageWidth(value:Number):void
		{
			_stageWidth = value;
		}
		public function get stageWidth():Number
		{
			return _stageWidth;
		}

		public function CPreloader()
		{
			xCenter=%i;
			yCenter=%i;
			radius=%i;
			size=%i;
			color=%i;
			colorBack=%i;
				
			currentAngle=-Math.PI/2;

			// Creates the image
			backImage=BitmapAsset(new backImageClass());	
			addChild(backImage);
			
			// Adds the progress bar
			_progress = new Shape();
			addChild(_progress);		
		}

		private function progressEventHandler(event:ProgressEvent):void
		{
			var angle:Number = event.bytesLoaded/event.bytesTotal*2*Math.PI-Math.PI/2;

			var a:Number;
			var x1:Number, y1:Number, x2:Number, y2:Number;
			if (currentAngle<angle)
			{
				for (a=currentAngle; a<=angle; a+=0.001)
				{
					x1=radius/2+Math.cos(a)*(radius-size);
					y1=radius/2-Math.sin(a)*(radius-size);
					x2=radius/2+Math.cos(a)*radius;
					y2=radius/2-Math.sin(a)*radius;	
					_progress.graphics.lineStyle(1, color, 1.0);			
					_progress.graphics.moveTo(x1, y1);
					_progress.graphics.lineTo(x2, y2);
	
					var n:Number;
					for (n=0; n<3; n++)
					{
						x1=radius/2+Math.cos(a)*(radius-size-n);
						y1=radius/2-Math.sin(a)*(radius-size-n);
						x2=radius/2+Math.cos(a)*(radius-size-n-1);
						y2=radius/2-Math.sin(a)*(radius-size-n-1);
						_progress.graphics.lineStyle(1, color, 0.6-n/5);			
						_progress.graphics.moveTo(x1, y1);
						_progress.graphics.lineTo(x2, y2);					
	
						x1=radius/2+Math.cos(a)*(radius+n);
						y1=radius/2-Math.sin(a)*(radius+n);
						x2=radius/2+Math.cos(a)*(radius+n+1);
						y2=radius/2-Math.sin(a)*(radius+n+1);
						_progress.graphics.lineStyle(1, color, 0.6-n/5);			
						_progress.graphics.moveTo(x1, y1);
						_progress.graphics.lineTo(x2, y2);					
					}				
				}
				currentAngle=angle;
			}
		}

		public function initialize():void
		{
			xImage=stage.stageWidth/2-backImage.width/2;
			yImage=stage.stageHeight/2-backImage.height/2;
			backImage.x=xImage;
			backImage.y=yImage;
			if (xCenter<0)
			{
				xCenter=stage.stageWidth/2;
			}
			if (yCenter<0)
			{
				yCenter=stage.stageHeight/2;
			}
			_progress.x=xCenter-radius/2;
			_progress.y=yCenter-radius/2;			

			graphics.clear();
			graphics.beginFill(colorBack);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
		}

		public function initCompleteEventHandler(event:FlexEvent):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}	
}
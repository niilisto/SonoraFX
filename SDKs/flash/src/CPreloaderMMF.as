package {
	import Application.*;
	import Expressions.*;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.*;
	
	import mx.core.BitmapAsset;
	import mx.events.FlexEvent;
	import mx.preloaders.IPreloaderDisplay;
	import mx.preloaders.Preloader;
	import flash.utils.ByteArray;
	import mx.core.ByteArrayAsset;
	
	public class CPreloaderMMF extends Sprite implements IPreloaderDisplay 
	{

		private var _progress:Shape;
		private var _preloader:Preloader;
		private var _backgroundAlpha:Number;
		private var _backgroundColor:uint;
		private var _backgroundImage:Object;
		private var _backgroundSize:String;
		private var _stageHeight:Number;
		private var _stageWidth:Number;
		private var ccjByteArray:ByteArrayAsset;
		private var app:CRunApp;
		
		[Embed(source="Preloader.ccf",mimeType="application/octet-stream")]
		private var ccj:Class;			

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

		public function CPreloaderMMF()
		{			
		}

		private function progressEventHandler(event:ProgressEvent):void
		{
			app.setPreloaderProgress(event.bytesTotal, event.bytesLoaded);
			app.playApplication(false);
		}

		public function initialize():void
		{
			var ccjByteArray:ByteArrayAsset = ByteArrayAsset(new ccj());
			app = new CRunApp(ccjByteArray, null, null, null);
			app.setPreloader(this);
		    app.load();
		    app.startApplication();
		}

		public function initCompleteEventHandler(event:FlexEvent):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}	
}
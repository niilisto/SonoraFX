//----------------------------------------------------------------------------------
//
// MOCHISTART : lancement de la pub MOCHI
//
//----------------------------------------------------------------------------------
package Services
{
	import Application.CRunApp;
	
	import flash.display.*;
	
	public class CMoStart
	{
		public var app:CRunApp;
		public var gameID:String;
		public var bAdAtStart:Boolean;
		public var bAdAtFrames:Array;
		public var bAdAtEnd:Boolean;
		public var resolution:String;
		public var bStopPause:Boolean;
				
		public function CMoStart(a:CRunApp)
		{
			app=a;
			resolution=app.gaCxWin.toString()+"x"+app.gaCyWin.toString();
			bAdAtFrames=new Array(app.gaNbFrames);
			var n:int;
			for (n=0; n<app.gaNbFrames; n++)
			{
				bAdAtFrames[n]=false;
			}
			bAdAtStart=false;
			bAdAtEnd=false;
			bStopPause=false;
							
			//MOCHIINSERT1
		}
		public function startIntroAd():Boolean
		{
			if (app.stage!=null)
			{
				if (bAdAtStart)
				{
					bAdAtStart=false;
					bStopPause=true;
					app.run.pause();
					hideLayers();
		            app.adClip = new MovieClip();
		            app.stage.addChild(app.adClip);
		            startAd();
			        return true;
	   			}      	
	  		}		
   			return false;
		}
		
		public function startFrameAd():Boolean
		{
			if (app.stage!=null)
			{
				if (bAdAtFrames[app.mochiFrame])
				{
					bStopPause=false;
		            app.adClip = new MovieClip();
		            app.stage.addChild(app.adClip);
		            startAd();
			        return true;
				}
			}
			return false;
		}
		
		public function startEndAd():Boolean
		{
			if (app.stage!=null)
			{
				if (bAdAtEnd)
				{
					bAdAtEnd=false;
					bStopPause=false;
		            app.adClip = new MovieClip();
		            app.stage.addChild(app.adClip);
		            startAd();
			        return true;
	   			}
	  		}      			
   			return false;
		}

		public function hideLayers():void
		{
			var n:int;
			for (n=0; n<app.frame.nLayers; n++)
			{
				app.frame.layers[n].hide();
			}
			app.planeControls.visible=false;
		}
		
		// Detection de la fin de la pub
		public function ad_finished():void
		{
		    app.stage.removeChild(app.adClip);
		    app.adClip = null;
		    
		    if (bStopPause)
		    {
				var n:int;
				for (n=0; n<app.frame.nLayers; n++)
				{
					app.frame.layers[n].show();
				}
				app.planeControls.visible=true;
			    app.run.resume();
		    }
		}

		public function startAd():void
		{
             //MOCHIINSERT2 MochiAd.showInterLevelAd({clip: app.adClip, id: gameID , res: resolution, ad_finished: ad_finished});
		}
		
	}
}
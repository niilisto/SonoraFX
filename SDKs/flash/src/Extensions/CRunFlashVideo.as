//----------------------------------------------------------------------------------
//
// CRUNFLASHVIDEO : video dans Flash
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.*;
	
	public class CRunFlashVideo extends CRunExtension
	{
		private var FLAG_RESIZETOVIDEO:int=0x0001;
		private var FLAG_PAUSEATSTART:int=0x0002;
		private var FLAG_LOOPING:int=0x0004;
		
		private var CND_ONERROR:int=0;
		private var CND_ISPLAYING:int=1;
		
		private var ACT_PAUSE:int=0;
		private var ACT_RESUME:int=1;
		private var ACT_SEEKTO:int=2;
		private var ACT_URL:int=3;
		private var ACT_SETWIDTH:int=4;
		private var ACT_SETHEIGHT:int=5;
		private var ACT_PLAY:int=6;
		private var ACT_SETVOLUME:int=7;
		private var ACT_SETLOOPING:int=8;
				
		private var EXP_WIDTH:int=0;
		private var EXP_HEIGHT:int=1;
		private var EXP_ORIGINALWIDTH:int=2;
		private var EXP_ORIGINALHEIGHT:int=3;
		private var EXP_FRAMERATE:int=4;
		private var EXP_URL:int=5;
		private var EXP_GETVOLUME:int=6;
		private var EXP_GETTIME:int=7;
		private var EXP_GETTOTALLENGTH:int=8;
		private var EXP_GETLOADEDLENGTH:int=9;
		private var EXP_GETVIDEOLENGTH:int=10;
				
		private var flags:int;
		private var url:String;
		private var video:Video;
		private var stream:NetStream;
		private var connection:NetConnection;
		private var plane:Sprite;
		private var bError:Boolean;
		private var bConnected:Boolean;
		private var bToConnect:Boolean;
		private var bPlaying:Boolean;
		private var frameRate:int;
		private var bToPause:Boolean;
		private var originalWidth:int;
		private var originalHeight:int;
		private var volume:int;		
		private var duration:int;
		private var oldBPlaying:Boolean;
		private var looping:int;
		
		public function CRunFlashVideo()
		{
			video=null;
			stream=null;
			connection=null;
		}
		
	    public override function getNumberOfConditions():int
	    {
	        return 2;
	    }

	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	        ho.hoImgWidth = file.readInt();
	        ho.hoImgHeight = file.readInt();
	        flags = file.readInt();
	        url=file.readString();
	    	bError=false;
	    	bConnected=false;
	    		
			plane=rh.rhFrame.layers[ho.hoLayer].planeSprites;
			video=new Video();
			plane.addChild(video);
			video.x=ho.hoX-ho.hoAdRunHeader.rhWindowX;
			video.y=ho.hoY-ho.hoAdRunHeader.rhWindowY;
			video.width=ho.hoImgWidth;
			video.height=ho.hoImgHeight;
			if ((ho.ros.rsFlags&CRSpr.RSFLAG_HIDDEN)!=0)
			{
				video.visible=false;
			}
		
			connection=new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection.connect(null);
		
			looping=0;
			if ((flags&FLAG_LOOPING)!=0)
			{
				looping=-1;	
			}
			oldBPlaying=false;	
			bPlaying=false;
			bToConnect=false;
			bToPause=false;
			volume=100;
			duration=0;
			if (url.length>0)
			{
				bToConnect=true;
			}
	        return false;
	    }

		private function netStatusHandler(event:NetStatusEvent):void 
		{
            switch (event.info.code) 
            {
                case "NetConnection.Connect.Success":
					var nsClient:Object = {};
                	nsClient.onMetaData = ns_onMetaData;
                	nsClient.onCuePoint = ns_onCuePoint;
	            	stream=new NetStream(connection);
	            	stream.client=nsClient;
	            	stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
	            	stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
	            	video.attachNetStream(stream);
                    bConnected=true;
                    break;
                case "NetStream.Play.StreamNotFound":
                	bError=true;
		            bPlaying=false;
                    break;
                case "NetStream.Play.Stop":
                	bPlaying=false;
                	break;
                case "NetStream.Play.Start":
                	bPlaying=true;
                	break;
            }
        }
		private function connectStream():void 
		{
        }
		private function securityErrorHandler(event:SecurityErrorEvent):void 
		{
            bError=true;
            bPlaying=false;
        }
        private function asyncErrorHandler(event:AsyncErrorEvent):void 
        {
			bError=true;
            bPlaying=false;
        }

		public override function destroyRunObject(bFlag:Boolean):void
		{
			if (connection!=null)
			{
				connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            	connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
   			}
   			if (stream!=null)
   			{
            	stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            	stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
            	stream.close();
   			}
			if (video!=null)
			{
				video.clear();
				plane.removeChild(video);
			}
		}
		public override function handleRunObject():int
		{
			if (bPlaying)
			{
				if (bToPause)
				{
					bToPause=false;
					stream.pause();
				}
				oldBPlaying=true;
			}
			else if (oldBPlaying)
			{
				oldBPlaying=false;
				if (looping!=0)
				{
					looping--;
					if (looping!=0)
					{				
						bToConnect=true;
					}
				}
			}
			if (bToConnect)
			{
				if (bConnected)
				{
					bError=false;
					bToPause=false;
					try 
					{
           				stream.play(url);
     				}
					catch (error:Error) 
					{
						bError=true;
					}
	       			if ((flags&FLAG_PAUSEATSTART)!=0)
           			{
           				bToPause=true;
            		}
            		flags&=~FLAG_PAUSEATSTART;
            		bToConnect=false;
				}
			}
			return 0;
		}
		private function ns_onMetaData(item:Object):void 
		{
			// Resize Video object to same size as meta data.
			originalWidth=item.width;
			originalHeight=item.height;
			duration=item.duration*1000;
			if ((flags&FLAG_RESIZETOVIDEO)!=0)
			{
                video.width = item.width;
                video.height = item.height;
                ho.hoImgWidth=item.width;
                ho.hoImgHeight=item.height;
   			}
            frameRate=item.framerate;
		}
		private function ns_onCuePoint(item:Object):void 
		{
		}
		public override function displayRunObject():void
		{
			video.x=ho.hoX-ho.hoAdRunHeader.rhWindowX;
			video.y=ho.hoY-ho.hoAdRunHeader.rhWindowY;
		}

		public override function showSprite():void
		{
			video.visible=true;
		}
		
		public override function hideSprite():void
		{			
			video.visible=false;
		}
		
		public override function getChildIndex():int
		{	
			return plane.getChildIndex(video);
		}
		
		public override function getChildMaxIndex():int
		{
			return plane.numChildren;
		}
		
		public override function setChildIndex(index:int):void
		{
			if (index>=plane.numChildren)
			{
				index=plane.numChildren-1;
				if (index<0)
				{
					index=0;
				}
			}
			plane.setChildIndex(video, index);
		}

		public override function pauseRunObject():void
		{
			if (bPlaying)
			{
				stream.pause();
			}
		}
		
		public override function continueRunObject():void
		{
			if (bPlaying)
			{
				stream.resume();
			}
		}

	    // Conditions
	    // --------------------------------------------------
	    public override function condition(num:int, cnd:CCndExtension):Boolean
	    {
	        switch (num)
	        {
	        	case CND_ONERROR:
	        		return bError;
	        	case CND_ISPLAYING:
	        		return bPlaying;
	        }
	        return false;
	    }
	    
	     // Actions
	    // -------------------------------------------------
	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
	            case ACT_PAUSE:
	            	actPause(act);
	            	break;
	            case ACT_RESUME:
	            	actResume(act);
	            	break;
	            case ACT_SEEKTO:
	            	actSeekTo(act);
	            	break;
	            case ACT_URL:
	            	actURL(act);
	            	break;
	            case ACT_SETWIDTH:
	            	actSetWidth(act);
	            	break;
	            case ACT_SETHEIGHT:
	            	actSetHeight(act);
	            	break;	            	
	            case ACT_PLAY:
	            	actPlay(act);
	            	break;	            	
	            case ACT_SETVOLUME:
	            	actSetVolume(act);
	            	break;	            	
	            case ACT_SETLOOPING:
	            	actSetLooping(act);
	            	break;	            	
	        }
	    }

		private function actPause(act:CActExtension):void
		{
			if (bPlaying)
			{
				stream.pause();
			}
		}
		private function actResume(act:CActExtension):void
		{
			if (bPlaying)
			{
				stream.resume();
			}
		}
		private function actSeekTo(act:CActExtension):void
		{
			if (bPlaying)
			{
				var s:Number=act.getParamExpression(rh, 0 );
				stream.seek(s);
			}
		}
		private function actURL(act:CActExtension):void
		{
			var s:String=act.getParamExpString(rh, 0);
			if (s.length>0)
			{
				url=s;
				bPlaying=false;
				bToConnect=true;
				flags&=~FLAG_PAUSEATSTART;
			}
		}
		private function actPlay(act:CActExtension):void
		{
			if (bPlaying)
			{
				stream.seek(0);				
			}
			else if (url.length>0)
			{
				bToConnect=true;
				flags&=~FLAG_PAUSEATSTART;
			}
		}
		private function actSetWidth(act:CActExtension):void
		{
			var w:int=act.getParamExpression(rh, 0);
			if (w>0)
			{
				video.width=w;
				ho.hoImgWidth=w;
			}
		}
		private function actSetHeight(act:CActExtension):void
		{
			var h:int=act.getParamExpression(rh, 0);
			if (h>0)
			{
				video.height=h;
				ho.hoImgHeight=h;
			}
		}
		private function actSetVolume(act:CActExtension):void
		{
			var h:int=act.getParamExpression(rh, 0);
			if (h>=0 && h<=100)
			{
				if (bPlaying)
				{
					volume=h;
					var st:SoundTransform=stream.soundTransform;					
					st.volume=Number(h)/100.0;
					stream.soundTransform=st;
				}
			}
		}
		private function actSetLooping(act:CActExtension):void
		{
			var l:int=act.getParamExpression(rh, 0);
			looping=l;
		}

		// EXPRESSIONS
		// -------------------------------------------------------------------------
	    public override function expression(num:int):CValue
	    {
	        switch (num)
	        {
	            case EXP_WIDTH:
	            	return new CValue(ho.hoImgWidth);
	            case EXP_HEIGHT:
	            	return new CValue(ho.hoImgHeight);
	            case EXP_ORIGINALWIDTH:
	            	return new CValue(originalWidth);
	            case EXP_ORIGINALHEIGHT:
	            	return new CValue(originalHeight);
	            case EXP_FRAMERATE:
	            	return new CValue(frameRate);
	            case EXP_URL:
	            	var ret:CValue=new CValue(0);
	            	ret.forceString(url);
	            	return ret;
	            case EXP_GETVOLUME:
	            	return new CValue(volume);
	            case EXP_GETTIME:
	            	return expGetTime();
	            case EXP_GETTOTALLENGTH:
	            	return expGetTotalLength();
	            case EXP_GETLOADEDLENGTH:
	            	return expGetLoadedLength();
	            case EXP_GETVIDEOLENGTH:
	            	return expGetVideoLength();
	        }
	        return null;
	    }
		private function expGetTime():CValue
		{
			var ret:CValue=new CValue(0);
			if (bPlaying)
			{
				ret.forceInt(stream.time*1000);
			}
			return ret;
		}
		private function expGetTotalLength():CValue
		{
			var ret:CValue=new CValue(0);
			if (bPlaying)
			{
				ret.forceInt(stream.bytesTotal/1024);
			}
			return ret;
		}
		private function expGetLoadedLength():CValue
		{
			var ret:CValue=new CValue(0);
			if (bPlaying)
			{
				ret.forceInt(stream.bytesLoaded/1024);
			}
			return ret;
		}
		private function expGetVideoLength():CValue
		{
			var ret:CValue=new CValue(0);
			if (bPlaying)
			{
				ret.forceInt(duration);
			}
			return ret;
		}
	}
}
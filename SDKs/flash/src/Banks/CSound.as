//----------------------------------------------------------------------------------
//
// CSOUND : un son
//
//----------------------------------------------------------------------------------
package Banks
{
	import Application.CRunApp;
	
	import Services.*;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class CSound
	{
		public var app:CRunApp;
		public var handle:int;
		public var sound:Sound;
		public var useCount:int;
		public var bLocked:Boolean=false;
		public var soundPosition:Number;
		public var soundChannel:SoundChannel;
		public var nLoops:int;
		public var volume:Number;
		public var pan:Number;
		public var numSound:int;
		public var name:String;
		public var bPaused:Boolean;
				
		public function CSound(a:CRunApp)
		{
			app=a;
			sound=null;
		}
	    public function loadHandle(file:CFile):void
	    {
			handle=file.readAShort();
			var l:int=file.readAShort();
			if (file.bUnicode==false)
			{ 
				file.skipBytes(l);
			}
			else
			{
				file.skipBytes(l*2);
			}
	    }
		public function load(num:int, file:CFile, fileOffset:uint):void
		{
			if (sound==null)
			{
				file.seek(fileOffset);
				handle=file.readAShort();
				var l:int=file.readAShort();
				name=file.readAStringSize(l);
				
				numSound=num;
				var appli:CRunApp=app;
				while(appli.parentApp!=null)
				{
					appli=appli.parentApp;
				}
				sound=new appli.sounds[num]() as Sound;
			}			
		}
		public function duplicate():CSound
		{
			var newSound:CSound=new CSound(app);
			var appli:CRunApp=app;
			while(appli.parentApp!=null)
			{
				appli=appli.parentApp;
			}
			newSound.sound=new appli.sounds[numSound]() as Sound;
			newSound.handle=handle;
			newSound.name=name;
			return newSound;
		}
		public function play(nl:int, bPrio:Boolean, v:Number, p:Number):void
		{
			nLoops=nl;
			if (nLoops==0)
			{
				nLoops=1000000;
			}
			if (soundChannel!=null)
			{
				soundChannel.stop();
			}
			volume=v;
			pan=p;
			soundChannel=sound.play(0, nLoops);
			soundChannel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
			var soundTransform:SoundTransform=soundChannel.soundTransform;
			soundTransform.pan=pan;
			soundTransform.volume=volume;
			soundChannel.soundTransform=soundTransform;
			soundPosition=-1;
			bLocked=bPrio;
			bPaused=false;
		}
		public function startAgain(nl:int, bPrio:Boolean):void
		{
			if (soundChannel!=null)
			{
				soundPosition=0;
				soundChannel.stop();
				soundPosition=-1;
			}
			nLoops=nl;
			bLocked=bPrio;
			soundChannel=sound.play(0, nl);
			var soundTransform:SoundTransform=soundChannel.soundTransform;
			soundTransform.pan=pan;
			soundTransform.volume=volume;
			soundChannel.soundTransform=soundTransform;
			soundChannel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
			bPaused=false;
		}
		public function startPosition(pos:Number):void
		{
			if (pos<sound.length)
			{
				if (soundChannel!=null)
				{
					soundPosition=0;
					soundChannel.stop();
					soundPosition=-1;
				}
				soundChannel=sound.play(pos, nLoops);
				var soundTransform:SoundTransform=soundChannel.soundTransform;
				soundTransform.pan=pan;
				soundTransform.volume=volume;
				soundChannel.soundTransform=soundTransform;
				soundChannel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
				bPaused=false;
			}
		} 
		public function setPan(p:Number):void
		{
			pan=p;
			if (soundChannel!=null)
			{
				var soundTransform:SoundTransform=soundChannel.soundTransform;
				if (soundTransform!=null)
				{
					soundTransform.pan=p;
					soundChannel.soundTransform=soundTransform;
				}
			}
		}
		public function getPan():Number
		{
			return pan;
		}
		public function setVolume(v:Number):void
		{
			volume=v;
			if (soundChannel!=null)
			{
				var soundTransform:SoundTransform=soundChannel.soundTransform;
				if (soundTransform!=null)
				{		
					soundTransform.volume=v;
					soundChannel.soundTransform=soundTransform;
				}
			}
		}
		public function getVolume():Number
		{
			return volume;
		}
		public function stop():void
		{
			if (soundChannel!=null)
			{
				soundChannel.stop();
				app.soundPlayer.soundComplete(this);
				soundChannel=null;
				soundPosition=-1;
			}
		}
		public function pause():void
		{
			if (soundChannel!=null)
			{
				soundPosition=soundChannel.position;
				soundChannel.stop();
				soundChannel=null;
				bPaused=true;
			}
		}
		public function getPosition():Number
		{
			if (soundChannel!=null)
			{
				return soundChannel.position%sound.length;
			}
			return 0;			
		}
		public function getLength():Number
		{
			return sound.length;
		}
		public function resume():void
		{
			if (soundChannel==null && soundPosition!=-1)
			{
				if (nLoops>1)
				{
					soundPosition=0;
				}
				soundChannel=sound.play(soundPosition, nLoops, null);
				soundChannel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
				var soundTransform:SoundTransform=soundChannel.soundTransform;
				soundTransform.pan=pan;
				soundTransform.volume=volume;
				soundChannel.soundTransform=soundTransform;
				soundPosition=-1;
				bPaused=false;
			}
		}
		public function isPlaying():Boolean
		{
			if (bPaused)
			{
				return true;
			}
			if (soundChannel!=null)
			{
				return true;
			}
			return false; 
		}
		public function isPaused():Boolean
		{
			return bPaused;
		}
		public function soundComplete(e:Event):void
		{
			soundChannel=null;
			if (soundPosition==-1)
			{
				app.soundPlayer.soundComplete(this);
			}	
		}
	}
}
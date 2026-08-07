//----------------------------------------------------------------------------------
//
// CSOUNDPLAYER : synthetiseur MIDI
//
//----------------------------------------------------------------------------------
package Application
{
	
	import Banks.*;
	
	public class CSoundPlayer 
	{
	    public static var nChannels:int=32;
	    
	    public var app:CRunApp;
	    public var bMultipleSounds:Boolean=false;
	    public var bOn:Boolean=true;
	    public var nChannels:int = 32;
	    public var sounds:Array;
	    public var volumes:Array;
	    public var pans:Array;
	    public var bLocked:Array;
		public var mainVolume:Number;
		public var mainPan:Number;
			    
	    public function CSoundPlayer(a:CRunApp) 
	    {
	    	app=a;
	    	sounds=new Array(nChannels);
        	volumes=new Array(nChannels);
        	pans=new Array(nChannels);
        	bLocked=new Array(nChannels);
	        var n:int;
        	for (n=0; n<nChannels; n++)
        	{
            	sounds[n] = null;
            	volumes[n]=1.0;
            	pans[n]=0.0;
            	bLocked[n]=false;
        	}
        	mainVolume=1.0;
        	mainPan=0.0;
	    }
	    public function setMultipleSounds(bMultiple:Boolean):void
	    {
			bMultipleSounds=bMultiple;
	    }	    
	    public function play(handle:int, nLoops:int, channel:int, bPrio:Boolean):void
	    {	    	
	        if (bOn == false)
	        {
	            return;
	        }	        
        	var sound:CSound = app.soundBank.getSoundFromHandle(handle);
        	if (sound==null)
        	{
        		return;
        	}
        	
            var n:int;
	        if (bMultipleSounds)
	        {
	            if (channel < 0)
	            {
	                for (n = 0; n < nChannels; n++)
	                {
	                    if (sounds[n] == sound)
	                    {
	                    	sound=sounds[n].duplicate();
	                    	break;
	                    }
	                }
                    for (n = 0; n < nChannels; n++)
                    {
                    	if (sounds[n]==null && bLocked[n]==false)
                    	{
                    		break;	                    		
                    	}
                    }
                    if (n==nChannels)
                    {
                    	for (n=0; n<nChannels; n++)
                    	{
                    		if (bLocked[n]==false && sounds[n]!=null && sounds[n].bLocked==false)
                    		{
                    			break;
                    		}
                    	}
                    	if (n==nChannels)
                    	{
                    		return;
                    	}
	                }
                	channel=n;
	            }
	            else
	            {
	            	if (sounds[channel]!=null && sounds[channel].bLocked==true)
	            	{
	            		return;
	            	}
	            	if (sounds[channel]!=sound)
	            	{
		                for (n = 0; n < nChannels; n++)
		                {
		                	if (sounds[n]==sound)
		                	{
		                		sound=sounds[n].duplicate();
		                	}
		                }
		            }
	            }
	        }
	        else
	        {
	            if (sounds[0] != null)
	            {
	            	if (sounds[0].bLocked)
	            	{
	            		return;
	            	}
	            	if (sounds[0]==sound)
	            	{
		                sounds[0].startAgain(nLoops, bPrio);
		                return;
		            }	            		
	                channel=0;
	            }
	            else
	            {
	                channel = 0;
	            }
	        }
        	if (channel < 0 || channel >= nChannels)
        	{
            	return;
        	}
        	if (sounds[channel] != null)
        	{
            	sounds[channel].stop();
        	}
        	sounds[channel]=sound;
        	sounds[channel].play(nLoops, bPrio, volumes[channel], pans[channel]);
	    }
	    public function keepCurrentSounds():void
	    {	    	
	        var n:int;
	        for (n = 0; n < nChannels; n++)
	        {
	            if (sounds[n] != null)
	            {
	                if (sounds[n].isPlaying())
	                {
	                    app.soundBank.setToLoad(sounds[n].handle);
	                }
	            }
	        }
	    }
	    public function setOnOff(bState:Boolean):void
	    {
			if (bState!=bOn)
			{
			    bOn=bState;
			    if (bOn==false)
			    {
					stopAllSounds();
			    }
			}
	    }
	    public function getOnOff():Boolean
	    {
			return bOn;
	    }    
	    public function stopAllSounds():void
	    {
	        var n:int;
	        for (n = 0; n < nChannels; n++)
	        {
	            if (sounds[n] != null)
	            {
	                sounds[n].stop();
	            }
	        }
	    }
	    public function stop(handle:int):void
	    {
	        var n:int;
	        for (n = 0; n < nChannels; n++)
	        {
	            if (sounds[n] != null)
	            {
	                if (sounds[n].handle == handle)
	                {
	                    sounds[n].stop();
	                }
	            }
        	}
	    }
	    public function pauseHandle(handle:int):void
	    {
	        var n:int;
	        for (n = 0; n < nChannels; n++)
	        {
	            if (sounds[n] != null)
	            {
	                if (sounds[n].handle == handle)
	                {
	                    sounds[n].pause();
	                }
	            }
	        }
	    }
	    public function resumeHandle(handle:int):void
	    {
	        var n:int;
	        for (n = 0; n < nChannels; n++)
	        {
	            if (sounds[n] != null)
	            {
	                if (sounds[n].handle == handle)
	                {
	                    sounds[n].resume();
	                }
	            }
	        }
	    }
	    public function pause():void
	    {
	        var n:int;
	        for (n = 0; n < nChannels; n++)
	        {
	            if (sounds[n] != null)
	            {
                    sounds[n].pause();
	            }
	        }
	    }
	    public function resume():void
	    {
	        var n:int;
	        for (n = 0; n < nChannels; n++)
	        {
	            if (sounds[n] != null)
	            {
                    sounds[n].resume();
	            }
	        }
	    }	
	    public function pauseChannel(channel:int):void
	    {
	        if (channel >= 0 && channel < nChannels)
	        {
	            if (sounds[channel] != null)
	            {
	                sounds[channel].pause();
	            }
	        }
	    }
	    public function resumeChannel(channel:int):void
	    {
	        if (channel >= 0 && channel < nChannels)
	        {
	            if (sounds[channel] != null)
	            {
	                sounds[channel].resume();
	            }
	        }
	    }
	    public function stopChannel(channel:int):void
	    {
	        if (channel >= 0 && channel < nChannels)
	        {
	            if (sounds[channel] != null)
	            {
	                sounds[channel].stop();
	            }
	        }
	    }
	    public function lockChannel(channel:int):void
	    {
	        if (channel >= 0 && channel < nChannels)
	        {
		        bLocked[channel] = true;
	        }
	    }
	    public function unlockChannel(channel:int):void
	    {
	        if (channel >= 0 && channel < nChannels)
	        {
	        	bLocked[channel]=false;
	        }
	    }
	    public function setChannelPan(channel:int, p:Number):void
	    {
	        if (channel >= 0 && channel < nChannels)
	        {
	        	pans[channel]=p;
	            if (sounds[channel] != null)
	            {	            	
	                sounds[channel].setPan(p);
	            }
	        }
	    }
	    public function getChannelPan(channel:int):Number
	    {
	        if (channel >= 0 && channel < nChannels)
	        {
	        	return pans[channel];
	        }
	        return 0;
	    }
	    public function setChannelPos(channel:int, p:Number):void
	    {
	        if (channel >= 0 && channel < nChannels)
	        {
	            if (sounds[channel] != null)
	            {	            	
	                sounds[channel].startPosition(p);
	            }
	        }
	    }
	    public function getChannelPos(channel:int):Number
	    {
	        if (channel >= 0 && channel < nChannels)
	        {
	            if (sounds[channel] != null)
	            {	            	
	                return sounds[channel].getPosition();
	            }
	        }
	        return 0;
	    }
	    public function getChannelDur(channel:int):Number
	    {
	        if (channel >= 0 && channel < nChannels)
	        {
	            if (sounds[channel] != null)
	            {	            	
	                return sounds[channel].getLength();
	            }
	        }
	        return 0;
	    }
	    public function getChannel(name:String):int
	    {
	    	var n:int;
	    	for (n=0; n<nChannels; n++)
	    	{
	    		if (sounds[n]!=null)
	    		{
	    			if (sounds[n].name==name)
	    			{
	    				return n;
	    			}
	    		}
	    	}	
	    	return -1;
	    }
	    public function getSamplePosition(name:String):Number
	    {
	    	var channel:int=getChannel(name);
	    	if (channel>=0)
	    	{
                return sounds[channel].getPosition();
	        }
	        return 0;
	    }
	    public function getSampleVolume(name:String):Number
	    {
	    	var channel:int=getChannel(name);
	    	if (channel>=0)
	    	{
                return sounds[channel].getVolume();
	        }
	        return 0;
	    }
	    public function getSampleDur(name:String):Number
	    {
	    	var channel:int=getChannel(name);
	    	if (channel>=0)
	    	{
                return sounds[channel].getLength();
	        }
	        return 0;
	    }
	    public function getSamplePan(name:String):Number
	    {
	    	var channel:int=getChannel(name);
	    	if (channel>=0)
	    	{
                return sounds[channel].getPan();
	        }
	        return 0;
	    }
	    public function setChannelVolume(channel:int, v:Number):void
	    {
	        if (channel >= 0 && channel < nChannels)
	        {
	        	volumes[channel]=v;
	            if (sounds[channel] != null)
	            {	            	
	                sounds[channel].setVolume(v);
	            }
	        }
	    }
	    public function getChannelVolume(channel:int):Number
	    {
	        if (channel >= 0 && channel < nChannels)
	        {
	        	return volumes[channel];
	        }
	        return 1.0;
	    }
	    public function isSoundPlaying():Boolean
	    {
	        var n:int;
	        for (n = 0; n < nChannels; n++)
	        {
	            if (sounds[n] != null)
	            {
                    return sounds[n].isPlaying();
	            }
	        }
	        return false;
	    }	
	    public function isChannelPlaying(channel:int):Boolean
	    {
	        if (channel >= 0 && channel < nChannels)
	        {
	            if (sounds[channel] != null)
	            {
                    return sounds[channel].isPlaying();
	            }
	        }
	        return false;
	    }
	    public function isChannelPaused(channel:int):Boolean
	    {
	        if (channel >= 0 && channel < nChannels)
	        {
	            if (sounds[channel] != null)
	            {
	                return sounds[channel].isPaused();
	            }
	        }
	        return false;
	    }
	    public function isSamplePlaying(handle:int):Boolean
	    {
	        var n:int;
	        for (n = 0; n < nChannels; n++)
	        {
	            if (sounds[n] != null)
	            {
	                if (sounds[n].handle == handle)
	                {
	                    return sounds[n].isPlaying();
	                }
	            }
	        }
	        return false;
	    }	
	    public function isSamplePaused(handle:int):Boolean
	    {
	        var n:int;
	        for (n = 0; n < nChannels; n++)
	        {
	            if (sounds[n] != null)
	            {
	                if (sounds[n].handle == handle)
	                {
	                    return sounds[n].isPaused();
	                }
	            }
	        }
	        return false;
	    }	
	    public function setSamplePan(handle:int, p:Number):void
	    {
	        var n:int;
	        for (n = 0; n < nChannels; n++)
	        {
	            if (sounds[n] != null)
	            {
	                if (sounds[n].handle == handle)
	                {
	                	sounds[n].setPan(p);
	                }
	            }
	        }
	    }	
	    public function setSampleVolume(handle:int, v:Number):void
	    {
	        var n:int;
	        for (n = 0; n < nChannels; n++)
	        {
	            if (sounds[n] != null)
	            {
	                if (sounds[n].handle == handle)
	                {
	                	sounds[n].setVolume(v);
	                }
	            }
	        }
	    }	
	    public function setSamplePos(handle:int, p:Number):void
	    {
	        var n:int;
	        for (n = 0; n < nChannels; n++)
	        {
	            if (sounds[n] != null)
	            {
	                if (sounds[n].handle == handle)
	                {
	                	sounds[n].startPosition(p);
	                }
	            }
	        }
	    }	
	    public function setMainPan(p:Number):void
	    {
	        var n:int;
	        mainPan=p;
	        for (n = 0; n < nChannels; n++)
	        {
	        	pans[n]=p;
	            if (sounds[n] != null)
	            {
                	sounds[n].setPan(p);
	            }
	        }
	    }
	    public function getMainPan():Number
	    {
	    	return mainPan;
	    }
	    public function setMainVolume(v:Number):void
	    {
	        var n:int;
	        mainVolume=v;
	        for (n = 0; n < nChannels; n++)
	        {
	        	volumes[n]=v;
	            if (sounds[n] != null)
	            {
                	sounds[n].setVolume(v);
	            }
	        }
	    }
	    public function getMainVolume():Number
	    {
	    	return mainVolume;
	    }
	    public function soundComplete(sound:CSound):void	    
	    {
	    	var n:int;
	    	for (n=0; n<nChannels; n++)
	    	{
	    		if (sounds[n]==sound)
	    		{
	    			sounds[n]=null;
	    			break;
	    		}
	    	}	    	
	    }	    
	}
}
package Extensions
{
    import Actions.*;
    import Conditions.*;
    import Expressions.*;
    import RunLoop.*;
    import Services.*;
    import flash.utils.getTimer;
    
    public class CRunSonoraFX extends CRunExtension
    {
        // --- CONDITIONS ---
        public static const CND_ON_PLAY:int = 0;
        public static const CND_ON_STOP:int = 1;
        public static const CND_ON_PAUSE:int = 2;
        public static const CND_ON_RESUME:int = 3;
        public static const CND_ON_SET_VOLUME:int = 4;
        public static const CND_ON_SET_FREQUENCY:int = 5;
        public static const CND_ON_SET_POSITION:int = 6;
        public static const CND_ON_SET_PAN:int = 7;
        public static const CND_IS_PLAYING:int = 8;
        public static const CND_IS_PAUSED:int = 9;
        public static const CND_IS_STOPPED:int = 10;
        public static const CND_ON_FADE_COMPLETE:int = 11;
        public static const CND_ON_ANY_PLAY:int = 12;
        public static const CND_ON_ANY_STOP:int = 13;
        public static const CND_ON_ANY_PAUSE:int = 14;
        public static const CND_ON_ANY_RESUME:int = 15;
        public static const CND_ON_ANY_SET_VOLUME:int = 16;
        public static const CND_ON_ANY_SET_FREQUENCY:int = 17;
        public static const CND_ON_ANY_SET_POSITION:int = 18;
        public static const CND_ON_ANY_SET_PAN:int = 19;
        public static const CND_ON_ANY_FADE_COMPLETE:int = 20;
        public static const CND_LAST:int = 21;

        // --- ACTIONS ---
        public static const ACT_PLAYAUDIO:int = 0;
        public static const ACT_STOPAUDIO:int = 1;
        public static const ACT_PAUSEAUDIO:int = 2;
        public static const ACT_RESUMEAUDIO:int = 3;
        public static const ACT_QUEUEAUDIO:int = 4;
        public static const ACT_SETVOLUME:int = 5;
        public static const ACT_SETFREQUENCY:int = 6;
        public static const ACT_SETPAN:int = 7;
        public static const ACT_ENABLETREMOLO:int = 8;
        public static const ACT_FADECHANNEL:int = 9;
        public static const ACT_ENQUEUETRACK:int = 10;
        public static const ACT_CLEARQUEUE:int = 11;
        public static const ACT_ENABLEVOLUMELFO:int = 12;
        public static const ACT_SETADSR:int = 13;
        public static const ACT_RANDOMIZEPITCH:int = 14;
        public static const ACT_CROSSFADE:int = 15;
        public static const ACT_SETORIGINFREQUENCY:int = 16;
        public static const ACT_STOPALLCHANNELS:int = 17;
        public static const ACT_PAUSEALLCHANNELS:int = 18;
        public static const ACT_RESUMEALLCHANNELS:int = 19;
        public static const ACT_SETALLVOLUMES:int = 20;
        public static const ACT_SETALLFREQUENCYSWEEPS:int = 21;
        public static const ACT_SETALLPANNING:int = 22;
        public static const ACT_ENABLEALLTREMOLOS:int = 23;
        public static const ACT_FADEALLCHANNELS:int = 24;
        public static const ACT_ENABLEALLVOLUMELFOS:int = 25;
        public static const ACT_SETALLADSRENVELOPES:int = 26;
        public static const ACT_RANDOMIZEALLPITCHES:int = 27;
        public static const ACT_SETALLORIGINFREQUENCIES:int = 28;
        public static const ACT_SETCHANNELSTOPPED:int = 29;

        // --- EXPRESSIONS ---
        public static const EXP_GETPLAYSOUNDNAME:int = 0;
        public static const EXP_GETPLAYLOOPS:int = 1;
        public static const EXP_GETVOLUME:int = 2;
        public static const EXP_GETFREQUENCY:int = 3;
        public static const EXP_GETPOSITION:int = 4;
        public static const EXP_GETPAN:int = 5;
        public static const EXP_GETTRIGGEREDCHANNEL:int = 6;
        public static const EXP_GETTRIGGEREDNAME:int = 7;
        public static const EXP_GETTRIGGEREDVOLUME:int = 8;
        public static const EXP_GETTRIGGEREDFREQUENCY:int = 9;
        public static const EXP_GETTRIGGEREDPAN:int = 10;
        public static const EXP_GETTRIGGEREDPOSITION:int = 11;
        public static const EXP_GETTRIGGEREDLOOPS:int = 12;
        public static const EXP_GETPLAYSTATE:int = 13;
        public static const EXP_GETCUSTOMTIMER:int = 14;
        public static const EXP_GETFREQORIGIN:int = 15;
        public static const EXP_GETTRIGGEREDFREQORIGIN:int = 16;
        public static const EXP_GETFREQORIGINPCT:int = 17;

        private var channels:Array;
        private var customTimer:Number = 0.0;
        private var lastTime:int = 0;

        public var triggeredChannel:int = -1;
        public var triggeredName:String = "";
        public var triggeredLoop:int = 0;
        public var triggeredVolume:Number = 100.0;
        public var triggeredFrequency:Number = 44100.0;
        public var triggeredPosition:int = 0;
        public var triggeredPan:Number = 0.0;

        public function CRunSonoraFX()
        {
        }

        override public function getNumberOfConditions():int
        {
            return CND_LAST;
        }

        override public function createRunObject(file:CFile, cob:CCreateObjectInfo, version:int):Boolean
        {
            channels = new Array(48);
            for (var i:int = 0; i < 48; i++) {
                channels[i] = new ChannelStateAS(i + 1);
            }
            lastTime = getTimer();
            return false;
        }

        private function getChannel(id:int):ChannelStateAS {
            if (id < 1 || id > 48) return null;
            return channels[id - 1];
        }

        override public function handleRunObject():int
        {
            var currentTime:int = getTimer();
            var deltaTime:Number = (currentTime - lastTime) / 1000.0;
            lastTime = currentTime;
            customTimer += deltaTime;

            for (var i:int = 0; i < 48; i++) {
                var ch:ChannelStateAS = channels[i];

                if (ch.playingState == 1 && ch.autoReleaseTimer > 0.0) {
                    ch.autoReleaseTimer -= deltaTime;
                    if (ch.autoReleaseTimer <= 0.0) {
                        ch.autoReleaseTimer = 0.0;
                        ch.playingState = 3;
                    }
                }

                // 1. Fade Mode
                if (ch.fadeState != 0) {
                    ch.volume += ch.fadeState * ch.fadeSpeed;
                    if (ch.fadeState == 1) {
                        if (ch.volume >= ch.volOrigin) {
                            ch.volume = ch.volOrigin;
                            ch.fadeState = 0;
                            ch.triggerFadeComplete = true;
                        }
                    } else if (ch.fadeState == -1) {
                        if (ch.volume <= 0.0) {
                            ch.volume = 0.0;
                            ch.fadeState = 0;
                            ch.triggerFadeComplete = true;
                            ch.playingState = 3;
                            ch.triggerStop = true;

                            if (ch.trackQueue.length > 0) {
                                ch.soundName = ch.trackQueue.shift();
                                ch.volume = 0.0;
                                ch.fadeState = 1;
                                ch.fadeSpeed = ch.nextFadeInSpeed;
                                ch.playingState = 1;
                                ch.triggerPlay = true;
                            }
                        }
                    }
                    ch.triggerVolume = true;
                }

                // 2. ADSR
                if (ch.adsrState != 0) {
                    ch.adsrTimer += 1.0;
                    switch (ch.adsrState) {
                        case 1:
                            var t1:Number = (ch.adsrAttack > 0) ? (ch.adsrTimer / ch.adsrAttack) : 1.0;
                            ch.volume = ch.adsrStartVol + t1 * (ch.volOrigin - ch.adsrStartVol);
                            if (ch.adsrTimer >= ch.adsrAttack) {
                                ch.volume = ch.volOrigin;
                                ch.adsrTimer = 0.0;
                                ch.adsrStartVol = ch.volume;
                                ch.adsrState = (ch.adsrDecay > 0) ? 2 : 3;
                            }
                            ch.triggerVolume = true;
                            break;
                        case 2:
                            var t2:Number = (ch.adsrDecay > 0) ? (ch.adsrTimer / ch.adsrDecay) : 1.0;
                            ch.volume = ch.volOrigin + t2 * (ch.adsrSustain - ch.volOrigin);
                            if (ch.adsrTimer >= ch.adsrDecay) {
                                ch.volume = ch.adsrSustain;
                                ch.adsrTimer = 0.0;
                                ch.adsrStartVol = ch.volume;
                                ch.adsrState = 3;
                            }
                            ch.triggerVolume = true;
                            break;
                        case 3:
                            break;
                        case 4:
                            var t4:Number = (ch.adsrRelease > 0) ? (ch.adsrTimer / ch.adsrRelease) : 1.0;
                            ch.volume = ch.adsrStartVol * (1.0 - t4);
                            if (ch.adsrTimer >= ch.adsrRelease) {
                                ch.volume = 0.0;
                                ch.adsrState = 0;
                                ch.playingState = 3;
                                ch.triggerStop = true;
                            }
                            ch.triggerVolume = true;
                            break;
                    }
                }

                // 3. Volume LFO
                if (ch.volLFOTrigger == 1) {
                    ch.volLFOPhase += deltaTime * ch.volLFORate * 2.0 * Math.PI;
                    if (ch.volLFOPhase > 2.0 * Math.PI) ch.volLFOPhase -= 2.0 * Math.PI;
                    var lfoVal:Number = Math.sin(ch.volLFOPhase);
                    var depth:Number = ch.volLFODepth / 100.0;
                    ch.volume = ch.volOrigin * (1.0 + depth * lfoVal);
                    ch.volume = Math.max(0.0, Math.min(100.0, ch.volume));
                    ch.triggerVolume = true;
                }

                // 4. Frequency
                var prevFreq:Number = ch.freqRate;
                switch (ch.freqDirection) {
                    case -1: ch.freqRate = Math.max(ch.freqRate - ch.freqSpeed, ch.freqTarget); break;
                    case 1: ch.freqRate = Math.min(ch.freqRate + ch.freqSpeed, ch.freqTarget); break;
                    case 2: ch.freqRate = ch.freqOrigin + Math.sin(customTimer * ch.freqSpeed * 0.01) * 8000.0; break;
                    case 3: ch.freqRate = Math.max(ch.freqRate - ch.freqSpeed, 0.0); break;
                    case 4:
                        ch.freqLFOPhase += deltaTime * ch.freqSpeed * 0.01;
                        var t4_f:Number = ch.freqLFOPhase % 1.0;
                        var tri:Number = (t4_f < 0.5) ? (4.0 * t4_f - 1.0) : (3.0 - 4.0 * t4_f);
                        ch.freqRate = ch.freqOrigin + tri * 8000.0;
                        break;
                    case 5:
                        ch.freqLFOPhase += deltaTime * ch.freqSpeed * 0.01;
                        var t5_f:Number = ch.freqLFOPhase % 1.0;
                        ch.freqRate = ch.freqOrigin + ((t5_f < 0.5) ? 8000.0 : -8000.0);
                        break;
                    case 6:
                        ch.freqLFOPhase += deltaTime * ch.freqSpeed * 0.01;
                        var t6_f:Number = ch.freqLFOPhase % 1.0;
                        ch.freqRate = ch.freqOrigin + (2.0 * t6_f - 1.0) * 8000.0;
                        break;
                    case 0:
                    default:
                        if (ch.freqRate != ch.freqOrigin) {
                            if (ch.freqRate > ch.freqOrigin) ch.freqRate = Math.max(ch.freqRate - ch.freqSpeed, ch.freqOrigin);
                            else ch.freqRate = Math.min(ch.freqRate + ch.freqSpeed, ch.freqOrigin);
                        }
                        break;
                }
                if (ch.freqRate != prevFreq) ch.triggerFreq = true;

                // 5. Tremolo
                if (ch.tremoloTrigger == 1) {
                    ch.tremoloPhase += deltaTime * ch.tremoloRate * 2.0 * Math.PI;
                    if (ch.tremoloPhase > 2.0 * Math.PI) ch.tremoloPhase -= 2.0 * Math.PI;
                    ch.triggerFreq = true;
                }

                // Deduplication
                if (ch.triggerVolume && ch.volume == ch.lastVolume) ch.triggerVolume = false;
                
                if (ch.triggerFreq) {
                    var finalFreq:Number = ch.freqRate;
                    if (ch.tremoloTrigger == 1) finalFreq = ch.freqRate * (1.0 + ch.tremoloDepth * Math.sin(ch.tremoloPhase));
                    if (finalFreq == ch.lastFreq) ch.triggerFreq = false;
                }

                if (ch.triggerPan && ch.pan == ch.lastPan) ch.triggerPan = false;

                // GENERATE EVENTS
                if (ch.triggerPlay) {
                    ch.triggerPlay = false;
                    triggeredChannel = ch.id;
                    triggeredName = ch.soundName;
                    triggeredLoop = ch.loopFlag;
                    ho.generateEvent(CND_ON_PLAY, 0);
                    ho.generateEvent(CND_ON_ANY_PLAY, 0);
                }
                if (ch.triggerStop) {
                    ch.triggerStop = false;
                    triggeredChannel = ch.id;
                    ho.generateEvent(CND_ON_STOP, 0);
                    ho.generateEvent(CND_ON_ANY_STOP, 0);
                }
                if (ch.triggerPause) {
                    ch.triggerPause = false;
                    triggeredChannel = ch.id;
                    ho.generateEvent(CND_ON_PAUSE, 0);
                    ho.generateEvent(CND_ON_ANY_PAUSE, 0);
                }
                if (ch.triggerResume) {
                    ch.triggerResume = false;
                    triggeredChannel = ch.id;
                    ho.generateEvent(CND_ON_RESUME, 0);
                    ho.generateEvent(CND_ON_ANY_RESUME, 0);
                }
                if (ch.triggerVolume) {
                    ch.triggerVolume = false;
                    triggeredChannel = ch.id;
                    triggeredVolume = ch.volume;
                    ch.lastVolume = ch.volume;
                    ho.generateEvent(CND_ON_SET_VOLUME, 0);
                    ho.generateEvent(CND_ON_ANY_SET_VOLUME, 0);
                }
                if (ch.triggerFreq) {
                    ch.triggerFreq = false;
                    triggeredChannel = ch.id;
                    var fFreq:Number = ch.freqRate;
                    if (ch.tremoloTrigger == 1) fFreq = ch.freqRate * (1.0 + ch.tremoloDepth * Math.sin(ch.tremoloPhase));
                    triggeredFrequency = fFreq;
                    ch.lastFreq = fFreq;
                    ho.generateEvent(CND_ON_SET_FREQUENCY, 0);
                    ho.generateEvent(CND_ON_ANY_SET_FREQUENCY, 0);
                }
                if (ch.triggerPosition) {
                    ch.triggerPosition = false;
                    triggeredChannel = ch.id;
                    triggeredPosition = ch.positionMs;
                    ch.lastPosition = ch.positionMs;
                    ho.generateEvent(CND_ON_SET_POSITION, 0);
                    ho.generateEvent(CND_ON_ANY_SET_POSITION, 0);
                }
                if (ch.triggerPan) {
                    ch.triggerPan = false;
                    triggeredChannel = ch.id;
                    triggeredPan = ch.pan;
                    ch.lastPan = ch.pan;
                    ho.generateEvent(CND_ON_SET_PAN, 0);
                    ho.generateEvent(CND_ON_ANY_SET_PAN, 0);
                }
                if (ch.triggerFadeComplete) {
                    ch.triggerFadeComplete = false;
                    triggeredChannel = ch.id;
                    ho.generateEvent(CND_ON_FADE_COMPLETE, 0);
                    ho.generateEvent(CND_ON_ANY_FADE_COMPLETE, 0);
                }
            }
            return 0; // REFLAG_DISPLAY or similar if you wanted to draw, 0 is fine
        }

        override public function condition(num:int, cnd:CCndExtension):Boolean
        {
            var channelId:int;
            switch (num) {
                case CND_ON_PLAY:
                case CND_ON_STOP:
                case CND_ON_PAUSE:
                case CND_ON_RESUME:
                case CND_ON_SET_VOLUME:
                case CND_ON_SET_FREQUENCY:
                case CND_ON_SET_POSITION:
                case CND_ON_SET_PAN:
                case CND_ON_FADE_COMPLETE:
                    channelId = cnd.getParamExpression(rh, 0);
                    return (channelId == -1 || channelId == triggeredChannel);
                case CND_IS_PLAYING:
                    channelId = cnd.getParamExpression(rh, 0);
                    if (channelId == -1) {
                        for (var i1:int=0; i1<48; i1++) if ((channels[i1] as ChannelStateAS).playingState == 1) return true;
                        return false;
                    }
                    var c1:ChannelStateAS = getChannel(channelId);
                    return c1 != null && c1.playingState == 1;
                case CND_IS_PAUSED:
                    channelId = cnd.getParamExpression(rh, 0);
                    if (channelId == -1) {
                        for (var i2:int=0; i2<48; i2++) if ((channels[i2] as ChannelStateAS).playingState == 2) return true;
                        return false;
                    }
                    var c2:ChannelStateAS = getChannel(channelId);
                    return c2 != null && c2.playingState == 2;
                case CND_IS_STOPPED:
                    channelId = cnd.getParamExpression(rh, 0);
                    if (channelId == -1) {
                        for (var i3:int=0; i3<48; i3++) if ((channels[i3] as ChannelStateAS).playingState == 3) return true;
                        return false;
                    }
                    var c3:ChannelStateAS = getChannel(channelId);
                    return c3 != null && c3.playingState == 3;
                default:
                    return true;
            }
        }

        override public function action(num:int, act:CActExtension):void
        {
            var id:int;
            var rate:Number, depth:Number, volume:Number, speed:Number, pan:Number, range:Number, freq:Number, targetVolume:Number, attack:Number, decay:Number, sustain:Number, release:Number;
            var loopFlag:int, startMs:int, endMs:int, fadeState:int, direction:int;
            var filename:String;
            var c:ChannelStateAS;

            switch (num) {
                case ACT_PLAYAUDIO:
                    id = act.getParamExpression(rh, 0);
                    filename = act.getParamExpString(rh, 1);
                    loopFlag = act.getParamExpression(rh, 2);
                    startMs = act.getParamExpression(rh, 3);
                    endMs = act.getParamExpression(rh, 4);
                    volume = act.getParamExpression(rh, 5);
                    freq = act.getParamExpression(rh, 6);
                    
                    var ch:ChannelStateAS = null;
                    if (id == 0) {
                        for (var i:int = 0; i < 48; i++) {
                            if ((channels[i] as ChannelStateAS).playingState == 3) { ch = channels[i]; break; }
                        }
                        if (ch == null) ch = channels[0];
                    } else {
                        ch = getChannel(id);
                    }
                    if (ch != null) {
                        ch.soundName = filename;
                        ch.trackQueue.length = 0;
                        ch.loopFlag = loopFlag;
                        ch.loopStart = startMs;
                        ch.loopEnd = endMs;
                        ch.volume = volume;
                        ch.volOrigin = volume;
                        ch.freqRate = (freq > 0.0) ? freq : 44100.0;
                        ch.freqOrigin = ch.freqRate;
                        ch.freqTarget = ch.freqRate;
                        ch.playingState = 1;
                        ch.fadeState = 0;
                        ch.adsrState = 0;
                        ch.autoReleaseTimer = (loopFlag != 0) ? 2.5 : -1.0;
                        ch.triggerPlay = true;
                        ch.triggerVolume = true;
                        ch.triggerFreq = true;
                    }
                    break;
                case ACT_STOPAUDIO:
                    id = act.getParamExpression(rh, 0);
                    if (id == -1) { for each (c in channels) { c.playingState = 3; c.triggerStop = true; } }
                    else { c = getChannel(id); if (c != null) { c.playingState = 3; c.triggerStop = true; } }
                    break;
                case ACT_PAUSEAUDIO:
                    id = act.getParamExpression(rh, 0);
                    if (id == -1) { for each (c in channels) { c.playingState = 2; c.triggerPause = true; } }
                    else { c = getChannel(id); if (c != null) { c.playingState = 2; c.triggerPause = true; } }
                    break;
                case ACT_RESUMEAUDIO:
                    id = act.getParamExpression(rh, 0);
                    if (id == -1) { for each (c in channels) { c.playingState = 1; c.triggerResume = true; } }
                    else { c = getChannel(id); if (c != null) { c.playingState = 1; c.triggerResume = true; } }
                    break;
                case ACT_QUEUEAUDIO:
                    id = act.getParamExpression(rh, 0);
                    filename = act.getParamExpString(rh, 1);
                    var fadeOutSpeed:Number = act.getParamExpDouble(rh, 2);
                    var fadeInSpeed:Number = act.getParamExpDouble(rh, 3);
                    c = getChannel(id);
                    if (c != null) {
                        c.trackQueue.length = 0;
                        c.trackQueue.push(filename);
                        c.fadeState = -1;
                        c.fadeSpeed = fadeOutSpeed;
                        c.nextFadeInSpeed = fadeInSpeed;
                    }
                    break;
                case ACT_SETVOLUME:
                    id = act.getParamExpression(rh, 0);
                    volume = act.getParamExpression(rh, 1);
                    if (id == -1) { for each (c in channels) { c.volume = volume; c.volOrigin = volume; c.triggerVolume = true; } }
                    else { c = getChannel(id); if (c != null) { c.volume = volume; c.volOrigin = volume; c.triggerVolume = true; } }
                    break;
                case ACT_SETFREQUENCY:
                    id = act.getParamExpression(rh, 0);
                    freq = act.getParamExpression(rh, 1);
                    speed = act.getParamExpression(rh, 2);
                    direction = act.getParamExpression(rh, 3);
                    if (id == -1) { for each (c in channels) setFreqInternal(c, freq, speed, direction); }
                    else { c = getChannel(id); if (c != null) setFreqInternal(c, freq, speed, direction); }
                    break;
                case ACT_SETPAN:
                    id = act.getParamExpression(rh, 0);
                    pan = act.getParamExpression(rh, 1);
                    if (id == -1) { for each (c in channels) { c.pan = pan; c.triggerPan = true; } }
                    else { c = getChannel(id); if (c != null) { c.pan = pan; c.triggerPan = true; } }
                    break;
                case ACT_ENABLETREMOLO:
                    id = act.getParamExpression(rh, 0);
                    rate = act.getParamExpression(rh, 1);
                    depth = act.getParamExpression(rh, 2);
                    if (id == -1) { for each (c in channels) setTremoloInternal(c, rate, depth); }
                    else { c = getChannel(id); if (c != null) setTremoloInternal(c, rate, depth); }
                    break;
                case ACT_FADECHANNEL:
                    id = act.getParamExpression(rh, 0);
                    targetVolume = act.getParamExpression(rh, 1);
                    speed = act.getParamExpression(rh, 2);
                    fadeState = act.getParamExpression(rh, 3);
                    if (id == -1) { for each (c in channels) setFadeInternal(c, targetVolume, speed, fadeState); }
                    else { c = getChannel(id); if (c != null) setFadeInternal(c, targetVolume, speed, fadeState); }
                    break;
                case ACT_ENQUEUETRACK:
                    id = act.getParamExpression(rh, 0);
                    filename = act.getParamExpString(rh, 1);
                    if (id == -1) { for each (c in channels) c.trackQueue.push(filename); }
                    else { c = getChannel(id); if (c != null) c.trackQueue.push(filename); }
                    break;
                case ACT_CLEARQUEUE:
                    id = act.getParamExpression(rh, 0);
                    if (id == -1) { for each (c in channels) c.trackQueue.length = 0; }
                    else { c = getChannel(id); if (c != null) c.trackQueue.length = 0; }
                    break;
                case ACT_ENABLEVOLUMELFO:
                    id = act.getParamExpression(rh, 0);
                    rate = act.getParamExpression(rh, 1);
                    depth = act.getParamExpression(rh, 2);
                    if (id == -1) { for each (c in channels) setVolLFOInternal(c, rate, depth); }
                    else { c = getChannel(id); if (c != null) setVolLFOInternal(c, rate, depth); }
                    break;
                case ACT_SETADSR:
                    id = act.getParamExpression(rh, 0);
                    attack = act.getParamExpression(rh, 1);
                    decay = act.getParamExpression(rh, 2);
                    sustain = act.getParamExpression(rh, 3);
                    release = act.getParamExpression(rh, 4);
                    if (id == -1) { for each (c in channels) setADSRInternal(c, attack, decay, sustain, release); }
                    else { c = getChannel(id); if (c != null) setADSRInternal(c, attack, decay, sustain, release); }
                    break;
                case ACT_RANDOMIZEPITCH:
                    id = act.getParamExpression(rh, 0);
                    range = act.getParamExpression(rh, 1);
                    if (id == -1) { for each (c in channels) setRandPitchInternal(c, range); }
                    else { c = getChannel(id); if (c != null) setRandPitchInternal(c, range); }
                    break;
                case ACT_CROSSFADE:
                    var fromId:int = act.getParamExpression(rh, 0);
                    var toId:int = act.getParamExpression(rh, 1);
                    speed = act.getParamExpression(rh, 2);
                    var cfFrom:ChannelStateAS = getChannel(fromId);
                    var cfTo:ChannelStateAS = getChannel(toId);
                    if (cfFrom != null) setFadeInternal(cfFrom, 0.0, speed, -1);
                    if (cfTo != null) setFadeInternal(cfTo, 100.0, speed, 1);
                    break;
                case ACT_SETORIGINFREQUENCY:
                    id = act.getParamExpression(rh, 0);
                    freq = act.getParamExpDouble(rh, 1);
                    if (id == -1) { for each (c in channels) setOriginFreqInternal(c, freq); }
                    else { c = getChannel(id); if (c != null) setOriginFreqInternal(c, freq); }
                    break;
                
                // For all variants, we duplicate logic slightly since we don't have CActParamOverride
                case ACT_STOPALLCHANNELS:
                    for each (c in channels) { c.playingState = 3; c.triggerStop = true; }
                    break;
                case ACT_PAUSEALLCHANNELS:
                    for each (c in channels) { c.playingState = 2; c.triggerPause = true; }
                    break;
                case ACT_RESUMEALLCHANNELS:
                    for each (c in channels) { c.playingState = 1; c.triggerResume = true; }
                    break;
                case ACT_SETALLVOLUMES:
                    volume = act.getParamExpression(rh, 0);
                    for each (c in channels) { c.volume = volume; c.volOrigin = volume; c.triggerVolume = true; }
                    break;
                case ACT_SETALLFREQUENCYSWEEPS:
                    freq = act.getParamExpDouble(rh, 0);
                    speed = act.getParamExpDouble(rh, 1);
                    direction = act.getParamExpression(rh, 2);
                    for each (c in channels) setFreqInternal(c, freq, speed, direction);
                    break;
                case ACT_SETALLPANNING:
                    pan = act.getParamExpression(rh, 0);
                    for each (c in channels) { c.pan = pan; c.triggerPan = true; }
                    break;
                case ACT_ENABLEALLTREMOLOS:
                    rate = act.getParamExpression(rh, 0);
                    depth = act.getParamExpression(rh, 1);
                    for each (c in channels) setTremoloInternal(c, rate, depth);
                    break;
                case ACT_FADEALLCHANNELS:
                    targetVolume = act.getParamExpression(rh, 0);
                    speed = act.getParamExpression(rh, 1);
                    fadeState = act.getParamExpression(rh, 2);
                    for each (c in channels) setFadeInternal(c, targetVolume, speed, fadeState);
                    break;
                case ACT_ENABLEALLVOLUMELFOS:
                    rate = act.getParamExpression(rh, 0);
                    depth = act.getParamExpression(rh, 1);
                    for each (c in channels) setVolLFOInternal(c, rate, depth);
                    break;
                case ACT_SETALLADSRENVELOPES:
                    attack = act.getParamExpression(rh, 0);
                    decay = act.getParamExpression(rh, 1);
                    sustain = act.getParamExpression(rh, 2);
                    release = act.getParamExpression(rh, 3);
                    for each (c in channels) setADSRInternal(c, attack, decay, sustain, release);
                    break;
                case ACT_RANDOMIZEALLPITCHES:
                    range = act.getParamExpression(rh, 0);
                    for each (c in channels) setRandPitchInternal(c, range);
                    break;
                case ACT_SETALLORIGINFREQUENCIES:
                    freq = act.getParamExpDouble(rh, 0);
                    for each (c in channels) setOriginFreqInternal(c, freq);
                    break;
                case ACT_SETCHANNELSTOPPED:
                    id = act.getParamExpression(rh, 0);
                    c = getChannel(id);
                    if (c != null) {
                        c.playingState = 3;
                        c.fadeState = 0;
                        c.adsrState = 0;
                        c.autoReleaseTimer = 0.0;
                    }
                    break;
            }
        }

        private function setFreqInternal(ch:ChannelStateAS, freq:Number, speed:Number, direction:int):void {
            if (direction == 0) {
                ch.freqTarget = ch.freqOrigin;
            } else if (speed == 0.0) {
                var safeFreq:Number = (freq > 0.0) ? freq : ch.freqOrigin;
                ch.freqOrigin = safeFreq;
                ch.freqRate = safeFreq;
                ch.freqTarget = safeFreq;
            } else {
                ch.freqTarget = (freq > 0.0) ? freq : ch.freqMin;
            }
            ch.freqSpeed = speed;
            ch.freqDirection = direction;
            ch.freqLFOPhase = 0.0;
            ch.lastFreq = -1.0;
            ch.triggerFreq = true;
        }

        private function setTremoloInternal(ch:ChannelStateAS, rate:Number, depth:Number):void {
            ch.tremoloTrigger = (rate > 0) ? 1 : 0;
            ch.tremoloRate = rate;
            ch.tremoloDepth = Math.max(0.0, Math.min(depth / 100.0, 1.0));
            ch.triggerFreq = true;
        }

        private function setFadeInternal(ch:ChannelStateAS, targetVolume:Number, speed:Number, state:int):void {
            ch.volOrigin = targetVolume;
            ch.fadeSpeed = speed;
            ch.fadeState = state;
        }

        private function setVolLFOInternal(ch:ChannelStateAS, rate:Number, depth:Number):void {
            ch.volLFOTrigger = (rate > 0) ? 1 : 0;
            ch.volLFORate = rate;
            ch.volLFODepth = depth;
            ch.volLFOPhase = 0.0;
        }

        private function setADSRInternal(ch:ChannelStateAS, attack:Number, decay:Number, sustain:Number, release:Number):void {
            ch.adsrAttack = attack;
            ch.adsrDecay = decay;
            ch.adsrSustain = sustain;
            ch.adsrRelease = release;
            ch.adsrTimer = 0.0;
            ch.adsrStartVol = ch.volume;
            ch.adsrState = (attack > 0) ? 1 : ((decay > 0) ? 2 : 3);
        }

        private function setRandPitchInternal(ch:ChannelStateAS, range:Number):void {
            var offset:Number = (Math.random()) * 2.0 * range - range;
            ch.freqRate = Math.max(ch.freqMin, Math.min(ch.freqMax, ch.freqOrigin + offset));
            ch.lastFreq = -1.0;
            ch.triggerFreq = true;
        }

        private function setOriginFreqInternal(ch:ChannelStateAS, freq:Number):void {
            ch.freqOrigin = freq;
            ch.freqRate = freq;
            ch.freqTarget = freq;
            ch.freqMin = freq / 8.0;
            ch.freqMax = freq * 8.0;
            ch.lastFreq = -1.0;
            ch.triggerFreq = true;
        }

        override public function expression(num:int):CValue
        {
            var id:int;
            var ch:ChannelStateAS;
            switch (num) {
                case EXP_GETPLAYSOUNDNAME:
                    id = ho.getExpParam().getInt();
                    ch = getChannel(id);
                    return new CValue(ch != null ? ch.soundName : "");
                case EXP_GETPLAYLOOPS:
                    id = ho.getExpParam().getInt();
                    ch = getChannel(id);
                    return new CValue(ch != null ? ch.loopFlag : 0);
                case EXP_GETVOLUME:
                    id = ho.getExpParam().getInt();
                    ch = getChannel(id);
                    return new CValue(ch != null ? ch.volume : 0.0);
                case EXP_GETFREQUENCY:
                    id = ho.getExpParam().getInt();
                    ch = getChannel(id);
                    return new CValue(ch != null ? ch.freqRate : 0.0);
                case EXP_GETPOSITION:
                    id = ho.getExpParam().getInt();
                    ch = getChannel(id);
                    return new CValue(ch != null ? ch.positionMs : 0);
                case EXP_GETPAN:
                    id = ho.getExpParam().getInt();
                    ch = getChannel(id);
                    return new CValue(ch != null ? ch.pan : 0.0);
                case EXP_GETTRIGGEREDCHANNEL: return new CValue(triggeredChannel);
                case EXP_GETTRIGGEREDNAME: return new CValue(triggeredName);
                case EXP_GETTRIGGEREDVOLUME: return new CValue(triggeredVolume);
                case EXP_GETTRIGGEREDFREQUENCY: return new CValue(triggeredFrequency);
                case EXP_GETTRIGGEREDPAN: return new CValue(triggeredPan);
                case EXP_GETTRIGGEREDPOSITION: return new CValue(triggeredPosition);
                case EXP_GETTRIGGEREDLOOPS: return new CValue(triggeredLoop);
                case EXP_GETPLAYSTATE:
                    id = ho.getExpParam().getInt();
                    ch = getChannel(id);
                    return new CValue(ch != null ? ch.playingState : 3);
                case EXP_GETCUSTOMTIMER: return new CValue(customTimer);
                case EXP_GETFREQORIGIN:
                    id = ho.getExpParam().getInt();
                    ch = getChannel(id);
                    return new CValue(ch != null ? ch.freqOrigin : 0.0);
                case EXP_GETTRIGGEREDFREQORIGIN:
                    ch = getChannel(triggeredChannel);
                    return new CValue(ch != null ? ch.freqOrigin : 0.0);
                case EXP_GETFREQORIGINPCT:
                    id = ho.getExpParam().getInt();
                    var pct:int = ho.getExpParam().getInt();
                    ch = getChannel(id);
                    return new CValue(ch != null ? ch.freqOrigin * (pct / 100.0) : 0.0);
                default:
                    return new CValue(0);
            }
        }
    }
}

class ChannelStateAS {
    public var id:int = 0;
    public var soundName:String = "";
    public var trackQueue:Array = [];
    
    public var volume:Number = 100.0;
    public var volOrigin:Number = 100.0;
    public var fadeState:int = 0;
    public var fadeSpeed:Number = 2.0;
    public var nextFadeInSpeed:Number = 2.0;
    public var triggerFadeComplete:Boolean = false;

    public var volLFOTrigger:int = 0;
    public var volLFORate:Number = 4.0;
    public var volLFODepth:Number = 30.0;
    public var volLFOPhase:Number = 0.0;

    public var adsrState:int = 0;
    public var adsrAttack:Number = 0.0;
    public var adsrDecay:Number = 0.0;
    public var adsrSustain:Number = 100.0;
    public var adsrRelease:Number = 0.0;
    public var adsrTimer:Number = 0.0;
    public var adsrStartVol:Number = 0.0;

    public var freqRate:Number = 44100.0;
    public var freqSpeed:Number = 200.0;
    public var freqDirection:int = 0;
    public var freqOrigin:Number = 44100.0;
    public var freqTarget:Number = 44100.0;
    public var freqMin:Number = 5512.5;
    public var freqMax:Number = 352800.0;
    public var freqLFOPhase:Number = 0.0;

    public var tremoloTrigger:int = 0;
    public var tremoloRate:Number = 4.0;
    public var tremoloPhase:Number = 0.0;
    public var tremoloDepth:Number = 0.15;

    public var loopFlag:int = 0;
    public var loopStart:int = 0;
    public var loopEnd:int = 0;
    public var playingState:int = 3;
    public var positionMs:int = 0;
    public var pan:Number = 0.0;
    public var autoReleaseTimer:Number = 0.0;

    public var triggerPlay:Boolean = false;
    public var triggerStop:Boolean = false;
    public var triggerPause:Boolean = false;
    public var triggerResume:Boolean = false;
    public var triggerVolume:Boolean = false;
    public var triggerFreq:Boolean = false;
    public var triggerPosition:Boolean = false;
    public var triggerPan:Boolean = false;

    public var lastVolume:Number = -999.0;
    public var lastFreq:Number = -999.0;
    public var lastPosition:int = -999;
    public var lastPan:Number = -999.0;

    public function ChannelStateAS(i:int) {
        this.id = i;
    }
}

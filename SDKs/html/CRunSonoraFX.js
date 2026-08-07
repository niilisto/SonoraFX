//----------------------------------------------------------------------------------
//
// CRunSonoraFX.js
// Clickteam Fusion 2.5 HTML5 runtime extension for SonoraFX
//
//----------------------------------------------------------------------------------

CRunSonoraFX.CND_ONPLAY = 0;
CRunSonoraFX.CND_ONSTOP = 1;
CRunSonoraFX.CND_ONPAUSE = 2;
CRunSonoraFX.CND_ONRESUME = 3;
CRunSonoraFX.CND_ONSETVOLUME = 4;
CRunSonoraFX.CND_ONSETFREQUENCY = 5;
CRunSonoraFX.CND_ONSETPOSITION = 6;
CRunSonoraFX.CND_ONSETPAN = 7;
CRunSonoraFX.CND_ISPLAYING = 8;
CRunSonoraFX.CND_ISPAUSED = 9;
CRunSonoraFX.CND_ISSTOPPED = 10;
CRunSonoraFX.CND_ONFADECOMPLETE = 11;
CRunSonoraFX.CND_ONANYPLAY = 12;
CRunSonoraFX.CND_ONANYSTOP = 13;
CRunSonoraFX.CND_ONANYPAUSE = 14;
CRunSonoraFX.CND_ONANYRESUME = 15;
CRunSonoraFX.CND_ONANYSETVOLUME = 16;
CRunSonoraFX.CND_ONANYSETFREQUENCY = 17;
CRunSonoraFX.CND_ONANYSETPOSITION = 18;
CRunSonoraFX.CND_ONANYSETPAN = 19;
CRunSonoraFX.CND_ONANYFADECOMPLETE = 20;
CRunSonoraFX.CND_LAST = 21;

CRunSonoraFX.ACT_PLAYAUDIO = 0;
CRunSonoraFX.ACT_STOPAUDIO = 1;
CRunSonoraFX.ACT_PAUSEAUDIO = 2;
CRunSonoraFX.ACT_RESUMEAUDIO = 3;
CRunSonoraFX.ACT_QUEUEAUDIO = 4;
CRunSonoraFX.ACT_SETVOLUME = 5;
CRunSonoraFX.ACT_SETFREQUENCY = 6;
CRunSonoraFX.ACT_SETPAN = 7;
CRunSonoraFX.ACT_ENABLETREMOLO = 8;
CRunSonoraFX.ACT_FADECHANNEL = 9;
CRunSonoraFX.ACT_ENQUEUETRACK = 10;
CRunSonoraFX.ACT_CLEARQUEUE = 11;
CRunSonoraFX.ACT_ENABLEVOLUMELFO = 12;
CRunSonoraFX.ACT_SETADSR = 13;
CRunSonoraFX.ACT_RANDOMIZEPITCH = 14;
CRunSonoraFX.ACT_CROSSFADE = 15;
CRunSonoraFX.ACT_SETORIGINFREQUENCY = 16;
CRunSonoraFX.ACT_STOPALLCHANNELS = 17;
CRunSonoraFX.ACT_PAUSEALLCHANNELS = 18;
CRunSonoraFX.ACT_RESUMEALLCHANNELS = 19;
CRunSonoraFX.ACT_SETALLVOLUMES = 20;
CRunSonoraFX.ACT_SETALLFREQUENCYSWEEPS = 21;
CRunSonoraFX.ACT_SETALLPANNING = 22;
CRunSonoraFX.ACT_ENABLEALLTREMOLOS = 23;
CRunSonoraFX.ACT_FADEALLCHANNELS = 24;
CRunSonoraFX.ACT_ENABLEALLVOLUMELFOS = 25;
CRunSonoraFX.ACT_SETALLADSRENVELOPES = 26;
CRunSonoraFX.ACT_RANDOMIZEALLPITCHES = 27;
CRunSonoraFX.ACT_SETALLORIGINFREQUENCIES = 28;
CRunSonoraFX.ACT_SETCHANNELSTOPPED = 29;
CRunSonoraFX.ACT_PLAYWITHRANDOMVARIANCE = 30;
CRunSonoraFX.ACT_UPDATESPATIALAUDIO2D = 31;
CRunSonoraFX.ACT_CROSSFADEPARALLEL = 32;
CRunSonoraFX.ACT_SEQUENTIALTRANSITION = 33;

CRunSonoraFX.EXP_GETPLAYSOUNDNAME = 0;
CRunSonoraFX.EXP_GETPLAYLOOPS = 1;
CRunSonoraFX.EXP_GETVOLUME = 2;
CRunSonoraFX.EXP_GETFREQUENCY = 3;
CRunSonoraFX.EXP_GETPOSITION = 4;
CRunSonoraFX.EXP_GETPAN = 5;
CRunSonoraFX.EXP_TRIGGEREDCHANNEL = 6;
CRunSonoraFX.EXP_TRIGGEREDNAME = 7;
CRunSonoraFX.EXP_TRIGGEREDVOLUME = 8;
CRunSonoraFX.EXP_TRIGGEREDFREQUENCY = 9;
CRunSonoraFX.EXP_TRIGGEREDPAN = 10;
CRunSonoraFX.EXP_TRIGGEREDPOSITION = 11;
CRunSonoraFX.EXP_TRIGGEREDLOOPS = 12;
CRunSonoraFX.EXP_GETPLAYSTATE = 13;
CRunSonoraFX.EXP_GETCUSTOMTIMER = 14;
CRunSonoraFX.EXP_GETFREQORIGIN = 15;
CRunSonoraFX.EXP_GETTRIGGEREDFREQORIGIN = 16;
CRunSonoraFX.EXP_GETFREQORIGINPCT = 17;

function CRunSonoraFX()
{
    this.channels = [];
    this.customTimer = 0.0;
    this.lastTime = 0;
    
    this.triggeredChannel = -1;
    this.triggeredName = "";
    this.triggeredLoop = 0;
    this.triggeredVolume = 100.0;
    this.triggeredFrequency = 44100.0;
    this.triggeredPosition = 0;
    this.triggeredPan = 0.0;
}

CRunSonoraFX.prototype = CServices.extend(new CRunExtension(),
{
    getNumberOfConditions:function()
    {
        return CRunSonoraFX.CND_LAST;
    },
    
    createRunObject:function(file, cob, version)
    {
        for (var i = 0; i < 48; i++) {
            this.channels.push({
                id: i + 1,
                soundName: "",
                trackQueue: [],
                
                volume: 100.0,
                volOrigin: 100.0,
                fadeState: 0,
                fadeSpeed: 2.0,
                nextFadeInSpeed: 2.0,
                triggerFadeComplete: false,

                volLFOTrigger: 0,
                volLFORate: 4.0,
                volLFODepth: 30.0,
                volLFOPhase: 0.0,

                adsrState: 0,
                adsrAttack: 0.0,
                adsrDecay: 0.0,
                adsrSustain: 100.0,
                adsrRelease: 0.0,
                adsrTimer: 0.0,
                adsrStartVol: 0.0,

                freqRate: 44100.0,
                freqSpeed: 200.0,
                freqDirection: 0,
                freqOrigin: 44100.0,
                freqTarget: 44100.0,
                freqMin: 5512.5,
                freqMax: 352800.0,
                freqLFOPhase: 0.0,

                tremoloTrigger: 0,
                tremoloRate: 4.0,
                tremoloPhase: 0.0,
                tremoloDepth: 0.15,

                loopFlag: 0,
                loopStart: 0,
                loopEnd: 0,
                playingState: 3,
                positionMs: 0,
                pan: 0.0,
                autoReleaseTimer: 0.0,

                triggerPlay: false,
                triggerStop: false,
                triggerPause: false,
                triggerResume: false,
                triggerVolume: false,
                triggerFreq: false,
                triggerPosition: false,
                triggerPan: false,

                lastVolume: -999.0,
                lastFreq: -999.0,
                lastPosition: -999,
                lastPan: -999.0,
                
                transitionTargetId: 0,
                transitionSample: "",
                transitionFadeIn: 2.0
            });
        }
        this.lastTime = Date.now();
    },
    
    getChannel: function(id) {
        if (id < 1 || id > 48) return null;
        return this.channels[id - 1];
    },

    handleRunObject: function()
    {
        var currentTime = Date.now();
        var deltaTime = (currentTime - this.lastTime) / 1000.0;
        this.lastTime = currentTime;
        this.customTimer += deltaTime;

        for (var i = 0; i < 48; i++) {
            var ch = this.channels[i];

            if (ch.playingState === 1) {
                ch.positionMs += Math.floor(deltaTime * 1000);
            }

            if (ch.playingState === 1 && ch.autoReleaseTimer > 0.0) {
                ch.autoReleaseTimer -= deltaTime;
                if (ch.autoReleaseTimer <= 0.0) {
                    ch.autoReleaseTimer = 0.0;
                    ch.playingState = 3;
                }
            }

            // 1. Fade Mode
            if (ch.fadeState !== 0) {
                ch.volume += ch.fadeState * ch.fadeSpeed;
                if (ch.fadeState === 1) { // Fade In
                    if (ch.volume >= ch.volOrigin) {
                        ch.volume = ch.volOrigin;
                        ch.fadeState = 0;
                        ch.triggerFadeComplete = true;
                    }
                } else if (ch.fadeState === -1) { // Fade Out
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
            if (ch.adsrState !== 0) {
                ch.adsrTimer += 1.0;
                switch (ch.adsrState) {
                    case 1:
                        var t1 = (ch.adsrAttack > 0) ? (ch.adsrTimer / ch.adsrAttack) : 1.0;
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
                        var t2 = (ch.adsrDecay > 0) ? (ch.adsrTimer / ch.adsrDecay) : 1.0;
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
                        var t4 = (ch.adsrRelease > 0) ? (ch.adsrTimer / ch.adsrRelease) : 1.0;
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
            if (ch.volLFOTrigger === 1) {
                ch.volLFOPhase += deltaTime * ch.volLFORate * 2.0 * Math.PI;
                if (ch.volLFOPhase > 2.0 * Math.PI) ch.volLFOPhase -= 2.0 * Math.PI;
                var lfoVal = Math.sin(ch.volLFOPhase);
                var depth = ch.volLFODepth / 100.0;
                ch.volume = ch.volOrigin * (1.0 + depth * lfoVal);
                ch.volume = Math.max(0.0, Math.min(100.0, ch.volume));
                ch.triggerVolume = true;
            }

            // 4. Frequency
            var prevFreq = ch.freqRate;
            switch (ch.freqDirection) {
                case -1: ch.freqRate = Math.max(ch.freqRate - ch.freqSpeed, ch.freqTarget); break;
                case 1: ch.freqRate = Math.min(ch.freqRate + ch.freqSpeed, ch.freqTarget); break;
                case 2: ch.freqRate = ch.freqOrigin + Math.sin(this.customTimer * ch.freqSpeed * 0.01) * 8000.0; break;
                case 3: ch.freqRate = Math.max(ch.freqRate - ch.freqSpeed, 0.0); break;
                case 4:
                    ch.freqLFOPhase += deltaTime * ch.freqSpeed * 0.01;
                    var t4_f = ch.freqLFOPhase % 1.0;
                    var tri = (t4_f < 0.5) ? (4.0 * t4_f - 1.0) : (3.0 - 4.0 * t4_f);
                    ch.freqRate = ch.freqOrigin + tri * 8000.0;
                    break;
                case 5:
                    ch.freqLFOPhase += deltaTime * ch.freqSpeed * 0.01;
                    var t5_f = ch.freqLFOPhase % 1.0;
                    ch.freqRate = ch.freqOrigin + ((t5_f < 0.5) ? 8000.0 : -8000.0);
                    break;
                case 6:
                    ch.freqLFOPhase += deltaTime * ch.freqSpeed * 0.01;
                    var t6_f = ch.freqLFOPhase % 1.0;
                    ch.freqRate = ch.freqOrigin + (2.0 * t6_f - 1.0) * 8000.0;
                    break;
                case 0:
                default:
                    if (ch.freqRate !== ch.freqOrigin) {
                        if (ch.freqRate > ch.freqOrigin) ch.freqRate = Math.max(ch.freqRate - ch.freqSpeed, ch.freqOrigin);
                        else ch.freqRate = Math.min(ch.freqRate + ch.freqSpeed, ch.freqOrigin);
                    }
                    break;
            }
            if (ch.freqRate !== prevFreq) ch.triggerFreq = true;

            // 5. Tremolo
            if (ch.tremoloTrigger === 1) {
                ch.tremoloPhase += deltaTime * ch.tremoloRate * 2.0 * Math.PI;
                if (ch.tremoloPhase > 2.0 * Math.PI) ch.tremoloPhase -= 2.0 * Math.PI;
                ch.triggerFreq = true;
            }

            // Deduplication
            if (ch.triggerVolume && ch.volume === ch.lastVolume) ch.triggerVolume = false;
            
            if (ch.triggerFreq) {
                var finalFreq = ch.freqRate;
                if (ch.tremoloTrigger === 1) finalFreq = ch.freqRate * (1.0 + ch.tremoloDepth * Math.sin(ch.tremoloPhase));
                if (finalFreq === ch.lastFreq) ch.triggerFreq = false;
            }

            if (ch.triggerPan && ch.pan === ch.lastPan) ch.triggerPan = false;

            // GENERATE EVENTS
            if (ch.triggerStop) {
                ch.triggerStop = false;
                this.triggeredChannel = ch.id;
                this.ho.generateEvent(CRunSonoraFX.CND_ONSTOP, 0);
                this.ho.generateEvent(CRunSonoraFX.CND_ONANYSTOP, 0);
            }
            if (ch.triggerPlay) {
                ch.triggerPlay = false;
                this.triggeredChannel = ch.id;
                this.triggeredName = ch.soundName;
                this.triggeredLoop = ch.loopFlag;
                this.triggeredVolume = ch.volume;
                this.triggeredFrequency = ch.freqRate;
                this.triggeredPosition = ch.positionMs;
                this.triggeredPan = ch.pan;
                this.ho.generateEvent(CRunSonoraFX.CND_ONPLAY, 0);
                this.ho.generateEvent(CRunSonoraFX.CND_ONANYPLAY, 0);
            }
            if (ch.triggerPause) {
                ch.triggerPause = false;
                this.triggeredChannel = ch.id;
                this.ho.generateEvent(CRunSonoraFX.CND_ONPAUSE, 0);
                this.ho.generateEvent(CRunSonoraFX.CND_ONANYPAUSE, 0);
            }
            if (ch.triggerResume) {
                ch.triggerResume = false;
                this.triggeredChannel = ch.id;
                this.ho.generateEvent(CRunSonoraFX.CND_ONRESUME, 0);
                this.ho.generateEvent(CRunSonoraFX.CND_ONANYRESUME, 0);
            }
            if (ch.triggerVolume) {
                ch.triggerVolume = false;
                this.triggeredChannel = ch.id;
                this.triggeredVolume = ch.volume;
                ch.lastVolume = ch.volume;
                this.ho.generateEvent(CRunSonoraFX.CND_ONSETVOLUME, 0);
                this.ho.generateEvent(CRunSonoraFX.CND_ONANYSETVOLUME, 0);
            }
            if (ch.triggerFreq) {
                ch.triggerFreq = false;
                this.triggeredChannel = ch.id;
                var fFreq = ch.freqRate;
                if (ch.tremoloTrigger === 1) fFreq = ch.freqRate * (1.0 + ch.tremoloDepth * Math.sin(ch.tremoloPhase));
                this.triggeredFrequency = fFreq;
                ch.lastFreq = fFreq;
                this.ho.generateEvent(CRunSonoraFX.CND_ONSETFREQUENCY, 0);
                this.ho.generateEvent(CRunSonoraFX.CND_ONANYSETFREQUENCY, 0);
            }
            if (ch.triggerPosition) {
                ch.triggerPosition = false;
                this.triggeredChannel = ch.id;
                this.triggeredPosition = ch.positionMs;
                ch.lastPosition = ch.positionMs;
                this.ho.generateEvent(CRunSonoraFX.CND_ONSETPOSITION, 0);
                this.ho.generateEvent(CRunSonoraFX.CND_ONANYSETPOSITION, 0);
            }
            if (ch.triggerPan) {
                ch.triggerPan = false;
                this.triggeredChannel = ch.id;
                this.triggeredPan = ch.pan;
                ch.lastPan = ch.pan;
                this.ho.generateEvent(CRunSonoraFX.CND_ONSETPAN, 0);
                this.ho.generateEvent(CRunSonoraFX.CND_ONANYSETPAN, 0);
            }
            if (ch.triggerFadeComplete) {
                ch.triggerFadeComplete = false;
                this.triggeredChannel = ch.id;
                this.ho.generateEvent(CRunSonoraFX.CND_ONFADECOMPLETE, 0);
                this.ho.generateEvent(CRunSonoraFX.CND_ONANYFADECOMPLETE, 0);
            }
        }
        return 0; // Call next frame
    },
    
    destroyRunObject: function(bFast)
    {
    },
    
    condition:function(num, cnd)
    {
        var channelId;
        switch (num) {
            case CRunSonoraFX.CND_ONPLAY:
            case CRunSonoraFX.CND_ONSTOP:
            case CRunSonoraFX.CND_ONPAUSE:
            case CRunSonoraFX.CND_ONRESUME:
            case CRunSonoraFX.CND_ONSETVOLUME:
            case CRunSonoraFX.CND_ONSETFREQUENCY:
            case CRunSonoraFX.CND_ONSETPOSITION:
            case CRunSonoraFX.CND_ONSETPAN:
            case CRunSonoraFX.CND_ONFADECOMPLETE:
                channelId = cnd.getParamExpression(this.rh, 0);
                return (channelId === -1 || channelId === this.triggeredChannel);
            case CRunSonoraFX.CND_ISPLAYING:
                channelId = cnd.getParamExpression(this.rh, 0);
                if (channelId === -1) {
                    for (var i1 = 0; i1 < 48; i1++) if (this.channels[i1].playingState === 1) return true;
                    return false;
                }
                var c1 = this.getChannel(channelId);
                return c1 !== null && c1.playingState === 1;
            case CRunSonoraFX.CND_ISPAUSED:
                channelId = cnd.getParamExpression(this.rh, 0);
                if (channelId === -1) {
                    for (var i2 = 0; i2 < 48; i2++) if (this.channels[i2].playingState === 2) return true;
                    return false;
                }
                var c2 = this.getChannel(channelId);
                return c2 !== null && c2.playingState === 2;
            case CRunSonoraFX.CND_ISSTOPPED:
                channelId = cnd.getParamExpression(this.rh, 0);
                if (channelId === -1) {
                    for (var i3 = 0; i3 < 48; i3++) if (this.channels[i3].playingState === 3) return true;
                    return false;
                }
                var c3 = this.getChannel(channelId);
                return c3 !== null && c3.playingState === 3;
            default:
                return true;
        }
    },
    
    setFreqInternal: function(ch, freq, speed, direction) {
        if (direction === 0) {
            ch.freqTarget = ch.freqOrigin;
        } else if (speed === 0.0) {
            var safeFreq = (freq > 0.0) ? freq : ch.freqOrigin;
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
    },

    setTremoloInternal: function(ch, rate, depth) {
        ch.tremoloTrigger = (rate > 0) ? 1 : 0;
        ch.tremoloRate = rate;
        ch.tremoloDepth = Math.max(0.0, Math.min(depth / 100.0, 1.0));
        ch.triggerFreq = true;
    },

    setFadeInternal: function(ch, targetVolume, speed, state) {
        ch.volOrigin = targetVolume;
        ch.fadeSpeed = speed;
        ch.fadeState = state;
    },

    setVolLFOInternal: function(ch, rate, depth) {
        ch.volLFOTrigger = (rate > 0) ? 1 : 0;
        ch.volLFORate = rate;
        ch.volLFODepth = depth;
        ch.volLFOPhase = 0.0;
    },

    setADSRInternal: function(ch, attack, decay, sustain, release) {
        ch.adsrAttack = attack;
        ch.adsrDecay = decay;
        ch.adsrSustain = sustain;
        ch.adsrRelease = release;
        ch.adsrTimer = 0.0;
        ch.adsrStartVol = ch.volume;
        ch.adsrState = (attack > 0) ? 1 : ((decay > 0) ? 2 : 3);
    },

    setRandPitchInternal: function(ch, range) {
        var offset = (Math.random()) * 2.0 * range - range;
        ch.freqRate = Math.max(ch.freqMin, Math.min(ch.freqMax, ch.freqOrigin + offset));
        ch.lastFreq = -1.0;
        ch.triggerFreq = true;
    },

    setOriginFreqInternal: function(ch, freq) {
        ch.freqOrigin = freq;
        ch.freqRate = freq;
        ch.freqTarget = freq;
        ch.freqMin = freq / 8.0;
        ch.freqMax = freq * 8.0;
        ch.lastFreq = -1.0;
        ch.triggerFreq = true;
    },

    action:function(num, act)
    {   
        var id, rate, depth, volume, speed, pan, range, freq, targetVolume, attack, decay, sustain, release;
        var loopFlag, startMs, endMs, fadeState, direction;
        var filename;
        var c;

        switch (num)
        {
            case CRunSonoraFX.ACT_PLAYAUDIO:
                id = act.getParamExpression(this.rh, 0);
                filename = act.getParamExpString(this.rh, 1);
                loopFlag = act.getParamExpression(this.rh, 2);
                startMs = act.getParamExpression(this.rh, 3);
                endMs = act.getParamExpression(this.rh, 4);
                volume = act.getParamExpression(this.rh, 5);
                freq = act.getParamExpression(this.rh, 6);
                
                var ch = null;
                if (id === 0) {
                    for (var i = 0; i < 48; i++) {
                        if (this.channels[i].playingState === 3) { ch = this.channels[i]; break; }
                    }
                    if (ch === null) ch = this.channels[0];
                } else {
                    ch = this.getChannel(id);
                }
                if (ch !== null) {
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
                    ch.autoReleaseTimer = (loopFlag !== 0) ? 2.5 : -1.0;
                    ch.triggerPlay = true;
                    ch.triggerVolume = true;
                    ch.triggerFreq = true;
                }
                break;
            case CRunSonoraFX.ACT_STOPAUDIO:
                id = act.getParamExpression(this.rh, 0);
                if (id === -1) { for (var i1=0; i1<48; i1++) { this.channels[i1].playingState = 3; this.channels[i1].triggerStop = true; } }
                else { c = this.getChannel(id); if (c !== null) { c.playingState = 3; c.triggerStop = true; } }
                break;
            case CRunSonoraFX.ACT_PAUSEAUDIO:
                id = act.getParamExpression(this.rh, 0);
                if (id === -1) { for (var i2=0; i2<48; i2++) { this.channels[i2].playingState = 2; this.channels[i2].triggerPause = true; } }
                else { c = this.getChannel(id); if (c !== null) { c.playingState = 2; c.triggerPause = true; } }
                break;
            case CRunSonoraFX.ACT_RESUMEAUDIO:
                id = act.getParamExpression(this.rh, 0);
                if (id === -1) { for (var i3=0; i3<48; i3++) { this.channels[i3].playingState = 1; this.channels[i3].triggerResume = true; } }
                else { c = this.getChannel(id); if (c !== null) { c.playingState = 1; c.triggerResume = true; } }
                break;
            case CRunSonoraFX.ACT_QUEUEAUDIO:
                id = act.getParamExpression(this.rh, 0);
                filename = act.getParamExpString(this.rh, 1);
                var fadeOutSpeed = act.getParamExpression(this.rh, 2); // usually getParamExpDouble, but JS treats number same
                var fadeInSpeed = act.getParamExpression(this.rh, 3);
                c = this.getChannel(id);
                if (c !== null) {
                    c.trackQueue.length = 0;
                    c.trackQueue.push(filename);
                    c.fadeState = -1;
                    c.fadeSpeed = fadeOutSpeed;
                    c.nextFadeInSpeed = fadeInSpeed;
                }
                break;
            case CRunSonoraFX.ACT_SETVOLUME:
                id = act.getParamExpression(this.rh, 0);
                volume = act.getParamExpression(this.rh, 1);
                if (id === -1) { for (var iv=0; iv<48; iv++) { this.channels[iv].volume = volume; this.channels[iv].volOrigin = volume; this.channels[iv].triggerVolume = true; } }
                else { c = this.getChannel(id); if (c !== null) { c.volume = volume; c.volOrigin = volume; c.triggerVolume = true; } }
                break;
            case CRunSonoraFX.ACT_SETFREQUENCY:
                id = act.getParamExpression(this.rh, 0);
                freq = act.getParamExpression(this.rh, 1);
                speed = act.getParamExpression(this.rh, 2);
                direction = act.getParamExpression(this.rh, 3);
                if (id === -1) { for (var iff=0; iff<48; iff++) this.setFreqInternal(this.channels[iff], freq, speed, direction); }
                else { c = this.getChannel(id); if (c !== null) this.setFreqInternal(c, freq, speed, direction); }
                break;
            case CRunSonoraFX.ACT_SETPAN:
                id = act.getParamExpression(this.rh, 0);
                pan = act.getParamExpression(this.rh, 1);
                if (id === -1) { for (var ip=0; ip<48; ip++) { this.channels[ip].pan = pan; this.channels[ip].triggerPan = true; } }
                else { c = this.getChannel(id); if (c !== null) { c.pan = pan; c.triggerPan = true; } }
                break;
            case CRunSonoraFX.ACT_ENABLETREMOLO:
                id = act.getParamExpression(this.rh, 0);
                rate = act.getParamExpression(this.rh, 1);
                depth = act.getParamExpression(this.rh, 2);
                if (id === -1) { for (var it=0; it<48; it++) this.setTremoloInternal(this.channels[it], rate, depth); }
                else { c = this.getChannel(id); if (c !== null) this.setTremoloInternal(c, rate, depth); }
                break;
            case CRunSonoraFX.ACT_FADECHANNEL:
                id = act.getParamExpression(this.rh, 0);
                targetVolume = act.getParamExpression(this.rh, 1);
                speed = act.getParamExpression(this.rh, 2);
                fadeState = act.getParamExpression(this.rh, 3);
                if (id === -1) { for (var ifc=0; ifc<48; ifc++) this.setFadeInternal(this.channels[ifc], targetVolume, speed, fadeState); }
                else { c = this.getChannel(id); if (c !== null) this.setFadeInternal(c, targetVolume, speed, fadeState); }
                break;
            case CRunSonoraFX.ACT_ENQUEUETRACK:
                id = act.getParamExpression(this.rh, 0);
                filename = act.getParamExpString(this.rh, 1);
                if (id === -1) { for (var iq=0; iq<48; iq++) this.channels[iq].trackQueue.push(filename); }
                else { c = this.getChannel(id); if (c !== null) c.trackQueue.push(filename); }
                break;
            case CRunSonoraFX.ACT_CLEARQUEUE:
                id = act.getParamExpression(this.rh, 0);
                if (id === -1) { for (var icq=0; icq<48; icq++) this.channels[icq].trackQueue.length = 0; }
                else { c = this.getChannel(id); if (c !== null) c.trackQueue.length = 0; }
                break;
            case CRunSonoraFX.ACT_ENABLEVOLUMELFO:
                id = act.getParamExpression(this.rh, 0);
                rate = act.getParamExpression(this.rh, 1);
                depth = act.getParamExpression(this.rh, 2);
                if (id === -1) { for (var ilf=0; ilf<48; ilf++) this.setVolLFOInternal(this.channels[ilf], rate, depth); }
                else { c = this.getChannel(id); if (c !== null) this.setVolLFOInternal(c, rate, depth); }
                break;
            case CRunSonoraFX.ACT_SETADSR:
                id = act.getParamExpression(this.rh, 0);
                attack = act.getParamExpression(this.rh, 1);
                decay = act.getParamExpression(this.rh, 2);
                sustain = act.getParamExpression(this.rh, 3);
                release = act.getParamExpression(this.rh, 4);
                if (id === -1) { for (var ia=0; ia<48; ia++) this.setADSRInternal(this.channels[ia], attack, decay, sustain, release); }
                else { c = this.getChannel(id); if (c !== null) this.setADSRInternal(c, attack, decay, sustain, release); }
                break;
            case CRunSonoraFX.ACT_RANDOMIZEPITCH:
                id = act.getParamExpression(this.rh, 0);
                range = act.getParamExpression(this.rh, 1);
                if (id === -1) { for (var irp=0; irp<48; irp++) this.setRandPitchInternal(this.channels[irp], range); }
                else { c = this.getChannel(id); if (c !== null) this.setRandPitchInternal(c, range); }
                break;
            case CRunSonoraFX.ACT_CROSSFADE:
                var fromId = act.getParamExpression(this.rh, 0);
                var toId = act.getParamExpression(this.rh, 1);
                speed = act.getParamExpression(this.rh, 2);
                var cfFrom = this.getChannel(fromId);
                var cfTo = this.getChannel(toId);
                if (cfFrom !== null) this.setFadeInternal(cfFrom, 0.0, speed, -1);
                if (cfTo !== null) this.setFadeInternal(cfTo, 100.0, speed, 1);
                break;
            case CRunSonoraFX.ACT_CROSSFADEPARALLEL:
                var fromId = act.getParamExpression(this.rh, 0);
                var nextSample = act.getParamExpString(this.rh, 1);
                speed = act.getParamExpression(this.rh, 2);
                var toId = act.getParamExpression(this.rh, 3);
                
                var chMaster = this.getChannel(fromId);
                var chSlave = this.getChannel(toId);
                
                if (chMaster !== null && chSlave !== null) {
                    chMaster.volOrigin = 0.0;
                    chMaster.fadeSpeed = speed;
                    chMaster.fadeState = -1;
                    
                    chSlave.soundName = nextSample;
                    chSlave.volume = 0.0;
                    chSlave.volOrigin = 100.0;
                    chSlave.freqRate = 44100.0;
                    chSlave.freqOrigin = 44100.0;
                    chSlave.freqTarget = 44100.0;
                    chSlave.playingState = 1;
                    chSlave.fadeState = 1;
                    chSlave.fadeSpeed = speed;
                    chSlave.positionMs = chMaster.positionMs;
                    chSlave.autoReleaseTimer = -1.0;
                    chSlave.triggerPlay = true;
                    chSlave.triggerVolume = true;
                    chSlave.triggerFreq = true;
                    chSlave.triggerPosition = true;
                }
                break;
            case CRunSonoraFX.ACT_SEQUENTIALTRANSITION:
                var fromId = act.getParamExpression(this.rh, 0);
                var nextSample = act.getParamExpString(this.rh, 1);
                var outSpeed = act.getParamExpression(this.rh, 2);
                var toId = act.getParamExpression(this.rh, 3);
                var inSpeed = act.getParamExpression(this.rh, 4);
                
                var chMaster = this.getChannel(fromId);
                if (chMaster !== null) {
                    chMaster.volOrigin = 0.0;
                    chMaster.fadeSpeed = outSpeed;
                    chMaster.fadeState = -1;
                    
                    chMaster.transitionTargetId = toId;
                    chMaster.transitionSample = nextSample;
                    chMaster.transitionFadeIn = inSpeed;
                }
                break;
            case CRunSonoraFX.ACT_SETORIGINFREQUENCY:
                id = act.getParamExpression(this.rh, 0);
                freq = act.getParamExpression(this.rh, 1);
                if (id === -1) { for (var iof=0; iof<48; iof++) this.setOriginFreqInternal(this.channels[iof], freq); }
                else { c = this.getChannel(id); if (c !== null) this.setOriginFreqInternal(c, freq); }
                break;
                
            case CRunSonoraFX.ACT_STOPALLCHANNELS:
                for (var j1=0; j1<48; j1++) { this.channels[j1].playingState = 3; this.channels[j1].triggerStop = true; }
                break;
            case CRunSonoraFX.ACT_PAUSEALLCHANNELS:
                for (var j2=0; j2<48; j2++) { this.channels[j2].playingState = 2; this.channels[j2].triggerPause = true; }
                break;
            case CRunSonoraFX.ACT_RESUMEALLCHANNELS:
                for (var j3=0; j3<48; j3++) { this.channels[j3].playingState = 1; this.channels[j3].triggerResume = true; }
                break;
            case CRunSonoraFX.ACT_SETALLVOLUMES:
                volume = act.getParamExpression(this.rh, 0);
                for (var j4=0; j4<48; j4++) { this.channels[j4].volume = volume; this.channels[j4].volOrigin = volume; this.channels[j4].triggerVolume = true; }
                break;
            case CRunSonoraFX.ACT_SETALLFREQUENCYSWEEPS:
                freq = act.getParamExpression(this.rh, 0);
                speed = act.getParamExpression(this.rh, 1);
                direction = act.getParamExpression(this.rh, 2);
                for (var j5=0; j5<48; j5++) this.setFreqInternal(this.channels[j5], freq, speed, direction);
                break;
            case CRunSonoraFX.ACT_SETALLPANNING:
                pan = act.getParamExpression(this.rh, 0);
                for (var j6=0; j6<48; j6++) { this.channels[j6].pan = pan; this.channels[j6].triggerPan = true; }
                break;
            case CRunSonoraFX.ACT_ENABLEALLTREMOLOS:
                rate = act.getParamExpression(this.rh, 0);
                depth = act.getParamExpression(this.rh, 1);
                for (var j7=0; j7<48; j7++) this.setTremoloInternal(this.channels[j7], rate, depth);
                break;
            case CRunSonoraFX.ACT_FADEALLCHANNELS:
                targetVolume = act.getParamExpression(this.rh, 0);
                speed = act.getParamExpression(this.rh, 1);
                fadeState = act.getParamExpression(this.rh, 2);
                for (var j8=0; j8<48; j8++) this.setFadeInternal(this.channels[j8], targetVolume, speed, fadeState);
                break;
            case CRunSonoraFX.ACT_ENABLEALLVOLUMELFOS:
                rate = act.getParamExpression(this.rh, 0);
                depth = act.getParamExpression(this.rh, 1);
                for (var j9=0; j9<48; j9++) this.setVolLFOInternal(this.channels[j9], rate, depth);
                break;
            case CRunSonoraFX.ACT_SETALLADSRENVELOPES:
                attack = act.getParamExpression(this.rh, 0);
                decay = act.getParamExpression(this.rh, 1);
                sustain = act.getParamExpression(this.rh, 2);
                release = act.getParamExpression(this.rh, 3);
                for (var j10=0; j10<48; j10++) this.setADSRInternal(this.channels[j10], attack, decay, sustain, release);
                break;
            case CRunSonoraFX.ACT_RANDOMIZEALLPITCHES:
                range = act.getParamExpression(this.rh, 0);
                for (var j11=0; j11<48; j11++) this.setRandPitchInternal(this.channels[j11], range);
                break;
            case CRunSonoraFX.ACT_SETALLORIGINFREQUENCIES:
                freq = act.getParamExpression(this.rh, 0);
                for (var j12=0; j12<48; j12++) this.setOriginFreqInternal(this.channels[j12], freq);
                break;
            case CRunSonoraFX.ACT_SETCHANNELSTOPPED:
                id = act.getParamExpression(this.rh, 0);
                c = this.getChannel(id);
                if (c !== null) {
                    c.playingState = 3;
                    c.fadeState = 0;
                    c.adsrState = 0;
                    c.autoReleaseTimer = 0.0;
                }
                break;
            case CRunSonoraFX.ACT_PLAYRANDOMVARIANCE:
                id = act.getParamExpression(this.rh, 0);
                filename = act.getParamExpString(this.rh, 1);
                loopFlag = act.getParamExpression(this.rh, 2);
                startMs = act.getParamExpression(this.rh, 3);
                endMs = act.getParamExpression(this.rh, 4);
                var baseVol = act.getParamExpression(this.rh, 5);
                var volVar = act.getParamExpression(this.rh, 6);
                var baseFreq = act.getParamExpression(this.rh, 7);
                var freqVar = act.getParamExpression(this.rh, 8);
                
                var rndVol = baseVol + ((Math.random() * (volVar * 2)) - volVar);
                var rndFreq = baseFreq + ((Math.random() * (freqVar * 2)) - freqVar);
                if (rndVol < 0.0) rndVol = 0.0;
                if (rndVol > 100.0) rndVol = 100.0;
                if (rndFreq < 0.0) rndFreq = 0.0;
                
                var chR = null;
                if (id === 0) {
                    for (var iR = 0; iR < 48; iR++) {
                        if (this.channels[iR].playingState === 3) { chR = this.channels[iR]; break; }
                    }
                    if (chR === null) chR = this.channels[0];
                } else {
                    chR = this.getChannel(id);
                }
                if (chR !== null) {
                    chR.soundName = filename;
                    chR.trackQueue.length = 0;
                    chR.loopFlag = loopFlag;
                    chR.loopStart = startMs;
                    chR.loopEnd = endMs;
                    chR.volume = rndVol;
                    chR.volOrigin = rndVol;
                    chR.freqRate = rndFreq;
                    chR.freqOrigin = rndFreq;
                    chR.freqTarget = rndFreq;
                    chR.playingState = 1;
                    chR.fadeState = 0;
                    chR.adsrState = 0;
                    chR.autoReleaseTimer = (loopFlag !== 0) ? 2.5 : -1.0;
                    chR.triggerPlay = true;
                    chR.triggerVolume = true;
                    chR.triggerFreq = true;
                }
                break;
            case CRunSonoraFX.ACT_UPDATESPATIALAUDIO2D:
                id = act.getParamExpression(this.rh, 0);
                var srcX = act.getParamExpression(this.rh, 1);
                var srcY = act.getParamExpression(this.rh, 2);
                var lsnrX = act.getParamExpression(this.rh, 3);
                var lsnrY = act.getParamExpression(this.rh, 4);
                var maxDist = act.getParamExpression(this.rh, 5);
                var rolloff = act.getParamExpression(this.rh, 6);
                
                var dx = srcX - lsnrX;
                var dy = srcY - lsnrY;
                var dist = Math.sqrt(dx*dx + dy*dy);
                
                var v = 100.0;
                if (dist >= maxDist || maxDist <= 0.0) {
                    v = 0.0;
                } else {
                    v = 100.0 * Math.pow(1.0 - (dist / maxDist), rolloff);
                }
                if (v < 0.0) v = 0.0; if (v > 100.0) v = 100.0;
                
                var p = 0.0;
                if (maxDist > 0.0) p = (dx / maxDist) * 100.0;
                if (p < -100.0) p = -100.0; if (p > 100.0) p = 100.0;
                
                var chS = this.getChannel(id);
                if (chS !== null) {
                    chS.volume = v;
                    chS.triggerVolume = true;
                    chS.pan = p;
                    chS.triggerPan = true;
                }
                break;
        }
    },

    expression: function(num)
    {
        var id;
        var ch;
        switch (num)
        {
            case CRunSonoraFX.EXP_GETPLAYSOUNDNAME:
                id = this.ho.getExpParam().getInt();
                ch = this.getChannel(id);
                return (ch !== null ? ch.soundName : "");
            case CRunSonoraFX.EXP_GETPLAYLOOPS:
                id = this.ho.getExpParam().getInt();
                ch = this.getChannel(id);
                return (ch !== null ? ch.loopFlag : 0);
            case CRunSonoraFX.EXP_GETVOLUME:
                id = this.ho.getExpParam().getInt();
                ch = this.getChannel(id);
                return (ch !== null ? ch.volume : 0.0);
            case CRunSonoraFX.EXP_GETFREQUENCY:
                id = this.ho.getExpParam().getInt();
                ch = this.getChannel(id);
                return (ch !== null ? ch.freqRate : 0.0);
            case CRunSonoraFX.EXP_GETPOSITION:
                id = this.ho.getExpParam().getInt();
                ch = this.getChannel(id);
                return (ch !== null ? ch.positionMs : 0);
            case CRunSonoraFX.EXP_GETPAN:
                id = this.ho.getExpParam().getInt();
                ch = this.getChannel(id);
                return (ch !== null ? ch.pan : 0.0);
            case CRunSonoraFX.EXP_TRIGGEREDCHANNEL: return this.triggeredChannel;
            case CRunSonoraFX.EXP_TRIGGEREDNAME: return this.triggeredName;
            case CRunSonoraFX.EXP_TRIGGEREDVOLUME: return this.triggeredVolume;
            case CRunSonoraFX.EXP_TRIGGEREDFREQUENCY: return this.triggeredFrequency;
            case CRunSonoraFX.EXP_TRIGGEREDPAN: return this.triggeredPan;
            case CRunSonoraFX.EXP_TRIGGEREDPOSITION: return this.triggeredPosition;
            case CRunSonoraFX.EXP_TRIGGEREDLOOPS: return this.triggeredLoop;
            case CRunSonoraFX.EXP_GETPLAYSTATE:
                id = this.ho.getExpParam().getInt();
                ch = this.getChannel(id);
                return (ch !== null ? ch.playingState : 3);
            case CRunSonoraFX.EXP_GETCUSTOMTIMER: return this.customTimer;
            case CRunSonoraFX.EXP_GETFREQORIGIN:
                id = this.ho.getExpParam().getInt();
                ch = this.getChannel(id);
                return (ch !== null ? ch.freqOrigin : 0.0);
            case CRunSonoraFX.EXP_GETTRIGGEREDFREQORIGIN:
                ch = this.getChannel(this.triggeredChannel);
                return (ch !== null ? ch.freqOrigin : 0.0);
            case CRunSonoraFX.EXP_GETFREQORIGINPCT:
                id = this.ho.getExpParam().getInt();
                var pct = this.ho.getExpParam().getInt();
                ch = this.getChannel(id);
                return (ch !== null ? ch.freqOrigin * (pct / 100.0) : 0.0);
        }
        return 0;
    }
});

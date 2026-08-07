#import "CRunSonoraFX.h"
#import "CFile.h"
#import "CCreateObjectInfo.h"
#import "CCndExtension.h"
#import "CActExtension.h"
#import "CValue.h"
#import "CRunApp.h"
#import "CRun.h"
#import "CRunApp.h"
#import "CHo.h"

@implementation ChannelStateObjC
-(id)init {
    if (self = [super init]) {
        _soundName = @"";
        _trackQueue = [[NSMutableArray alloc] init];
        _volume = 100.0f;
        _volOrigin = 100.0f;
        _fadeState = 0;
        _fadeSpeed = 2.0f;
        _nextFadeInSpeed = 2.0f;
        _triggerFadeComplete = NO;
        
        _volLFOTrigger = 0;
        _volLFORate = 4.0f;
        _volLFODepth = 30.0f;
        _volLFOPhase = 0.0f;
        
        _adsrState = 0;
        _adsrAttack = 0.0f;
        _adsrDecay = 0.0f;
        _adsrSustain = 100.0f;
        _adsrRelease = 0.0f;
        _adsrTimer = 0.0f;
        _adsrStartVol = 0.0f;
        
        _freqRate = 44100.0f;
        _freqSpeed = 200.0f;
        _freqDirection = 0;
        _freqOrigin = 44100.0f;
        _freqTarget = 44100.0f;
        _freqMin = 5512.5f;
        _freqMax = 352800.0f;
        _freqLFOPhase = 0.0f;
        
        _tremoloTrigger = 0;
        _tremoloRate = 4.0f;
        _tremoloPhase = 0.0f;
        _tremoloDepth = 0.15f;
        
        _loopFlag = 0;
        _loopStart = 0;
        _loopEnd = 0;
        _playingState = 3;
        _positionMs = 0;
        _pan = 0.0f;
        _autoReleaseTimer = 0.0f;
        
        _triggerPlay = NO;
        _triggerStop = NO;
        _triggerPause = NO;
        _triggerResume = NO;
        _triggerVolume = NO;
        _triggerFreq = NO;
        _triggerPosition = NO;
        _triggerPan = NO;
        
        _lastVolume = -999.0f;
        _lastFreq = -999.0f;
        _lastPosition = -999;
        _lastPan = -999.0f;
    }
    return self;
}
@end

@implementation CRunSonoraFX

-(int)getNumberOfConditions {
    return 21;
}

-(BOOL)createRunObject:(CFile*)file withCOB:(CCreateObjectInfo*)cob andVersion:(int)version {
    channels = [[NSMutableArray alloc] initWithCapacity:48];
    for (int i=0; i<48; i++) {
        ChannelStateObjC* ch = [[ChannelStateObjC alloc] init];
        ch.id = i + 1;
        [channels addObject:ch];
    }
    lastTime = [[NSDate date] timeIntervalSince1970];
    customTimer = 0.0f;
    triggeredChannel = -1;
    triggeredName = @"";
    return NO;
}

-(ChannelStateObjC*)getChannel:(int)id {
    if (id < 1 || id > 48) return nil;
    return channels[id - 1];
}

-(int)handleRunObject {
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    float deltaTime = (float)(currentTime - lastTime);
    lastTime = currentTime;
    customTimer += deltaTime;
    
    for (ChannelStateObjC* ch in channels) {
        if (ch.playingState == 1 && ch.autoReleaseTimer > 0.0f) {
            ch.autoReleaseTimer -= deltaTime;
            if (ch.autoReleaseTimer <= 0.0f) {
                ch.autoReleaseTimer = 0.0f;
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
                    ch.triggerFadeComplete = YES;
                }
            } else if (ch.fadeState == -1) {
                if (ch.volume <= 0.0f) {
                    ch.volume = 0.0f;
                    ch.fadeState = 0;
                    ch.triggerFadeComplete = YES;
                    ch.playingState = 3;
                    ch.triggerStop = YES;
                    
                    if (ch.trackQueue.count > 0) {
                        ch.soundName = ch.trackQueue[0];
                        [ch.trackQueue removeObjectAtIndex:0];
                        ch.volume = 0.0f;
                        ch.fadeState = 1;
                        ch.fadeSpeed = ch.nextFadeInSpeed;
                        ch.playingState = 1;
                        ch.triggerPlay = YES;
                    }
                }
            }
            ch.triggerVolume = YES;
        }
        
        // 2. ADSR
        if (ch.adsrState != 0) {
            ch.adsrTimer += 1.0f;
            switch (ch.adsrState) {
                case 1: {
                    float t1 = (ch.adsrAttack > 0) ? (ch.adsrTimer / ch.adsrAttack) : 1.0f;
                    ch.volume = ch.adsrStartVol + t1 * (ch.volOrigin - ch.adsrStartVol);
                    if (ch.adsrTimer >= ch.adsrAttack) {
                        ch.volume = ch.volOrigin;
                        ch.adsrTimer = 0.0f;
                        ch.adsrStartVol = ch.volume;
                        ch.adsrState = (ch.adsrDecay > 0) ? 2 : 3;
                    }
                    ch.triggerVolume = YES;
                    break;
                }
                case 2: {
                    float t2 = (ch.adsrDecay > 0) ? (ch.adsrTimer / ch.adsrDecay) : 1.0f;
                    ch.volume = ch.volOrigin + t2 * (ch.adsrSustain - ch.volOrigin);
                    if (ch.adsrTimer >= ch.adsrDecay) {
                        ch.volume = ch.adsrSustain;
                        ch.adsrTimer = 0.0f;
                        ch.adsrStartVol = ch.volume;
                        ch.adsrState = 3;
                    }
                    ch.triggerVolume = YES;
                    break;
                }
                case 3:
                    break;
                case 4: {
                    float t4 = (ch.adsrRelease > 0) ? (ch.adsrTimer / ch.adsrRelease) : 1.0f;
                    ch.volume = ch.adsrStartVol * (1.0f - t4);
                    if (ch.adsrTimer >= ch.adsrRelease) {
                        ch.volume = 0.0f;
                        ch.adsrState = 0;
                        ch.playingState = 3;
                        ch.triggerStop = YES;
                    }
                    ch.triggerVolume = YES;
                    break;
                }
            }
        }
        
        // 3. Volume LFO
        if (ch.volLFOTrigger == 1) {
            ch.volLFOPhase += deltaTime * ch.volLFORate * 2.0f * M_PI;
            if (ch.volLFOPhase > 2.0f * M_PI) ch.volLFOPhase -= 2.0f * M_PI;
            float lfoVal = sinf(ch.volLFOPhase);
            float depth = ch.volLFODepth / 100.0f;
            ch.volume = ch.volOrigin * (1.0f + depth * lfoVal);
            ch.volume = MAX(0.0f, MIN(100.0f, ch.volume));
            ch.triggerVolume = YES;
        }
        
        // 4. Frequency
        float prevFreq = ch.freqRate;
        switch (ch.freqDirection) {
            case -1: ch.freqRate = MAX(ch.freqRate - ch.freqSpeed, ch.freqTarget); break;
            case 1: ch.freqRate = MIN(ch.freqRate + ch.freqSpeed, ch.freqTarget); break;
            case 2: ch.freqRate = ch.freqOrigin + sinf(customTimer * ch.freqSpeed * 0.01f) * 8000.0f; break;
            case 3: ch.freqRate = MAX(ch.freqRate - ch.freqSpeed, 0.0f); break;
            case 4: {
                ch.freqLFOPhase += deltaTime * ch.freqSpeed * 0.01f;
                float t4 = fmodf(ch.freqLFOPhase, 1.0f);
                float tri = (t4 < 0.5f) ? (4.0f * t4 - 1.0f) : (3.0f - 4.0f * t4);
                ch.freqRate = ch.freqOrigin + tri * 8000.0f;
                break;
            }
            case 5: {
                ch.freqLFOPhase += deltaTime * ch.freqSpeed * 0.01f;
                float t5 = fmodf(ch.freqLFOPhase, 1.0f);
                ch.freqRate = ch.freqOrigin + ((t5 < 0.5f) ? 8000.0f : -8000.0f);
                break;
            }
            case 6: {
                ch.freqLFOPhase += deltaTime * ch.freqSpeed * 0.01f;
                float t6 = fmodf(ch.freqLFOPhase, 1.0f);
                ch.freqRate = ch.freqOrigin + (2.0f * t6 - 1.0f) * 8000.0f;
                break;
            }
            case 0:
            default:
                if (ch.freqRate != ch.freqOrigin) {
                    if (ch.freqRate > ch.freqOrigin) ch.freqRate = MAX(ch.freqRate - ch.freqSpeed, ch.freqOrigin);
                    else ch.freqRate = MIN(ch.freqRate + ch.freqSpeed, ch.freqOrigin);
                }
                break;
        }
        if (ch.freqRate != prevFreq) ch.triggerFreq = YES;
        
        // 5. Tremolo
        if (ch.tremoloTrigger == 1) {
            ch.tremoloPhase += deltaTime * ch.tremoloRate * 2.0f * M_PI;
            if (ch.tremoloPhase > 2.0f * M_PI) ch.tremoloPhase -= 2.0f * M_PI;
            ch.triggerFreq = YES;
        }
        
        // Deduplication
        if (ch.triggerVolume && ch.volume == ch.lastVolume) ch.triggerVolume = NO;
        if (ch.triggerFreq) {
            float finalFreq = ch.freqRate;
            if (ch.tremoloTrigger == 1) finalFreq = ch.freqRate * (1.0f + ch.tremoloDepth * sinf(ch.tremoloPhase));
            if (finalFreq == ch.lastFreq) ch.triggerFreq = NO;
        }
        if (ch.triggerPan && ch.pan == ch.lastPan) ch.triggerPan = NO;
        
        // GENERATE EVENTS
        if (ch.triggerPlay) {
            ch.triggerPlay = NO;
            triggeredChannel = ch.id;
            triggeredName = ch.soundName;
            triggeredLoop = ch.loopFlag;
            [self.ho generateEvent:0 withParam:0];
            [self.ho generateEvent:12 withParam:0];
        }
        if (ch.triggerStop) {
            ch.triggerStop = NO;
            triggeredChannel = ch.id;
            [self.ho generateEvent:1 withParam:0];
            [self.ho generateEvent:13 withParam:0];
        }
        if (ch.triggerPause) {
            ch.triggerPause = NO;
            triggeredChannel = ch.id;
            [self.ho generateEvent:2 withParam:0];
            [self.ho generateEvent:14 withParam:0];
        }
        if (ch.triggerResume) {
            ch.triggerResume = NO;
            triggeredChannel = ch.id;
            [self.ho generateEvent:3 withParam:0];
            [self.ho generateEvent:15 withParam:0];
        }
        if (ch.triggerVolume) {
            ch.triggerVolume = NO;
            triggeredChannel = ch.id;
            triggeredVolume = ch.volume;
            ch.lastVolume = ch.volume;
            [self.ho generateEvent:4 withParam:0];
            [self.ho generateEvent:16 withParam:0];
        }
        if (ch.triggerFreq) {
            ch.triggerFreq = NO;
            triggeredChannel = ch.id;
            float fFreq = ch.freqRate;
            if (ch.tremoloTrigger == 1) fFreq = ch.freqRate * (1.0f + ch.tremoloDepth * sinf(ch.tremoloPhase));
            triggeredFrequency = fFreq;
            ch.lastFreq = fFreq;
            [self.ho generateEvent:5 withParam:0];
            [self.ho generateEvent:17 withParam:0];
        }
        if (ch.triggerPosition) {
            ch.triggerPosition = NO;
            triggeredChannel = ch.id;
            triggeredPosition = ch.positionMs;
            ch.lastPosition = ch.positionMs;
            [self.ho generateEvent:6 withParam:0];
            [self.ho generateEvent:18 withParam:0];
        }
        if (ch.triggerPan) {
            ch.triggerPan = NO;
            triggeredChannel = ch.id;
            triggeredPan = ch.pan;
            ch.lastPan = ch.pan;
            [self.ho generateEvent:7 withParam:0];
            [self.ho generateEvent:19 withParam:0];
        }
        if (ch.triggerFadeComplete) {
            ch.triggerFadeComplete = NO;
            triggeredChannel = ch.id;
            [self.ho generateEvent:11 withParam:0];
            [self.ho generateEvent:20 withParam:0];
        }
    }
    return 0;
}

-(BOOL)condition:(int)num withCndExtension:(CCndExtension*)cnd {
    int channelId;
    switch (num) {
        case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: case 11:
            channelId = [cnd getParamExpression:self.rh withNum:0];
            return (channelId == -1 || channelId == triggeredChannel);
        case 8:
            channelId = [cnd getParamExpression:self.rh withNum:0];
            if (channelId == -1) {
                for (ChannelStateObjC* ch in channels) if (ch.playingState == 1) return YES;
                return NO;
            }
            return ([self getChannel:channelId] != nil && [self getChannel:channelId].playingState == 1);
        case 9:
            channelId = [cnd getParamExpression:self.rh withNum:0];
            if (channelId == -1) {
                for (ChannelStateObjC* ch in channels) if (ch.playingState == 2) return YES;
                return NO;
            }
            return ([self getChannel:channelId] != nil && [self getChannel:channelId].playingState == 2);
        case 10:
            channelId = [cnd getParamExpression:self.rh withNum:0];
            if (channelId == -1) {
                for (ChannelStateObjC* ch in channels) if (ch.playingState == 3) return YES;
                return NO;
            }
            return ([self getChannel:channelId] != nil && [self getChannel:channelId].playingState == 3);
        default:
            return YES;
    }
}

-(void)setFreqInternal:(ChannelStateObjC*)ch freq:(float)freq speed:(float)speed direction:(int)direction {
    if (direction == 0) {
        ch.freqTarget = ch.freqOrigin;
    } else if (speed == 0.0f) {
        float safeFreq = (freq > 0.0f) ? freq : ch.freqOrigin;
        ch.freqOrigin = safeFreq;
        ch.freqRate = safeFreq;
        ch.freqTarget = safeFreq;
    } else {
        ch.freqTarget = (freq > 0.0f) ? freq : ch.freqMin;
    }
    ch.freqSpeed = speed;
    ch.freqDirection = direction;
    ch.freqLFOPhase = 0.0f;
    ch.lastFreq = -1.0f;
    ch.triggerFreq = YES;
}

-(void)setTremoloInternal:(ChannelStateObjC*)ch rate:(float)rate depth:(float)depth {
    ch.tremoloTrigger = (rate > 0) ? 1 : 0;
    ch.tremoloRate = rate;
    ch.tremoloDepth = MAX(0.0f, MIN(depth / 100.0f, 1.0f));
    ch.triggerFreq = YES;
}

-(void)setFadeInternal:(ChannelStateObjC*)ch targetVolume:(float)targetVolume speed:(float)speed state:(int)state {
    ch.volOrigin = targetVolume;
    ch.fadeSpeed = speed;
    ch.fadeState = state;
}

-(void)setVolLFOInternal:(ChannelStateObjC*)ch rate:(float)rate depth:(float)depth {
    ch.volLFOTrigger = (rate > 0) ? 1 : 0;
    ch.volLFORate = rate;
    ch.volLFODepth = depth;
    ch.volLFOPhase = 0.0f;
}

-(void)setADSRInternal:(ChannelStateObjC*)ch attack:(float)attack decay:(float)decay sustain:(float)sustain release:(float)release {
    ch.adsrAttack = attack;
    ch.adsrDecay = decay;
    ch.adsrSustain = sustain;
    ch.adsrRelease = release;
    ch.adsrTimer = 0.0f;
    ch.adsrStartVol = ch.volume;
    ch.adsrState = (attack > 0) ? 1 : ((decay > 0) ? 2 : 3);
}

-(void)setRandPitchInternal:(ChannelStateObjC*)ch range:(float)range {
    float offset = ((float)rand() / RAND_MAX) * 2.0f * range - range;
    ch.freqRate = MAX(ch.freqMin, MIN(ch.freqMax, ch.freqOrigin + offset));
    ch.lastFreq = -1.0f;
    ch.triggerFreq = YES;
}

-(void)setOriginFreqInternal:(ChannelStateObjC*)ch freq:(float)freq {
    ch.freqOrigin = freq;
    ch.freqRate = freq;
    ch.freqTarget = freq;
    ch.freqMin = freq / 8.0f;
    ch.freqMax = freq * 8.0f;
    ch.lastFreq = -1.0f;
    ch.triggerFreq = YES;
}

-(void)action:(int)num withActExtension:(CActExtension*)act {
    int id;
    float rate, depth, volume, speed, pan, range, freq, targetVolume, attack, decay, sustain, release;
    int loopFlag, startMs, endMs, fadeState, direction;
    NSString* filename;
    ChannelStateObjC* c;
    
    switch (num) {
        case 0:
            id = [act getParamExpression:self.rh withNum:0];
            filename = [act getParamExpString:self.rh withNum:1];
            loopFlag = [act getParamExpression:self.rh withNum:2];
            startMs = [act getParamExpression:self.rh withNum:3];
            endMs = [act getParamExpression:self.rh withNum:4];
            volume = (float)[act getParamExpression:self.rh withNum:5];
            freq = (float)[act getParamExpression:self.rh withNum:6];
            
            c = nil;
            if (id == 0) {
                for (int i = 0; i < 48; i++) {
                    ChannelStateObjC* tc = channels[i];
                    if (tc.playingState == 3) { c = tc; break; }
                }
                if (c == nil) c = channels[0];
            } else {
                c = [self getChannel:id];
            }
            if (c != nil) {
                c.soundName = filename;
                [c.trackQueue removeAllObjects];
                c.loopFlag = loopFlag;
                c.loopStart = startMs;
                c.loopEnd = endMs;
                c.volume = volume;
                c.volOrigin = volume;
                c.freqRate = (freq > 0.0f) ? freq : 44100.0f;
                c.freqOrigin = c.freqRate;
                c.freqTarget = c.freqRate;
                c.playingState = 1;
                c.fadeState = 0;
                c.adsrState = 0;
                c.autoReleaseTimer = (loopFlag != 0) ? 2.5f : -1.0f;
                c.triggerPlay = YES;
                c.triggerVolume = YES;
                c.triggerFreq = YES;
            }
            break;
        case 1:
            id = [act getParamExpression:self.rh withNum:0];
            if (id == -1) { for (ChannelStateObjC* ch in channels) { ch.playingState = 3; ch.triggerStop = YES; } }
            else { c = [self getChannel:id]; if (c != nil) { c.playingState = 3; c.triggerStop = YES; } }
            break;
        case 2:
            id = [act getParamExpression:self.rh withNum:0];
            if (id == -1) { for (ChannelStateObjC* ch in channels) { ch.playingState = 2; ch.triggerPause = YES; } }
            else { c = [self getChannel:id]; if (c != nil) { c.playingState = 2; c.triggerPause = YES; } }
            break;
        case 3:
            id = [act getParamExpression:self.rh withNum:0];
            if (id == -1) { for (ChannelStateObjC* ch in channels) { ch.playingState = 1; ch.triggerResume = YES; } }
            else { c = [self getChannel:id]; if (c != nil) { c.playingState = 1; c.triggerResume = YES; } }
            break;
        case 4:
            id = [act getParamExpression:self.rh withNum:0];
            filename = [act getParamExpString:self.rh withNum:1];
            speed = (float)[act getParamExpression:self.rh withNum:2];
            float fIn = (float)[act getParamExpression:self.rh withNum:3];
            c = [self getChannel:id];
            if (c != nil) {
                [c.trackQueue removeAllObjects];
                [c.trackQueue addObject:filename];
                c.fadeState = -1;
                c.fadeSpeed = speed;
                c.nextFadeInSpeed = fIn;
            }
            break;
        case 5:
            id = [act getParamExpression:self.rh withNum:0];
            volume = (float)[act getParamExpression:self.rh withNum:1];
            if (id == -1) { for (ChannelStateObjC* ch in channels) { ch.volume = volume; ch.volOrigin = volume; ch.triggerVolume = YES; } }
            else { c = [self getChannel:id]; if (c != nil) { c.volume = volume; c.volOrigin = volume; c.triggerVolume = YES; } }
            break;
        case 6:
            id = [act getParamExpression:self.rh withNum:0];
            freq = (float)[act getParamExpression:self.rh withNum:1];
            speed = (float)[act getParamExpression:self.rh withNum:2];
            direction = [act getParamExpression:self.rh withNum:3];
            if (id == -1) { for (ChannelStateObjC* ch in channels) [self setFreqInternal:ch freq:freq speed:speed direction:direction]; }
            else { c = [self getChannel:id]; if (c != nil) [self setFreqInternal:c freq:freq speed:speed direction:direction]; }
            break;
        case 7:
            id = [act getParamExpression:self.rh withNum:0];
            pan = (float)[act getParamExpression:self.rh withNum:1];
            if (id == -1) { for (ChannelStateObjC* ch in channels) { ch.pan = pan; ch.triggerPan = YES; } }
            else { c = [self getChannel:id]; if (c != nil) { c.pan = pan; c.triggerPan = YES; } }
            break;
        case 8:
            id = [act getParamExpression:self.rh withNum:0];
            rate = (float)[act getParamExpression:self.rh withNum:1];
            depth = (float)[act getParamExpression:self.rh withNum:2];
            if (id == -1) { for (ChannelStateObjC* ch in channels) [self setTremoloInternal:ch rate:rate depth:depth]; }
            else { c = [self getChannel:id]; if (c != nil) [self setTremoloInternal:c rate:rate depth:depth]; }
            break;
        case 9:
            id = [act getParamExpression:self.rh withNum:0];
            targetVolume = (float)[act getParamExpression:self.rh withNum:1];
            speed = (float)[act getParamExpression:self.rh withNum:2];
            fadeState = [act getParamExpression:self.rh withNum:3];
            if (id == -1) { for (ChannelStateObjC* ch in channels) [self setFadeInternal:ch targetVolume:targetVolume speed:speed state:fadeState]; }
            else { c = [self getChannel:id]; if (c != nil) [self setFadeInternal:c targetVolume:targetVolume speed:speed state:fadeState]; }
            break;
        case 10:
            id = [act getParamExpression:self.rh withNum:0];
            filename = [act getParamExpString:self.rh withNum:1];
            if (id == -1) { for (ChannelStateObjC* ch in channels) [ch.trackQueue addObject:filename]; }
            else { c = [self getChannel:id]; if (c != nil) [c.trackQueue addObject:filename]; }
            break;
        case 11:
            id = [act getParamExpression:self.rh withNum:0];
            if (id == -1) { for (ChannelStateObjC* ch in channels) [ch.trackQueue removeAllObjects]; }
            else { c = [self getChannel:id]; if (c != nil) [c.trackQueue removeAllObjects]; }
            break;
        case 12:
            id = [act getParamExpression:self.rh withNum:0];
            rate = (float)[act getParamExpression:self.rh withNum:1];
            depth = (float)[act getParamExpression:self.rh withNum:2];
            if (id == -1) { for (ChannelStateObjC* ch in channels) [self setVolLFOInternal:ch rate:rate depth:depth]; }
            else { c = [self getChannel:id]; if (c != nil) [self setVolLFOInternal:c rate:rate depth:depth]; }
            break;
        case 13:
            id = [act getParamExpression:self.rh withNum:0];
            attack = (float)[act getParamExpression:self.rh withNum:1];
            decay = (float)[act getParamExpression:self.rh withNum:2];
            sustain = (float)[act getParamExpression:self.rh withNum:3];
            release = (float)[act getParamExpression:self.rh withNum:4];
            if (id == -1) { for (ChannelStateObjC* ch in channels) [self setADSRInternal:ch attack:attack decay:decay sustain:sustain release:release]; }
            else { c = [self getChannel:id]; if (c != nil) [self setADSRInternal:c attack:attack decay:decay sustain:sustain release:release]; }
            break;
        case 14:
            id = [act getParamExpression:self.rh withNum:0];
            range = (float)[act getParamExpression:self.rh withNum:1];
            if (id == -1) { for (ChannelStateObjC* ch in channels) [self setRandPitchInternal:ch range:range]; }
            else { c = [self getChannel:id]; if (c != nil) [self setRandPitchInternal:c range:range]; }
            break;
        case 15:
            id = [act getParamExpression:self.rh withNum:0]; // fromId
            int toId = [act getParamExpression:self.rh withNum:1];
            speed = (float)[act getParamExpression:self.rh withNum:2];
            ChannelStateObjC* cfFrom = [self getChannel:id];
            ChannelStateObjC* cfTo = [self getChannel:toId];
            if (cfFrom != nil) [self setFadeInternal:cfFrom targetVolume:0.0f speed:speed state:-1];
            if (cfTo != nil) [self setFadeInternal:cfTo targetVolume:100.0f speed:speed state:1];
            break;
        case 16:
            id = [act getParamExpression:self.rh withNum:0];
            freq = (float)[act getParamExpression:self.rh withNum:1];
            if (id == -1) { for (ChannelStateObjC* ch in channels) [self setOriginFreqInternal:ch freq:freq]; }
            else { c = [self getChannel:id]; if (c != nil) [self setOriginFreqInternal:c freq:freq]; }
            break;
        case 17:
            for (ChannelStateObjC* ch in channels) { ch.playingState = 3; ch.triggerStop = YES; }
            break;
        case 18:
            for (ChannelStateObjC* ch in channels) { ch.playingState = 2; ch.triggerPause = YES; }
            break;
        case 19:
            for (ChannelStateObjC* ch in channels) { ch.playingState = 1; ch.triggerResume = YES; }
            break;
        case 20:
            volume = (float)[act getParamExpression:self.rh withNum:0];
            for (ChannelStateObjC* ch in channels) { ch.volume = volume; ch.volOrigin = volume; ch.triggerVolume = YES; }
            break;
        case 21:
            freq = (float)[act getParamExpression:self.rh withNum:0];
            speed = (float)[act getParamExpression:self.rh withNum:1];
            direction = [act getParamExpression:self.rh withNum:2];
            for (ChannelStateObjC* ch in channels) [self setFreqInternal:ch freq:freq speed:speed direction:direction];
            break;
        case 22:
            pan = (float)[act getParamExpression:self.rh withNum:0];
            for (ChannelStateObjC* ch in channels) { ch.pan = pan; ch.triggerPan = YES; }
            break;
        case 23:
            rate = (float)[act getParamExpression:self.rh withNum:0];
            depth = (float)[act getParamExpression:self.rh withNum:1];
            for (ChannelStateObjC* ch in channels) [self setTremoloInternal:ch rate:rate depth:depth];
            break;
        case 24:
            targetVolume = (float)[act getParamExpression:self.rh withNum:0];
            speed = (float)[act getParamExpression:self.rh withNum:1];
            fadeState = [act getParamExpression:self.rh withNum:2];
            for (ChannelStateObjC* ch in channels) [self setFadeInternal:ch targetVolume:targetVolume speed:speed state:fadeState];
            break;
        case 25:
            rate = (float)[act getParamExpression:self.rh withNum:0];
            depth = (float)[act getParamExpression:self.rh withNum:1];
            for (ChannelStateObjC* ch in channels) [self setVolLFOInternal:ch rate:rate depth:depth];
            break;
        case 26:
            attack = (float)[act getParamExpression:self.rh withNum:0];
            decay = (float)[act getParamExpression:self.rh withNum:1];
            sustain = (float)[act getParamExpression:self.rh withNum:2];
            release = (float)[act getParamExpression:self.rh withNum:3];
            for (ChannelStateObjC* ch in channels) [self setADSRInternal:ch attack:attack decay:decay sustain:sustain release:release];
            break;
        case 27:
            range = (float)[act getParamExpression:self.rh withNum:0];
            for (ChannelStateObjC* ch in channels) [self setRandPitchInternal:ch range:range];
            break;
        case 28:
            freq = (float)[act getParamExpression:self.rh withNum:0];
            for (ChannelStateObjC* ch in channels) [self setOriginFreqInternal:ch freq:freq];
            break;
        case 29:
            id = [act getParamExpression:self.rh withNum:0];
            c = [self getChannel:id];
            if (c != nil) {
                c.playingState = 3;
                c.fadeState = 0;
                c.adsrState = 0;
                c.autoReleaseTimer = 0.0f;
            }
            break;
    }
}

-(CValue*)expression:(int)num {
    int id;
    ChannelStateObjC* ch;
    switch (num) {
        case 0:
            id = [[self.ho getExpParam] getInt];
            ch = [self getChannel:id];
            return [[CValue alloc] initWithString:(ch != nil ? ch.soundName : @"")];
        case 1:
            id = [[self.ho getExpParam] getInt];
            ch = [self getChannel:id];
            return [[CValue alloc] initWithInt:(ch != nil ? ch.loopFlag : 0)];
        case 2:
            id = [[self.ho getExpParam] getInt];
            ch = [self getChannel:id];
            return [[CValue alloc] initWithDouble:(ch != nil ? ch.volume : 0.0)];
        case 3:
            id = [[self.ho getExpParam] getInt];
            ch = [self getChannel:id];
            return [[CValue alloc] initWithDouble:(ch != nil ? ch.freqRate : 0.0)];
        case 4:
            id = [[self.ho getExpParam] getInt];
            ch = [self getChannel:id];
            return [[CValue alloc] initWithInt:(ch != nil ? ch.positionMs : 0)];
        case 5:
            id = [[self.ho getExpParam] getInt];
            ch = [self getChannel:id];
            return [[CValue alloc] initWithDouble:(ch != nil ? ch.pan : 0.0)];
        case 6: return [[CValue alloc] initWithInt:triggeredChannel];
        case 7: return [[CValue alloc] initWithString:triggeredName];
        case 8: return [[CValue alloc] initWithDouble:triggeredVolume];
        case 9: return [[CValue alloc] initWithDouble:triggeredFrequency];
        case 10: return [[CValue alloc] initWithDouble:triggeredPan];
        case 11: return [[CValue alloc] initWithInt:triggeredPosition];
        case 12: return [[CValue alloc] initWithInt:triggeredLoop];
        case 13:
            id = [[self.ho getExpParam] getInt];
            ch = [self getChannel:id];
            return [[CValue alloc] initWithInt:(ch != nil ? ch.playingState : 3)];
        case 14: return [[CValue alloc] initWithDouble:customTimer];
        case 15:
            id = [[self.ho getExpParam] getInt];
            ch = [self getChannel:id];
            return [[CValue alloc] initWithDouble:(ch != nil ? ch.freqOrigin : 0.0)];
        case 16:
            ch = [self getChannel:triggeredChannel];
            return [[CValue alloc] initWithDouble:(ch != nil ? ch.freqOrigin : 0.0)];
        case 17:
            id = [[self.ho getExpParam] getInt];
            int pct = [[self.ho getExpParam] getInt];
            ch = [self getChannel:id];
            return [[CValue alloc] initWithDouble:(ch != nil ? ch.freqOrigin * (pct / 100.0) : 0.0)];
        default:
            return [[CValue alloc] initWithInt:0];
    }
}

@end

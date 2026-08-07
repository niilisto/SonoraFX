package Extensions;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import RunLoop.CRunExtension;
import Services.CFile;
import Services.CCreateObjectInfo;

import java.util.ArrayList;
import java.util.LinkedList;

public class CRunSonoraFX extends CRunExtension {

    // --- CONDITIONS ---
    public static final int CND_ON_PLAY = 0;
    public static final int CND_ON_STOP = 1;
    public static final int CND_ON_PAUSE = 2;
    public static final int CND_ON_RESUME = 3;
    public static final int CND_ON_SET_VOLUME = 4;
    public static final int CND_ON_SET_FREQUENCY = 5;
    public static final int CND_ON_SET_POSITION = 6;
    public static final int CND_ON_SET_PAN = 7;
    public static final int CND_IS_PLAYING = 8;
    public static final int CND_IS_PAUSED = 9;
    public static final int CND_IS_STOPPED = 10;
    public static final int CND_ON_FADE_COMPLETE = 11;
    public static final int CND_ON_ANY_PLAY = 12;
    public static final int CND_ON_ANY_STOP = 13;
    public static final int CND_ON_ANY_PAUSE = 14;
    public static final int CND_ON_ANY_RESUME = 15;
    public static final int CND_ON_ANY_SET_VOLUME = 16;
    public static final int CND_ON_ANY_SET_FREQUENCY = 17;
    public static final int CND_ON_ANY_SET_POSITION = 18;
    public static final int CND_ON_ANY_SET_PAN = 19;
    public static final int CND_ON_ANY_FADE_COMPLETE = 20;
    public static final int CND_LAST = 21;

    // --- ACTIONS ---
    public static final int ACT_PLAYAUDIO = 0;
    public static final int ACT_STOPAUDIO = 1;
    public static final int ACT_PAUSEAUDIO = 2;
    public static final int ACT_RESUMEAUDIO = 3;
    public static final int ACT_QUEUEAUDIO = 4;
    public static final int ACT_SETVOLUME = 5;
    public static final int ACT_SETFREQUENCY = 6;
    public static final int ACT_SETPAN = 7;
    public static final int ACT_ENABLETREMOLO = 8;
    public static final int ACT_FADECHANNEL = 9;
    public static final int ACT_ENQUEUETRACK = 10;
    public static final int ACT_CLEARQUEUE = 11;
    public static final int ACT_ENABLEVOLUMELFO = 12;
    public static final int ACT_SETADSR = 13;
    public static final int ACT_RANDOMIZEPITCH = 14;
    public static final int ACT_CROSSFADE = 15;
    public static final int ACT_SETORIGINFREQUENCY = 16;
    public static final int ACT_STOPALLCHANNELS = 17;
    public static final int ACT_PAUSEALLCHANNELS = 18;
    public static final int ACT_RESUMEALLCHANNELS = 19;
    public static final int ACT_SETALLVOLUMES = 20;
    public static final int ACT_SETALLFREQUENCYSWEEPS = 21;
    public static final int ACT_SETALLPANNING = 22;
    public static final int ACT_ENABLEALLTREMOLOS = 23;
    public static final int ACT_FADEALLCHANNELS = 24;
    public static final int ACT_ENABLEALLVOLUMELFOS = 25;
    public static final int ACT_SETALLADSRENVELOPES = 26;
    public static final int ACT_RANDOMIZEALLPITCHES = 27;
    public static final int ACT_SETALLORIGINFREQUENCIES = 28;
    public static final int ACT_SETCHANNELSTOPPED = 29;

    // --- EXPRESSIONS ---
    public static final int EXP_GETPLAYSOUNDNAME = 0;
    public static final int EXP_GETPLAYLOOPS = 1;
    public static final int EXP_GETVOLUME = 2;
    public static final int EXP_GETFREQUENCY = 3;
    public static final int EXP_GETPOSITION = 4;
    public static final int EXP_GETPAN = 5;
    public static final int EXP_GETTRIGGEREDCHANNEL = 6;
    public static final int EXP_GETTRIGGEREDNAME = 7;
    public static final int EXP_GETTRIGGEREDVOLUME = 8;
    public static final int EXP_GETTRIGGEREDFREQUENCY = 9;
    public static final int EXP_GETTRIGGEREDPAN = 10;
    public static final int EXP_GETTRIGGEREDPOSITION = 11;
    public static final int EXP_GETTRIGGEREDLOOPS = 12;
    public static final int EXP_GETPLAYSTATE = 13;
    public static final int EXP_GETCUSTOMTIMER = 14;
    public static final int EXP_GETFREQORIGIN = 15;
    public static final int EXP_GETTRIGGEREDFREQORIGIN = 16;
    public static final int EXP_GETFREQORIGINPCT = 17;

    // --- STATE MACHINE STRUCTURES ---
    class ChannelState {
        int id = 0;
        String soundName = "";
        LinkedList<String> trackQueue = new LinkedList<>();
        
        float volume = 100.0f;
        float volOrigin = 100.0f;
        int fadeState = 0;
        float fadeSpeed = 2.0f;
        float nextFadeInSpeed = 2.0f;
        boolean triggerFadeComplete = false;

        int volLFOTrigger = 0;
        float volLFORate = 4.0f;
        float volLFODepth = 30.0f;
        float volLFOPhase = 0.0f;

        int adsrState = 0;
        float adsrAttack = 0.0f;
        float adsrDecay = 0.0f;
        float adsrSustain = 100.0f;
        float adsrRelease = 0.0f;
        float adsrTimer = 0.0f;
        float adsrStartVol = 0.0f;

        float freqRate = 44100.0f;
        float freqSpeed = 200.0f;
        int freqDirection = 0;
        float freqOrigin = 44100.0f;
        float freqTarget = 44100.0f;
        float freqMin = 5512.5f;
        float freqMax = 352800.0f;
        float freqLFOPhase = 0.0f;

        int tremoloTrigger = 0;
        float tremoloRate = 4.0f;
        float tremoloPhase = 0.0f;
        float tremoloDepth = 0.15f;

        int loopFlag = 0;
        int loopStart = 0;
        int loopEnd = 0;
        int playingState = 3;
        int positionMs = 0;
        float pan = 0.0f;
        float autoReleaseTimer = 0.0f;

        boolean triggerPlay = false;
        boolean triggerStop = false;
        boolean triggerPause = false;
        boolean triggerResume = false;
        boolean triggerVolume = false;
        boolean triggerFreq = false;
        boolean triggerPosition = false;
        boolean triggerPan = false;

        float lastVolume = -999.0f;
        float lastFreq = -999.0f;
        int lastPosition = -999;
        float lastPan = -999.0f;
    }

    private ChannelState[] channels = new ChannelState[48];
    private float customTimer = 0.0f;
    private long lastTime = 0;

    // Triggered properties
    public int triggeredChannel = -1;
    public String triggeredName = "";
    public int triggeredLoop = 0;
    public float triggeredVolume = 100.0f;
    public float triggeredFrequency = 44100.0f;
    public int triggeredPosition = 0;
    public float triggeredPan = 0.0f;

    @Override
    public int getNumberOfConditions() {
        return CND_LAST;
    }

    @Override
    public boolean createRunObject(CFile file, CCreateObjectInfo cob, int version) {
        for (int i = 0; i < 48; i++) {
            channels[i] = new ChannelState();
            channels[i].id = i + 1;
        }
        lastTime = System.currentTimeMillis();
        return false; // Not a displayable object
    }

    private ChannelState getChannel(int id) {
        if (id < 1 || id > 48) return null;
        return channels[id - 1];
    }

    @Override
    public int handleRunObject() {
        long currentTime = System.currentTimeMillis();
        float deltaTime = (currentTime - lastTime) / 1000.0f;
        lastTime = currentTime;
        customTimer += deltaTime;

        for (ChannelState ch : channels) {
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
                        ch.triggerFadeComplete = true;
                    }
                } else if (ch.fadeState == -1) {
                    if (ch.volume <= 0.0f) {
                        ch.volume = 0.0f;
                        ch.fadeState = 0;
                        ch.triggerFadeComplete = true;
                        ch.playingState = 3;
                        ch.triggerStop = true;

                        if (!ch.trackQueue.isEmpty()) {
                            ch.soundName = ch.trackQueue.removeFirst();
                            ch.volume = 0.0f;
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
                ch.adsrTimer += 1.0f;
                switch (ch.adsrState) {
                    case 1:
                        float t1 = (ch.adsrAttack > 0) ? (ch.adsrTimer / ch.adsrAttack) : 1.0f;
                        ch.volume = ch.adsrStartVol + t1 * (ch.volOrigin - ch.adsrStartVol);
                        if (ch.adsrTimer >= ch.adsrAttack) {
                            ch.volume = ch.volOrigin;
                            ch.adsrTimer = 0.0f;
                            ch.adsrStartVol = ch.volume;
                            ch.adsrState = (ch.adsrDecay > 0) ? 2 : 3;
                        }
                        ch.triggerVolume = true;
                        break;
                    case 2:
                        float t2 = (ch.adsrDecay > 0) ? (ch.adsrTimer / ch.adsrDecay) : 1.0f;
                        ch.volume = ch.volOrigin + t2 * (ch.adsrSustain - ch.volOrigin);
                        if (ch.adsrTimer >= ch.adsrDecay) {
                            ch.volume = ch.adsrSustain;
                            ch.adsrTimer = 0.0f;
                            ch.adsrStartVol = ch.volume;
                            ch.adsrState = 3;
                        }
                        ch.triggerVolume = true;
                        break;
                    case 3:
                        break;
                    case 4:
                        float t4 = (ch.adsrRelease > 0) ? (ch.adsrTimer / ch.adsrRelease) : 1.0f;
                        ch.volume = ch.adsrStartVol * (1.0f - t4);
                        if (ch.adsrTimer >= ch.adsrRelease) {
                            ch.volume = 0.0f;
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
                ch.volLFOPhase += deltaTime * ch.volLFORate * 2.0f * (float)Math.PI;
                if (ch.volLFOPhase > 2.0f * Math.PI) ch.volLFOPhase -= 2.0f * Math.PI;
                float lfoVal = (float)Math.sin(ch.volLFOPhase);
                float depth = ch.volLFODepth / 100.0f;
                ch.volume = ch.volOrigin * (1.0f + depth * lfoVal);
                ch.volume = Math.max(0.0f, Math.min(100.0f, ch.volume));
                ch.triggerVolume = true;
            }

            // 4. Frequency
            float prevFreq = ch.freqRate;
            switch (ch.freqDirection) {
                case -1: ch.freqRate = Math.max(ch.freqRate - ch.freqSpeed, ch.freqTarget); break;
                case 1: ch.freqRate = Math.min(ch.freqRate + ch.freqSpeed, ch.freqTarget); break;
                case 2: ch.freqRate = ch.freqOrigin + (float)Math.sin(customTimer * ch.freqSpeed * 0.01f) * 8000.0f; break;
                case 3: ch.freqRate = Math.max(ch.freqRate - ch.freqSpeed, 0.0f); break;
                case 4:
                    ch.freqLFOPhase += deltaTime * ch.freqSpeed * 0.01f;
                    float t4 = ch.freqLFOPhase % 1.0f;
                    float tri = (t4 < 0.5f) ? (4.0ff * t4 - 1.0f) : (3.0f - 4.0f * t4);
                    ch.freqRate = ch.freqOrigin + tri * 8000.0f;
                    break;
                case 5:
                    ch.freqLFOPhase += deltaTime * ch.freqSpeed * 0.01f;
                    float t5 = ch.freqLFOPhase % 1.0f;
                    ch.freqRate = ch.freqOrigin + ((t5 < 0.5f) ? 8000.0f : -8000.0f);
                    break;
                case 6:
                    ch.freqLFOPhase += deltaTime * ch.freqSpeed * 0.01f;
                    float t6 = ch.freqLFOPhase % 1.0f;
                    ch.freqRate = ch.freqOrigin + (2.0f * t6 - 1.0f) * 8000.0f;
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
                ch.tremoloPhase += deltaTime * ch.tremoloRate * 2.0f * (float)Math.PI;
                if (ch.tremoloPhase > 2.0f * Math.PI) ch.tremoloPhase -= 2.0f * Math.PI;
                ch.triggerFreq = true;
            }

            // Deduplication
            if (ch.triggerVolume && ch.volume == ch.lastVolume) ch.triggerVolume = false;
            
            if (ch.triggerFreq) {
                float finalFreq = ch.freqRate;
                if (ch.tremoloTrigger == 1) finalFreq = ch.freqRate * (1.0f + ch.tremoloDepth * (float)Math.sin(ch.tremoloPhase));
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
                float finalFreq = ch.freqRate;
                if (ch.tremoloTrigger == 1) finalFreq = ch.freqRate * (1.0f + ch.tremoloDepth * (float)Math.sin(ch.tremoloPhase));
                triggeredFrequency = finalFreq;
                ch.lastFreq = finalFreq;
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
        return 0; // Not 0 means keep calling handleRunObject
    }

    @Override
    public boolean condition(int num, CCndExtension cnd) {
        int channelId;
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
                    for (ChannelState ch : channels) if (ch.playingState == 1) return true;
                    return false;
                }
                ChannelState c1 = getChannel(channelId);
                return c1 != null && c1.playingState == 1;
            case CND_IS_PAUSED:
                channelId = cnd.getParamExpression(rh, 0);
                if (channelId == -1) {
                    for (ChannelState ch : channels) if (ch.playingState == 2) return true;
                    return false;
                }
                ChannelState c2 = getChannel(channelId);
                return c2 != null && c2.playingState == 2;
            case CND_IS_STOPPED:
                channelId = cnd.getParamExpression(rh, 0);
                if (channelId == -1) {
                    for (ChannelState ch : channels) if (ch.playingState == 3) return true;
                    return false;
                }
                ChannelState c3 = getChannel(channelId);
                return c3 != null && c3.playingState == 3;
            default:
                return true; // ON_ANY_*
        }
    }

    @Override
    public void action(int num, CActExtension act) {
        int id;
        float rate, depth, volume, speed, pan, range, freq, targetVolume, attack, decay, sustain, release;
        int loopFlag, startMs, endMs, fadeState, direction;
        String filename;

        switch (num) {
            case ACT_PLAYAUDIO:
                id = act.getParamExpression(rh, 0);
                filename = act.getParamExpString(rh, 1);
                loopFlag = act.getParamExpression(rh, 2);
                startMs = act.getParamExpression(rh, 3);
                endMs = act.getParamExpression(rh, 4);
                volume = act.getParamExpression(rh, 5);
                freq = act.getParamExpression(rh, 6);
                
                ChannelState ch = null;
                if (id == 0) {
                    for (int i = 0; i < 48; i++) {
                        if (channels[i].playingState == 3) { ch = channels[i]; break; }
                    }
                    if (ch == null) ch = channels[0]; // fallback
                } else {
                    ch = getChannel(id);
                }
                if (ch != null) {
                    ch.soundName = filename;
                    ch.trackQueue.clear();
                    ch.loopFlag = loopFlag;
                    ch.loopStart = startMs;
                    ch.loopEnd = endMs;
                    ch.volume = volume;
                    ch.volOrigin = volume;
                    ch.freqRate = (freq > 0.0f) ? freq : 44100.0f;
                    ch.freqOrigin = ch.freqRate;
                    ch.freqTarget = ch.freqRate;
                    ch.playingState = 1;
                    ch.fadeState = 0;
                    ch.adsrState = 0;
                    ch.autoReleaseTimer = (loopFlag != 0) ? 2.5f : -1.0f;
                    ch.triggerPlay = true;
                    ch.triggerVolume = true;
                    ch.triggerFreq = true;
                }
                break;
            case ACT_STOPAUDIO:
                id = act.getParamExpression(rh, 0);
                if (id == -1) { for (ChannelState c : channels) { c.playingState = 3; c.triggerStop = true; } }
                else { ChannelState c = getChannel(id); if (c != null) { c.playingState = 3; c.triggerStop = true; } }
                break;
            case ACT_PAUSEAUDIO:
                id = act.getParamExpression(rh, 0);
                if (id == -1) { for (ChannelState c : channels) { c.playingState = 2; c.triggerPause = true; } }
                else { ChannelState c = getChannel(id); if (c != null) { c.playingState = 2; c.triggerPause = true; } }
                break;
            case ACT_RESUMEAUDIO:
                id = act.getParamExpression(rh, 0);
                if (id == -1) { for (ChannelState c : channels) { c.playingState = 1; c.triggerResume = true; } }
                else { ChannelState c = getChannel(id); if (c != null) { c.playingState = 1; c.triggerResume = true; } }
                break;
            case ACT_QUEUEAUDIO:
                id = act.getParamExpression(rh, 0);
                filename = act.getParamExpString(rh, 1);
                float fadeOutSpeed = act.getParamExpDouble(rh, 2);
                float fadeInSpeed = act.getParamExpDouble(rh, 3);
                ChannelState cq = getChannel(id);
                if (cq != null) {
                    cq.trackQueue.clear();
                    cq.trackQueue.add(filename);
                    cq.fadeState = -1;
                    cq.fadeSpeed = fadeOutSpeed;
                    cq.nextFadeInSpeed = fadeInSpeed;
                }
                break;
            case ACT_SETVOLUME:
                id = act.getParamExpression(rh, 0);
                volume = act.getParamExpression(rh, 1);
                if (id == -1) { for (ChannelState c : channels) { c.volume = volume; c.volOrigin = volume; c.triggerVolume = true; } }
                else { ChannelState c = getChannel(id); if (c != null) { c.volume = volume; c.volOrigin = volume; c.triggerVolume = true; } }
                break;
            case ACT_SETFREQUENCY:
                id = act.getParamExpression(rh, 0);
                freq = act.getParamExpression(rh, 1);
                speed = act.getParamExpression(rh, 2);
                direction = act.getParamExpression(rh, 3);
                if (id == -1) { for (ChannelState c : channels) setFreqInternal(c, freq, speed, direction); }
                else { ChannelState c = getChannel(id); if (c != null) setFreqInternal(c, freq, speed, direction); }
                break;
            case ACT_SETPAN:
                id = act.getParamExpression(rh, 0);
                pan = act.getParamExpression(rh, 1);
                if (id == -1) { for (ChannelState c : channels) { c.pan = pan; c.triggerPan = true; } }
                else { ChannelState c = getChannel(id); if (c != null) { c.pan = pan; c.triggerPan = true; } }
                break;
            case ACT_ENABLETREMOLO:
                id = act.getParamExpression(rh, 0);
                rate = act.getParamExpression(rh, 1);
                depth = act.getParamExpression(rh, 2);
                if (id == -1) { for (ChannelState c : channels) setTremoloInternal(c, rate, depth); }
                else { ChannelState c = getChannel(id); if (c != null) setTremoloInternal(c, rate, depth); }
                break;
            case ACT_FADECHANNEL:
                id = act.getParamExpression(rh, 0);
                targetVolume = act.getParamExpression(rh, 1);
                speed = act.getParamExpression(rh, 2);
                fadeState = act.getParamExpression(rh, 3);
                if (id == -1) { for (ChannelState c : channels) setFadeInternal(c, targetVolume, speed, fadeState); }
                else { ChannelState c = getChannel(id); if (c != null) setFadeInternal(c, targetVolume, speed, fadeState); }
                break;
            case ACT_ENQUEUETRACK:
                id = act.getParamExpression(rh, 0);
                filename = act.getParamExpString(rh, 1);
                if (id == -1) { for (ChannelState c : channels) c.trackQueue.add(filename); }
                else { ChannelState c = getChannel(id); if (c != null) c.trackQueue.add(filename); }
                break;
            case ACT_CLEARQUEUE:
                id = act.getParamExpression(rh, 0);
                if (id == -1) { for (ChannelState c : channels) c.trackQueue.clear(); }
                else { ChannelState c = getChannel(id); if (c != null) c.trackQueue.clear(); }
                break;
            case ACT_ENABLEVOLUMELFO:
                id = act.getParamExpression(rh, 0);
                rate = act.getParamExpression(rh, 1);
                depth = act.getParamExpression(rh, 2);
                if (id == -1) { for (ChannelState c : channels) setVolLFOInternal(c, rate, depth); }
                else { ChannelState c = getChannel(id); if (c != null) setVolLFOInternal(c, rate, depth); }
                break;
            case ACT_SETADSR:
                id = act.getParamExpression(rh, 0);
                attack = act.getParamExpression(rh, 1);
                decay = act.getParamExpression(rh, 2);
                sustain = act.getParamExpression(rh, 3);
                release = act.getParamExpression(rh, 4);
                if (id == -1) { for (ChannelState c : channels) setADSRInternal(c, attack, decay, sustain, release); }
                else { ChannelState c = getChannel(id); if (c != null) setADSRInternal(c, attack, decay, sustain, release); }
                break;
            case ACT_RANDOMIZEPITCH:
                id = act.getParamExpression(rh, 0);
                range = act.getParamExpression(rh, 1);
                if (id == -1) { for (ChannelState c : channels) setRandPitchInternal(c, range); }
                else { ChannelState c = getChannel(id); if (c != null) setRandPitchInternal(c, range); }
                break;
            case ACT_CROSSFADE:
                int fromId = act.getParamExpression(rh, 0);
                int toId = act.getParamExpression(rh, 1);
                speed = act.getParamExpression(rh, 2);
                ChannelState cfFrom = getChannel(fromId);
                ChannelState cfTo = getChannel(toId);
                if (cfFrom != null) setFadeInternal(cfFrom, 0.0f, speed, -1);
                if (cfTo != null) setFadeInternal(cfTo, 100.0f, speed, 1);
                break;
            case ACT_SETORIGINFREQUENCY:
                id = act.getParamExpression(rh, 0);
                freq = act.getParamExpDouble(rh, 1);
                if (id == -1) { for (ChannelState c : channels) setOriginFreqInternal(c, freq); }
                else { ChannelState c = getChannel(id); if (c != null) setOriginFreqInternal(c, freq); }
                break;
            // The ALL variants:
            case ACT_STOPALLCHANNELS: action(ACT_STOPAUDIO, new CActParamOverride(-1)); break;
            case ACT_PAUSEALLCHANNELS: action(ACT_PAUSEAUDIO, new CActParamOverride(-1)); break;
            case ACT_RESUMEALLCHANNELS: action(ACT_RESUMEAUDIO, new CActParamOverride(-1)); break;
            case ACT_SETALLVOLUMES: 
                volume = act.getParamExpression(rh, 0);
                for (ChannelState c : channels) { c.volume = volume; c.volOrigin = volume; c.triggerVolume = true; }
                break;
            case ACT_SETALLFREQUENCYSWEEPS:
                freq = act.getParamExpDouble(rh, 0);
                speed = act.getParamExpDouble(rh, 1);
                direction = act.getParamExpression(rh, 2);
                for (ChannelState c : channels) setFreqInternal(c, freq, speed, direction);
                break;
            case ACT_SETALLPANNING:
                pan = act.getParamExpression(rh, 0);
                for (ChannelState c : channels) { c.pan = pan; c.triggerPan = true; }
                break;
            case ACT_ENABLEALLTREMOLOS:
                rate = act.getParamExpression(rh, 0);
                depth = act.getParamExpression(rh, 1);
                for (ChannelState c : channels) setTremoloInternal(c, rate, depth);
                break;
            case ACT_FADEALLCHANNELS:
                targetVolume = act.getParamExpression(rh, 0);
                speed = act.getParamExpression(rh, 1);
                fadeState = act.getParamExpression(rh, 2);
                for (ChannelState c : channels) setFadeInternal(c, targetVolume, speed, fadeState);
                break;
            case ACT_ENABLEALLVOLUMELFOS:
                rate = act.getParamExpression(rh, 0);
                depth = act.getParamExpression(rh, 1);
                for (ChannelState c : channels) setVolLFOInternal(c, rate, depth);
                break;
            case ACT_SETALLADSRENVELOPES:
                attack = act.getParamExpression(rh, 0);
                decay = act.getParamExpression(rh, 1);
                sustain = act.getParamExpression(rh, 2);
                release = act.getParamExpression(rh, 3);
                for (ChannelState c : channels) setADSRInternal(c, attack, decay, sustain, release);
                break;
            case ACT_RANDOMIZEALLPITCHES:
                range = act.getParamExpression(rh, 0);
                for (ChannelState c : channels) setRandPitchInternal(c, range);
                break;
            case ACT_SETALLORIGINFREQUENCIES:
                freq = act.getParamExpDouble(rh, 0);
                for (ChannelState c : channels) setOriginFreqInternal(c, freq);
                break;
            case ACT_SETCHANNELSTOPPED:
                id = act.getParamExpression(rh, 0);
                ChannelState cStopped = getChannel(id);
                if (cStopped != null) {
                    cStopped.playingState = 3;
                    cStopped.fadeState = 0;
                    cStopped.adsrState = 0;
                    cStopped.autoReleaseTimer = 0.0f;
                }
                break;
        }
    }

    private class CActParamOverride extends CActExtension {
        private int val;
        public CActParamOverride(int val) { this.val = val; }
        public int getParamExpression(RunLoop.CRun rh, int num) { return val; }
    }

    private void setFreqInternal(ChannelState ch, float freq, float speed, int direction) {
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
        ch.triggerFreq = true;
    }

    private void setTremoloInternal(ChannelState ch, float rate, float depth) {
        ch.tremoloTrigger = (rate > 0) ? 1 : 0;
        ch.tremoloRate = rate;
        ch.tremoloDepth = Math.max(0.0f, Math.min(depth / 100.0f, 1.0f));
        ch.triggerFreq = true;
    }

    private void setFadeInternal(ChannelState ch, float targetVolume, float speed, int state) {
        ch.volOrigin = targetVolume;
        ch.fadeSpeed = speed;
        ch.fadeState = state;
    }

    private void setVolLFOInternal(ChannelState ch, float rate, float depth) {
        ch.volLFOTrigger = (rate > 0) ? 1 : 0;
        ch.volLFORate = rate;
        ch.volLFODepth = depth;
        ch.volLFOPhase = 0.0f;
    }

    private void setADSRInternal(ChannelState ch, float attack, float decay, float sustain, float release) {
        ch.adsrAttack = attack;
        ch.adsrDecay = decay;
        ch.adsrSustain = sustain;
        ch.adsrRelease = release;
        ch.adsrTimer = 0.0f;
        ch.adsrStartVol = ch.volume;
        ch.adsrState = (attack > 0) ? 1 : ((decay > 0) ? 2 : 3);
    }

    private void setRandPitchInternal(ChannelState ch, float range) {
        float offset = ((float)Math.random()) * 2.0f * range - range;
        ch.freqRate = Math.max(ch.freqMin, Math.min(ch.freqMax, ch.freqOrigin + offset));
        ch.lastFreq = -1.0f;
        ch.triggerFreq = true;
    }

    private void setOriginFreqInternal(ChannelState ch, float freq) {
        ch.freqOrigin = freq;
        ch.freqRate = freq;
        ch.freqTarget = freq;
        ch.freqMin = freq / 8.0f;
        ch.freqMax = freq * 8.0f;
        ch.lastFreq = -1.0f;
        ch.triggerFreq = true;
    }

    @Override
    public CValue expression(int num) {
        int id;
        ChannelState ch;
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
                return new CValue(ch != null ? ch.volume : 0.0f);
            case EXP_GETFREQUENCY:
                id = ho.getExpParam().getInt();
                ch = getChannel(id);
                return new CValue(ch != null ? ch.freqRate : 0.0f);
            case EXP_GETPOSITION:
                id = ho.getExpParam().getInt();
                ch = getChannel(id);
                return new CValue(ch != null ? ch.positionMs : 0);
            case EXP_GETPAN:
                id = ho.getExpParam().getInt();
                ch = getChannel(id);
                return new CValue(ch != null ? ch.pan : 0.0f);
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
                return new CValue(ch != null ? ch.freqOrigin : 0.0f);
            case EXP_GETTRIGGEREDFREQORIGIN:
                ch = getChannel(triggeredChannel);
                return new CValue(ch != null ? ch.freqOrigin : 0.0f);
            case EXP_GETFREQORIGINPCT:
                id = ho.getExpParam().getInt();
                int pct = ho.getExpParam().getInt();
                ch = getChannel(id);
                return new CValue(ch != null ? ch.freqOrigin * (pct / 100.0f) : 0.0f);
            default:
                return new CValue(0);
        }
    }
}

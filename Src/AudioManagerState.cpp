#include "AudioManagerState.h"
#include <cmath>
#include <cstdlib>
#include <algorithm>

static const float PI = 3.14159265f;

AudioManagerState::AudioManagerState() {
    Initialize();
}

void AudioManagerState::Initialize() {
    std::lock_guard<std::mutex> lock(stateMutex);
    channels.clear();
    customTimer = 0.0f;
    lastUpdate = std::chrono::steady_clock::now();
    for (int i = 1; i <= 48; ++i) {
        ChannelState state;
        state.id = i;
        state.volume = 100.0f;
        state.volOrigin = 100.0f;
        state.freqRate = 44100.0f;
        state.freqOrigin = 44100.0f;
        state.freqTarget = 44100.0f;
        state.freqMin = 5512.5f;
        state.freqMax = 352800.0f;
        channels.push_back(state);
    }
}

// ============================================================================
// HELPER: Apply wildcard loop
// ============================================================================
#define FOR_CHANNEL(id, ch) \
    if ((id) == 0) { for (auto& ch : channels) { \
    } } else { ChannelState* _ch = GetChannel(id); if (_ch) { auto& ch = *_ch;

// ============================================================================
// UPDATE
// ============================================================================
void AudioManagerState::Update(float deltaTime) {
    std::lock_guard<std::mutex> lock(stateMutex);
    customTimer += deltaTime;

    auto now = std::chrono::steady_clock::now();
    float deltaMs = std::chrono::duration<float, std::milli>(now - lastUpdate).count();
    lastUpdate = now;

    for (auto& ch : channels) {

        // --- Position Tracking ---
        if (ch.playingState == 1) {
            ch.positionMs += (int)deltaMs;
        }

        // Auto-release timer for non-looping sounds
        if (ch.playingState == 1 && ch.autoReleaseTimer > 0.0f) {
            ch.autoReleaseTimer -= deltaTime;
            if (ch.autoReleaseTimer <= 0.0f) {
                ch.autoReleaseTimer = 0.0f;
                ch.playingState = 3; // Mark as stopped/free!
            }
        }

        // --- 1. Fade Mode ---
        if (ch.fadeState != 0) {
            ch.volume += ch.fadeState * ch.fadeSpeed;
            if (ch.fadeState == 1) { // Fade In
                if (ch.volume >= ch.volOrigin) {
                    ch.volume = ch.volOrigin;
                    ch.fadeState = 0;
                    ch.triggerFadeComplete = true;
                }
            } else if (ch.fadeState == -1) { // Fade Out
                if (ch.volume <= 0.0f) {
                    ch.volume = 0.0f;
                    ch.fadeState = 0;
                    ch.triggerFadeComplete = true;
                    ch.playingState = 3;
                    ch.triggerStop = true;

                    if (ch.transitionTargetId != 0) {
                        ChannelState* slave = GetChannel(ch.transitionTargetId);
                        if (slave) {
                            slave->soundName = ch.transitionSample;
                            slave->playingState = 1;
                            slave->fadeState = 1;
                            slave->volume = 0.0f;
                            slave->volOrigin = 100.0f;
                            slave->fadeSpeed = ch.transitionFadeIn;
                            slave->freqRate = 44100.0f;
                            slave->freqOrigin = 44100.0f;
                            slave->freqTarget = 44100.0f;
                            slave->positionMs = 0;
                            slave->autoReleaseTimer = -1.0f;
                            slave->triggerPlay = true;
                            slave->triggerVolume = true;
                            slave->triggerFreq = true;
                            slave->triggerPosition = true;
                        }
                        ch.transitionTargetId = 0;
                    }
                    else if (!ch.trackQueue.empty()) {
                        ch.soundName = ch.trackQueue.front();
                        ch.trackQueue.pop_front();
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

        // --- 2. ADSR Envelope ---
        if (ch.adsrState != 0) {
            ch.adsrTimer += 1.0f;
            switch (ch.adsrState) {
                case 1: { // Attack: 0 -> volOrigin in adsrAttack frames
                    float t = (ch.adsrAttack > 0) ? (ch.adsrTimer / ch.adsrAttack) : 1.0f;
                    ch.volume = ch.adsrStartVol + t * (ch.volOrigin - ch.adsrStartVol);
                    if (ch.adsrTimer >= ch.adsrAttack) {
                        ch.volume = ch.volOrigin;
                        ch.adsrTimer = 0.0f;
                        ch.adsrStartVol = ch.volume;
                        ch.adsrState = (ch.adsrDecay > 0) ? 2 : 3;
                    }
                    ch.triggerVolume = true;
                    break;
                }
                case 2: { // Decay: volOrigin -> sustain in adsrDecay frames
                    float t = (ch.adsrDecay > 0) ? (ch.adsrTimer / ch.adsrDecay) : 1.0f;
                    ch.volume = ch.volOrigin + t * (ch.adsrSustain - ch.volOrigin);
                    if (ch.adsrTimer >= ch.adsrDecay) {
                        ch.volume = ch.adsrSustain;
                        ch.adsrTimer = 0.0f;
                        ch.adsrStartVol = ch.volume;
                        ch.adsrState = 3;
                    }
                    ch.triggerVolume = true;
                    break;
                }
                case 3: // Sustain: hold until release triggered
                    break;
                case 4: { // Release: sustain -> 0 in adsrRelease frames
                    float t = (ch.adsrRelease > 0) ? (ch.adsrTimer / ch.adsrRelease) : 1.0f;
                    ch.volume = ch.adsrStartVol * (1.0f - t);
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
        }

        // --- 3. Volume LFO (true tremolo) ---
        if (ch.volLFOTrigger == 1) {
            ch.volLFOPhase += deltaTime * ch.volLFORate * 2.0f * PI;
            if (ch.volLFOPhase > 2.0f * PI) ch.volLFOPhase -= 2.0f * PI;
            float lfoVal = sinf(ch.volLFOPhase);
            float depth = ch.volLFODepth / 100.0f;
            ch.volume = ch.volOrigin * (1.0f + depth * lfoVal);
            ch.volume = std::max(0.0f, std::min(100.0f, ch.volume));
            ch.triggerVolume = true;
        }

        // --- 4. Frequency Sweep + LFO Shapes ---
        float prevFreq = ch.freqRate;
        switch (ch.freqDirection) {
            case -1: // Slide Down to target
                ch.freqRate = std::max(ch.freqRate - ch.freqSpeed, ch.freqTarget);
                break;
            case 1: // Slide Up to target
                ch.freqRate = std::min(ch.freqRate + ch.freqSpeed, ch.freqTarget);
                break;
            case 2: // Sine wave
                ch.freqRate = ch.freqOrigin + sinf(customTimer * ch.freqSpeed * 0.01f) * 8000.0f;
                break;
            case 3: // Knockout (slide to 0)
                ch.freqRate = std::max(ch.freqRate - ch.freqSpeed, 0.0f);
                break;
            case 4: { // Triangle wave
                ch.freqLFOPhase += deltaTime * ch.freqSpeed * 0.01f;
                float t = fmodf(ch.freqLFOPhase, 1.0f);
                float tri = (t < 0.5f) ? (4.0f * t - 1.0f) : (3.0f - 4.0f * t);
                ch.freqRate = ch.freqOrigin + tri * 8000.0f;
                break;
            }
            case 5: { // Square wave
                ch.freqLFOPhase += deltaTime * ch.freqSpeed * 0.01f;
                float t = fmodf(ch.freqLFOPhase, 1.0f);
                ch.freqRate = ch.freqOrigin + ((t < 0.5f) ? 8000.0f : -8000.0f);
                break;
            }
            case 6: { // Sawtooth wave
                ch.freqLFOPhase += deltaTime * ch.freqSpeed * 0.01f;
                float t = fmodf(ch.freqLFOPhase, 1.0f);
                ch.freqRate = ch.freqOrigin + (2.0f * t - 1.0f) * 8000.0f;
                break;
            }
            case 0: // Smooth return to origin
            default:
                if (ch.freqRate != ch.freqOrigin) {
                    if (ch.freqRate > ch.freqOrigin)
                        ch.freqRate = std::max(ch.freqRate - ch.freqSpeed, ch.freqOrigin);
                    else
                        ch.freqRate = std::min(ch.freqRate + ch.freqSpeed, ch.freqOrigin);
                }
                break;
        }
        if (ch.freqRate != prevFreq) ch.triggerFreq = true;

        // --- 5. Tremolo (Pitch modulation LFO) ---
        if (ch.tremoloTrigger == 1) {
            ch.tremoloPhase += deltaTime * ch.tremoloRate * 2.0f * PI;
            if (ch.tremoloPhase > 2.0f * PI) ch.tremoloPhase -= 2.0f * PI;
            ch.triggerFreq = true;
        }

        // --- 6. Deduplication checks ---
        if (ch.triggerVolume && ch.volume == ch.lastVolume)
            ch.triggerVolume = false;

        if (ch.triggerFreq) {
            float finalFreq = ch.freqRate;
            if (ch.tremoloTrigger == 1)
                finalFreq = ch.freqRate * (1.0f + ch.tremoloDepth * sinf(ch.tremoloPhase));
            if (finalFreq == ch.lastFreq)
                ch.triggerFreq = false;
        }

        if (ch.triggerPan && ch.pan == ch.lastPan)
            ch.triggerPan = false;
    }
}

// ============================================================================
// CHANNEL ACCESSOR
// ============================================================================
ChannelState* AudioManagerState::GetChannel(int id) {
    if (id < 1 || id > 48) return nullptr;
    return &channels[id - 1];
}

// ============================================================================
// ACTIONS
// ============================================================================
void AudioManagerState::PlayAudio(int id, const std::string& filename, int loopFlag, int startMs, int endMs, float volume, float freq) {
    std::lock_guard<std::mutex> lock(stateMutex);
    ChannelState* ch = nullptr;
    if (id == 0) {
        // Step 1: Always search for the LOWEST truly STOPPED channel (1 to 48)
        for (int i = 0; i < 48; ++i) {
            if (channels[i].playingState == 3) {
                ch = &channels[i];
                break;
            }
        }
        // Step 2: Fallback ONLY if all 48 channels are actively playing simultaneously
        if (!ch) {
            static int lastAllocatedChannelIndex = 0;
            lastAllocatedChannelIndex = (lastAllocatedChannelIndex + 1) % 48;
            ch = &channels[lastAllocatedChannelIndex];
        }
    } else {
        ch = GetChannel(id);
    }
    if (!ch) return;
    ch->soundName = filename;
    ch->trackQueue.clear();
    ch->loopFlag = loopFlag;
    ch->loopStart = startMs;
    ch->loopEnd = endMs;
    ch->volume = volume;
    ch->volOrigin = volume;
    ch->freqRate = (freq > 0.0f) ? freq : 44100.0f;
    ch->freqOrigin = ch->freqRate;
    ch->freqTarget = ch->freqRate;
    ch->playingState = 1;
    ch->fadeState = 0;
    ch->adsrState = 0;

    // Auto-release timer: loopFlag == 0 means infinite BGM (never auto-free)
    // loopFlag != 0 means SFX (auto-free after 2.5 seconds)
    if (loopFlag != 0) {
        ch->autoReleaseTimer = 2.5f;
    } else {
        ch->autoReleaseTimer = -1.0f;
    }

    ch->triggerPlay = true;
    ch->triggerVolume = true;
    ch->triggerFreq = true;
}

void AudioManagerState::StopAudio(int id) {
    std::lock_guard<std::mutex> lock(stateMutex);
    if (id == -1) {
        for (auto& ch : channels) { ch.playingState = 3; ch.triggerStop = true; }
        return;
    }
    ChannelState* ch = GetChannel(id);
    if (!ch) return;
    ch->playingState = 3;
    ch->triggerStop = true;
}

void AudioManagerState::PauseAudio(int id) {
    std::lock_guard<std::mutex> lock(stateMutex);
    if (id == -1) {
        for (auto& ch : channels) { ch.playingState = 2; ch.triggerPause = true; }
        return;
    }
    ChannelState* ch = GetChannel(id);
    if (!ch) return;
    ch->playingState = 2;
    ch->triggerPause = true;
}

void AudioManagerState::ResumeAudio(int id) {
    std::lock_guard<std::mutex> lock(stateMutex);
    if (id == -1) {
        for (auto& ch : channels) { ch.playingState = 1; ch.triggerResume = true; }
        return;
    }
    ChannelState* ch = GetChannel(id);
    if (!ch) return;
    ch->playingState = 1;
    ch->triggerResume = true;
}

void AudioManagerState::QueueAudio(int id, const std::string& filename, float fadeOutSpeed, float fadeInSpeed) {
    std::lock_guard<std::mutex> lock(stateMutex);
    ChannelState* ch = GetChannel(id);
    if (!ch) return;
    ch->trackQueue.clear();
    ch->trackQueue.push_back(filename);
    ch->fadeState = -1;
    ch->fadeSpeed = fadeOutSpeed;
    ch->nextFadeInSpeed = fadeInSpeed;
}

void AudioManagerState::EnqueueTrack(int id, const std::string& filename) {
    std::lock_guard<std::mutex> lock(stateMutex);
    if (id == -1) {
        for (auto& ch : channels) ch.trackQueue.push_back(filename);
        return;
    }
    ChannelState* ch = GetChannel(id);
    if (!ch) return;
    ch->trackQueue.push_back(filename);
}

void AudioManagerState::ClearQueue(int id) {
    std::lock_guard<std::mutex> lock(stateMutex);
    if (id == -1) {
        for (auto& ch : channels) ch.trackQueue.clear();
        return;
    }
    ChannelState* ch = GetChannel(id);
    if (!ch) return;
    ch->trackQueue.clear();
}

void AudioManagerState::SetVolume(int id, float volume) {
    std::lock_guard<std::mutex> lock(stateMutex);
    if (id == -1) {
        for (auto& ch : channels) { ch.volume = volume; ch.volOrigin = volume; ch.triggerVolume = true; }
        return;
    }
    ChannelState* ch = GetChannel(id);
    if (!ch) return;
    ch->volume = volume;
    ch->volOrigin = volume;
    ch->triggerVolume = true;
}

void AudioManagerState::SetFrequency(int id, float freq, float speed, int direction) {
    std::lock_guard<std::mutex> lock(stateMutex);
    auto applyFreq = [&](ChannelState& ch) {
        if (direction == 0) {
            ch.freqTarget = ch.freqOrigin;
        } else if (speed == 0.0f) {
            float safeFreq = (freq > 0.0f) ? freq : ch.freqOrigin;
            ch.freqOrigin = safeFreq;
            ch.freqRate = safeFreq;
            ch.freqTarget = safeFreq;
        } else {
            // Guard: never sweep to 0 or below — clamp to freqMin
            ch.freqTarget = (freq > 0.0f) ? freq : ch.freqMin;
        }
        ch.freqSpeed = speed;
        ch.freqDirection = direction;
        ch.freqLFOPhase = 0.0f;
        ch.lastFreq = -1.0f;
        ch.triggerFreq = true;
    };

    if (id == -1) {
        for (auto& ch : channels) applyFreq(ch);
        return;
    }
    ChannelState* ch = GetChannel(id);
    if (ch) applyFreq(*ch);
}

void AudioManagerState::SetPan(int id, float pan) {
    std::lock_guard<std::mutex> lock(stateMutex);
    if (id == -1) {
        for (auto& ch : channels) { ch.pan = pan; ch.triggerPan = true; }
        return;
    }
    ChannelState* ch = GetChannel(id);
    if (!ch) return;
    ch->pan = pan;
    ch->triggerPan = true;
}

void AudioManagerState::EnableTremolo(int id, float rate, float depth) {
    std::lock_guard<std::mutex> lock(stateMutex);
    float depthFrac = std::max(0.0f, std::min(depth / 100.0f, 1.0f));
    if (id == -1) {
        for (auto& ch : channels) {
            ch.tremoloTrigger = (rate > 0) ? 1 : 0;
            ch.tremoloRate = rate;
            ch.tremoloDepth = depthFrac;
            ch.triggerFreq = true;
        }
        return;
    }
    ChannelState* ch = GetChannel(id);
    if (!ch) return;
    ch->tremoloTrigger = (rate > 0) ? 1 : 0;
    ch->tremoloRate = rate;
    ch->tremoloDepth = depthFrac;
    ch->triggerFreq = true;
}

void AudioManagerState::EnableVolumeLFO(int id, float rate, float depth) {
    std::lock_guard<std::mutex> lock(stateMutex);
    if (id == -1) {
        for (auto& ch : channels) {
            ch.volLFOTrigger = (rate > 0) ? 1 : 0;
            ch.volLFORate = rate;
            ch.volLFODepth = depth;
            ch.volLFOPhase = 0.0f;
        }
        return;
    }
    ChannelState* ch = GetChannel(id);
    if (!ch) return;
    ch->volLFOTrigger = (rate > 0) ? 1 : 0;
    ch->volLFORate = rate;
    ch->volLFODepth = depth;
    ch->volLFOPhase = 0.0f;
}

void AudioManagerState::FadeChannel(int id, float targetVolume, float fadeSpeed, int fadeState) {
    std::lock_guard<std::mutex> lock(stateMutex);
    if (id == -1) {
        for (auto& ch : channels) {
            ch.volOrigin = targetVolume;
            ch.fadeSpeed = fadeSpeed;
            ch.fadeState = fadeState;
        }
        return;
    }
    ChannelState* ch = GetChannel(id);
    if (!ch) return;
    ch->volOrigin = targetVolume;
    ch->fadeSpeed = fadeSpeed;
    ch->fadeState = fadeState;
}

void AudioManagerState::SetADSR(int id, float attack, float decay, float sustain, float release) {
    std::lock_guard<std::mutex> lock(stateMutex);
    if (id == -1) {
        for (auto& ch : channels) {
            ch.adsrAttack = attack;
            ch.adsrDecay = decay;
            ch.adsrSustain = sustain;
            ch.adsrRelease = release;
            ch.adsrTimer = 0.0f;
            ch.adsrStartVol = ch.volume;
            ch.adsrState = (attack > 0) ? 1 : ((decay > 0) ? 2 : 3);
        }
        return;
    }
    ChannelState* ch = GetChannel(id);
    if (!ch) return;
    ch->adsrAttack = attack;
    ch->adsrDecay = decay;
    ch->adsrSustain = sustain;
    ch->adsrRelease = release;
    ch->adsrTimer = 0.0f;
    ch->adsrStartVol = ch->volume;
    ch->adsrState = (attack > 0) ? 1 : ((decay > 0) ? 2 : 3);
}

void AudioManagerState::RandomizePitch(int id, float range) {
    std::lock_guard<std::mutex> lock(stateMutex);
    auto applyRandom = [&](ChannelState& ch) {
        float offset = ((float)rand() / RAND_MAX) * 2.0f * range - range;
        ch.freqRate = std::max(ch.freqMin, std::min(ch.freqMax, ch.freqOrigin + offset));
        ch.lastFreq = -1.0f;
        ch.triggerFreq = true;
    };
    if (id == -1) {
        for (auto& ch : channels) applyRandom(ch);
        return;
    }
    ChannelState* ch = GetChannel(id);
    if (ch) applyRandom(*ch);
}

void AudioManagerState::Crossfade(int fromId, int toId, float speed) {
    FadeChannel(fromId, 0.0f, speed, -1);
    FadeChannel(toId, 100.0f, speed, 1);
}

void AudioManagerState::CrossfadeParallel(int fromId, int toId, const std::string& nextSample, float speed) {
    std::lock_guard<std::mutex> lock(stateMutex);
    ChannelState* chMaster = GetChannel(fromId);
    ChannelState* chSlave = GetChannel(toId);
    if (!chMaster || !chSlave) return;

    // Fade out master
    chMaster->volOrigin = 0.0f;
    chMaster->fadeSpeed = speed;
    chMaster->fadeState = -1;
    
    // Setup slave to fade in
    chSlave->soundName = nextSample;
    chSlave->volume = 0.0f;
    chSlave->volOrigin = 100.0f; // Target for Fade In
    chSlave->freqRate = 44100.0f;
    chSlave->freqOrigin = 44100.0f;
    chSlave->freqTarget = 44100.0f;
    chSlave->playingState = 1;
    chSlave->fadeState = 1;
    chSlave->fadeSpeed = speed;
    
    // SYNC POSITION
    chSlave->positionMs = chMaster->positionMs; 
    
    chSlave->autoReleaseTimer = -1.0f; // Crossfade track assumes infinite unless stopped
    chSlave->triggerPlay = true;
    chSlave->triggerVolume = true;
    chSlave->triggerFreq = true;
    chSlave->triggerPosition = true;
}

void AudioManagerState::SequentialTransition(int fromId, int toId, const std::string& nextSample, float outSpeed, float inSpeed) {
    std::lock_guard<std::mutex> lock(stateMutex);
    ChannelState* chMaster = GetChannel(fromId);
    if (!chMaster) return;

    chMaster->volOrigin = 0.0f;
    chMaster->fadeSpeed = outSpeed;
    chMaster->fadeState = -1;
    
    chMaster->transitionTargetId = toId;
    chMaster->transitionSample = nextSample;
    chMaster->transitionFadeIn = inSpeed;
}

void AudioManagerState::SetOriginFrequency(int id, float freq) {
    std::lock_guard<std::mutex> lock(stateMutex);
    auto applyOrigin = [&](ChannelState& ch) {
        ch.freqOrigin = freq;
        ch.freqRate = freq;
        ch.freqTarget = freq;
        ch.freqMin = freq / 8.0f;
        ch.freqMax = freq * 8.0f;
        ch.lastFreq = -1.0f;
        ch.triggerFreq = true;
    };
    if (id == -1) {
        for (auto& ch : channels) applyOrigin(ch);
        return;
    }
    ChannelState* ch = GetChannel(id);
    if (ch) applyOrigin(*ch);
}

// ============================================================================
// TRIGGER POLLING
// ============================================================================

bool AudioManagerState::PollTriggerPlay(int& channelId, std::string& soundName, int& loop, float& vol, float& freq, int& pos, float& pan) {
    std::lock_guard<std::mutex> lock(stateMutex);
    for (auto& ch : channels) {
        if (ch.triggerPlay) {
            ch.triggerPlay = false;
            channelId = ch.id;
            soundName = ch.soundName;
            loop = ch.loopFlag;
            vol = ch.volume;
            freq = ch.freqRate;
            pos = ch.positionMs;
            pan = ch.pan;
            return true;
        }
    }
    return false;
}

bool AudioManagerState::PollTriggerStop(int& channelId) {
    std::lock_guard<std::mutex> lock(stateMutex);
    for (auto& ch : channels) {
        if (ch.triggerStop) {
            ch.triggerStop = false;
            channelId = ch.id;
            return true;
        }
    }
    return false;
}

bool AudioManagerState::PollTriggerPause(int& channelId) {
    std::lock_guard<std::mutex> lock(stateMutex);
    for (auto& ch : channels) {
        if (ch.triggerPause) {
            ch.triggerPause = false;
            channelId = ch.id;
            return true;
        }
    }
    return false;
}

bool AudioManagerState::PollTriggerResume(int& channelId) {
    std::lock_guard<std::mutex> lock(stateMutex);
    for (auto& ch : channels) {
        if (ch.triggerResume) {
            ch.triggerResume = false;
            channelId = ch.id;
            return true;
        }
    }
    return false;
}

bool AudioManagerState::PollTriggerVolume(int& channelId, float& volume) {
    std::lock_guard<std::mutex> lock(stateMutex);
    for (auto& ch : channels) {
        if (ch.triggerVolume) {
            ch.triggerVolume = false;
            if (ch.playingState == 1) {
                channelId = ch.id;
                volume = ch.volume;
                ch.lastVolume = ch.volume;
                return true;
            }
        }
    }
    return false;
}

bool AudioManagerState::PollTriggerFreq(int& channelId, float& frequency) {
    std::lock_guard<std::mutex> lock(stateMutex);
    for (auto& ch : channels) {
        if (ch.triggerFreq) {
            ch.triggerFreq = false;
            if (ch.playingState == 1) {
                channelId = ch.id;
                float finalFreq = ch.freqRate;
                if (ch.tremoloTrigger == 1)
                    finalFreq = ch.freqRate * (1.0f + ch.tremoloDepth * sinf(ch.tremoloPhase));
                frequency = finalFreq;
                ch.lastFreq = finalFreq;
                return true;
            }
        }
    }
    return false;
}

bool AudioManagerState::PollTriggerPosition(int& channelId, int& position) {
    std::lock_guard<std::mutex> lock(stateMutex);
    for (auto& ch : channels) {
        if (ch.triggerPosition) {
            ch.triggerPosition = false;
            if (ch.playingState == 1) {
                channelId = ch.id;
                position = ch.positionMs;
                ch.lastPosition = ch.positionMs;
                return true;
            }
        }
    }
    return false;
}

bool AudioManagerState::PollTriggerPan(int& channelId, float& pan) {
    std::lock_guard<std::mutex> lock(stateMutex);
    for (auto& ch : channels) {
        if (ch.triggerPan) {
            ch.triggerPan = false;
            if (ch.playingState == 1) {
                channelId = ch.id;
                pan = ch.pan;
                ch.lastPan = ch.pan;
                return true;
            }
        }
    }
    return false;
}

bool AudioManagerState::PollTriggerFadeComplete(int& channelId) {
    std::lock_guard<std::mutex> lock(stateMutex);
    for (auto& ch : channels) {
        if (ch.triggerFadeComplete) {
            ch.triggerFadeComplete = false;
            channelId = ch.id;
            return true;
        }
    }
    return false;
}

void AudioManagerState::NotifyChannelStopped(int id) {
    std::lock_guard<std::mutex> lock(stateMutex);
    ChannelState* ch = GetChannel(id);
    if (ch) {
        ch->playingState = 3;
        ch->fadeState = 0;
        ch->adsrState = 0;
        ch->autoReleaseTimer = 0.0f;
    }
}

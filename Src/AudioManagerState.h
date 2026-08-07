#pragma once
#include <string>
#include <vector>
#include <deque>
#include <mutex>
#include <chrono>

struct ChannelState {
    int id = 0; // 1-indexed (1 to 48)
    std::string soundName = "";

    // --- Playback Queue (Playlist) ---
    std::deque<std::string> trackQueue;  // multi-track queue
    
    // Volume & Fades
    float volume = 100.0f;       // 0 to 100
    float volOrigin = 100.0f;    // target/initial volume
    int fadeState = 0;           // 0=none, 1=in, -1=out
    float fadeSpeed = 2.0f;      // rate of fade
    float nextFadeInSpeed = 2.0f; // rate of next track's fade in
    bool triggerFadeComplete = false;
    
    // Sequential Transition
    int transitionTargetId = 0;
    std::string transitionSample = "";
    float transitionFadeIn = 2.0f;

    // Volume LFO (true tremolo)
    int volLFOTrigger = 0;       // 0=off, 1=on
    float volLFORate = 4.0f;     // oscillation speed
    float volLFODepth = 30.0f;   // intensity (0..100 %)
    float volLFOPhase = 0.0f;    // current phase

    // ADSR Envelope
    int adsrState = 0;           // 0=idle, 1=attack, 2=decay, 3=sustain, 4=release
    float adsrAttack = 0.0f;     // frames to reach full volume
    float adsrDecay = 0.0f;      // frames to reach sustain level
    float adsrSustain = 100.0f;  // sustain level (0..100)
    float adsrRelease = 0.0f;    // frames to fade to 0
    float adsrTimer = 0.0f;      // elapsed frames in current ADSR state
    float adsrStartVol = 0.0f;   // volume at start of current state

    // Frequency (Pitch)
    float freqRate = 44100.0f;
    float freqSpeed = 200.0f;
    int freqDirection = 0;       // -1, 0, 1, 2=sine, 3=knockout, 4=triangle, 5=square, 6=sawtooth
    float freqOrigin = 44100.0f;
    float freqTarget = 44100.0f;
    float freqMin = 5512.5f;
    float freqMax = 352800.0f;
    float freqLFOPhase = 0.0f;   // separate phase for shaped LFOs
    
    // Tremolo (Pitch modulation LFO)
    int tremoloTrigger = 0;
    float tremoloRate = 4.0f;
    float tremoloPhase = 0.0f;
    float tremoloDepth = 0.15f;  // depth as fraction (0.0-1.0)

    // Playback state
    int loopFlag = 0;
    int loopStart = 0;
    int loopEnd = 0;
    int playingState = 3;        // 1=Playing, 2=Paused, 3=Stopped
    int positionMs = 0;
    int durationMs = 0;
    float pan = 0.0f;
    int playFrameDelay = 0;      // frame countdown debounce for Clickteam playback check
    float autoReleaseTimer = 0.0f; // auto-free timer for non-looping sounds
    
    // Trigger notification flags
    bool triggerPlay = false;
    bool triggerStop = false;
    bool triggerPause = false;
    bool triggerResume = false;
    bool triggerVolume = false;
    bool triggerFreq = false;
    bool triggerPosition = false;
    bool triggerPan = false;

    // Last sent values to avoid redundant triggers
    float lastVolume = -999.0f;
    float lastFreq = -999.0f;
    int lastPosition = -999;
    float lastPan = -999.0f;
};

class AudioManagerState {
private:
    std::vector<ChannelState> channels;
    std::mutex stateMutex;
    float customTimer = 0.0f;
    
    std::chrono::steady_clock::time_point lastUpdate;

    AudioManagerState();

public:
    static AudioManagerState& GetInstance() {
        static AudioManagerState instance;
        return instance;
    }

    void Initialize();
    void Update(float deltaTime);
    float GetCustomTimer() const { return customTimer; }

    // Channel accessors
    ChannelState* GetChannel(int id);
    
    // Thread-safe state modifications (Actions)
    void PlayAudio(int id, const std::string& filename, int loopFlag, int startMs, int endMs, float volume, float freq);
    void StopAudio(int id);
    void PauseAudio(int id);
    void ResumeAudio(int id);
    void QueueAudio(int id, const std::string& filename, float fadeOutSpeed, float fadeInSpeed);
    void EnqueueTrack(int id, const std::string& filename);  // playlist add
    void ClearQueue(int id);                                   // playlist clear
    void SetVolume(int id, float volume);
    void SetFrequency(int id, float freq, float speed, int direction);
    void SetPan(int id, float pan);
    void EnableTremolo(int id, float rate, float depth);
    void EnableVolumeLFO(int id, float rate, float depth);     // volume LFO
    void FadeChannel(int id, float targetVolume, float fadeSpeed, int fadeState);
    void SetADSR(int id, float attack, float decay, float sustain, float release);
    void RandomizePitch(int id, float range);                  // random pitch offset
    void Crossfade(int fromId, int toId, float speed);         // old classic
    void CrossfadeParallel(int fromId, int toId, const std::string& nextSample, float speed); // parallel mix
    void SequentialTransition(int fromId, int toId, const std::string& nextSample, float outSpeed, float inSpeed);
    void SetOriginFrequency(int id, float freq);               // set original baseline frequency
    void NotifyChannelStopped(int id);                         // notify C++ that a channel stopped natively

    // Event polling for Clickteam Conditions
    bool PollTriggerPlay(int& channelId, std::string& soundName, int& loop, float& vol, float& freq, int& pos, float& pan);
    bool PollTriggerStop(int& channelId);
    bool PollTriggerPause(int& channelId);
    bool PollTriggerResume(int& channelId);
    bool PollTriggerVolume(int& channelId, float& volume);
    bool PollTriggerFreq(int& channelId, float& frequency);
    bool PollTriggerPosition(int& channelId, int& position);
    bool PollTriggerPan(int& channelId, float& pan);
    bool PollTriggerFadeComplete(int& channelId);
};

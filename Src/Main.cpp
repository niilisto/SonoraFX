#include "Common.h"
#include "Main.h"
#include "AudioManagerState.h"
#include <chrono>

// Time helper variables
static std::chrono::steady_clock::time_point g_lastTimePoint;

// ============================================================================
// EVENT INFORMATION TABLES
// ============================================================================

// --- CONDITIONS ---
short conditionsInfos[] =
{
    // CND_OnPlay(channel)
    IDMN_CND_ON_PLAY,           M_CND_ON_PLAY,           CND_OnPlay,           0, 1, PARAM_EXPRESSION, M_CND_P_CHANNEL,
    // CND_OnStop(channel)
    IDMN_CND_ON_STOP,           M_CND_ON_STOP,           CND_OnStop,           0, 1, PARAM_EXPRESSION, M_CND_P_CHANNEL,
    // CND_OnPause(channel)
    IDMN_CND_ON_PAUSE,          M_CND_ON_PAUSE,          CND_OnPause,          0, 1, PARAM_EXPRESSION, M_CND_P_CHANNEL,
    // CND_OnResume(channel)
    IDMN_CND_ON_RESUME,         M_CND_ON_RESUME,         CND_OnResume,         0, 1, PARAM_EXPRESSION, M_CND_P_CHANNEL,
    // CND_OnSetVolume(channel)
    IDMN_CND_ON_SET_VOLUME,     M_CND_ON_SET_VOLUME,     CND_OnSetVolume,      0, 1, PARAM_EXPRESSION, M_CND_P_CHANNEL,
    // CND_OnSetFrequency(channel)
    IDMN_CND_ON_SET_FREQUENCY,  M_CND_ON_SET_FREQUENCY,  CND_OnSetFrequency,   0, 1, PARAM_EXPRESSION, M_CND_P_CHANNEL,
    // CND_OnSetPosition(channel)
    IDMN_CND_ON_SET_POSITION,   M_CND_ON_SET_POSITION,   CND_OnSetPosition,    0, 1, PARAM_EXPRESSION, M_CND_P_CHANNEL,
    // CND_OnSetPan(channel)
    IDMN_CND_ON_SET_PAN,        M_CND_ON_SET_PAN,        CND_OnSetPan,         0, 1, PARAM_EXPRESSION, M_CND_P_CHANNEL,
    // CND_IsPlaying(channel)
    IDMN_CND_IS_PLAYING,        M_CND_IS_PLAYING,        CND_IsPlaying,        0, 1, PARAM_EXPRESSION, M_CND_P_CHANNEL,
    // CND_IsPaused(channel)
    IDMN_CND_IS_PAUSED,         M_CND_IS_PAUSED,         CND_IsPaused,         0, 1, PARAM_EXPRESSION, M_CND_P_CHANNEL,
    // CND_IsStopped(channel)
    IDMN_CND_IS_STOPPED,        M_CND_IS_STOPPED,        CND_IsStopped,        0, 1, PARAM_EXPRESSION, M_CND_P_CHANNEL,
    // CND_OnFadeComplete(channel)
    IDMN_CND_ON_FADE_COMPLETE,  M_CND_ON_FADE_COMPLETE,  CND_OnFadeComplete,   0, 1, PARAM_EXPRESSION, M_CND_P_CHANNEL,
    // CND_OnAnyPlay()
    IDMN_CND_ON_ANY_PLAY,       M_CND_ON_ANY_PLAY,       CND_OnAnyPlay,        0, 0,
    // CND_OnAnyStop()
    IDMN_CND_ON_ANY_STOP,       M_CND_ON_ANY_STOP,       CND_OnAnyStop,        0, 0,
    // CND_OnAnyPause()
    IDMN_CND_ON_ANY_PAUSE,      M_CND_ON_ANY_PAUSE,      CND_OnAnyPause,       0, 0,
    // CND_OnAnyResume()
    IDMN_CND_ON_ANY_RESUME,     M_CND_ON_ANY_RESUME,     CND_OnAnyResume,      0, 0,
    // CND_OnAnySetVolume()
    IDMN_CND_ON_ANY_SET_VOLUME, M_CND_ON_ANY_SET_VOLUME, CND_OnAnySetVolume,   0, 0,
    // CND_OnAnySetFrequency()
    IDMN_CND_ON_ANY_SET_FREQUENCY, M_CND_ON_ANY_SET_FREQUENCY, CND_OnAnySetFrequency, 0, 0,
    // CND_OnAnySetPosition()
    IDMN_CND_ON_ANY_SET_POSITION, M_CND_ON_ANY_SET_POSITION, CND_OnAnySetPosition, 0, 0,
    // CND_OnAnySetPan()
    IDMN_CND_ON_ANY_SET_PAN,    M_CND_ON_ANY_SET_PAN,    CND_OnAnySetPan,      0, 0,
    // CND_OnAnyFadeComplete()
    IDMN_CND_ON_ANY_FADE_COMPLETE, M_CND_ON_ANY_FADE_COMPLETE, CND_OnAnyFadeComplete, 0, 0,
};

// --- ACTIONS ---
short actionsInfos[] =
{
    // ACT_PlayAudio(channel, filename, loopFlag, startMs, endMs, volume, freq)
    IDMN_ACT_PLAY_AUDIO, M_ACT_PLAY_AUDIO, ACT_PlayAudio, 0, 7, 
        PARAM_EXPRESSION, PARAM_FILENAME, PARAM_EXPRESSION, PARAM_EXPRESSION, PARAM_EXPRESSION, PARAM_EXPRESSION, PARAM_EXPRESSION,
        M_ACT_P_CHANNEL, M_ACT_P_FILENAME, M_ACT_P_LOOP_FLAG, M_ACT_P_LOOP_START, M_ACT_P_LOOP_END, M_ACT_P_VOLUME, M_ACT_P_FREQUENCY,

    // ACT_StopAudio(channel)
    IDMN_ACT_STOP_AUDIO, M_ACT_STOP_AUDIO, ACT_StopAudio, 0, 1, PARAM_EXPRESSION, M_ACT_P_CHANNEL,

    // ACT_PauseAudio(channel)
    IDMN_ACT_PAUSE_AUDIO, M_ACT_PAUSE_AUDIO, ACT_PauseAudio, 0, 1, PARAM_EXPRESSION, M_ACT_P_CHANNEL,

    // ACT_ResumeAudio(channel)
    IDMN_ACT_RESUME_AUDIO, M_ACT_RESUME_AUDIO, ACT_ResumeAudio, 0, 1, PARAM_EXPRESSION, M_ACT_P_CHANNEL,

    // ACT_QueueAudio(channel, filename, fadeOutSpeed, fadeInSpeed)
    IDMN_ACT_QUEUE_AUDIO, M_ACT_QUEUE_AUDIO, ACT_QueueAudio, 0, 4, PARAM_EXPRESSION, PARAM_FILENAME, PARAM_EXPRESSION, PARAM_EXPRESSION, M_ACT_P_CHANNEL, M_ACT_P_FILENAME, M_ACT_P_FADE_OUT_SPEED, M_ACT_P_FADE_IN_SPEED,

    // ACT_SetVolume(channel, volume)
    IDMN_ACT_SET_VOLUME, M_ACT_SET_VOLUME, ACT_SetVolume, 0, 2, PARAM_EXPRESSION, PARAM_EXPRESSION, M_ACT_P_CHANNEL, M_ACT_P_VOLUME,

    // ACT_SetFrequency(channel, freq, speed, direction)
    IDMN_ACT_SET_FREQUENCY, M_ACT_SET_FREQUENCY, ACT_SetFrequency, 0, 4, 
        PARAM_EXPRESSION, PARAM_EXPRESSION, PARAM_EXPRESSION, PARAM_EXPRESSION,
        M_ACT_P_CHANNEL, M_ACT_P_FREQUENCY, M_ACT_P_FREQ_SPEED, M_ACT_P_FREQ_DIRECTION,

    // ACT_SetPan(channel, pan)
    IDMN_ACT_SET_PAN, M_ACT_SET_PAN, ACT_SetPan, 0, 2, PARAM_EXPRESSION, PARAM_EXPRESSION, M_ACT_P_CHANNEL, M_ACT_P_PAN,

    // ACT_EnableTremolo(channel, rate, depth)
    IDMN_ACT_ENABLE_TREMOLO, M_ACT_ENABLE_TREMOLO, ACT_EnableTremolo, 0, 3, PARAM_EXPRESSION, PARAM_EXPRESSION, PARAM_EXPRESSION, M_ACT_P_CHANNEL, M_ACT_P_RATE, M_ACT_P_DEPTH,

    // ACT_FadeChannel(channel, targetVolume, speed, state)
    IDMN_ACT_FADE_CHANNEL, M_ACT_FADE_CHANNEL, ACT_FadeChannel, 0, 4, 
        PARAM_EXPRESSION, PARAM_EXPRESSION, PARAM_EXPRESSION, PARAM_EXPRESSION,
        M_ACT_P_CHANNEL, M_ACT_P_VOLUME, M_ACT_P_FADE_SPEED, M_ACT_P_FADE_STATE,

    // ACT_EnqueueTrack(channel, filename)
    IDMN_ACT_ENQUEUE_TRACK, M_ACT_ENQUEUE_TRACK, ACT_EnqueueTrack, 0, 2, PARAM_EXPRESSION, PARAM_FILENAME, M_ACT_P_CHANNEL, M_ACT_P_FILENAME,
    // ACT_ClearQueue(channel)
    IDMN_ACT_CLEAR_QUEUE, M_ACT_CLEAR_QUEUE, ACT_ClearQueue, 0, 1, PARAM_EXPRESSION, M_ACT_P_CHANNEL,
    // ACT_EnableVolumeLFO(channel, rate, depth)
    IDMN_ACT_ENABLE_VOL_LFO, M_ACT_ENABLE_VOL_LFO, ACT_EnableVolumeLFO, 0, 3, PARAM_EXPRESSION, PARAM_EXPRESSION, PARAM_EXPRESSION, M_ACT_P_CHANNEL, M_ACT_P_RATE, M_ACT_P_DEPTH,
    // ACT_SetADSR(channel, attack, decay, sustain, release)
    IDMN_ACT_SET_ADSR, M_ACT_SET_ADSR, ACT_SetADSR, 0, 5, PARAM_EXPRESSION, PARAM_EXPRESSION, PARAM_EXPRESSION, PARAM_EXPRESSION, PARAM_EXPRESSION, M_ACT_P_CHANNEL, M_ACT_P_ATTACK, M_ACT_P_DECAY, M_ACT_P_SUSTAIN, M_ACT_P_RELEASE,
    // ACT_RandomizePitch(channel, range)
    IDMN_ACT_RANDOMIZE_PITCH, M_ACT_RANDOMIZE_PITCH, ACT_RandomizePitch, 0, 2, PARAM_EXPRESSION, PARAM_EXPRESSION, M_ACT_P_CHANNEL, M_ACT_P_RANGE,
    // ACT_Crossfade(fromChannel, toChannel, speed)
    IDMN_ACT_CROSSFADE, M_ACT_CROSSFADE, ACT_Crossfade, 0, 3, PARAM_EXPRESSION, PARAM_EXPRESSION, PARAM_EXPRESSION, M_ACT_P_FROM_CHANNEL, M_ACT_P_TO_CHANNEL, M_ACT_P_FADE_SPEED,
    // ACT_SetOriginFrequency(channel, freq)
    IDMN_ACT_SET_ORIGIN_FREQUENCY, M_ACT_SET_ORIGIN_FREQUENCY, ACT_SetOriginFrequency, 0, 2, PARAM_EXPRESSION, PARAM_EXPRESSION, M_ACT_P_CHANNEL, M_ACT_P_ORIGIN_FREQ,

    // ACT_StopAllChannels()
    IDMN_ACT_STOP_ALL, M_ACT_STOP_ALL, ACT_StopAllChannels, 0, 0,
    // ACT_PauseAllChannels()
    IDMN_ACT_PAUSE_ALL, M_ACT_PAUSE_ALL, ACT_PauseAllChannels, 0, 0,
    // ACT_ResumeAllChannels()
    IDMN_ACT_RESUME_ALL, M_ACT_RESUME_ALL, ACT_ResumeAllChannels, 0, 0,
    // ACT_SetAllVolumes(volume)
    IDMN_ACT_SET_ALL_VOLUMES, M_ACT_SET_ALL_VOLUMES, ACT_SetAllVolumes, 0, 1, PARAM_EXPRESSION, M_ACT_P_VOLUME,
    // ACT_SetAllFrequencySweeps(freq, speed, direction)
    IDMN_ACT_SET_ALL_FREQUENCY_SWEEPS, M_ACT_SET_ALL_FREQUENCY_SWEEPS, ACT_SetAllFrequencySweeps, 0, 3,
        PARAM_EXPRESSION, PARAM_EXPRESSION, PARAM_EXPRESSION,
        M_ACT_P_FREQUENCY, M_ACT_P_FREQ_SPEED, M_ACT_P_FREQ_DIRECTION,
    // ACT_SetAllPanning(pan)
    IDMN_ACT_SET_ALL_PANNING, M_ACT_SET_ALL_PANNING, ACT_SetAllPanning, 0, 1, PARAM_EXPRESSION, M_ACT_P_PAN,
    // ACT_EnableAllTremolos(rate, depth)
    IDMN_ACT_ENABLE_ALL_TREMOLOS, M_ACT_ENABLE_ALL_TREMOLOS, ACT_EnableAllTremolos, 0, 2,
        PARAM_EXPRESSION, PARAM_EXPRESSION, M_ACT_P_RATE, M_ACT_P_DEPTH,
    // ACT_FadeAllChannels(targetVolume, speed, state)
    IDMN_ACT_FADE_ALL_CHANNELS, M_ACT_FADE_ALL_CHANNELS, ACT_FadeAllChannels, 0, 3,
        PARAM_EXPRESSION, PARAM_EXPRESSION, PARAM_EXPRESSION,
        M_ACT_P_VOLUME, M_ACT_P_FADE_SPEED, M_ACT_P_FADE_STATE,
    // ACT_EnableAllVolumeLFOs(rate, depth)
    IDMN_ACT_ENABLE_ALL_VOLUME_LFOS, M_ACT_ENABLE_ALL_VOLUME_LFOS, ACT_EnableAllVolumeLFOs, 0, 2,
        PARAM_EXPRESSION, PARAM_EXPRESSION, M_ACT_P_RATE, M_ACT_P_DEPTH,
    // ACT_SetAllADSREnvelopes(attack, decay, sustain, release)
    IDMN_ACT_SET_ALL_ADSR_ENVELOPES, M_ACT_SET_ALL_ADSR_ENVELOPES, ACT_SetAllADSREnvelopes, 0, 4,
        PARAM_EXPRESSION, PARAM_EXPRESSION, PARAM_EXPRESSION, PARAM_EXPRESSION,
        M_ACT_P_ATTACK, M_ACT_P_DECAY, M_ACT_P_SUSTAIN, M_ACT_P_RELEASE,
    // ACT_RandomizeAllPitches(range)
    IDMN_ACT_RANDOMIZE_ALL_PITCHES, M_ACT_RANDOMIZE_ALL_PITCHES, ACT_RandomizeAllPitches, 0, 1, PARAM_EXPRESSION, M_ACT_P_RANGE,
    // ACT_SetAllOriginFrequencies(freq)
    IDMN_ACT_SET_ALL_ORIGIN_FREQUENCIES, M_ACT_SET_ALL_ORIGIN_FREQUENCIES, ACT_SetAllOriginFrequencies, 0, 1, PARAM_EXPRESSION, M_ACT_P_ORIGIN_FREQ,
    // ACT_SetChannelStopped(channel)
    IDMN_ACT_SET_CHANNEL_STOPPED, M_ACT_SET_CHANNEL_STOPPED, ACT_SetChannelStopped, 0, 1, PARAM_EXPRESSION, M_ACT_P_CHANNEL,
};

// --- EXPRESSIONS ---
short expressionsInfos[] =
{
    // EXP_GetPlaySoundName(channel) -> string
    IDMN_EXP_GET_PLAY_SOUND_NAME, M_EXP_GET_PLAY_SOUND_NAME, EXP_GetPlaySoundName, EXPFLAG_STRING, 1, EXPPARAM_LONG, M_EXP_P_CHANNEL,
    // EXP_GetPlayLoops(channel) -> int
    IDMN_EXP_GET_PLAY_LOOPS,      M_EXP_GET_PLAY_LOOPS,      EXP_GetPlayLoops,      0,              1, EXPPARAM_LONG, M_EXP_P_CHANNEL,
    // EXP_GetVolume(channel) -> float
    IDMN_EXP_GET_VOLUME,          M_EXP_GET_VOLUME,          EXP_GetVolume,          EXPFLAG_DOUBLE, 1, EXPPARAM_LONG, M_EXP_P_CHANNEL,
    // EXP_GetFrequency(channel) -> float
    IDMN_EXP_GET_FREQUENCY,       M_EXP_GET_FREQUENCY,       EXP_GetFrequency,       EXPFLAG_DOUBLE, 1, EXPPARAM_LONG, M_EXP_P_CHANNEL,
    // EXP_GetPosition(channel) -> int
    IDMN_EXP_GET_POSITION,        M_EXP_GET_POSITION,        EXP_GetPosition,        0,              1, EXPPARAM_LONG, M_EXP_P_CHANNEL,
    // EXP_GetPan(channel) -> float
    IDMN_EXP_GET_PAN,             M_EXP_GET_PAN,             EXP_GetPan,             EXPFLAG_DOUBLE, 1, EXPPARAM_LONG, M_EXP_P_CHANNEL,
    // EXP_GetTriggeredChannel() -> int
    IDMN_EXP_GET_TRIGGERED_CHANNEL, M_EXP_GET_TRIGGERED_CHANNEL, EXP_GetTriggeredChannel, 0,             0,
    // EXP_GetTriggeredName() -> string
    IDMN_EXP_GET_TRIGGERED_NAME,  M_EXP_GET_TRIGGERED_NAME,  EXP_GetTriggeredName,  EXPFLAG_STRING, 0,
    // EXP_GetTriggeredVolume() -> float
    IDMN_EXP_GET_TRIGGERED_VOLUME, M_EXP_GET_TRIGGERED_VOLUME, EXP_GetTriggeredVolume, EXPFLAG_DOUBLE, 0,
    // EXP_GetTriggeredFrequency() -> float
    IDMN_EXP_GET_TRIGGERED_FREQUENCY, M_EXP_GET_TRIGGERED_FREQUENCY, EXP_GetTriggeredFrequency, EXPFLAG_DOUBLE, 0,
    // EXP_GetTriggeredPan() -> float
    IDMN_EXP_GET_TRIGGERED_PAN,   M_EXP_GET_TRIGGERED_PAN,   EXP_GetTriggeredPan,   EXPFLAG_DOUBLE, 0,
    // EXP_GetTriggeredPosition() -> int
    IDMN_EXP_GET_TRIGGERED_POSITION, M_EXP_GET_TRIGGERED_POSITION, EXP_GetTriggeredPosition, 0,          0,
    // EXP_GetTriggeredLoops() -> int
    IDMN_EXP_GET_TRIGGERED_LOOPS, M_EXP_GET_TRIGGERED_LOOPS, EXP_GetTriggeredLoops, 0,             0,
    // EXP_GetPlayState(channel) -> int
    IDMN_EXP_GET_PLAY_STATE,      M_EXP_GET_PLAY_STATE,      EXP_GetPlayState,      0,              1, EXPPARAM_LONG, M_EXP_P_CHANNEL,
    // EXP_GetCustomTimer() -> float
    IDMN_EXP_GET_CUSTOM_TIMER,    M_EXP_GET_CUSTOM_TIMER,    EXP_GetCustomTimer,    EXPFLAG_DOUBLE, 0,
    // EXP_GetFreqOrigin(channel) -> float
    IDMN_EXP_GET_FREQ_ORIGIN,     M_EXP_GET_FREQ_ORIGIN,     EXP_GetFreqOrigin,     EXPFLAG_DOUBLE, 1, EXPPARAM_LONG, M_EXP_P_CHANNEL,
    // EXP_GetTriggeredFreqOrigin() -> float
    IDMN_EXP_GET_TRIGGERED_FREQ_ORIGIN, M_EXP_GET_TRIGGERED_FREQ_ORIGIN, EXP_GetTriggeredFreqOrigin, EXPFLAG_DOUBLE, 0,
    // EXP_GetFreqOriginPct(channel, percentage) -> float
    IDMN_EXP_GET_FREQ_ORIGIN_PCT, M_EXP_GET_FREQ_ORIGIN_PCT, EXP_GetFreqOriginPct, EXPFLAG_DOUBLE, 2, EXPPARAM_LONG, EXPPARAM_LONG, M_EXP_P_CHANNEL, M_EXP_P_PERCENTAGE,
};

// ============================================================================
// RUNTIME CALLBACKS
// ============================================================================

static inline void WriteLog(const char* message) {}

// CreateRunObject: Called when the object is created in a frame
short WINAPI DLLExport CreateRunObject(LPRDATA rdPtr, LPEDATA edPtr, fpcob cobPtr)
{
    WriteLog("CreateRunObject called");
    rdPtr->maxChannels = 48;
    rdPtr->triggeredChannel = -1;
    rdPtr->triggeredName[0] = '\0';
    rdPtr->triggeredLoop = 0;
    rdPtr->triggeredVolume = 100.0f;
    rdPtr->triggeredFrequency = 44100.0f;
    rdPtr->triggeredPosition = 0;
    rdPtr->triggeredPan = 0.0f;

    AudioManagerState::GetInstance().Initialize();
    g_lastTimePoint = std::chrono::steady_clock::now();

    return 0;
}

// DestroyRunObject: Called when the object is destroyed
short WINAPI DLLExport DestroyRunObject(LPRDATA rdPtr, long fast)
{
    WriteLog("DestroyRunObject called");
    return 0;
}

typedef int (WINAPI* LPFNISCHANNELPLAYING)(void*, int);

static bool IsClickteamChannelPlaying(LPRDATA rdPtr, int channelId) {
    static LPFNISCHANNELPLAYING pfnIsSndChannelPlaying = nullptr;
    static bool loggedStatus = false;
    if (!pfnIsSndChannelPlaying) {
        HMODULE hMod = GetModuleHandleA("mmfs2.dll");
        if (!hMod) {
            hMod = GetModuleHandleA(NULL);
        }
        if (hMod) {
            pfnIsSndChannelPlaying = (LPFNISCHANNELPLAYING)GetProcAddress(hMod, "IsSndChannelPlaying");
        }
        if (!loggedStatus) {
            char buf[128];
            sprintf_s(buf, "GetProcAddress IsSndChannelPlaying: %p", pfnIsSndChannelPlaying);
            WriteLog(buf);
            loggedStatus = true;
        }
    }
    if (pfnIsSndChannelPlaying && rdPtr->rHo.hoAdRunHeader && rdPtr->rHo.hoAdRunHeader->rhApp) {
        int internalChannel = channelId - 1;
        if (internalChannel < 0) internalChannel = 0;
        return pfnIsSndChannelPlaying(rdPtr->rHo.hoAdRunHeader->rhApp, internalChannel) != 0;
    }
    return false; // Safe fallback: mark as stopped if API unavailable
}

// HandleRunObject: Called on every frame loop inside Fusion
short WINAPI DLLExport HandleRunObject(LPRDATA rdPtr)
{
    // Calculate Delta Time in seconds
    auto currentTimePoint = std::chrono::steady_clock::now();
    std::chrono::duration<float> elapsed = currentTimePoint - g_lastTimePoint;
    g_lastTimePoint = currentTimePoint;
    float deltaTime = elapsed.count();

    // Tick the state manager
    AudioManagerState::GetInstance().Update(deltaTime);

    // Poll triggers and issue events to Clickteam Fusion event sheet
    int channelId = 0;
    std::string soundName = "";
    int loop = 0;
    float volume = 0.0f;
    float frequency = 0.0f;
    int position = 0;
    float pan = 0.0f;

    while (AudioManagerState::GetInstance().PollTriggerPlay(channelId, soundName, loop)) {
        char buf[256];
        sprintf_s(buf, "Triggering OnPlay event: Ch=%d, Name='%s', Loop=%d", channelId, soundName.c_str(), loop);
        WriteLog(buf);
        rdPtr->triggeredChannel = channelId;
        strcpy_s(rdPtr->triggeredName, soundName.c_str());
        rdPtr->triggeredLoop = loop;
        callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, CND_OnPlay, 0);
        callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, CND_OnAnyPlay, 0);
    }

    while (AudioManagerState::GetInstance().PollTriggerStop(channelId)) {
        char buf[128];
        sprintf_s(buf, "Triggering OnStop event: Ch=%d", channelId);
        WriteLog(buf);
        rdPtr->triggeredChannel = channelId;
        callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, CND_OnStop, 0);
        callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, CND_OnAnyStop, 0);
    }

    while (AudioManagerState::GetInstance().PollTriggerPause(channelId)) {
        rdPtr->triggeredChannel = channelId;
        callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, CND_OnPause, 0);
        callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, CND_OnAnyPause, 0);
    }

    while (AudioManagerState::GetInstance().PollTriggerResume(channelId)) {
        rdPtr->triggeredChannel = channelId;
        callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, CND_OnResume, 0);
        callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, CND_OnAnyResume, 0);
    }

    while (AudioManagerState::GetInstance().PollTriggerVolume(channelId, volume)) {
        rdPtr->triggeredChannel = channelId;
        rdPtr->triggeredVolume = volume;
        callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, CND_OnSetVolume, 0);
        callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, CND_OnAnySetVolume, 0);
    }

    while (AudioManagerState::GetInstance().PollTriggerFreq(channelId, frequency)) {
        rdPtr->triggeredChannel = channelId;
        rdPtr->triggeredFrequency = frequency;
        callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, CND_OnSetFrequency, 0);
        callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, CND_OnAnySetFrequency, 0);
    }

    while (AudioManagerState::GetInstance().PollTriggerPosition(channelId, position)) {
        rdPtr->triggeredChannel = channelId;
        rdPtr->triggeredPosition = position;
        callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, CND_OnSetPosition, 0);
        callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, CND_OnAnySetPosition, 0);
    }

    while (AudioManagerState::GetInstance().PollTriggerPan(channelId, pan)) {
        rdPtr->triggeredChannel = channelId;
        rdPtr->triggeredPan = pan;
        callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, CND_OnSetPan, 0);
        callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, CND_OnAnySetPan, 0);
    }

    while (AudioManagerState::GetInstance().PollTriggerFadeComplete(channelId)) {
        rdPtr->triggeredChannel = channelId;
        callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, CND_OnFadeComplete, 0);
        callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, CND_OnAnyFadeComplete, 0);
    }

    return 0;
}

// ============================================================================
// HELPERS
// ============================================================================

// Helper to decode raw float bits from CNC_GetFloatParameter
static inline float GetFloatParamHelper(LPRDATA rdPtr) {
    long tmp = CNC_GetFloatParameter(rdPtr);
    return *(float*)&tmp;
}

// Helper to safely extract UTF-8 std::string from Clickteam Fusion Unicode parameter
static std::string GetStringParamUTF8(LPRDATA rdPtr)
{
#ifdef _UNICODE
    const wchar_t* wstr = (const wchar_t*)CNC_GetStringParameter(rdPtr);
    if (!wstr || *wstr == 0) return "";
    int len = WideCharToMultiByte(CP_UTF8, 0, wstr, -1, NULL, 0, NULL, NULL);
    if (len <= 0) return "";
    std::string str(len - 1, 0);
    WideCharToMultiByte(CP_UTF8, 0, wstr, -1, &str[0], len, NULL, NULL);
    return str;
#else
    const char* str = (const char*)CNC_GetStringParameter(rdPtr);
    return str ? std::string(str) : "";
#endif
}

// Helper to return string from Clickteam expressions
static inline LPTSTR ReturnStringExpression(LPRDATA rdPtr, const std::string& str) {
#ifdef _UNICODE
    int len = MultiByteToWideChar(CP_UTF8, 0, str.c_str(), -1, NULL, 0);
    LPTSTR wstr = (LPTSTR)callRunTimeFunction(rdPtr, RFUNCTION_GETSTRINGSPACE_EX, 0, len * sizeof(wchar_t));
    if (wstr) {
        MultiByteToWideChar(CP_UTF8, 0, str.c_str(), -1, wstr, len);
    }
    return wstr;
#else
    LPTSTR astr = (LPTSTR)callRunTimeFunction(rdPtr, RFUNCTION_GETSTRINGSPACE_EX, 0, (str.length() + 1) * sizeof(char));
    if (astr) {
        strcpy_s(astr, str.length() + 1, str.c_str());
    }
    return astr;
#endif
}

// ============================================================================
// CONDITIONS IMPLEMENTATION
// ============================================================================

long WINAPI CondOnPlay(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    char buf[128];
    sprintf_s(buf, "CondOnPlay called: Parameter channel=%d, Triggered channel=%d", channelId, rdPtr->triggeredChannel);
    WriteLog(buf);
    return (channelId == -1 || rdPtr->triggeredChannel == channelId) ? TRUE : FALSE;
}

long WINAPI CondOnStop(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    return (channelId == -1 || rdPtr->triggeredChannel == channelId) ? TRUE : FALSE;
}

long WINAPI CondOnPause(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    return (channelId == -1 || rdPtr->triggeredChannel == channelId) ? TRUE : FALSE;
}

long WINAPI CondOnResume(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    return (channelId == -1 || rdPtr->triggeredChannel == channelId) ? TRUE : FALSE;
}

long WINAPI CondOnSetVolume(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    return (channelId == -1 || rdPtr->triggeredChannel == channelId) ? TRUE : FALSE;
}

long WINAPI CondOnSetFrequency(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    return (channelId == -1 || rdPtr->triggeredChannel == channelId) ? TRUE : FALSE;
}

long WINAPI CondOnSetPosition(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    return (channelId == -1 || rdPtr->triggeredChannel == channelId) ? TRUE : FALSE;
}

long WINAPI CondOnSetPan(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    return (channelId == -1 || rdPtr->triggeredChannel == channelId) ? TRUE : FALSE;
}

long WINAPI CondIsPlaying(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    if (channelId == -1) {
        for (int i = 1; i <= 48; ++i) {
            ChannelState* ch = AudioManagerState::GetInstance().GetChannel(i);
            if (ch && ch->playingState == 1) return TRUE;
        }
        return FALSE;
    }
    ChannelState* ch = AudioManagerState::GetInstance().GetChannel(channelId);
    return (ch && ch->playingState == 1) ? TRUE : FALSE;
}

long WINAPI CondIsPaused(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    if (channelId == -1) {
        for (int i = 1; i <= 48; ++i) {
            ChannelState* ch = AudioManagerState::GetInstance().GetChannel(i);
            if (ch && ch->playingState == 2) return TRUE;
        }
        return FALSE;
    }
    ChannelState* ch = AudioManagerState::GetInstance().GetChannel(channelId);
    return (ch && ch->playingState == 2) ? TRUE : FALSE;
}

long WINAPI CondIsStopped(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    if (channelId == -1) {
        for (int i = 1; i <= 48; ++i) {
            ChannelState* ch = AudioManagerState::GetInstance().GetChannel(i);
            if (ch && ch->playingState == 3) return TRUE;
        }
        return FALSE;
    }
    ChannelState* ch = AudioManagerState::GetInstance().GetChannel(channelId);
    return (ch && ch->playingState == 3) ? TRUE : FALSE;
}

long WINAPI CondOnFadeComplete(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    return (channelId == -1 || rdPtr->triggeredChannel == channelId) ? TRUE : FALSE;
}

long WINAPI CondOnAnyPlay(LPRDATA rdPtr, long param1, long param2) { return TRUE; }
long WINAPI CondOnAnyStop(LPRDATA rdPtr, long param1, long param2) { return TRUE; }
long WINAPI CondOnAnyPause(LPRDATA rdPtr, long param1, long param2) { return TRUE; }
long WINAPI CondOnAnyResume(LPRDATA rdPtr, long param1, long param2) { return TRUE; }
long WINAPI CondOnAnySetVolume(LPRDATA rdPtr, long param1, long param2) { return TRUE; }
long WINAPI CondOnAnySetFrequency(LPRDATA rdPtr, long param1, long param2) { return TRUE; }
long WINAPI CondOnAnySetPosition(LPRDATA rdPtr, long param1, long param2) { return TRUE; }
long WINAPI CondOnAnySetPan(LPRDATA rdPtr, long param1, long param2) { return TRUE; }
long WINAPI CondOnAnyFadeComplete(LPRDATA rdPtr, long param1, long param2) { return TRUE; }

// ============================================================================
// ACTIONS IMPLEMENTATION
// ============================================================================

// PlayAudio(channel, filename, loopFlag, startMs, endMs, volume, freq)
short WINAPI ActPlayAudio(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    std::string filename = GetStringParamUTF8(rdPtr);
    int loopFlag = CNC_GetIntParameter(rdPtr);
    int startMs = CNC_GetIntParameter(rdPtr);
    int endMs = CNC_GetIntParameter(rdPtr);
    float volume = static_cast<float>(CNC_GetIntParameter(rdPtr));
    float freq = static_cast<float>(CNC_GetIntParameter(rdPtr));

    char buf[512];
    sprintf_s(buf, "ActPlayAudio called: Ch=%d, Path='%s', Loop=%d, Start=%d, End=%d, Vol=%.1f, Freq=%.1f",
              channelId, filename.c_str(), loopFlag, startMs, endMs, volume, freq);
    WriteLog(buf);

    AudioManagerState::GetInstance().PlayAudio(channelId, filename, loopFlag, startMs, endMs, volume, freq);
    return 0;
}

// StopAudio(channel)
short WINAPI ActStopAudio(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    AudioManagerState::GetInstance().StopAudio(channelId);
    return 0;
}

// PauseAudio(channel)
short WINAPI ActPauseAudio(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    AudioManagerState::GetInstance().PauseAudio(channelId);
    return 0;
}

// ResumeAudio(channel)
short WINAPI ActResumeAudio(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    AudioManagerState::GetInstance().ResumeAudio(channelId);
    return 0;
}

// QueueAudio(channel, filename, fadeOutSpeed, fadeInSpeed)
short WINAPI ActQueueAudio(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    std::string filename = GetStringParamUTF8(rdPtr);
    float fadeOutSpeed = GetFloatParamHelper(rdPtr);
    float fadeInSpeed = GetFloatParamHelper(rdPtr);
    AudioManagerState::GetInstance().QueueAudio(channelId, filename, fadeOutSpeed, fadeInSpeed);
    return 0;
}

// SetVolume(channel, volume)
short WINAPI ActSetVolume(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    float volume = static_cast<float>(CNC_GetIntParameter(rdPtr));
    AudioManagerState::GetInstance().SetVolume(channelId, volume);
    return 0;
}

// SetFrequency(channel, freq, speed, direction)
short WINAPI ActSetFrequency(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    float freq = static_cast<float>(CNC_GetIntParameter(rdPtr));
    float speed = static_cast<float>(CNC_GetIntParameter(rdPtr));
    int direction = CNC_GetIntParameter(rdPtr);
    AudioManagerState::GetInstance().SetFrequency(channelId, freq, speed, direction);
    return 0;
}

// SetPan(channel, pan)
short WINAPI ActSetPan(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    float pan = static_cast<float>(CNC_GetIntParameter(rdPtr));
    AudioManagerState::GetInstance().SetPan(channelId, pan);
    return 0;
}

// EnableTremolo(channel, rate, depth)
short WINAPI ActEnableTremolo(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    int rate = CNC_GetIntParameter(rdPtr);
    float depth = static_cast<float>(CNC_GetIntParameter(rdPtr));
    AudioManagerState::GetInstance().EnableTremolo(channelId, rate, depth);
    return 0;
}

// FadeChannel(channel, targetVolume, speed, state)
short WINAPI ActFadeChannel(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    float targetVolume = static_cast<float>(CNC_GetIntParameter(rdPtr));
    float speed = static_cast<float>(CNC_GetIntParameter(rdPtr));
    int state = CNC_GetIntParameter(rdPtr);
    AudioManagerState::GetInstance().FadeChannel(channelId, targetVolume, speed, state);
    return 0;
}

// EnqueueTrack(channel, filename)
short WINAPI ActEnqueueTrack(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    std::string filename = GetStringParamUTF8(rdPtr);
    AudioManagerState::GetInstance().EnqueueTrack(channelId, filename);
    return 0;
}

// ClearQueue(channel)
short WINAPI ActClearQueue(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    AudioManagerState::GetInstance().ClearQueue(channelId);
    return 0;
}

// EnableVolumeLFO(channel, rate, depth)
short WINAPI ActEnableVolumeLFO(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    float rate = static_cast<float>(CNC_GetIntParameter(rdPtr));
    float depth = static_cast<float>(CNC_GetIntParameter(rdPtr));
    AudioManagerState::GetInstance().EnableVolumeLFO(channelId, rate, depth);
    return 0;
}

// SetADSR(channel, attack, decay, sustain, release)
short WINAPI ActSetADSR(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    float attack = static_cast<float>(CNC_GetIntParameter(rdPtr));
    float decay = static_cast<float>(CNC_GetIntParameter(rdPtr));
    float sustain = static_cast<float>(CNC_GetIntParameter(rdPtr));
    float release = static_cast<float>(CNC_GetIntParameter(rdPtr));
    AudioManagerState::GetInstance().SetADSR(channelId, attack, decay, sustain, release);
    return 0;
}

// RandomizePitch(channel, range)
short WINAPI ActRandomizePitch(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    float range = static_cast<float>(CNC_GetIntParameter(rdPtr));
    AudioManagerState::GetInstance().RandomizePitch(channelId, range);
    return 0;
}

// Crossfade(fromChannel, toChannel, speed)
short WINAPI ActCrossfade(LPRDATA rdPtr, long param1, long param2)
{
    int fromChannel = CNC_GetIntParameter(rdPtr);
    int toChannel = CNC_GetIntParameter(rdPtr);
    float speed = static_cast<float>(CNC_GetIntParameter(rdPtr));
    AudioManagerState::GetInstance().Crossfade(fromChannel, toChannel, speed);
    return 0;
}

// SetOriginFrequency(channel, freq)
short WINAPI ActSetOriginFrequency(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    float freq = GetFloatParamHelper(rdPtr);
    AudioManagerState::GetInstance().SetOriginFrequency(channelId, freq);
    return 0;
}

// StopAllChannels()
short WINAPI ActStopAllChannels(LPRDATA rdPtr, long param1, long param2)
{
    AudioManagerState::GetInstance().StopAudio(-1);
    return 0;
}

// PauseAllChannels()
short WINAPI ActPauseAllChannels(LPRDATA rdPtr, long param1, long param2)
{
    AudioManagerState::GetInstance().PauseAudio(-1);
    return 0;
}

// ResumeAllChannels()
short WINAPI ActResumeAllChannels(LPRDATA rdPtr, long param1, long param2)
{
    AudioManagerState::GetInstance().ResumeAudio(-1);
    return 0;
}

// SetAllVolumes(volume)
short WINAPI ActSetAllVolumes(LPRDATA rdPtr, long param1, long param2)
{
    float volume = static_cast<float>(CNC_GetIntParameter(rdPtr));
    AudioManagerState::GetInstance().SetVolume(-1, volume);
    return 0;
}

// SetAllFrequencySweeps(freq, speed, direction)
short WINAPI ActSetAllFrequencySweeps(LPRDATA rdPtr, long param1, long param2)
{
    float freq = GetFloatParamHelper(rdPtr);
    float speed = GetFloatParamHelper(rdPtr);
    int direction = CNC_GetIntParameter(rdPtr);
    AudioManagerState::GetInstance().SetFrequency(-1, freq, speed, direction);
    return 0;
}

// SetAllPanning(pan)
short WINAPI ActSetAllPanning(LPRDATA rdPtr, long param1, long param2)
{
    float pan = static_cast<float>(CNC_GetIntParameter(rdPtr));
    AudioManagerState::GetInstance().SetPan(-1, pan);
    return 0;
}

// EnableAllTremolos(rate, depth)
short WINAPI ActEnableAllTremolos(LPRDATA rdPtr, long param1, long param2)
{
    int rate = CNC_GetIntParameter(rdPtr);
    float depth = static_cast<float>(CNC_GetIntParameter(rdPtr));
    AudioManagerState::GetInstance().EnableTremolo(-1, rate, depth);
    return 0;
}

// FadeAllChannels(targetVolume, speed, state)
short WINAPI ActFadeAllChannels(LPRDATA rdPtr, long param1, long param2)
{
    float targetVolume = static_cast<float>(CNC_GetIntParameter(rdPtr));
    float speed = static_cast<float>(CNC_GetIntParameter(rdPtr));
    int state = CNC_GetIntParameter(rdPtr);
    AudioManagerState::GetInstance().FadeChannel(-1, targetVolume, speed, state);
    return 0;
}

// EnableAllVolumeLFOs(rate, depth)
short WINAPI ActEnableAllVolumeLFOs(LPRDATA rdPtr, long param1, long param2)
{
    float rate = static_cast<float>(CNC_GetIntParameter(rdPtr));
    float depth = static_cast<float>(CNC_GetIntParameter(rdPtr));
    AudioManagerState::GetInstance().EnableVolumeLFO(-1, rate, depth);
    return 0;
}

// SetAllADSREnvelopes(attack, decay, sustain, release)
short WINAPI ActSetAllADSREnvelopes(LPRDATA rdPtr, long param1, long param2)
{
    float attack = static_cast<float>(CNC_GetIntParameter(rdPtr));
    float decay = static_cast<float>(CNC_GetIntParameter(rdPtr));
    float sustain = static_cast<float>(CNC_GetIntParameter(rdPtr));
    float release = static_cast<float>(CNC_GetIntParameter(rdPtr));
    AudioManagerState::GetInstance().SetADSR(-1, attack, decay, sustain, release);
    return 0;
}

// RandomizeAllPitches(range)
short WINAPI ActRandomizeAllPitches(LPRDATA rdPtr, long param1, long param2)
{
    float range = static_cast<float>(CNC_GetIntParameter(rdPtr));
    AudioManagerState::GetInstance().RandomizePitch(-1, range);
    return 0;
}

// SetAllOriginFrequencies(freq)
short WINAPI ActSetAllOriginFrequencies(LPRDATA rdPtr, long param1, long param2)
{
    float freq = GetFloatParamHelper(rdPtr);
    AudioManagerState::GetInstance().SetOriginFrequency(-1, freq);
    return 0;
}

// SetChannelStopped(channel)
short WINAPI ActSetChannelStopped(LPRDATA rdPtr, long param1, long param2)
{
    int channelId = CNC_GetIntParameter(rdPtr);
    AudioManagerState::GetInstance().NotifyChannelStopped(channelId);
    return 0;
}

// ============================================================================
// EXPRESSIONS IMPLEMENTATION
// ============================================================================

// ExpGetPlaySoundName(channel)
long WINAPI ExpGetPlaySoundName(LPRDATA rdPtr, long param1)
{
    int channelId = CNC_GetFirstExpressionParameter(rdPtr, param1, TYPE_INT);
    ChannelState* ch = AudioManagerState::GetInstance().GetChannel(channelId);
    std::string name = ch ? ch->soundName : "";
    
    char buf[512];
    sprintf_s(buf, "ExpGetPlaySoundName called: Ch=%d, returning string='%s'", channelId, name.c_str());
    WriteLog(buf);

    rdPtr->rHo.hoFlags |= HOF_STRING;
    return (long)ReturnStringExpression(rdPtr, name);
}

// ExpGetPlayLoops(channel)
long WINAPI ExpGetPlayLoops(LPRDATA rdPtr, long param1)
{
    int channelId = CNC_GetFirstExpressionParameter(rdPtr, param1, TYPE_INT);
    ChannelState* ch = AudioManagerState::GetInstance().GetChannel(channelId);
    return ch ? ch->loopFlag : 0;
}

// ExpGetVolume(channel)
long WINAPI ExpGetVolume(LPRDATA rdPtr, long param1)
{
    int channelId = CNC_GetFirstExpressionParameter(rdPtr, param1, TYPE_INT);
    ChannelState* ch = AudioManagerState::GetInstance().GetChannel(channelId);
    float val = ch ? ch->volume : 0.0f;
    rdPtr->rHo.hoFlags |= HOF_FLOAT;
    return *(long*)&val;
}

// ExpGetFrequency(channel)
long WINAPI ExpGetFrequency(LPRDATA rdPtr, long param1)
{
    int channelId = CNC_GetFirstExpressionParameter(rdPtr, param1, TYPE_INT);
    ChannelState* ch = AudioManagerState::GetInstance().GetChannel(channelId);
    float val = ch ? ch->freqRate : 0.0f;
    rdPtr->rHo.hoFlags |= HOF_FLOAT;
    return *(long*)&val;
}

// ExpGetPosition(channel)
long WINAPI ExpGetPosition(LPRDATA rdPtr, long param1)
{
    int channelId = CNC_GetFirstExpressionParameter(rdPtr, param1, TYPE_INT);
    ChannelState* ch = AudioManagerState::GetInstance().GetChannel(channelId);
    // In our wrapper, the developer queries the channel position natively on Clickteam,
    // but we can return the current managed position or triggered position.
    return rdPtr->triggeredChannel == channelId ? rdPtr->triggeredPosition : 0;
}

// ExpGetPan(channel)
long WINAPI ExpGetPan(LPRDATA rdPtr, long param1)
{
    int channelId = CNC_GetFirstExpressionParameter(rdPtr, param1, TYPE_INT);
    ChannelState* ch = AudioManagerState::GetInstance().GetChannel(channelId);
    float val = ch ? ch->pan : 0.0f;
    rdPtr->rHo.hoFlags |= HOF_FLOAT;
    return *(long*)&val;
}

// ExpGetTriggeredChannel() — returns the channel that fired the current trigger
long WINAPI ExpGetTriggeredChannel(LPRDATA rdPtr, long param1)
{
    return rdPtr->triggeredChannel;
}

// ExpGetTriggeredName$() — returns the sound name from the current Play trigger
long WINAPI ExpGetTriggeredName(LPRDATA rdPtr, long param1)
{
    int len = (int)strlen(rdPtr->triggeredName) + 1;
    char* buf = (char*)callRunTimeFunction(rdPtr, RFUNCTION_GETSTRINGSPACE_EX, 0, len);
    if (buf) memcpy(buf, rdPtr->triggeredName, len);
    rdPtr->rHo.hoFlags |= HOF_STRING;
    return (long)buf;
}

// ExpGetTriggeredVolume() — returns the volume from the current trigger
long WINAPI ExpGetTriggeredVolume(LPRDATA rdPtr, long param1)
{
    float val = rdPtr->triggeredVolume;
    rdPtr->rHo.hoFlags |= HOF_FLOAT;
    return *(long*)&val;
}

// ExpGetTriggeredFrequency() — returns the frequency from the current trigger
long WINAPI ExpGetTriggeredFrequency(LPRDATA rdPtr, long param1)
{
    float val = rdPtr->triggeredFrequency;
    rdPtr->rHo.hoFlags |= HOF_FLOAT;
    return *(long*)&val;
}

// ExpGetTriggeredPan() — returns the pan from the current trigger
long WINAPI ExpGetTriggeredPan(LPRDATA rdPtr, long param1)
{
    float val = rdPtr->triggeredPan;
    rdPtr->rHo.hoFlags |= HOF_FLOAT;
    return *(long*)&val;
}

// ExpGetTriggeredPosition() — returns the position from the current trigger
long WINAPI ExpGetTriggeredPosition(LPRDATA rdPtr, long param1)
{
    return rdPtr->triggeredPosition;
}

// ExpGetTriggeredLoops() — returns the loop flag from the current trigger
long WINAPI ExpGetTriggeredLoops(LPRDATA rdPtr, long param1)
{
    return rdPtr->triggeredLoop;
}

// ExpGetPlayState(channel) — returns 1=Playing, 2=Paused, 3=Stopped
long WINAPI ExpGetPlayState(LPRDATA rdPtr, long param1)
{
    int channelId = CNC_GetFirstExpressionParameter(rdPtr, param1, TYPE_INT);
    ChannelState* ch = AudioManagerState::GetInstance().GetChannel(channelId);
    return ch ? ch->playingState : 3;
}

// ExpGetCustomTimer() — returns float runtime in seconds
long WINAPI ExpGetCustomTimer(LPRDATA rdPtr, long param1)
{
    float val = AudioManagerState::GetInstance().GetCustomTimer();
    rdPtr->rHo.hoFlags |= HOF_FLOAT;
    return *(long*)&val;
}

// ExpGetFreqOrigin(channel) — returns the stored origin frequency of a channel
long WINAPI ExpGetFreqOrigin(LPRDATA rdPtr, long param1)
{
    int channelId = CNC_GetFirstExpressionParameter(rdPtr, param1, TYPE_INT);
    ChannelState* ch = AudioManagerState::GetInstance().GetChannel(channelId);
    float val = ch ? ch->freqOrigin : 44100.0f;
    rdPtr->rHo.hoFlags |= HOF_FLOAT;
    return *(long*)&val;
}

// ExpGetTriggeredFreqOrigin() — returns the freqOrigin of the channel that fired the current trigger
long WINAPI ExpGetTriggeredFreqOrigin(LPRDATA rdPtr, long param1)
{
    ChannelState* ch = AudioManagerState::GetInstance().GetChannel(rdPtr->triggeredChannel);
    float val = ch ? ch->freqOrigin : 44100.0f;
    rdPtr->rHo.hoFlags |= HOF_FLOAT;
    return *(long*)&val;
}

// ExpGetFreqOriginPct(channel, percentage) — returns freqOrigin * (pct / 100)
long WINAPI ExpGetFreqOriginPct(LPRDATA rdPtr, long param1)
{
    int channelId = CNC_GetFirstExpressionParameter(rdPtr, param1, TYPE_INT);
    int pct       = CNC_GetNextExpressionParameter(rdPtr, param1, TYPE_INT);
    ChannelState* ch = AudioManagerState::GetInstance().GetChannel(channelId);
    float origin = ch ? ch->freqOrigin : 44100.0f;
    float val = origin * (pct / 100.0f);
    // Guard: never return 0 or below
    if (val <= 0.0f) val = ch ? ch->freqMin : 5512.5f;
    rdPtr->rHo.hoFlags |= HOF_FLOAT;
    return *(long*)&val;
}

// ============================================================================
// JUMP TABLES
// ============================================================================

long (WINAPI * ConditionJumps[])(LPRDATA rdPtr, long param1, long param2) =
{
    CondOnPlay,
    CondOnStop,
    CondOnPause,
    CondOnResume,
    CondOnSetVolume,
    CondOnSetFrequency,
    CondOnSetPosition,
    CondOnSetPan,
    CondIsPlaying,
    CondIsPaused,
    CondIsStopped,
    CondOnFadeComplete,
    CondOnAnyPlay,
    CondOnAnyStop,
    CondOnAnyPause,
    CondOnAnyResume,
    CondOnAnySetVolume,
    CondOnAnySetFrequency,
    CondOnAnySetPosition,
    CondOnAnySetPan,
    CondOnAnyFadeComplete
};

short (WINAPI * ActionJumps[])(LPRDATA rdPtr, long param1, long param2) =
{
    ActPlayAudio,
    ActStopAudio,
    ActPauseAudio,
    ActResumeAudio,
    ActQueueAudio,
    ActSetVolume,
    ActSetFrequency,
    ActSetPan,
    ActEnableTremolo,
    ActFadeChannel,
    ActEnqueueTrack,
    ActClearQueue,
    ActEnableVolumeLFO,
    ActSetADSR,
    ActRandomizePitch,
    ActCrossfade,
    ActSetOriginFrequency,
    ActStopAllChannels,
    ActPauseAllChannels,
    ActResumeAllChannels,
    ActSetAllVolumes,
    ActSetAllFrequencySweeps,
    ActSetAllPanning,
    ActEnableAllTremolos,
    ActFadeAllChannels,
    ActEnableAllVolumeLFOs,
    ActSetAllADSREnvelopes,
    ActRandomizeAllPitches,
    ActSetAllOriginFrequencies,
    ActSetChannelStopped
};

long (WINAPI * ExpressionJumps[])(LPRDATA rdPtr, long param) =
{
    ExpGetPlaySoundName,
    ExpGetPlayLoops,
    ExpGetVolume,
    ExpGetFrequency,
    ExpGetPosition,
    ExpGetPan,
    ExpGetTriggeredChannel,
    ExpGetTriggeredName,
    ExpGetTriggeredVolume,
    ExpGetTriggeredFrequency,
    ExpGetTriggeredPan,
    ExpGetTriggeredPosition,
    ExpGetTriggeredLoops,
    ExpGetPlayState,
    ExpGetCustomTimer,
    ExpGetFreqOrigin,
    ExpGetTriggeredFreqOrigin,
    ExpGetFreqOriginPct
};

#pragma once
#include "Common.hpp"
#include "Src/AudioManagerState.h"

class Extension final
{
public:
	RunHeader* rhPtr;
	RunObjectMultiPlatPtr rdPtr;

#ifdef __ANDROID__
	global<jobject> javaExtPtr;
#elif defined(__APPLE__)
	void* const objCExtPtr;
#endif

	Edif::Runtime Runtime;

	static const int MinimumBuild = 254;
	static const int Version = 1;

	static constexpr OEFLAGS OEFLAGS = OEFLAGS::NEVER_SLEEP | OEFLAGS::RUN_BEFORE_FADE_IN | OEFLAGS::VALUES | OEFLAGS::SCROLLING_INDEPENDENT | OEFLAGS::NEVER_KILL;
	static constexpr OEPREFS OEPREFS = OEPREFS::NONE;

#ifdef _WIN32
	Extension(RunObject* const rdPtr, const EDITDATA* const edPtr, const CreateObjectInfo* const cobPtr);
#elif defined(__ANDROID__)
	Extension(const EDITDATA* const edPtr, const jobject javaExtPtr, const CreateObjectInfo* const cobPtr);
#else
	Extension(const EDITDATA* const edPtr, void* const objCExtPtr, const CreateObjectInfo* const cobPtr);
#endif
	~Extension();

	// Trigger Context Storage for Event Bridge
	short triggeredChannel = 0;
	std::string triggeredName = "";
	int triggeredLoop = 0;
	float triggeredVolume = 100.0f;
	float triggeredFrequency = 44100.0f;
	int triggeredPosition = 0;
	float triggeredPan = 0.0f;
	float triggeredFreqOrigin = 44100.0f;

	// Actions (30 Total)
	void PlayAudio(int ch, const TCHAR* path, int loop, int startMs, int endMs, float volume, float freq);
	void StopAudio(int ch);
	void PauseAudio(int ch);
	void ResumeAudio(int ch);
	void QueueAudio(int ch, const TCHAR* path, float fadeOutSpeed, float fadeInSpeed);
	void SetVolume(int ch, float volume);
	void SetFrequency(int ch, float targetFreq, float speed, int direction);
	void SetPan(int ch, float pan);
	void EnableTremolo(int ch, float rate, float depth);
	void FadeChannel(int ch, float targetVol, float speed, int state);
	void EnqueueTrack(int ch, const TCHAR* path);
	void ClearQueue(int ch);
	void EnableVolumeLFO(int ch, float rate, float depth);
	void SetADSR(int ch, float attack, float decay, float sustain, float release);
	void RandomizePitch(int ch, float range);
	void Crossfade(int fromCh, int toCh, float speed);
	void CrossfadeParallel(int fromCh, const TCHAR* nextSample, float speed, int toCh);
	void SequentialTransition(int fromCh, const TCHAR* nextSample, float outSpeed, int toCh, float inSpeed);
	void SetOriginFrequency(int ch, float freq);
	void StopAllChannels();
	void PauseAllChannels();
	void ResumeAllChannels();
	void SetAllVolumes(float volume);
	void SetAllFrequencySweeps(float freq, float speed, int direction);
	void SetAllPanning(float pan);
	void EnableAllTremolos(float rate, float depth);
	void FadeAllChannels(float targetVol, float speed, int state);
	void EnableAllVolumeLFOs(float rate, float depth);
	void SetAllADSREnvelopes(float attack, float decay, float sustain, float release);
	void RandomizeAllPitches(float range);
	void SetAllOriginFrequencies(float freq);
	void SetChannelStopped(int ch);
	
	// New AAA Actions
	void PlayWithRandomVariance(int ch, const TCHAR* path, int loop, int startMs, int endMs, float baseVolume, float volVariance, float baseFreq, float freqVariance);
	void UpdateSpatialAudio(int ch, float sourceX, float sourceY, float listenerX, float listenerY, float maxDistance, float rolloffFactor);

	// Conditions (21 Total)
	bool OnPlay(int ch);
	bool OnStop(int ch);
	bool OnPause(int ch);
	bool OnResume(int ch);
	bool OnSetVolume(int ch);
	bool OnSetFrequency(int ch);
	bool OnSetPosition(int ch);
	bool OnSetPan(int ch);
	bool IsPlaying(int ch);
	bool IsPaused(int ch);
	bool IsStopped(int ch);
	bool OnFadeComplete(int ch);
	bool OnAnyPlay();
	bool OnAnyStop();
	bool OnAnyPause();
	bool OnAnyResume();
	bool OnAnySetVolume();
	bool OnAnySetFrequency();
	bool OnAnySetPosition();
	bool OnAnySetPan();
	bool OnAnyFadeComplete();

	// Expressions (18 Total)
	const TCHAR* GetPlaySoundName(int ch);
	int GetPlayLoops(int ch);
	float GetVolume(int ch);
	float GetFrequency(int ch);
	int GetPosition(int ch);
	float GetPan(int ch);
	int GetTriggeredChannel();
	const TCHAR* GetTriggeredName();
	float GetTriggeredVolume();
	float GetTriggeredFrequency();
	float GetTriggeredPan();
	int GetTriggeredPosition();
	int GetTriggeredLoops();
	int GetPlayState(int ch);
	float GetCustomTimer();
	float GetFreqOrigin(int ch);
	float GetTriggeredFreqOrigin();
	float GetFreqOriginPct(int ch, float pct);

	REFLAG Handle();

	void UnlinkedAction(int ID);
	long UnlinkedCondition(int ID);
	long UnlinkedExpression(int ID);
};

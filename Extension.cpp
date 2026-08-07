#include "Common.hpp"

#ifdef _WIN32
Extension::Extension(RunObject* const _rdPtr, const EDITDATA* const edPtr, const CreateObjectInfo* const cobPtr) :
	rdPtr(_rdPtr), rhPtr(_rdPtr->get_rHo()->get_AdRunHeader()), Runtime(this)
#elif defined(__ANDROID__)
Extension::Extension(const EDITDATA* const edPtr, const jobject javaExtPtr, const CreateObjectInfo* const cobPtr) :
	javaExtPtr(javaExtPtr, "Extension::javaExtPtr from Extension ctor"),
	Runtime(this, this->javaExtPtr)
#else
Extension::Extension(const EDITDATA* const edPtr, void* const objCExtPtr, const CreateObjectInfo* const cobPtr) :
	objCExtPtr(objCExtPtr), Runtime(this, objCExtPtr)
#endif
{
	// Initialize Audio Manager State
	AudioManagerState::GetInstance().Initialize();

	// Actions
	LinkAction(0, PlayAudio);
	LinkAction(1, StopAudio);
	LinkAction(2, PauseAudio);
	LinkAction(3, ResumeAudio);
	LinkAction(4, QueueAudio);
	LinkAction(5, SetVolume);
	LinkAction(6, SetFrequency);
	LinkAction(7, SetPan);
	LinkAction(8, EnableTremolo);
	LinkAction(9, FadeChannel);
	LinkAction(10, EnqueueTrack);
	LinkAction(11, ClearQueue);
	LinkAction(12, EnableVolumeLFO);
	LinkAction(13, SetADSR);
	LinkAction(14, RandomizePitch);
	LinkAction(15, Crossfade);
	LinkAction(16, SetOriginFrequency);
	LinkAction(17, StopAllChannels);
	LinkAction(18, PauseAllChannels);
	LinkAction(19, ResumeAllChannels);
	LinkAction(20, SetAllVolumes);
	LinkAction(21, SetAllFrequencySweeps);
	LinkAction(22, SetAllPanning);
	LinkAction(23, EnableAllTremolos);
	LinkAction(24, FadeAllChannels);
	LinkAction(25, EnableAllVolumeLFOs);
	LinkAction(26, SetAllADSREnvelopes);
	LinkAction(27, RandomizeAllPitches);
	LinkAction(28, SetAllOriginFrequencies);
	LinkAction(29, SetChannelStopped);
	LinkAction(30, PlayWithRandomVariance);
	LinkAction(31, UpdateSpatialAudio);
	LinkAction(32, CrossfadeParallel);
	LinkAction(33, SequentialTransition);
	// Conditions
	LinkCondition(0, OnPlay);
	LinkCondition(1, OnStop);
	LinkCondition(2, OnPause);
	LinkCondition(3, OnResume);
	LinkCondition(4, OnSetVolume);
	LinkCondition(5, OnSetFrequency);
	LinkCondition(6, OnSetPosition);
	LinkCondition(7, OnSetPan);
	LinkCondition(8, IsPlaying);
	LinkCondition(9, IsPaused);
	LinkCondition(10, IsStopped);
	LinkCondition(11, OnFadeComplete);
	LinkCondition(12, OnAnyPlay);
	LinkCondition(13, OnAnyStop);
	LinkCondition(14, OnAnyPause);
	LinkCondition(15, OnAnyResume);
	LinkCondition(16, OnAnySetVolume);
	LinkCondition(17, OnAnySetFrequency);
	LinkCondition(18, OnAnySetPosition);
	LinkCondition(19, OnAnySetPan);
	LinkCondition(20, OnAnyFadeComplete);

	// Expressions
	LinkExpression(0, GetPlaySoundName);
	LinkExpression(1, GetPlayLoops);
	LinkExpression(2, GetVolume);
	LinkExpression(3, GetFrequency);
	LinkExpression(4, GetPosition);
	LinkExpression(5, GetPan);
	LinkExpression(6, GetTriggeredChannel);
	LinkExpression(7, GetTriggeredName);
	LinkExpression(8, GetTriggeredVolume);
	LinkExpression(9, GetTriggeredFrequency);
	LinkExpression(10, GetTriggeredPan);
	LinkExpression(11, GetTriggeredPosition);
	LinkExpression(12, GetTriggeredLoops);
	LinkExpression(13, GetPlayState);
	LinkExpression(14, GetCustomTimer);
	LinkExpression(15, GetFreqOrigin);
	LinkExpression(16, GetTriggeredFreqOrigin);
	LinkExpression(17, GetFreqOriginPct);
}

Extension::~Extension()
{
}

REFLAG Extension::Handle()
{
	// Update DSP state machine every frame tick (~1/60s)
	float deltaTime = 1.0f / 60.0f;
	AudioManagerState::GetInstance().Update(deltaTime);

	int chId = 0;
	std::string sName = "";
	int loopCount = 0;
	float vol = 0.0f, freq = 0.0f, pan = 0.0f;
	int pos = 0;

	// Poll triggers and fire events
	while (AudioManagerState::GetInstance().PollTriggerStop(chId)) {
		triggeredChannel = (short)chId;
		Runtime.GenerateEvent(1);  // OnStop
		Runtime.GenerateEvent(13); // OnAnyStop
	}

	while (AudioManagerState::GetInstance().PollTriggerPlay(chId, sName, loopCount, vol, freq, pos, pan)) {
		triggeredChannel = (short)chId;
		triggeredName = sName;
		triggeredLoop = loopCount;
		triggeredVolume = vol;
		triggeredFrequency = freq;
		triggeredPosition = pos;
		triggeredPan = pan;
		Runtime.GenerateEvent(0);  // OnPlay
		Runtime.GenerateEvent(12); // OnAnyPlay
	}

	while (AudioManagerState::GetInstance().PollTriggerPause(chId)) {
		triggeredChannel = (short)chId;
		Runtime.GenerateEvent(2);  // OnPause
		Runtime.GenerateEvent(14); // OnAnyPause
	}

	while (AudioManagerState::GetInstance().PollTriggerResume(chId)) {
		triggeredChannel = (short)chId;
		Runtime.GenerateEvent(3);  // OnResume
		Runtime.GenerateEvent(15); // OnAnyResume
	}

	while (AudioManagerState::GetInstance().PollTriggerVolume(chId, vol)) {
		triggeredChannel = (short)chId;
		triggeredVolume = vol;
		Runtime.GenerateEvent(4);  // OnSetVolume
		Runtime.GenerateEvent(16); // OnAnySetVolume
	}

	while (AudioManagerState::GetInstance().PollTriggerFreq(chId, freq)) {
		triggeredChannel = (short)chId;
		triggeredFrequency = freq;
		Runtime.GenerateEvent(5);  // OnSetFrequency
		Runtime.GenerateEvent(17); // OnAnySetFrequency
	}

	while (AudioManagerState::GetInstance().PollTriggerPosition(chId, pos)) {
		triggeredChannel = (short)chId;
		triggeredPosition = pos;
		Runtime.GenerateEvent(6);  // OnSetPosition
		Runtime.GenerateEvent(18); // OnAnySetPosition
	}

	while (AudioManagerState::GetInstance().PollTriggerPan(chId, pan)) {
		triggeredChannel = (short)chId;
		triggeredPan = pan;
		Runtime.GenerateEvent(7);  // OnSetPan
		Runtime.GenerateEvent(19); // OnAnySetPan
	}

	while (AudioManagerState::GetInstance().PollTriggerFadeComplete(chId)) {
		triggeredChannel = (short)chId;
		Runtime.GenerateEvent(11); // OnFadeComplete
		Runtime.GenerateEvent(20); // OnAnyFadeComplete
	}

	return REFLAG::NONE; // Continue ticking every frame
}

void Extension::UnlinkedAction(int ID)
{
	DarkEdif::MsgBox::Error(_T("SonoraFX Error"), _T("Unlinked Action ID: %d"), ID);
}

long Extension::UnlinkedCondition(int ID)
{
	DarkEdif::MsgBox::Error(_T("SonoraFX Error"), _T("Unlinked Condition ID: %d"), ID);
	return 0;
}

long Extension::UnlinkedExpression(int ID)
{
	DarkEdif::MsgBox::Error(_T("SonoraFX Error"), _T("Unlinked Expression ID: %d"), ID);
	return 0;
}

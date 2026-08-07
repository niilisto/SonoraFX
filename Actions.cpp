#include "Common.hpp"
#include <cstdlib>
#include <cmath>
// Helper function string conversion for TCHAR -> std::string
static std::string TCHARToString(const TCHAR* tstr) {
    if (!tstr) return "";
#ifdef UNICODE
    int size = WideCharToMultiByte(CP_UTF8, 0, tstr, -1, NULL, 0, NULL, NULL);
    if (size <= 0) return "";
    std::string str(size - 1, 0);
    WideCharToMultiByte(CP_UTF8, 0, tstr, -1, &str[0], size, NULL, NULL);
    return str;
#else
    return std::string(tstr);
#endif
}

void Extension::PlayAudio(int ch, const TCHAR* path, int loop, int startMs, int endMs, float volume, float freq)
{
	std::string sPath = TCHARToString(path);
	AudioManagerState::GetInstance().PlayAudio(ch, sPath, loop, startMs, endMs, volume, freq);
}

void Extension::StopAudio(int ch)
{
	AudioManagerState::GetInstance().StopAudio(ch);
}

void Extension::PauseAudio(int ch)
{
	AudioManagerState::GetInstance().PauseAudio(ch);
}

void Extension::ResumeAudio(int ch)
{
	AudioManagerState::GetInstance().ResumeAudio(ch);
}

void Extension::QueueAudio(int ch, const TCHAR* path, float fadeOutSpeed, float fadeInSpeed)
{
	std::string sPath = TCHARToString(path);
	AudioManagerState::GetInstance().QueueAudio(ch, sPath, fadeOutSpeed, fadeInSpeed);
}

void Extension::SetVolume(int ch, float volume)
{
	AudioManagerState::GetInstance().SetVolume(ch, volume);
}

void Extension::SetFrequency(int ch, float targetFreq, float speed, int direction)
{
	AudioManagerState::GetInstance().SetFrequency(ch, targetFreq, speed, direction);
}

void Extension::SetPan(int ch, float pan)
{
	AudioManagerState::GetInstance().SetPan(ch, pan);
}

void Extension::EnableTremolo(int ch, float rate, float depth)
{
	AudioManagerState::GetInstance().EnableTremolo(ch, rate, depth);
}

void Extension::FadeChannel(int ch, float targetVol, float speed, int state)
{
	AudioManagerState::GetInstance().FadeChannel(ch, targetVol, speed, state);
}

void Extension::EnqueueTrack(int ch, const TCHAR* path)
{
	std::string sPath = TCHARToString(path);
	AudioManagerState::GetInstance().EnqueueTrack(ch, sPath);
}

void Extension::ClearQueue(int ch)
{
	AudioManagerState::GetInstance().ClearQueue(ch);
}

void Extension::EnableVolumeLFO(int ch, float rate, float depth)
{
	AudioManagerState::GetInstance().EnableVolumeLFO(ch, rate, depth);
}

void Extension::SetADSR(int ch, float attack, float decay, float sustain, float release)
{
	AudioManagerState::GetInstance().SetADSR(ch, attack, decay, sustain, release);
}

void Extension::RandomizePitch(int ch, float range)
{
	AudioManagerState::GetInstance().RandomizePitch(ch, range);
}

void Extension::Crossfade(int fromCh, int toCh, float speed)
{
	AudioManagerState::GetInstance().Crossfade(fromCh, toCh, speed);
}

void Extension::CrossfadeParallel(int fromCh, const TCHAR* nextSample, float speed, int toCh)
{
	if (!nextSample) return;
	std::string sSample = TCHARToString(nextSample);
	AudioManagerState::GetInstance().CrossfadeParallel(fromCh, toCh, sSample, speed);
}

void Extension::SequentialTransition(int fromCh, const TCHAR* nextSample, float outSpeed, int toCh, float inSpeed)
{
	if (!nextSample) return;
	std::string sSample = TCHARToString(nextSample);
	AudioManagerState::GetInstance().SequentialTransition(fromCh, toCh, sSample, outSpeed, inSpeed);
}

void Extension::SetOriginFrequency(int ch, float freq)
{
	AudioManagerState::GetInstance().SetOriginFrequency(ch, freq);
}

void Extension::StopAllChannels()
{
	for (int c = 1; c <= 48; ++c) {
		AudioManagerState::GetInstance().StopAudio(c);
	}
}

void Extension::PauseAllChannels()
{
	for (int c = 1; c <= 48; ++c) {
		AudioManagerState::GetInstance().PauseAudio(c);
	}
}

void Extension::ResumeAllChannels()
{
	for (int c = 1; c <= 48; ++c) {
		AudioManagerState::GetInstance().ResumeAudio(c);
	}
}

void Extension::SetAllVolumes(float volume)
{
	for (int c = 1; c <= 48; ++c) {
		AudioManagerState::GetInstance().SetVolume(c, volume);
	}
}

void Extension::SetAllFrequencySweeps(float freq, float speed, int direction)
{
	for (int c = 1; c <= 48; ++c) {
		AudioManagerState::GetInstance().SetFrequency(c, freq, speed, direction);
	}
}

void Extension::SetAllPanning(float pan)
{
	for (int c = 1; c <= 48; ++c) {
		AudioManagerState::GetInstance().SetPan(c, pan);
	}
}

void Extension::EnableAllTremolos(float rate, float depth)
{
	for (int c = 1; c <= 48; ++c) {
		AudioManagerState::GetInstance().EnableTremolo(c, rate, depth);
	}
}

void Extension::FadeAllChannels(float targetVol, float speed, int state)
{
	for (int c = 1; c <= 48; ++c) {
		AudioManagerState::GetInstance().FadeChannel(c, targetVol, speed, state);
	}
}

void Extension::EnableAllVolumeLFOs(float rate, float depth)
{
	for (int c = 1; c <= 48; ++c) {
		AudioManagerState::GetInstance().EnableVolumeLFO(c, rate, depth);
	}
}

void Extension::SetAllADSREnvelopes(float attack, float decay, float sustain, float release)
{
	for (int c = 1; c <= 48; ++c) {
		AudioManagerState::GetInstance().SetADSR(c, attack, decay, sustain, release);
	}
}

void Extension::RandomizeAllPitches(float range)
{
	for (int c = 1; c <= 48; ++c) {
		AudioManagerState::GetInstance().RandomizePitch(c, range);
	}
}

void Extension::SetAllOriginFrequencies(float freq)
{
	for (int c = 1; c <= 48; ++c) {
		AudioManagerState::GetInstance().SetOriginFrequency(c, freq);
	}
}

void Extension::SetChannelStopped(int ch)
{
	AudioManagerState::GetInstance().NotifyChannelStopped(ch);
}

void Extension::PlayWithRandomVariance(int ch, const TCHAR* path, int loop, int startMs, int endMs, float baseVolume, float volVariance, float baseFreq, float freqVariance)
{
	float r1 = ((std::rand() % 2000) / 1000.0f) - 1.0f; // -1.0 to 1.0
	float r2 = ((std::rand() % 2000) / 1000.0f) - 1.0f; // -1.0 to 1.0
	
	float finalVol = baseVolume + (r1 * volVariance);
	if (finalVol < 0.0f) finalVol = 0.0f;
	if (finalVol > 100.0f) finalVol = 100.0f;

	float finalFreq = baseFreq + (r2 * freqVariance);
	if (finalFreq < 100.0f) finalFreq = 100.0f;

	std::string sPath = TCHARToString(path);
	AudioManagerState::GetInstance().PlayAudio(ch, sPath, loop, startMs, endMs, finalVol, finalFreq);
}

void Extension::UpdateSpatialAudio(int ch, float sourceX, float sourceY, float listenerX, float listenerY, float maxDistance, float rolloffFactor)
{
	float dx = sourceX - listenerX;
	float dy = sourceY - listenerY;
	float dist = std::sqrt(dx * dx + dy * dy);

	float targetVol = 0.0f;
	float targetPan = 0.0f;

	if (maxDistance > 0.0f && dist < maxDistance)
	{
		float distRatio = dist / maxDistance;
		float factor = std::pow(distRatio, rolloffFactor);
		
		targetVol = 100.0f * (1.0f - factor);
		if (targetVol < 0.0f) targetVol = 0.0f;

		targetPan = (dx / maxDistance) * 100.0f;
		if (targetPan < -100.0f) targetPan = -100.0f;
		if (targetPan > 100.0f) targetPan = 100.0f;
	}
	else if (dist >= maxDistance)
	{
		targetVol = 0.0f;
		targetPan = (dx > 0) ? 100.0f : -100.0f;
	}

	AudioManagerState::GetInstance().SetVolume(ch, targetVol);
	AudioManagerState::GetInstance().SetPan(ch, targetPan);
}

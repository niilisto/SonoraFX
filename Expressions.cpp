#include "Common.hpp"

// String conversion helper for std::string -> std::wstring
static std::wstring StringToWString(const std::string& str) {
    if (str.empty()) return L"";
    int size = MultiByteToWideChar(CP_UTF8, 0, &str[0], (int)str.size(), NULL, 0);
    std::wstring wstr(size, 0);
    MultiByteToWideChar(CP_UTF8, 0, &str[0], (int)str.size(), &wstr[0], size);
    return wstr;
}

const TCHAR* Extension::GetPlaySoundName(int ch)
{
	ChannelState* cs = AudioManagerState::GetInstance().GetChannel(ch);
	std::wstring wname = cs ? StringToWString(cs->soundName) : L"";
	return Runtime.CopyString(wname.c_str());
}

int Extension::GetPlayLoops(int ch)
{
	ChannelState* cs = AudioManagerState::GetInstance().GetChannel(ch);
	return cs ? cs->loopFlag : 0;
}

float Extension::GetVolume(int ch)
{
	ChannelState* cs = AudioManagerState::GetInstance().GetChannel(ch);
	return cs ? cs->volume : 0.0f;
}

float Extension::GetFrequency(int ch)
{
	ChannelState* cs = AudioManagerState::GetInstance().GetChannel(ch);
	return cs ? cs->freqRate : 0.0f;
}

int Extension::GetPosition(int ch)
{
	ChannelState* cs = AudioManagerState::GetInstance().GetChannel(ch);
	return cs ? cs->positionMs : 0;
}

float Extension::GetPan(int ch)
{
	ChannelState* cs = AudioManagerState::GetInstance().GetChannel(ch);
	return cs ? cs->pan : 0.0f;
}

int Extension::GetTriggeredChannel()
{
	return (int)triggeredChannel;
}

const TCHAR* Extension::GetTriggeredName()
{
	std::wstring wname = StringToWString(triggeredName);
	return Runtime.CopyString(wname.c_str());
}

float Extension::GetTriggeredVolume()
{
	return triggeredVolume;
}

float Extension::GetTriggeredFrequency()
{
	return triggeredFrequency;
}

float Extension::GetTriggeredPan()
{
	return triggeredPan;
}

int Extension::GetTriggeredPosition()
{
	return triggeredPosition;
}

int Extension::GetTriggeredLoops()
{
	return triggeredLoop;
}

int Extension::GetPlayState(int ch)
{
	ChannelState* cs = AudioManagerState::GetInstance().GetChannel(ch);
	return cs ? cs->playingState : 3;
}

float Extension::GetCustomTimer()
{
	return AudioManagerState::GetInstance().GetCustomTimer();
}

float Extension::GetFreqOrigin(int ch)
{
	ChannelState* cs = AudioManagerState::GetInstance().GetChannel(ch);
	return cs ? cs->freqOrigin : 44100.0f;
}

float Extension::GetTriggeredFreqOrigin()
{
	return triggeredFreqOrigin;
}

float Extension::GetFreqOriginPct(int ch, float pct)
{
	ChannelState* cs = AudioManagerState::GetInstance().GetChannel(ch);
	float origin = cs ? cs->freqOrigin : 44100.0f;
	float val = origin * (pct / 100.0f);
	if (val <= 0.0f) val = cs ? cs->freqMin : 5512.5f;
	return val;
}

#include "Common.hpp"

bool Extension::OnPlay(int ch)
{
	return (triggeredChannel == ch);
}

bool Extension::OnStop(int ch)
{
	return (triggeredChannel == ch);
}

bool Extension::OnPause(int ch)
{
	return (triggeredChannel == ch);
}

bool Extension::OnResume(int ch)
{
	return (triggeredChannel == ch);
}

bool Extension::OnSetVolume(int ch)
{
	return (triggeredChannel == ch);
}

bool Extension::OnSetFrequency(int ch)
{
	return (triggeredChannel == ch);
}

bool Extension::OnSetPosition(int ch)
{
	return (triggeredChannel == ch);
}

bool Extension::OnSetPan(int ch)
{
	return (triggeredChannel == ch);
}

bool Extension::IsPlaying(int ch)
{
	if (ch == 0) {
		for (int c = 1; c <= 48; ++c) {
			ChannelState* cs = AudioManagerState::GetInstance().GetChannel(c);
			if (cs && cs->playingState == 1) return true;
		}
		return false;
	}
	ChannelState* cs = AudioManagerState::GetInstance().GetChannel(ch);
	return (cs && cs->playingState == 1);
}

bool Extension::IsPaused(int ch)
{
	if (ch == 0) {
		for (int c = 1; c <= 48; ++c) {
			ChannelState* cs = AudioManagerState::GetInstance().GetChannel(c);
			if (cs && cs->playingState == 2) return true;
		}
		return false;
	}
	ChannelState* cs = AudioManagerState::GetInstance().GetChannel(ch);
	return (cs && cs->playingState == 2);
}

bool Extension::IsStopped(int ch)
{
	ChannelState* cs = AudioManagerState::GetInstance().GetChannel(ch);
	return (cs == nullptr || cs->playingState == 3);
}

bool Extension::OnFadeComplete(int ch)
{
	return (triggeredChannel == ch);
}

bool Extension::OnAnyPlay()
{
	return true;
}

bool Extension::OnAnyStop()
{
	return true;
}

bool Extension::OnAnyPause()
{
	return true;
}

bool Extension::OnAnyResume()
{
	return true;
}

bool Extension::OnAnySetVolume()
{
	return true;
}

bool Extension::OnAnySetFrequency()
{
	return true;
}

bool Extension::OnAnySetPosition()
{
	return true;
}

bool Extension::OnAnySetPan()
{
	return true;
}

bool Extension::OnAnyFadeComplete()
{
	return true;
}

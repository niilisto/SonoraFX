# SonoraFX - Full Technical Reference Manual

This document provides a comprehensive reference for all **21 Conditions**, **30 Actions**, and **18 Expressions** available in the **SonoraFX** extension for Clickteam Fusion 2.5.

---

## 1. Conditions Reference (21 Conditions)

### Wildcard / Any-Channel Triggers (0 Parameters)
These triggers execute whenever an event occurs on any channel. They form the backbone of the Command Bridge.

| ID | Condition Name | Description |
| :--- | :--- | :--- |
| `CND_OnAnyPlay` | **On Any Play Command** | Fires when a play command is issued to any channel. |
| `CND_OnAnyStop` | **On Any Stop Command** | Fires when a stop command is issued to any channel. |
| `CND_OnAnyPause` | **On Any Pause Command** | Fires when a pause command is issued to any channel. |
| `CND_OnAnyResume` | **On Any Resume Command** | Fires when a resume command is issued to any channel. |
| `CND_OnAnySetVolume` | **On Any Volume Change Command** | Fires when volume changes on any channel (includes LFOs). |
| `CND_OnAnySetFrequency` | **On Any Frequency Change Command** | Fires when pitch changes on any channel (includes sweeps/LFOs). |
| `CND_OnAnySetPosition` | **On Any Position Change Command** | Fires when playback position is updated. |
| `CND_OnAnySetPan` | **On Any Pan Change Command** | Fires when stereo panning is modified. |
| `CND_OnAnyFadeComplete` | **On Any Fade Complete Command** | Fires when a volume fade completes on any channel. |

### Specific Channel Triggers (1 Parameter: Channel ID)
| ID | Condition Name | Description |
| :--- | :--- | :--- |
| `CND_OnPlay` | **On Play Command (Ch N)** | Fires when Channel N is ordered to play. |
| `CND_OnStop` | **On Stop Command (Ch N)** | Fires when Channel N is ordered to stop. |
| `CND_OnPause` | **On Pause Command (Ch N)** | Fires when Channel N is paused. |
| `CND_OnResume` | **On Resume Command (Ch N)** | Fires when Channel N is resumed. |
| `CND_OnSetVolume` | **On Volume Change (Ch N)** | Fires when Channel N volume is updated. |
| `CND_OnSetFrequency` | **On Frequency Change (Ch N)** | Fires when Channel N pitch/frequency is updated. |
| `CND_OnSetPosition` | **On Position Change (Ch N)** | Fires when Channel N playback position is updated. |
| `CND_OnSetPan` | **On Pan Change (Ch N)** | Fires when Channel N panning is updated. |
| `CND_OnFadeComplete` | **On Fade Complete (Ch N)** | Fires when Channel N volume fade finishes. |

### State Checks
| ID | Condition Name | Description |
| :--- | :--- | :--- |
| `CND_IsPlaying` | **Is Channel N Playing?** | True if Channel N is playing. Pass `0` to check if *any* channel is playing. |
| `CND_IsPaused` | **Is Channel N Paused?** | True if Channel N is paused. Pass `0` to check if *any* channel is paused. |
| `CND_IsStopped` | **Is Channel N Stopped?** | True if Channel N is stopped. |

---

## 2. Actions Reference (30 Actions)

### Specific Channel Actions (Parameter: Channel ID 1..48, or 0 for Free Channel)
- `ActPlayAudio(Ch, Path, Loop, Start, End, Vol, Freq)`: Main play action. Pass `Ch = 0` for smart free channel selection.
- `ActPlayRandomVariance(Ch, Path, Loop, Start, End, BaseVol, VolVar, BaseFreq, FreqVar)`: Plays audio applying a random variance `(+/- offset)` to the volume and pitch every time. Pass `Ch = 0` for free channel routing.
- `ActUpdateSpatialAudio2D(Ch, SrcX, SrcY, LsnrX, LsnrY, MaxDist, Rolloff)`: Calculates real-time euclidian distance attenuation and X-axis panning between a sound source and a listener (camera).
- `ActStopAudio(Ch)`: Stops playback on specified channel.
- `ActPauseAudio(Ch)`: Pauses playback.
- `ActResumeAudio(Ch)`: Resumes paused playback.
- `ActSetVolume(Ch, Vol)`: Sets channel volume (0 to 100).
- `ActSetFrequency(Ch, TargetFreq, Speed, Direction)`: Adjusts frequency or triggers pitch sweep / LFO shapes:
  - `Direction 0`: Smooth return to baseline origin frequency.
  - `Direction 1`: Slide Up towards target frequency.
  - `Direction -1`: Slide Down towards target frequency.
  - `Direction 2`: Sine wave LFO oscillation.
  - `Direction 3`: Knockout slide (slide pitch down to 0).
  - `Direction 4`: Triangle wave LFO oscillation.
  - `Direction 5`: Square wave LFO oscillation.
  - `Direction 6`: Sawtooth wave LFO oscillation.
- `ActSetPan(Ch, Pan)`: Sets stereo panning (-100 Left, 0 Center, 100 Right).
- `ActEnableTremolo(Ch, Rate, Depth)`: Enables volume tremolo LFO.
- `ActFadeChannel(Ch, TargetVol, Speed, State)`: Initiates volume fade in (`State=1`) or fade out (`State=-1`).
- `ActEnqueueTrack(Ch, Path)`: Enqueues a sound track to the channel playlist.
- `ActClearQueue(Ch)`: Clears all queued tracks in the channel playlist.
- `ActEnableVolumeLFO(Ch, Rate, Depth)`: Enables volume LFO oscillation.
- `ActSetADSR(Ch, Attack, Decay, Sustain, Release)`: Configures synthesizer ADSR volume envelope.
- `ActRandomizePitch(Ch, Range)`: Randomizes pitch by ±Range Hz for organic sound variety.
- `ActCrossfade(FromCh, ToCh, Speed)`: Fades out `FromCh` while fading in `ToCh`.
- `ActSetOriginFrequency(Ch, Freq)`: Overrides the baseline origin frequency for pitch calculations.
- `ActSetChannelStopped(Ch)`: Manually notifies C++ state machine that a native channel has stopped.

### All Channels Actions (Global Master Controls)
- `ActStopAllChannels()`: Stops all 48 channels.
- `ActPauseAllChannels()`: Pauses all 48 channels.
- `ActResumeAllChannels()`: Resumes all 48 channels.
- `ActSetAllVolumes(Vol)`: Adjusts volume across all 48 channels.
- `ActSetAllFrequencySweeps(Freq, Speed, Direction)`: Applies frequency sweep/LFO across all channels.
- `ActSetAllPanning(Pan)`: Sets master panning across all channels.
- `ActEnableAllTremolos(Rate, Depth)`: Enables tremolo across all channels.
- `ActFadeAllChannels(TargetVol, Speed, State)`: Master volume fade across all channels.
- `ActEnableAllVolumeLFOs(Rate, Depth)`: Enables volume LFOs across all channels.
- `ActSetAllADSREnvelopes(A, D, S, R)`: Configures ADSR envelopes across all channels.
- `ActRandomizeAllPitches(Range)`: Randomizes pitches across all channels.
- `ActSetAllOriginFrequencies(Freq)`: Overrides origin frequencies across all channels.

---

## 3. Expressions Reference (18 Expressions)

### Event Bridge Readers
- `TriggeredChannel()`: Returns the channel ID (1..48) associated with the active trigger.
- `ExpGetPlaySoundName(Ch)`: Returns the sound file path or sample string for specified channel.
- `TriggeredVolume()`: Returns calculated volume float (0..100).
- `TriggeredFrequency()`: Returns calculated pitch frequency float in Hz.
- `TriggeredPan()`: Returns calculated stereo panning float (-100..100).
- `TriggeredPosition()`: Returns playback position in milliseconds.
- `TriggeredLoops()`: Returns requested loop count.

### Inspectors & Calculators
- `ExpGetPlayState(Ch)`: Returns state integer (1 = Playing, 2 = Paused, 3 = Stopped).
- `ExpGetFreqOrigin(Ch)`: Returns baseline sample rate in Hz (e.g. 44100.0).
- `ExpGetTriggeredFreqOrigin()`: Returns baseline sample rate of current triggered channel.
- `ExpGetFreqOriginPct(Ch, Pct)`: Returns calculated target frequency for percentage `Pct` (e.g. 400% = 4x pitch), protecting against 0 Hz crashes.
- `ExpGetCustomTimer()`: Returns high-precision internal C++ runtime timer in seconds.

---

## 4. Multi-Platform Exporter Compatibility Guide

Because **SonoraFX** operates as a high-level state manager and delegates physical audio output back to Fusion via Event Sheet triggers (`On Any Play Command`), its architecture is **100% platform-agnostic** and can be extended to any Clickteam Fusion exporter.

To port SonoraFX to additional exporter runtimes using the official SDK templates located in `SDKs/`:

1. **Windows (C++ - `SDKs/windows/Fusion25SDK/`)**:
   - Native C++ implementation (`AudioManager.mfx`). Builds via Visual Studio using MSBuild.

2. **Android (Java - `SDKs/android/`)**:
   - Implement the `ChannelState` class in Java inside `CRunExtension.java`.
   - Map `PlayAudio`, `SetVolume`, and `SetFrequency` to update channel state objects and invoke `callGenerateEvent`.
   - The exact same Fusion Event Sheet bridge rules will function seamlessly on Android.

3. **HTML5 (JavaScript - `SDKs/html/`)**:
   - Implement `ChannelState` as a JavaScript object array in `CRunExtension.js`.
   - Manage state ticks inside `getNumberOfConditions` and dispatch trigger events via `generate_event`.

4. **iOS (Objective-C - `SDKs/ios/`)**:
   - Implement the `ChannelState` struct and update loop inside `CRunExtension.m`.

5. **Flash / ActionScript 3 (`SDKs/flash/`)**:
   - Implement `ChannelState` inside `CRunExtension.as`.

---

## 5. Flexible Dynamic Free Channel Allocation

To ensure maximum flexibility across different sound effect lengths:
- **Looping Audio (`Loops = 0`)**: Automatically treated as persistent background audio (BGM). Channels playing infinite loops will never be auto-released or overwritten by `Play Audio Ch 0`.
- **Non-Looping Audio (`Loops > 0`)**: Treated as sound effects (SFX). Sound effect channels dynamically auto-release after playback or via the `Set Channel Stopped` action, returning the channel to the free pool.
- **Explicit Channel Overrides**: Specific channel IDs (1 to 48) always take precedence over dynamic channel allocation (`Ch 0`).

---

## 6. Support & Donations 💖

If **SonoraFX** helped you build awesome audio systems for your games, consider supporting ongoing development!

- ☕ **Support on Ko-fi**: [ko-fi.com/nihil](https://ko-fi.com/nihil)


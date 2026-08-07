# SonoraFX for Clickteam Fusion 2.5+ (DarkEdif)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform: Windows](https://img.shields.io/badge/Platform-Windows%20%28x86%2FUnicode%29-lightgrey.svg)]()
[![Framework: DarkEdif](https://img.shields.io/badge/Framework-DarkEdif%20C%2B%2B17-orange.svg)]()
[![Donate](https://img.shields.io/badge/Donate-Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/nihil)

<img width="128" height="128" alt="icon" src="https://github.com/user-attachments/assets/1a5a8b77-036c-418a-b407-4d3661479d0e" />

**SonoraFX** is an advanced, high-performance audio control extension designed for Clickteam Fusion 2.5+. Built on the modern **DarkEdif C++17 framework**, it bridges Fusion's native sound player with a powerful C++ state machine, empowering game developers with features like **dynamic free-channel allocation**, **frequency pitch sweeps & wave LFOs**, **volume tremolo**, **ADSR envelopes**, **playlists**, and **seamless crossfades**.

---

## 🛠️ DarkEdif Architecture & Cross-Platform Engine

SonoraFX has been fully ported to the **DarkEdif C++17 extension SDK**:

1. **JSON-Driven ACE Manifest (`DarkExt.json`)**: 100% 1:1 definition of all 30 Actions, 21 Conditions, and 18 Expressions, parameter validation types, and localized editor menus.
2. **Legacy `EDITDATA` Auto-Migration**: Built-in property reader conversion allowing seamless upgrade of existing `.mfa` project files saved with previous MMF2SDK versions — no property reading errors.
3. **Multi-Platform Runtime Bridges**: Pre-built runtime support for **Windows (.mfx)**, **HTML5 (.js)**, **Android (.java)**, **iOS/Mac (.m)**, and **Flash (.as)**.
4. **Optimized DSP & Event Engine**: Lock-free thread-safe channel polling state machine with event throttling to prevent CPU saturation on wildcard channel operations (`Channel -1`).

---

## 🌟 Key Features

- **Smart Free Channel Allocation (`Channel 0`)**: Automatically assigns sound effects to the lowest available free channel (from 1 to 48) while leaving background music channels completely untouched.
- **Random Variance**: Automatically rolls a dice using `std::rand()` to apply subtle volume and pitch variations every time a sound effect plays, removing robotic repetition.
- **2D Spatial Audio**: Real-time euclidean distance calculation for volume attenuation (with custom Rolloff factor) and X-axis based stereo panning for perfect positional audio without heavy math loops.
- **Pitch Sweeps & Wave LFOs**: Smooth frequency slides and pitch modulations with 7 wave shapes (*Sine, Triangle, Square, Sawtooth, Slide Up, Slide Down, Knockout*).
- **Pitch Origin Safety (`GetFreqOriginPct`)**: Prevents sample frequency reset crashes when pitching up or down by anchoring calculations to the audio's original sample rate.
- **Volume Tremolo & ADSR Envelopes**: Add organic volume oscillations or synthesizer-style Attack-Decay-Sustain-Release envelopes.
- **Multi-Track Playlists**: Queue sound effects or music tracks sequentially per channel with automatic auto-advance.
- **Seamless Crossfading**: Transition smoothly between any two audio channels at configurable speeds.
- **Clean Command Bridge**: Integrates seamlessly with Fusion's native `Sound` object using 9 wildcard "Any Channel" triggers.

---

## 🚀 Quick Start & Event Sheet Setup

SonoraFX manages states and pitch curves internally, delegating physical sound playback to Fusion's native engine via a simple, one-time Event Sheet bridge setup.

Add these 6 events to your **Global Events** or **Frame Event Sheet**:

```text
* SonoraFX: On Any Play Command
  -> Sound : Play sample GetPlaySoundName$( "SonoraFX", TriggeredChannel( "SonoraFX" ) ), TriggeredLoops( "SonoraFX" ) times, on channel #TriggeredChannel( "SonoraFX" ), volume TriggeredVolume( "SonoraFX" ), pan TriggeredPan( "SonoraFX" ), frequency TriggeredFrequency( "SonoraFX" )

* SonoraFX: On Any Frequency Change Command
  -> Sound : Set frequency of channel #TriggeredChannel( "SonoraFX" ) to TriggeredFrequency( "SonoraFX" )

* SonoraFX: On Any Volume Change Command
  -> Sound : Set volume of channel #TriggeredChannel( "SonoraFX" ) to TriggeredVolume( "SonoraFX" )

* SonoraFX: On Any Stop Command
  -> Sound : Stop channel #TriggeredChannel( "SonoraFX" )

* SonoraFX: On Any Pause Command
  -> Sound : Pause channel #TriggeredChannel( "SonoraFX" )

* SonoraFX: On Any Resume Command
  -> Sound : Resume channel #TriggeredChannel( "SonoraFX" )
```

---

## 💡 Example Usage

### 1. Playing a Sound Effect on a Free Channel
```text
* Upon pressing "Space bar"
  -> SonoraFX : Play Ch 0: "Explosion.wav" (Loops=1 Start=0 End=0 Vol=100 Freq=0)
```
*SonoraFX automatically routes the explosion to Channel 1 (or the lowest idle channel), without cutting off background music running on Channel 48!*

### 2. Pitch Sweep (Slide Up to 4x Original Rate)
```text
* Upon pressing "C"
  -> SonoraFX : Set Ch -1 Freq Sweep (Target=GetFreqOriginPct("SonoraFX", -1, 400), Speed=20, Direction=1)
```

### 3. Crossfading Background Music
```text
* Upon entering Boss Room
  -> SonoraFX : Crossfade Ch 47 to Ch 48 (Speed=2)
```

---

## 📦 Installation

1. Download the latest pre-compiled `SonoraFX.mfx` from the Releases section.
2. Copy `SonoraFX.mfx` to your Clickteam Fusion 2.5 installation directories:
   - `Clickteam Fusion 2.5/Extensions/Unicode/SonoraFX.mfx`
   - `Clickteam Fusion 2.5/Data/Runtime/Unicode/SonoraFX.mfx`
3. Restart Clickteam Fusion 2.5.

---

## 💻 Building from Source

### Prerequisites
- **Visual Studio 2022** with the **Desktop development with C++** workload installed.
- **Windows 10 / 11 SDK**.

### Building via MSBuild Command Line
```cmd
MSBuild.exe SonoraFX/SonoraFX.vcxproj /p:Configuration=Release /p:Platform=Win32
```

---

## ⚠️ Known Limitations

- **Platform Testing**: Currently, this extension has been thoroughly tested on **Windows**. The iOS, HTML5, and Flash exporters require further testing in their respective environments to guarantee full stability.

---

## Support & Donations 💖

If **SonoraFX** helped you build awesome audio systems for your games, consider supporting ongoing development!

- ☕ **Support on Ko-fi**: [ko-fi.com/nihil](https://ko-fi.com/nihil)

[![Ko-fi Donate](https://img.shields.io/badge/Donate-Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/nihil)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. Created by **Niilisto (Nihil)**.


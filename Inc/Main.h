#ifndef MAIN_H
#define MAIN_H

// Clickteam SDK Headers
#include "ccx.h"
#include "ccxhdr.h"

// ============================================================================
// EXTENSION IDENTITY
// ============================================================================
#define IDENTIFIER MAKEID(A, M, G, R) // AMGR: Audio Manager
#define KCX_CURRENT_VERSION 1

// ============================================================================
// COUNT MACROS
// ============================================================================
#define CND_LAST 21 // 21 Conditions
#define ACT_LAST 30 // 30 Actions
#define EXP_LAST 18 // 18 Expressions

// Condition Codes
#define CND_OnPlay 0
#define CND_OnStop 1
#define CND_OnPause 2
#define CND_OnResume 3
#define CND_OnSetVolume 4
#define CND_OnSetFrequency 5
#define CND_OnSetPosition 6
#define CND_OnSetPan 7
#define CND_IsPlaying 8
#define CND_IsPaused 9
#define CND_IsStopped 10
#define CND_OnFadeComplete 11
#define CND_OnAnyPlay 12
#define CND_OnAnyStop 13
#define CND_OnAnyPause 14
#define CND_OnAnyResume 15
#define CND_OnAnySetVolume 16
#define CND_OnAnySetFrequency 17
#define CND_OnAnySetPosition 18
#define CND_OnAnySetPan 19
#define CND_OnAnyFadeComplete 20

// Action Codes
#define ACT_PlayAudio 0
#define ACT_StopAudio 1
#define ACT_PauseAudio 2
#define ACT_ResumeAudio 3
#define ACT_QueueAudio 4
#define ACT_SetVolume 5
#define ACT_SetFrequency 6
#define ACT_SetPan 7
#define ACT_EnableTremolo 8
#define ACT_FadeChannel 9
#define ACT_EnqueueTrack 10
#define ACT_ClearQueue 11
#define ACT_EnableVolumeLFO 12
#define ACT_SetADSR 13
#define ACT_RandomizePitch 14
#define ACT_Crossfade 15
#define ACT_SetOriginFrequency 16
#define ACT_StopAllChannels 17
#define ACT_PauseAllChannels 18
#define ACT_ResumeAllChannels 19
#define ACT_SetAllVolumes 20
#define ACT_SetAllFrequencySweeps 21
#define ACT_SetAllPanning 22
#define ACT_EnableAllTremolos 23
#define ACT_FadeAllChannels 24
#define ACT_EnableAllVolumeLFOs 25
#define ACT_SetAllADSREnvelopes 26
#define ACT_RandomizeAllPitches 27
#define ACT_SetAllOriginFrequencies 28
#define ACT_SetChannelStopped 29

// Expression Codes
#define EXP_GetPlaySoundName 0
#define EXP_GetPlayLoops 1
#define EXP_GetVolume 2
#define EXP_GetFrequency 3
#define EXP_GetPosition 4
#define EXP_GetPan 5
#define EXP_GetTriggeredChannel 6
#define EXP_GetTriggeredName 7
#define EXP_GetTriggeredVolume 8
#define EXP_GetTriggeredFrequency 9
#define EXP_GetTriggeredPan 10
#define EXP_GetTriggeredPosition 11
#define EXP_GetTriggeredLoops 12
#define EXP_GetPlayState 13
#define EXP_GetCustomTimer 14
#define EXP_GetFreqOrigin 15
#define EXP_GetTriggeredFreqOrigin 16
#define EXP_GetFreqOriginPct 17

// ============================================================================
// OBJECT DATA STRUCTURES
// ============================================================================

typedef struct tagEDATA_V1 {
  extHeader eHeader;
  short maxChannels;
} EDITDATA;
typedef EDITDATA *LPEDATA;

typedef struct tagRDATA {
  headerObject rHo;
  rVal rv; // Alterable values
  short maxChannels;

  // Trigger Context
  short triggeredChannel;
  char triggeredName[256];
  int triggeredLoop;
  float triggeredVolume;
  float triggeredFrequency;
  int triggeredPosition;
  float triggeredPan;
} RUNDATA;
typedef RUNDATA *LPRDATA;

// Size when editing the object
#define MAX_EDITSIZE sizeof(EDITDATA)

// Flags matching SDLJoystick
#define OEFLAGS                                                                \
  (OEFLAG_NEVERSLEEP | OEFLAG_RUNBEFOREFADEIN | OEFLAG_VALUES |                \
   OEFLAG_SCROLLINGINDEPENDANT | OEFLAG_NEVERKILL)
#define OEPREFS 0

#define WINDOWPROC_PRIORITY 100

#endif // MAIN_H

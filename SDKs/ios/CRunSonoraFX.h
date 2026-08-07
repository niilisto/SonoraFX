#import "CRunExtension.h"

@interface ChannelStateObjC : NSObject
@property (nonatomic, assign) int id;
@property (nonatomic, strong) NSString* soundName;
@property (nonatomic, strong) NSMutableArray* trackQueue;

@property (nonatomic, assign) float volume;
@property (nonatomic, assign) float volOrigin;
@property (nonatomic, assign) int fadeState;
@property (nonatomic, assign) float fadeSpeed;
@property (nonatomic, assign) float nextFadeInSpeed;
@property (nonatomic, assign) BOOL triggerFadeComplete;

@property (nonatomic, assign) int volLFOTrigger;
@property (nonatomic, assign) float volLFORate;
@property (nonatomic, assign) float volLFODepth;
@property (nonatomic, assign) float volLFOPhase;

@property (nonatomic, assign) int adsrState;
@property (nonatomic, assign) float adsrAttack;
@property (nonatomic, assign) float adsrDecay;
@property (nonatomic, assign) float adsrSustain;
@property (nonatomic, assign) float adsrRelease;
@property (nonatomic, assign) float adsrTimer;
@property (nonatomic, assign) float adsrStartVol;

@property (nonatomic, assign) float freqRate;
@property (nonatomic, assign) float freqSpeed;
@property (nonatomic, assign) int freqDirection;
@property (nonatomic, assign) float freqOrigin;
@property (nonatomic, assign) float freqTarget;
@property (nonatomic, assign) float freqMin;
@property (nonatomic, assign) float freqMax;
@property (nonatomic, assign) float freqLFOPhase;

@property (nonatomic, assign) int tremoloTrigger;
@property (nonatomic, assign) float tremoloRate;
@property (nonatomic, assign) float tremoloPhase;
@property (nonatomic, assign) float tremoloDepth;

@property (nonatomic, assign) int loopFlag;
@property (nonatomic, assign) int loopStart;
@property (nonatomic, assign) int loopEnd;
@property (nonatomic, assign) int playingState;
@property (nonatomic, assign) int positionMs;
@property (nonatomic, assign) float pan;
@property (nonatomic, assign) float autoReleaseTimer;

@property (nonatomic, assign) BOOL triggerPlay;
@property (nonatomic, assign) BOOL triggerStop;
@property (nonatomic, assign) BOOL triggerPause;
@property (nonatomic, assign) BOOL triggerResume;
@property (nonatomic, assign) BOOL triggerVolume;
@property (nonatomic, assign) BOOL triggerFreq;
@property (nonatomic, assign) BOOL triggerPosition;
@property (nonatomic, assign) BOOL triggerPan;

@property (nonatomic, assign) float lastVolume;
@property (nonatomic, assign) float lastFreq;
@property (nonatomic, assign) int lastPosition;
@property (nonatomic, assign) float lastPan;
@end

@interface CRunSonoraFX : CRunExtension
{
    NSMutableArray* channels;
    float customTimer;
    NSTimeInterval lastTime;

    int triggeredChannel;
    NSString* triggeredName;
    int triggeredLoop;
    float triggeredVolume;
    float triggeredFrequency;
    int triggeredPosition;
    float triggeredPan;
}

-(int)getNumberOfConditions;
-(BOOL)createRunObject:(CFile*)file withCOB:(CCreateObjectInfo*)cob andVersion:(int)version;
-(int)handleRunObject;
-(BOOL)condition:(int)num withCndExtension:(CCndExtension*)cnd;
-(void)action:(int)num withActExtension:(CActExtension*)act;
-(CValue*)expression:(int)num;

@end

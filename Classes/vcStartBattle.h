//
//  vcStartBattle.h
//  Sngr
//
//  Created by Oswald on 1/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <OpenAL/al.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>
#import "vcSngrBase.h"
#import "AudioPacket.h"

@class AudioPacket;


@interface vcStartBattle : vcSngrBase <AVAudioRecorderDelegate> {

	UIButton *				btnStartBattle;
	NSMutableDictionary *	recordSetting;
	AVAudioRecorder	*		recorder;
	NSString *				recorderfilepath;
	NSMutableArray	*		audioQueueOut;
	NSMutableArray	*		audioQueueIn;
	BOOL					recordingActive;
	BOOL					battleActive;
	NSTimer *				tmrTransport;
	NSTimer *				tmrRetrieveAudioData;
	int						nPositionID;
	int						nRetrievalID;
	int						nAudioRecordingLengthInSeconds;
	int						nAudioRetrievalIntervalInSeconds;
	int						nAudioTransportIntervalInSeconds;
	int						nAudioHeaderSize;
	int						nAudioDataSizePerSecond;
	int						nBuffer_Count;
	
}

@property (nonatomic, retain) IBOutlet UIButton *			btnStartBattle;
@property (nonatomic, retain) IBOutlet UIButton *			btnStartListening;

- (void)StartBattle:(id)sender;
- (void)StartListening:(id)sender;
- (void)InitializeRecording;
- (void)StartRecording;
- (void)StopRecording;
- (void)TransportLoop;
- (void)RetrieveAudioDataLoop;
- (void)SetupAudioQueue;
- (void)InitializeVars;
- (BOOL)GetAudioPacket:(void*)bufferID;
void AudioQueueCallBack(void *iNuserData, AudioQueueRef inAQ,
						AudioQueueBufferRef inBuffer);

@end

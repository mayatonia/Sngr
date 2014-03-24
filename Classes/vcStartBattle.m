//
//  vcStartBattle.m
//  Sngr
//
//  Created by Oswald on 1/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "vcStartBattle.h"


@implementation vcStartBattle

@synthesize btnStartBattle;


- (void)StartBattle:(id)sender{
	battleActive = YES;
	[self InitializeRecording];

}

- (void)RetrieveAudioDataLoop
{
	if (battleActive && recordingActive)
	{
		NSData *data = nil;
		int nAudioDataSize = nAudioDataSizePerSecond;
		int nFileDataSize = nAudioDataSize * (nRetrievalID +1) + nAudioHeaderSize;
		/*if (nRetrievalID == 0)
		{
			nAudioDataSize = nAudioDataSize;
			nFileDataSize = nAudioDataSize;
		}*/
		
		NSURL *url = [NSURL fileURLWithPath: recorderfilepath];
		
		NSFileManager *fm = [NSFileManager defaultManager];
		
		if ([fm fileExistsAtPath:[url path]])
		{
			AudioFileID audioFileID;
			
			AudioFileOpenURL((CFURLRef)url, 
							 kAudioFileReadPermission, 
							 kAudioFileCAFType,
							 &audioFileID);
			
			
			AudioStreamBasicDescription fileFormat;
			UInt32 propertySize = sizeof(fileFormat);
			OSStatus status = AudioFileGetProperty(audioFileID,
												   kAudioFilePropertyDataFormat,
												   &propertySize,
												   &fileFormat);
			
			NSLog(@"AudioFilePropertyExists: %d", status);
			if (status == noErr)
			{
				NSLog(@"GOT FILEFORMAT. SampleRate: %f - bitsPerChan: %d - bytesPerFrame: %d - bytesPerPacket: %d - chanPerFrame: %d - formatFlags: %d - framePerPacket: %d - Reserved: %d",
					  fileFormat.mSampleRate, fileFormat.mBitsPerChannel, fileFormat.mBytesPerFrame, fileFormat.mBytesPerPacket,
					  fileFormat.mChannelsPerFrame, fileFormat.mFormatFlags, fileFormat.mFramesPerPacket, fileFormat.mReserved);
		
			}
		
			UInt64 outDataSize = 0;
			UInt32 thePropSize = sizeof(UInt64);
			
			status = AudioFileGetProperty(audioFileID, kAudioFilePropertyAudioDataByteCount, &thePropSize, &outDataSize);
			
			

			
			NSDictionary *attr = [fm attributesOfItemAtPath:[url path] error: nil];
			NSNumber *numFileSize = [attr objectForKey:NSFileSize];
			if (status == noErr)
			{
				NSLog(@"GOT FILE DATA SIZE: FILE'S CURRENT SIZE: %d - DATA SIZE:  %d", [numFileSize intValue], outDataSize);
			}
			if ([numFileSize intValue] >= nFileDataSize) //The file has enough data for us to grab
			{
				NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:[url path]];
				long fileOffSet = (long)(nFileDataSize - nAudioDataSize);
				NSLog(@"MOVING TO OFFSET: %d", fileOffSet);
				[file seekToFileOffset:fileOffSet];
				data = [file readDataOfLength:nAudioDataSize];
			}
		}
		
	
		if (data)
		{
			AudioPacket * packet = [[AudioPacket alloc] init];
			packet->audioData = data;
			[packet->audioData retain];
			packet->PositionID = nRetrievalID;
			[audioQueueOut addObject:packet];
			NSLog(@"Audio Retrieved: %d - AudioDataSize: %d", nRetrievalID, [packet->audioData length]);
			nRetrievalID = nRetrievalID + 1;
		}
	}
}



static	AudioQueueRef			audioQueue;
void SetupAudioQueue()
{
	NSLog(@"SetupAudioQueue() - Called()");
	OSStatus err = noErr;
	
	//Setup the audio device;
	AudioStreamBasicDescription deviceFormat;
	deviceFormat.mSampleRate = 8000.0;
	deviceFormat.mFormatID = kAudioFormatAppleIMA4;
	deviceFormat.mFormatFlags = 0;
	deviceFormat.mBytesPerPacket = 34;
	deviceFormat.mFramesPerPacket = 64;
	deviceFormat.mBytesPerFrame = 0;
	deviceFormat.mChannelsPerFrame = 1;
	deviceFormat.mBitsPerChannel = 0;
	deviceFormat.mReserved = 0;
	
	//Create a new output AudioQueue for the device
	err = AudioQueueNewOutput(&deviceFormat, AudioQueueCallBack, NULL, CFRunLoopGetCurrent(), kCFRunLoopCommonModes,
							  0, &audioQueue);
	
	if (err != noErr)
	{
		NSLog(@"A problem occurred with AudioQueueNewOutput() - ERROR %d", err);	

	}
	//Allocate buffers for the audioqueue, and pre-fill them.
	for (int i = 0; i < 3; ++i)
	{
		NSLog(@"CREATING BUFFER: %d", i);
		AudioQueueBufferRef mBuffer;
		err = AudioQueueAllocateBuffer(audioQueue, 8228, &mBuffer);
		if (err != noErr) break;
		
		AudioQueueCallBack(NULL, audioQueue, mBuffer);		
	}
	
	if (err == noErr) 
	{
		AudioQueueSetParameter(audioQueue, kAudioQueueParam_Volume, 1);

		//AudioQueueSetProperty(audioQueue, kAudioQueueProperty_EnableLevelMetering, (const void*)1, (UInt32)sizeof(UInt32));
		//AudioQueueSetProperty(audioQueue, kAudioQueueProperty_DecodeBufferSizeFrames, (const void*)8192, (UInt32)sizeof(UInt32));

		err = AudioQueueStart(audioQueue, NULL);
	}
	else
	{
		NSLog(@"A problem occurred with AudioQueueAllAllocateBuffer() - ERROR %d", err);	
	}
	if (err == noErr)
	{
		//CFRunLoopRun();
	}
	else
	{
		NSLog(@"A problem occurred with AudioQueueStart() - ERROR %d", err);
	}

}


- (BOOL)GetAudioPacket:(void*)bufferID
{

	if ([audioQueueIn count] > 0)
	{
		void * pBytes = NULL;
		NSData *data = [audioQueueIn objectAtIndex:0];
	
		[audioQueueIn removeObjectAtIndex:0];
		NSLog(@"GetAudioPacket()  Called. Sending back packet. Size: %d", [data length]);
		//[data release];
		pBytes = (void *)[data bytes];
		memcpy(bufferID, (const void*)pBytes, [data length]);
		return TRUE;
	}
	return FALSE;
}
static	vcStartBattle * instance;

void AudioQueueCallBack(void *iNuserData, AudioQueueRef inAQ,
						AudioQueueBufferRef inBuffer)
{
	NSLog(@"AudioQueueCallback - Called");
	void *pBuffer = inBuffer->mAudioData;
	//Write max bytes of audio to pbuffer

	if ([instance GetAudioPacket:pBuffer])
	{
		inBuffer->mAudioDataByteSize = 8192;
		OSStatus err = noErr;
		err = AudioQueueEnqueueBuffer(audioQueue, inBuffer, 0, NULL);
	
		if (err != noErr)
		{
			NSLog(@"A problem occurred with AudioQueueEnqueueBuffer() - ERROR %d", err);
		}
	}
	else
	{
		NSLog(@"AudioQueueCallBack() - No Data to Queue");
		AudioQueueDispose(audioQueue, FALSE);
	}
}

- (void)TransportLoop
{
	if (battleActive)
	{
		if (recordingActive)
		{
			//SEND DATA TO SERVER
			if ([audioQueueOut count] > 0)
			{
				AudioPacket *packet = [audioQueueOut objectAtIndex:0];
				NSData *data = packet->audioData;
				int nCurrentPosition = packet->PositionID;
				NSLog(@"Preparing to send Audio Packet: %d - Size: %d", nCurrentPosition, [data length]);
				[SngrSession SessAddAudioPacket:data positionID:nCurrentPosition];
				[audioQueueOut removeObjectAtIndex:0];
				
				//Send data to server
				
				[packet->audioData release];
				[packet release];
			}
		}
		else
		{
			//declare a system sound id
			SystemSoundID soundID;
			
			NSString *sGuid = nil;
			
			int RC = SNGR_ERR_SUCCESS;
			NSLog(@"CURRENT POSITION: %d", nPositionID);
			
			RC = [SngrSession SessGetAudioPacketID:&sGuid positionID:&nPositionID];
			
			if (RC != SNGR_ERR_SUCCESS)
			{
				return;	
			}
			
			if (sGuid == nil)
			{
				return;
			}
			
			
			//Get a URL for the sound file
			NSString *url = [NSString stringWithFormat:@"%@?%@=%@", [SngrSession ServerPathAddress], @"BATTLE_DATA", sGuid];
			NSLog(@"FILE URL: %@", url);
			NSURL *fileurl = [NSURL URLWithString:url];
			
			//Use audio sevices to create the sound
			
			
			//Use audio services to play the sound
			NSLog(@"PREP TO QUEUE SOUND");
			//AudioServicesCreateSystemSoundID((CFURLRef)fileurl, &soundID);
			//AudioServicesPlaySystemSound(soundID);
			
			
			NSError *err = nil;
			NSData *data = [NSData dataWithContentsOfURL:fileurl];
			NSLog(@"POSITION: %d - DATA LENGTH: %d", nPositionID, [data length]);
			[data retain];
			[audioQueueIn addObject:data];
			
			if (nPositionID == nBuffer_Count + 1)
			{
				NSLog(@"Preparing to Setup Audio Queue");
				SetupAudioQueue();
			}
			
			
			//AVAudioPlayer *avplayer = [[AVAudioPlayer alloc] initWithData:data error:&err];
			//[avplayer setVolume:2.0];
			//[avplayer setNumberOfLoops: 0];
			//[avplayer play];
			
			//NSLog(@"PLAYED SOUND");
		
			


			
		}
		
	}
}

- (void)StartListening:(id)sender;
{

	[self InitializeVars];
	battleActive = YES;
	recordingActive = NO;
	
	if (!tmrTransport)
	{
		tmrTransport = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(TransportLoop) userInfo:nil repeats:YES];
	}
	
	
	
}

- (void)StartRecording
{	
	//Start Recording
	if (recordingActive)
	{		
		NSLog(@"RECORDING STARTED");
		[recorder recordForDuration:(NSTimeInterval) nAudioRecordingLengthInSeconds];
	}
}

- (void)InitializeVars
{
	instance = self;
	nBuffer_Count = 3;
	nPositionID = 0;
	nAudioRecordingLengthInSeconds = 30;
	nAudioTransportIntervalInSeconds = 0.1;
	nAudioRetrievalIntervalInSeconds = 1.0;
	nRetrievalID = 0;
	nAudioHeaderSize = 4096;
	nAudioDataSizePerSecond = 8228;
	
	audioQueueIn = [[NSMutableArray alloc] init];
	audioQueueOut = [[NSMutableArray alloc] init];
}

- (void)InitializeRecording
{
	NSLog(@"StartRecording() - Called");
	
	[self InitializeVars];
	
	NSString *documentsFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	NSError *err = nil;
	
	[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
	if (err)
	{
		NSLog(@"AudioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
		return;
	}
	
	recordSetting = [[NSMutableDictionary alloc] init];
	
	[recordSetting setValue:[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
	//[recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
	[recordSetting setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
	[recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
	
	/*
	[recordSetting setValue:[NSNumber numberWithInt:16]  forKey:AVLinearPCMBitDepthKey];
	[recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	[recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
	*/
	//[recordSetting setValue:[NSNumber numberWithInt: AVAudioQualityLow] forKey:AVEncoderAudioQualityKey];
	
	//Create a new dated file
	NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
	NSString *caldate  = [now description];
	recorderfilepath = [[NSString stringWithFormat:@"%@/%@.caf", documentsFolder, caldate] retain];
	
	NSURL *url = [NSURL fileURLWithPath:recorderfilepath];
	err = nil;
	
	recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
	
	if (!recorder)
	{
		NSLog(@"recoder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
		UIAlertView *alert =
			[[UIAlertView alloc] initWithTitle:@"Warning" 
				message:[err localizedDescription]
				delegate:nil 
				cancelButtonTitle:@"OK" 
							 otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	//Prepare to record
	[recorder setDelegate:self];
	[recorder prepareToRecord];
	
	recorder.meteringEnabled = YES;
	
	BOOL audioHWAvailable = audioSession.inputIsAvailable;
	if (!audioHWAvailable)
	{
		UIAlertView *alert =
		[[UIAlertView alloc] initWithTitle:@"Warning" 
								   message:@"Audio Input Hardware not Available"
								  delegate:nil 
						 cancelButtonTitle:@"OK" 
						 otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
		
		
	}
	

		
	recordingActive = YES;
	[self StartRecording];
	
	if (!tmrRetrieveAudioData)
	{
		tmrRetrieveAudioData = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(RetrieveAudioDataLoop) userInfo:nil repeats:YES];
	}
	
	if (!tmrTransport)
	{
		tmrTransport = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(TransportLoop) userInfo:nil repeats:YES];
	}
}

- (void)StopRecording
{
	NSLog(@"StopRecording() - Called");
	[recorder stop];
	
	NSURL *url = [NSURL fileURLWithPath: recorderfilepath];
	NSError *err = nil;
	
	NSData *audioData = [NSData dataWithContentsOfFile:[url path] options:0 error:&err];
	
	if (!audioData)
	{
		NSLog(@"Audio Data: %@ %d %@",[err domain], [err code], [[err userInfo] description]);
	}
	
	//[recoder deleteRecording]; will crash
	
	NSFileManager *fm = [NSFileManager defaultManager];
	
	err = nil;
	
	[fm removeItemAtPath:[url path] error:nil];
	
	if (err)
	{
		NSLog(@"FILE MANAGER: %@ %d %@",[err domain], [err code], [[err userInfo] description]);
	}
	
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
	NSLog(@"audioRecorderDidFinishRecording:successfully:");	
	
	NSURL *url = [NSURL fileURLWithPath: recorderfilepath];
	NSError *err = nil;
	/*
	NSData *audioData = [NSData dataWithContentsOfFile:[url path] options:0 error:&err];
	if (!audioData)
	{
		NSLog(@"Audio Data: %@ %d %@",[err domain], [err code], [[err userInfo] description]);
	}
	
	NSLog(@"AudioDataSize: %d", [audioData length]);
	[audioQueueOut addObject:audioData];
	*/
	//[recoder deleteRecording]; will crash
	
	NSFileManager *fm = [NSFileManager defaultManager];
	
	err = nil;
	
	
	[fm removeItemAtPath:[url path] error:nil];
	
	if (err)
	{
		NSLog(@"FILE MANAGER: %@ %d %@",[err domain], [err code], [[err userInfo] description]);
	}
	
	/*
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	
	[audioSession setCategory:AVAudioSessionCategoryPlayback error:&err];
	if (err)
	{
		NSLog(@"AudioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
		return;
	}
	
	AVAudioPlayer *avplayer = [[AVAudioPlayer alloc] initWithData:audioData error:&err];
	[avplayer setVolume:2.0];
	[avplayer setNumberOfLoops: 0];
	[avplayer play];
	
	NSLog(@"PLAYED SOUND");
	*/
	//[self StartRecording];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	recordingActive = NO;
	battleActive = NO;
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

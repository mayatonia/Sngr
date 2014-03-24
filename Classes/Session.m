//
//  Session.m
//  Sngr
//
//  Created by Oswald on 1/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Session.h"


@implementation Session
@synthesize ServerPathAddress;
@synthesize DataAccessLayer;
@synthesize ClientVersionInfo;
@synthesize ServerVersionInfo;

-(void)InitializeSessionClasses
{
	NSLog(@"InitializeSessionClassess() - Called.");
	if (DataAccessLayer == nil)
	{
		DataAccessLayer = [[DataAccess alloc] init];
		[DataAccessLayer SetServerPath:[self ServerPathAddress]];
		
		if (ClientVersionInfo == nil)
		{
			ClientVersionInfo = [[ClientInfo alloc] init];
			
			[ClientVersionInfo setClientUniqueID:[[UIDevice currentDevice] uniqueIdentifier]];
			[ClientVersionInfo setClientDeviceName:[[UIDevice currentDevice] name]];
			[ClientVersionInfo setClientSystemName:[[UIDevice currentDevice] systemName]];
			[ClientVersionInfo setClientSystemVersion:[[UIDevice currentDevice] systemVersion]];
			[ClientVersionInfo setClientModel:[[UIDevice currentDevice] model]];
			[ClientVersionInfo setClientLocalizedModel:[[UIDevice currentDevice] localizedModel]];
			[ClientVersionInfo setClientVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
		}
		
		if (ServerVersionInfo == nil)
		{
			ServerVersionInfo = [[ServerInfo alloc] init];
		}
		
		int RC = [self SessServerInit];
		if (RC == SNGR_ERR_SUCCESS)
		{
			NSLog(@"Server Version: %@", [ServerVersionInfo ServerVersion]);
		}
	}
}

-(int)SessServerInit
{
	NSLog(@"SessServerInit() - Called");
	return [DataAccessLayer DataServerInit:ClientVersionInfo ForServerInfo:ServerVersionInfo];
}

-(int)SessSignOn:(NSString*)userid withPassword:(NSString*)password orDeviceID:(NSString*)deviceid
{
	NSLog(@"SessSignOn() - Called");
	
	int RC = SNGR_ERR_SUCCESS;
	
	return RC;
	
}

- (int)SessAddAudioPacket:(NSData*)audioData positionID:(int)positionID
{
	NSLog(@"SessAddAudioPacket() - Called");
	
	int RC = SNGR_ERR_SUCCESS;
	
	RC = [DataAccessLayer DataAddAudioPacket:audioData positionID:positionID];
	
	return RC;
}

- (int)SessGetAudioPacketID:(NSString**)audioID positionID:(int*)positionID
{
	NSLog(@"SessGetAudioPacketID() - Called");
	
	int RC = SNGR_ERR_SUCCESS;
	
	RC = [DataAccessLayer DataGetAudioPacketID:audioID positionID:positionID];
	
	return RC;
}


@end

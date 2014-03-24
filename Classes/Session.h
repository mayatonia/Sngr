//
//  Session.h
//  Sngr
//
//  Created by Oswald on 1/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataAccess.h"
#import "Common.h"

@interface Session : NSObject {

	DataAccess * DataAccessLayer;
	NSString   * ServerPathAddress;
	ClientInfo * ClientVersionInfo;
	ServerInfo * ServerVersionInfo;
}

@property (nonatomic, retain) DataAccess * DataAccessLayer;
@property (nonatomic, retain) NSString	 * ServerPathAddress;
@property (nonatomic, retain) ClientInfo * ClientVersionInfo;
@property (nonatomic, retain) ServerInfo * ServerVersionInfo;

-(void)InitializeSessionClasses;

-(int)SessServerInit;
-(int)SessSignOn:(NSString*)userid withPassword:(NSString*)password orDeviceID:(NSString*)deviceid;
- (int)SessAddAudioPacket:(NSData*)audioData positionID:(int)positionID;
- (int)SessGetAudioPacketID:(NSString**)audioID positionID:(int*)positionID;

@end

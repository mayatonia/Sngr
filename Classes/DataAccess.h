//
//  DataAccess.h
//  Sngr
//
//  Created by Oswald on 1/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerConnector.h"
#import "Common.h"
#import "Transaction.h"
#import "SngrSerializer.h"

@interface DataAccess : NSObject {

	ServerConnector *httpserver;

}

@property (nonatomic, retain) ServerConnector * httpserver;

-(void)SetServerPath:(NSString *)ServerPathURLAsString;
-(int)DataAddAudioPacket:(NSData *)audioPacket positionID:(int)positionID;
-(int)DataServerInit:(ClientInfo *)clientversioninfo ForServerInfo:(ServerInfo *)serverversioninfo;
-(int)DataGetAudioPacketID:(NSString **)audioPacketID positionID:(int*)positionID;

@end

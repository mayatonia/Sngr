//
//  ServerConnector.h
//  Sngr
//
//  Created by Oswald on 1/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

@interface ServerConnector : NSObject {

	NSString * sngrServerPathUri;
}
@property (nonatomic, retain) NSString * sngrServerPathUri;

-(int)SyncSendDataToServer:(NSString *)xmlContent xmlResponse:(NSString**)xmlResponseString;
-(int)SendDataToServer:(NSString *)xmlContent xmlResponse:(NSString**)xmlResponseString;

@end

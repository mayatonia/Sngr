//
//  ClientInfo.h
//  Sngr
//
//  Created by Oswald on 1/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ClientInfo : NSObject {
	NSString * ClientUniqueID;
	NSString * ClientDeviceName;
	NSString * ClientSystemName;
	NSString * ClientSystemVersion;
	NSString * ClientModel;
	NSString * ClientLocalizedModel;
	NSString * ClientVersion;
}
@property (nonatomic, retain) NSString	 * ClientUniqueID;
@property (nonatomic, retain) NSString	 * ClientDeviceName;
@property (nonatomic, retain) NSString	 * ClientSystemName;
@property (nonatomic, retain) NSString	 * ClientSystemVersion;
@property (nonatomic, retain) NSString	 * ClientModel;
@property (nonatomic, retain) NSString	 * ClientLocalizedModel;
@property (nonatomic, retain) NSString	 * ClientVersion;

@end

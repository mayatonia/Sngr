//
//  Property.h
//  Sngr
//
//  Created by Oswald on 1/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SngrSerializer.h"


@interface Property : NSObject{

	NSMutableDictionary *			MyDictionary;
}

@property (nonatomic, retain) NSMutableDictionary *			MyDictionary;


- (void)AddProperty:(NSString *)PropertyName Property:(id)Property;
- (void)AddProperty:(NSString *)PropertyName Property:(id)Property Base64Encode:(BOOL)mustEncode;
- (id)GetProperty:(NSString *)PropertyName;


@end

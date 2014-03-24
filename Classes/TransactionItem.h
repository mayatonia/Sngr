//
//  TransactionItem.h
//  Sngr
//
//  Created by Oswald on 1/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TransactionItem : NSObject {

	NSString * Name;
	NSString * Value;
}


@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSString * Value;


- (void)SetName:(NSString*)name andValue:(NSString*)value;

@end

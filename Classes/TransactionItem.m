//
//  TransactionItem.m
//  Sngr
//
//  Created by Oswald on 1/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TransactionItem.h"


@implementation TransactionItem
@synthesize Name;
@synthesize Value;


- (void)SetName:(NSString*)name andValue:(NSString*)value
{
	Name = name;
	Value = value;
}
@end

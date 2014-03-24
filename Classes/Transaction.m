//
//  Transaction.m
//  Sngr
//
//  Created by Oswald on 1/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Transaction.h"


@implementation Transaction
@synthesize TranArray;

-(void)AddTransactionProperty:(NSString*)name andValue:(NSString *)value
{
	if ([self TranArray] == nil)
	{
		TranArray = [[NSMutableArray alloc] init];
	}
	
	TransactionItem * item = [[TransactionItem alloc] init];
	[item setName:name];
	[item setValue:value];
	
	[TranArray addObject:item]; 
}

@end

//
//  Transaction.h
//  Sngr
//
//  Created by Oswald on 1/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "TransactionItem.h"


@interface Transaction : NSObject{

	NSMutableArray * TranArray;
}

@property (nonatomic, retain) NSMutableArray *	TranArray;

-(void)AddTransactionProperty:(NSString*)name andValue:(NSString *)value;

@end

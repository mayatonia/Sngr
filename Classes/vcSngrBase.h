//
//  vcSngrBase.h
//  Sngr
//
//  Created by Oswald on 1/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"
#import "SngrSerializer.h"
#import "ServerConnector.h"
#import "Session.h"


@interface vcSngrBase : UIViewController {

	Session * SngrSession;

}

@property (nonatomic, retain) Session * SngrSession;

@end

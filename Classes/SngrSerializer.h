//
//  SngrSerializer.h
//  Sngr
//
//  Created by Oswald on 1/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Transaction.h"


#import "DDXML.h"
#import "Base64.h"

@interface SngrSerializer : NSObject {

}


-(NSString*)getXmlStringFromNSDictionary:(NSDictionary*)nsDictionaryObject;
- (NSString*)ConvertToBase64String:(id)nsDataObject;
- (NSData*)ConvertToNSData:(NSString *)nsString;

+ (NSString*)CreateXml:(Transaction*)tran;
-(NSString*)XmlString:(Transaction*)tran;

@end

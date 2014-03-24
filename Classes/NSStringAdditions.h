//
//  NSStringAdditions.h
//  Sngr
//
//  Created by Oswald on 1/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/tree.h>

@interface NSString (NSStringAdditions)

+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;
/**
 * xmlChar - A basic replacement for char, a byte in a UTF-8 encoded string.
 **/
- (const xmlChar *)xmlChar;

- (NSString *)trimWhitespace;

@end


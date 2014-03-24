//
//  Property.m
//  Sngr
//
//  Created by Oswald on 1/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Property.h"
#import <libxml/tree.h>


@implementation Property

@synthesize MyDictionary;

- (void)AddProperty:(NSString *)PropertyName Property:(id)PropertyValue
{
	if ([self MyDictionary] == nil)
	{
		MyDictionary = [[NSMutableDictionary alloc] init];
	}
	
	[MyDictionary setValue:PropertyValue forKey:PropertyName];
}

- (void)AddProperty:(NSString *)PropertyName Property:(id)PropertyValue Base64Encode:(BOOL)mustEncode
{
	if (mustEncode == TRUE)
	{
		SngrSerializer *ser = [SngrSerializer alloc];
		NSString * base64String = [ser ConvertToBase64String:PropertyValue];
		[self AddProperty:PropertyName Property:base64String];
	}
}

- (id)GetProperty:(NSString *)PropertyName
{
	return [MyDictionary objectForKey:PropertyName];
}


@end

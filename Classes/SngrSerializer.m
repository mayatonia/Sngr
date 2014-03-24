//
//  SngrSerializer.m
//  Sngr
//
//  Created by Oswald on 1/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SngrSerializer.h"



@implementation SngrSerializer

-(NSString*)getXmlStringFromNSDictionary:(NSDictionary*)nsDictionaryObject
{
	NSString *xmlstring = nil;
	if (nsDictionaryObject != nil)
	{
		NSString *error = [NSString alloc];
		NSData *data = [NSPropertyListSerialization dataFromPropertyList:nsDictionaryObject 
																  format:kCFPropertyListXMLFormat_v1_0 errorDescription:&error];
		xmlstring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	}
	
	return xmlstring;
}


- (NSString*)ConvertToBase64String:(id)nsDataObject
{
	NSString *base64string = nil;
	
	NSData *data = (NSData*)nsDataObject;
	if (data != nil)
	{
		//Base64 base64encoder = [Base64 initialize];
		base64string = [Base64 encode:data];
	}
	
	return base64string;
}

- (NSData*)ConvertToNSData:(NSString *)nsString
{
	NSData *data = nil;
	
	if (nsString != nil && [nsString length] > 0)
	{
		//Base64 base64decoder = [Base64 initialize];
		data = [Base64 decode: nsString];
	}
	
	return data;
}

+ (NSString*)CreateXml:(Transaction*)tran
{
	NSString * root = @"<SNGR></SNGR>";


	DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithXMLString:root options:0 error:nil];
	
	int nArrayLength = [[tran TranArray] count];
	
	DDXMLElement *node = [xmlDoc rootElement];
	
	for(int i = 0; i< nArrayLength; i++)
	{
	   TransactionItem *item = (TransactionItem*)[[tran TranArray] objectAtIndex:i];
		DDXMLElement *element = [DDXMLElement elementWithName:[item Name]];
		[element setStringValue:[item Value]];
		[node addChild:element];
	}

	NSMutableString *xmloutput = [NSMutableString stringWithString:[xmlDoc XMLString]];
	
	[xmloutput replaceOccurrencesOfString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 40)];
	
	return xmloutput;
 }
	
-(NSString*)XmlString:(Transaction*)tran
{
	return [SngrSerializer CreateXml:tran];
}

@end

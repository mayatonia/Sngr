//
//  DataAccess.m
//  Sngr
//
//  Created by Oswald on 1/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataAccess.h"


@implementation DataAccess
@synthesize httpserver;

-(void)SetServerPath:(NSString *)ServerPathURLAsString
{
	if (httpserver == nil)
	{
		httpserver = [[ServerConnector alloc] init];
	}
	
	[httpserver setSngrServerPathUri:ServerPathURLAsString];
}

-(int)DataServerInit:(ClientInfo *)clientversioninfo ForServerInfo:(ServerInfo *)serverversioninfo
{
	NSLog(@"DataServerInit() - Called");
	
	int RC = SNGR_ERR_SUCCESS;
	
	//Build transactions
	Transaction *tran = [[Transaction alloc] init];
	
	[tran AddTransactionProperty:@"REQ" andValue:[[NSNumber numberWithInt:SNGR_REQ_SERVER_INIT] stringValue]];
	[tran AddTransactionProperty:@"VER" andValue:[clientversioninfo ClientVersion]];
	[tran AddTransactionProperty:@"CSV" andValue:[clientversioninfo ClientSystemVersion]];
	[tran AddTransactionProperty:@"CID" andValue:[clientversioninfo ClientUniqueID]];
	[tran AddTransactionProperty:@"MDL" andValue:[clientversioninfo ClientModel]];
	
	NSString *xmlsent = [SngrSerializer CreateXml:tran];
	NSString *xmlreceived;
	
	if (xmlsent != nil && [xmlsent length] > 0)
	{
		RC = [httpserver SyncSendDataToServer:xmlsent xmlResponse:&xmlreceived];
	}
	else
	{
		RC = SNGR_ERR_XML_CREATE_FAILURE_SENT;
		NSLog(@"DataServerInit() - Failed to create transaction xml. Error: %d", RC);
	}
	//[xmlsent release];
	
	if (RC == SNGR_ERR_SUCCESS)
	{
		NSError *xmlerror = nil;
		DDXMLDocument *receivedDoc = [[DDXMLDocument alloc] initWithXMLString:xmlreceived options:0 error:&xmlerror];
		
		
		if (xmlerror != nil && [xmlerror description] != nil)
		{
			RC = SNGR_ERR_XML_CREATE_FAILURE_RECEIVED;
			NSLog(@"DataServerInit() - Error (%d) An error occurred while creating the response xml document. Description: %@", RC, [xmlerror description]);
		}
		
		if (RC == SNGR_ERR_SUCCESS)
		{
			int nChilds = [[receivedDoc rootElement] childCount];
			
			DDXMLElement *rootElement = [receivedDoc rootElement];
			for(int i = 0; i < nChilds; i++)
			{
				DDXMLNode *node = [rootElement childAtIndex:i];
				if ([[node name] isEqualToString:@"RC"])
				{
					RC = [[node stringValue] intValue];
					continue;
				}
				
				if ([[node name] isEqualToString:@"VER"])
				{
					[serverversioninfo setServerVersion:[node stringValue]];
					continue;
				}
			}

		}
		[receivedDoc release];
	}
	
	[tran release];
	[xmlreceived release];
	return RC;
}


-(int)DataAddAudioPacket:(NSData *)audioPacket positionID:(int)positionID;
{
	NSLog(@"DataAddAudioPacket() - Called");
	

	int RC = SNGR_ERR_SUCCESS;
	
	//Build transactions
	Transaction *tran = [[Transaction alloc] init];
	
	[tran AddTransactionProperty:@"REQ" andValue:[[NSNumber numberWithInt:SNGR_REQ_ADD_AUDIO_PACKETS] stringValue]];
	[tran AddTransactionProperty:@"PID" andValue:[[NSNumber numberWithInt:positionID] stringValue]];
	[tran AddTransactionProperty:@"DTA" andValue:[Base64 encode:audioPacket]];
		
	NSString *xmlsent = [SngrSerializer CreateXml:tran];
	NSString *xmlreceived;
	
	if (xmlsent != nil && [xmlsent length] > 0)
	{
		RC = [httpserver SyncSendDataToServer:xmlsent xmlResponse:&xmlreceived];
	}
	else
	{
		RC = SNGR_ERR_XML_CREATE_FAILURE_SENT;
		NSLog(@"DataServerInit() - Failed to create transaction xml. Error: %d", RC);
	}
	//[xmlsent release];
	
	if (RC == SNGR_ERR_SUCCESS)
	{
		NSError *xmlerror = nil;
		DDXMLDocument *receivedDoc = [[DDXMLDocument alloc] initWithXMLString:xmlreceived options:0 error:&xmlerror];
		
		
		if (xmlerror != nil && [xmlerror description] != nil)
		{
			RC = SNGR_ERR_XML_CREATE_FAILURE_RECEIVED;
			NSLog(@"DataServerInit() - Error (%d) An error occurred while creating the response xml document. Description: %@", RC, [xmlerror description]);
		}
		
		if (RC == SNGR_ERR_SUCCESS)
		{
			int nChilds = [[receivedDoc rootElement] childCount];
			
			DDXMLElement *rootElement = [receivedDoc rootElement];
			for(int i = 0; i < nChilds; i++)
			{
				DDXMLNode *node = [rootElement childAtIndex:i];
				if ([[node name] isEqualToString:@"RC"])
				{
					RC = [[node stringValue] intValue];
					continue;
				}
			}
			
		}
		
		
		
		[receivedDoc release];
	}
	
	[tran release];
	[xmlreceived release];
	return RC;
}


-(int)DataGetAudioPacketID:(NSString **)audioPacketID positionID:(int*)positionID
{
	NSLog(@"DataAddAudioPacket() - Called");
	
	int RC = SNGR_ERR_SUCCESS;
	
	//Build transactions
	Transaction *tran = [[Transaction alloc] init];
	
	[tran AddTransactionProperty:@"REQ" andValue:[[NSNumber numberWithInt:SNGR_REQ_GET_AUDIO_PACKET_ID] stringValue]];
	int nPosition = *positionID;
	[tran AddTransactionProperty:@"PID" andValue:[[NSNumber numberWithInt:nPosition] stringValue]];
	
	NSString *xmlsent = [SngrSerializer CreateXml:tran];
	NSString *xmlreceived;
	
	if (xmlsent != nil && [xmlsent length] > 0)
	{
		RC = [httpserver SyncSendDataToServer:xmlsent xmlResponse:&xmlreceived];
	}
	else
	{
		RC = SNGR_ERR_XML_CREATE_FAILURE_SENT;
		NSLog(@"DataServerInit() - Failed to create transaction xml. Error: %d", RC);
	}
	//[xmlsent release];
	
	if (RC == SNGR_ERR_SUCCESS)
	{
		NSError *xmlerror = nil;
		DDXMLDocument *receivedDoc = [[DDXMLDocument alloc] initWithXMLString:xmlreceived options:0 error:&xmlerror];
		
		
		if (xmlerror != nil && [xmlerror description] != nil)
		{
			RC = SNGR_ERR_XML_CREATE_FAILURE_RECEIVED;
			NSLog(@"DataServerInit() - Error (%d) An error occurred while creating the response xml document. Description: %@", RC, [xmlerror description]);
		}
		
		if (RC == SNGR_ERR_SUCCESS)
		{
			int nChilds = [[receivedDoc rootElement] childCount];
			
			DDXMLElement *rootElement = [receivedDoc rootElement];
			for(int i = 0; i < nChilds; i++)
			{
				DDXMLNode *node = [rootElement childAtIndex:i];
				if ([[node name] isEqualToString:@"RC"])
				{
					RC = [[node stringValue] intValue];
					continue;
				}
				
				if ([[node name] isEqualToString:@"PID"])
				{
					int newposition = [[node stringValue] intValue];
					*positionID = newposition;
					continue;
				}
				
				if ([[node name] isEqualToString:@"DTA"])
				{
					*audioPacketID = [node stringValue];
					continue;
				}
				
			}
			
		}
		[receivedDoc release];
	}
	
	[tran release];
	[xmlreceived release];
	return RC;
}

@end

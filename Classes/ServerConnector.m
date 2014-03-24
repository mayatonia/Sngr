//
//  ServerConnector.m
//  Sngr
//
//  Created by Oswald on 1/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ServerConnector.h"


@implementation ServerConnector
@synthesize sngrServerPathUri;

-(int)SyncSendDataToServer:(NSString *)xmlContent xmlResponse:(NSString**)xmlResponseString
{
	int RC = SNGR_ERR_SUCCESS;
	
	for(int i = 0; i < 3; i++)
	{
		NSString *xmlResponse;
		
		RC = [self SendDataToServer:xmlContent xmlResponse:&xmlResponse];
		//NSLog(@"Testing XmlResponse: %@", xmlResponse);

		if (RC == SNGR_ERR_SUCCESS)
		{
			if (xmlResponse != nil && [xmlResponse length] > 0)
			{
				*xmlResponseString = [xmlResponse copy];
				[xmlResponse release];
				//NSLog(@"Testing 2nd XmlResponseString: %@", *xmlResponseString);
			}
			else
			{
				NSLog(@"SyncSendDataToServer() - NO DATA RECEIVED FROM SERVER");
				RC == SNGR_ERR_HTTP_NODATA;
			}
			break;	
		}
	}
	return RC;
}

-(int)SendDataToServer:(NSString *)xmlContent xmlResponse:(NSString**)xmlResponseString{
	int RC = SNGR_ERR_SUCCESS;
	
	//NSLog(@"Sent to Server: %@", xmlContent);
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
	[request setURL:[NSURL URLWithString:sngrServerPathUri]];
	
	// Set request body and HTTP method
	//NSString *usernameString = [LatestChattyAppDelegate urlEscape:[[NSUserDefaults standardUserDefaults] stringForKey:@"username_preference"]];
	//NSString *passwordString = [LatestChattyAppDelegate urlEscape:[[NSUserDefaults standardUserDefaults] stringForKey:@"password_preference"]];
	//NSString *bodyString     = [LatestChattyAppDelegate urlEscape:postContent.text];
	//NSString *parentId       = [NSString stringWithFormat:@"%d", parentPost.postId];
	//if ([parentId isEqualToString:@"0"]) parentId = @"";
	

	[request setValue:@"text/XML" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:[xmlContent dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPMethod:@"POST"];
	
	// Send the request
	NSHTTPURLResponse *response;
	NSError * error = nil;
	
	NSString *responseBody = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error]
								 encoding:NSUTF8StringEncoding];

	if (error != nil && [[error description] length] > 0)
	{
		RC = [response statusCode];
		NSLog(@"Failed to transmit data to server. ERROR: %@", error);
	}
	else
	{
		NSLog(@"Received from Server: %@", responseBody);
	}
	

	*xmlResponseString = [responseBody copy];
	[responseBody release];
		
	//NSLog(@"TESTING xmlResponseString: %@", *xmlResponseString);
	
	return RC;
}


@end

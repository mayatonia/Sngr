//
//  Constants.h
//  Sngr
//
//  Created by Oswald on 1/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
enum {
	SNGR_ERR_SUCCESS                    = 0,
	
	SNGR_ERR_HTTP_ERROR					= 100000,
	SNGR_ERR_HTTP_NODATA,
	
	SNGR_ERR_XML_CREATE_FAILURE_SENT	= 200000,
	SNGR_ERR_XML_CREATE_FAILURE_RECEIVED,
	SNGR_ERR_SIGNON_FAILURE,
	SNGR_ERR_SIGNON_FAILURE_PASSWORD,
	SNGR_ERR_SIGNON_FAILURE_USERID,
	
	
	SNGR_ERR_BATTLE_START_FAILURE = 20000
	
};

enum{
	SNGR_REQ_SERVER_INIT				= 100000,
	SNGR_REQ_SERVER_SIGNIN				= 100001,
	SNGR_REQ_SERVER_SIGNOFF				= 100002,
	SNGR_REQ_SERVER_CHANGE_PASSWORD		= 100003,
	SNGR_REQ_POLL_CHATS					= 100004,
	SNGR_REQ_POLL_AUDIOSESSION			= 100005,
	
	SNGR_REQ_START_AUDIO_SESSION		= 200000,
	SNGR_REQ_CANCEL_AUDIO_SESSION		= 200001,
	SNGR_REQ_COMPLETE_AUDIO_SESSION		= 200002,
	SNGR_REQ_START_AUDIO_SESSION_ROUND	= 200003,
	SNGR_REQ_CANCEL_AUDIO_SESSION_ROUND = 200004,
	SNGR_REQ_COMPLETE_AUDIO_SESSION_ROUND=200005,
	SNGR_REQ_GET_AUDIO_SESSIONS			= 200006,
	SNGR_REQ_ADD_AUDIO_PACKETS			= 200007,
	SNGR_REQ_GET_AUDIO_PACKETS			= 200008,
	SNGR_REQ_GET_AUDIO_PACKET_ID		= 200009,
	SNGR_REQ_GET_AUDIO_PACKET_RESTFUL   = 200010
	
};

@interface Constants {

}

@end
//
//  MSConstants.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 07/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

extern NSString * const PUBLISHERKEY;
extern NSString * const SUBSCRIBERKEY;

//heartbeat messages
extern NSString* const HB_MSG_USER;
extern NSString* const HB_MSG_MACHINE;
extern NSString* const HB_MSG_REPLY;
extern NSString* const HB_MSG_BROADCAST;
extern NSString* const HB_MSG_KEY;
extern NSString* const HB_MSG_TIME;
extern NSString* const HB_MSG_DOMAIN;
extern NSString* const HB_MSG_STATS;
extern NSString* const HB_MSG_COMPANY;
extern NSString* const HB_STATS;
extern NSString* const HB_MSG_PUBLIC_KEY;

//message headers
extern NSString* const MSG_IV;
extern NSString* const MSG_CONTENTS;
extern NSString* const MSG_TYPE;

//channels
extern NSString* const OS_HEARTBEAT_CHANNEL;

//stats message headers
extern NSString* const SM_NETVER;
extern NSString* const SM_WINVER;
extern NSString* const SM_VIRTUAL_MEM;
extern NSString* const SM_PHYSICAL_MEM;
extern NSString* const SM_PRIVATE_MEM;
extern NSString* const SM_START_TIME;

//log message headers
extern NSString* const LM_TRACE_LEVEL;
extern NSString* const LM_TIME;
extern NSString* const LM_CATEGORY;
extern NSString* const LM_DESIGNCOMP;
extern NSString* const LM_COMP;
extern NSString* const LM_MESSAGE;
extern NSString* const LM_VERBOSE;
extern NSString* const LM_TAG;

//message types
extern NSString* const MSG_LOG_MESSAGE;
extern NSString* const MSG_HB_MESSAGE;
extern NSString* const MSG_STATS_MESSAGE;

//Notification Center names
extern NSString* const NC_CLIENTS_UPDATED;
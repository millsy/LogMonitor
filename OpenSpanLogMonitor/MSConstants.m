//
//  MSConstants.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 07/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

NSString * const PUBLISHERKEY = @"pub-fc91edb4-5379-47f0-a882-c2de5db4fbcb";
NSString * const SUBSCRIBERKEY = @"sub-1e9854a8-4b3c-11e1-be34-4103cb3c6424";

//heartbeat messages
NSString* const HB_MSG_USER = @"USER";
NSString* const HB_MSG_MACHINE = @"MACHINE";
NSString* const HB_MSG_REPLY = @"REPLY";
NSString* const HB_MSG_BROADCAST = @"BROADCAST";
NSString* const HB_MSG_KEY = @"KEY";
NSString* const HB_MSG_TIME = @"TIME";
NSString* const HB_MSG_DOMAIN = @"DOMAIN";
NSString* const HB_MSG_STATS = @"STATS";
NSString* const HB_MSG_COMPANY = @"COMPANY";
NSString* const HB_STATS = @"STATS";
NSString* const HB_MSG_PUBLIC_KEY = @"PUBLICKEY";

//message headers
NSString* const MSG_IV = @"IV";
NSString* const MSG_CONTENTS = @"MESSAGE";
NSString* const MSG_TYPE = @"MSGTYPE";

//channels
NSString* const OS_HEARTBEAT_CHANNEL = @"OS-HEARTBEAT";

//stats message headers
NSString* const SM_NETVER = @"NETVERSIONS";
NSString* const SM_WINVER = @"OSVERSION";
NSString* const SM_VIRTUAL_MEM = @"VIRTUALMEM";
NSString* const SM_PHYSICAL_MEM = @"PHYSICALMEM";
NSString* const SM_PRIVATE_MEM = @"PRIVATEMEM";
NSString* const SM_START_TIME = @"START_TIME";
NSString* const SM_OPENSPANVER = @"OPENSPANVER";

//log message headers
NSString* const LM_TRACE_LEVEL = @"TraceLevel";
NSString* const LM_TIME = @"DateTime";
NSString* const LM_CATEGORY = @"Category";
NSString* const LM_DESIGNCOMP = @"DesignCompName";
NSString* const LM_COMP = @"CompName";
NSString* const LM_MESSAGE = @"Message";
NSString* const LM_VERBOSE = @"VerboseMsg";
NSString* const LM_TAG = @"Tag";

//message types
NSString* const MSG_LOG_MESSAGE = @"LOGMESSAGE";
NSString* const MSG_HB_MESSAGE = @"HEARTBEAT";
NSString* const MSG_STATS_MESSAGE = @"STATS";

//Notification Center names
NSString* const NC_CLIENTS_UPDATED = @"ClientsUpdated";
NSString* const NC_NEW_LOG_ENTRY = @"LogEntryAdd";
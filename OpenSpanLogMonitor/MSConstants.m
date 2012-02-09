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

//message headers
NSString* const MSG_IV = @"IV";
NSString* const MSG_CONTENTS = @"MESSAGE";
NSString* const MSG_TYPE = @"MSGTYPE";

//channels
NSString* const OS_HEARTBEAT_CHANNEL = @"OS-HEARTBEAT";

//stats message headers
NSString* const  SM_NETVER = @"NETVERSIONS";
NSString* const  SM_WINVER = @"OSVERSION";

//message types
NSString* const MSG_LOG_MESSAGE = @"LOGMESSAGE";
NSString* const MSG_HB_MESSAGE = @"HEARTBEAT";
NSString* const MSG_STATS_MESSAGE = @"STATS";

//Notification Center names
NSString* const NC_CLIENTS_UPDATED = @"ClientsUpdated";
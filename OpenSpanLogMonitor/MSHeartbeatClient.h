//
//  MSHeartbeatClient.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 07/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSLoggerClient.h"
#import "MSEncryption.h"

@interface MSHeartbeatClient : NSObject

@property (nonatomic, assign, readonly) NSArray* clients;

-(id)initWithURL:(NSURL*)url password:(NSString*)password;
-(id)initWithEncryption:(MSEncryption*)encryption;

@end

//
//  MSLoggerClient.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 07/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CEPubnub.h"

@interface MSLoggerClient : NSObject

@property (strong, nonatomic, readonly) NSString* userName;
@property (strong, nonatomic, readonly) NSString* machineName;
@property (strong, nonatomic, readonly) NSString* domainName;
@property (strong, nonatomic, readonly) NSString* receiverChannel;
@property (strong, nonatomic, readonly) NSString* senderChannel;
@property (strong, nonatomic, readonly) NSString* encryptedKey;

@property (strong, nonatomic) NSDate* lastSeen;

@property (strong, nonatomic, readonly) NSArray* logEntries;

-(id)initWithUserName:(NSString*)userName machineName:(NSString*)machineName domainName:(NSString*)domainName receiverChannel:(NSString*) receiverChannel senderChannel:(NSString*)senderChannel encrypedKey:(NSString*) encryptedKey;

-(void)startListening;
-(void)stopListening;

@end

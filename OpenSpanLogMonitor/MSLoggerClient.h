//
//  MSLoggerClient.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 07/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CEPubnub.h"
#import "MSRuntimeInfo.h"
#import "MSCommonDate.h"

@interface MSLoggerClient : NSObject

@property (strong, nonatomic, readonly) NSString* userName;
@property (strong, nonatomic, readonly) NSString* machineName;
@property (strong, nonatomic, readonly) NSString* domainName;
@property (strong, nonatomic, readonly) NSString* receiverChannel;
@property (strong, nonatomic, readonly) NSString* senderChannel;
@property (strong, nonatomic, readonly) NSString* encryptedKey;
@property (strong, nonatomic, readonly) NSString* companyName;
@property (strong, nonatomic, readonly) NSString* statsChannel;
@property (strong, nonatomic, readonly) NSString* publicKeyURL;

@property (strong, nonatomic, readonly) MSRuntimeInfo* runtimeInfo;

@property (strong, nonatomic) NSDate* lastSeen;

@property (strong, nonatomic, readonly) NSMutableArray* logEntries;

-(id)initWithUserName:(NSString*)userName machineName:(NSString*)machineName domainName:(NSString*)domainName companyName:(NSString*)companyName receiverChannel:(NSString*) receiverChannel senderChannel:(NSString*)senderChannel statsChannel:(NSString*)statsChannel encrypedKey:(NSString*) encryptedKey publicKey:(NSString*)publicKey privateKeyURL:(NSURL*)privateKeyUrl privateKeyPassword:(NSString*)privateKeyPassword;

-(void)startListening;
-(void)stopListening;

@end

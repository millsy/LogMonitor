//
//  MSLoggerClient.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 07/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSLoggerClient.h"
#import "MSEncryption.h"

@interface MSLoggerClient()

@property (strong, nonatomic) CEPubnub* pubnub;
@property (strong, nonatomic, readonly) NSString* publishKey;
@property (strong, nonatomic, readonly) NSString* subscribeKey;
@property (strong, nonatomic) NSMutableArray* privateLogEntries;
@property (strong, nonatomic, readonly) NSString* key;

@end

@implementation MSLoggerClient

const static NSString* LM_MSG_IV = @"IV";
const static NSString* LM_MSG_MSG = @"MESSAGE";

//public
@synthesize userName = _userName;
@synthesize machineName = _machineName;
@synthesize receiverChannel = _receiverChannel;
@synthesize senderChannel = _senderChannel;
@synthesize encryptedKey = _encryptedKey;


//private
@synthesize key = _key;
@synthesize pubnub = _pubnub;
@synthesize publishKey = _publishKey;
@synthesize subscribeKey = _subscribeKey;
@synthesize privateLogEntries = _privateLogEntries;

-(id)init
{
    return nil;
}

-(id)initWithUserName:(NSString*)userName machineName:(NSString*)machineName receiverChannel:(NSString*) receiverChannel senderChannel:(NSString*)senderChannel encrypedKey:(NSString*) encryptedKey
{
    self = [super init];
    if(self)
    {
        _userName = userName;
        _machineName = machineName;
        _receiverChannel = receiverChannel;
        _senderChannel = senderChannel;
        _encryptedKey = encryptedKey;
        
        //start listening on subscriber
        
        [self.pubnub subscribe: self.receiverChannel delegate:self];
    }
    
    return self;
}

//pubsub delegate methods
- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveDictionary:(NSDictionary *)response onChannel:(NSString *)channel
{
    //check valid structure
    if([response objectForKey:LM_MSG_IV] && [response objectForKey:LM_MSG_MSG])
    {
        NSString* iv = [MSEncryption base64DecodeString:[response objectForKey:LM_MSG_IV]];
        NSString* encryptedMsg = [MSEncryption base64DecodeString:[response objectForKey:LM_MSG_MSG]];
        
        if(iv && encryptedMsg)
        {
            NSString* unencryptedMsg = [MSEncryption decryptString:encryptedMsg withKey:self.key vector:iv];
            if(unencryptedMsg)
            {
                NSLog(@"Message Received %@", unencryptedMsg);
            }else{
                NSLog(@"Failed to unencrypt message");
            }
        }else{
            NSLog(@"Failed to get IV and encryptedMsg from message");
        }
    }else{
        NSLog(@"Invalid message format received");
    }
}

- (void)pubnub:(CEPubnub *)pubnub subscriptionDidFailWithResponse:(NSString *)response onChannel:(NSString *)channel
{
   //not used now 
}

- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveHistoryArray:(NSArray *)response onChannel:(NSString *)channel
{
    //not used now
}

//public properties


-(NSArray*)logEntries
{    
    return [self.privateLogEntries copy];
}

//private properties
-(NSString*)key
{
    if(!_key)
    {
        if(self.encryptedKey)
        {
            //we have an encrypted key
            //decrypt self.encryptedKey
            _key = [MSEncryption decryptString:self.encryptedKey withCertificate:[NSURL URLWithString:@"http://localhost/logging.p12"] andPassword:@"12345"];       
        }
    }
    return _key;
}

-(NSMutableArray*)privateLogEntries
{
    if(!_privateLogEntries)
    {
        _privateLogEntries = [[NSMutableArray alloc]init];
    }
    
    return _privateLogEntries;
}

-(CEPubnub*)pubnub
{
    if(!_pubnub)
    {
        _pubnub = [[CEPubnub alloc]
                   publishKey:   self.publishKey
                   subscribeKey: self.subscribeKey 
                   secretKey:    @""//@"sec-649a5039-cb8d-40eb-beec-21b9c07aec64" 
                   sslOn:        YES
                   origin:       @"pubsub.pubnub.com"
                   ]; 
    }
    
    return _pubnub;
}

-(NSString*)publishKey
{
    if(!_publishKey)
    {
        _publishKey = @"pub-fc91edb4-5379-47f0-a882-c2de5db4fbcb";
    }
    return _publishKey;
}

-(NSString*)subscribeKey
{
    if(!_subscribeKey)
    {
        _subscribeKey = @"sub-1e9854a8-4b3c-11e1-be34-4103cb3c6424";
    }
    return _subscribeKey;
}

@end

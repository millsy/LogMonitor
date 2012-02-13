//
//  MSLoggerClient.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 07/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSLoggerClient.h"
#import "MSEncryption.h"
#import "MSConstants.h"
#import "NSData+Extension.h"

@interface MSLoggerClient()
{
    SBJsonParser* parser;
}
@property (strong, nonatomic) CEPubnub* pubnub;
@property (strong, nonatomic) NSMutableArray* privateLogEntries;
@property (strong, nonatomic) NSData* key;

@end

@implementation MSLoggerClient

//public
@synthesize userName = _userName;
@synthesize machineName = _machineName;
@synthesize domainName = _domainName;
@synthesize receiverChannel = _receiverChannel;
@synthesize senderChannel = _senderChannel;
@synthesize encryptedKey = _encryptedKey;
@synthesize lastSeen = _lastSeen;
@synthesize companyName = _companyName;
@synthesize statsChannel = _statsChannel;
@synthesize runtimeInfo = _runtimeInfo;
@synthesize publicKeyURL = _publicKeyURL;

//private
@synthesize key = _key;
@synthesize pubnub = _pubnub;
@synthesize privateLogEntries = _privateLogEntries;

-(id)init
{
    return nil;
}

-(id)initWithUserName:(NSString*)userName machineName:(NSString*)machineName domainName:(NSString*)domainName companyName:(NSString*)companyName receiverChannel:(NSString*) receiverChannel senderChannel:(NSString*)senderChannel statsChannel:(NSString*)statsChannel encrypedKey:(NSString*) encryptedKey publicKey:(NSString*)publicKey
{
    self = [super init];
    if(self)
    {
        if(userName) _userName = [userName copy];
        if(machineName) _machineName = [machineName copy];
        if(domainName) _domainName = [domainName copy];
        if(receiverChannel) _receiverChannel = [receiverChannel copy];
        if(senderChannel) _senderChannel = [senderChannel copy];
        if(encryptedKey) _encryptedKey = [encryptedKey copy];
        if(companyName) _companyName = [companyName copy];
        if(publicKey) _publicKeyURL = [publicKey copy];
        if(statsChannel)
        {
            _statsChannel = [statsChannel copy];
            
            //get history from stats - but only last msg
            [self.pubnub history:self.statsChannel limit:1 delegate:self];
            //start listening for stats
            [self.pubnub subscribe: self.statsChannel delegate:self];
        }
        
        _runtimeInfo = [[MSRuntimeInfo alloc] init];
        
        parser = [[SBJsonParser alloc]init];
        
        [self setLastSeen:[NSDate date]];
    }
    
    return self;
}

-(void)dealloc
{
    if(self.pubnub)
    {
        //gracefully shutdown channel subscribers first
        if(self.statsChannel)
            [self.pubnub unsubscribe:self.statsChannel];
        
        if(self.receiverChannel)
            [self.pubnub unsubscribe:self.receiverChannel];
        
        [self.pubnub release];
    }
    
    if(self.userName)[self.userName release];
    if(self.machineName)[self.machineName release];
    if(self.domainName)[self.domainName release];
    if(self.receiverChannel)[self.receiverChannel release];
    if(self.senderChannel)[self.senderChannel release];
    if(self.encryptedKey)[self.encryptedKey release];
    if(self.lastSeen)[self.lastSeen release];
    if(self.key)[self.key release];
    if(self.privateLogEntries) [self.privateLogEntries release];
    if(self.companyName) [self.companyName release];
    if(self.statsChannel) [self.statsChannel release];
    if(self.runtimeInfo) [self.runtimeInfo release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

-(void)startListening
{
    //start listening on subscriber
    [self.pubnub subscribe: self.receiverChannel delegate:self];
}

-(void)stopListening
{
    [self.pubnub unsubscribe:self.receiverChannel];
}

//pubsub delegate methods
- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveDictionary:(NSDictionary *)response onChannel:(NSString *)channel
{
    //check valid structure
    if([response objectForKey:MSG_IV] && [response objectForKey:MSG_CONTENTS] && [response objectForKey:MSG_TYPE])
    {
        NSData* iv = [MSEncryption base64DecodeStringToData:[response objectForKey:MSG_IV]];
        NSData* encryptedMsg = [MSEncryption base64DecodeStringToData:[response objectForKey:MSG_CONTENTS]];
        
        if(iv && encryptedMsg)
        {
            NSString* unencryptedMsg = [MSEncryption decryptData:encryptedMsg withKey:self.key vector:iv trimWhitespace:YES];
            if(unencryptedMsg)
            {
                NSError* err;
                NSDictionary* obj = [parser objectWithString:unencryptedMsg error:&err];
                
                if([[response objectForKey:MSG_TYPE] isEqualToString:MSG_LOG_MESSAGE])
                {
                    //log message received
                    
                }else if([[response objectForKey:MSG_TYPE] isEqualToString:MSG_STATS_MESSAGE]){
                    //stats message received
                    if(self.runtimeInfo){
                        //got runtime info before - update memory info
                        if([obj objectForKey:SM_NETVER]) if(!self.runtimeInfo.netVersions) self.runtimeInfo.netVersions = [obj objectForKey:SM_NETVER];
                        if([obj objectForKey:SM_WINVER])if(!self.runtimeInfo.windowsVersion) self.runtimeInfo.windowsVersion = [obj objectForKey:SM_WINVER];
                        if([obj objectForKey:SM_START_TIME])if(!self.runtimeInfo.startTime) self.runtimeInfo.startTime = [MSCommonDate string:[obj objectForKey: SM_START_TIME] toDateWithFormat:nil];
                        
                        if([obj objectForKey:SM_PHYSICAL_MEM]) self.runtimeInfo.physicalMemorySize = [[obj objectForKey:SM_PHYSICAL_MEM] longValue];
                        if([obj objectForKey:SM_PRIVATE_MEM]) self.runtimeInfo.privateMemorySize = [[obj objectForKey:SM_PRIVATE_MEM] longValue];
                        if([obj objectForKey:SM_VIRTUAL_MEM]) self.runtimeInfo.virtualMemorySize = [[obj objectForKey:SM_VIRTUAL_MEM] longValue];
                        
                        
                        
                        NSLog(@"Stats msg");
                    }
                }
                //
                
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
    for(id obj in response){
        if([obj isKindOfClass:[NSDictionary class]]){
            [self pubnub:pubnub subscriptionDidReceiveDictionary:obj onChannel:channel];
        }
    }
}

//public properties


-(NSArray*)logEntries
{    
    return [self.privateLogEntries copy];
}

//private properties
-(NSData*)key
{
    if(!_key)
    {
        if(self.encryptedKey)
        {
            //we have an encrypted key
            //decrypt self.encryptedKey
            [self setKey:[MSEncryption decryptString:self.encryptedKey withCertificate:[NSURL URLWithString:@"http://localhost/logging.p12"] andPassword:@"12345"]]; 
            
            //NSLog(@"Secret key hex = %@", [_key hexDump]);
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
                   publishKey:   PUBLISHERKEY
                   subscribeKey: SUBSCRIBERKEY
                   secretKey:    @""//@"sec-649a5039-cb8d-40eb-beec-21b9c07aec64" 
                   sslOn:        YES
                   origin:       @"pubsub.pubnub.com"
                   ]; 
    }
    
    return _pubnub;
}


@end

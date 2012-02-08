//
//  MSHeartbeatClient.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 07/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSHeartbeatClient.h"
#import "CEPubnub.h"
#import "MSConstants.h"

@interface MSHeartbeatClient()

@property (strong, atomic) NSMutableDictionary* availableClients;
@property (strong, nonatomic) CEPubnub* pubnub;

@end

@implementation MSHeartbeatClient


//private properties
@synthesize availableClients = _availableClients;
@synthesize pubnub = _pubnub;

-(id)init
{
    self = [super init];
    if(self)
    {
        _availableClients = [[NSMutableDictionary alloc]init];
        
        [self.pubnub subscribe:OS_HEARTBEAT_CHANNEL delegate:self];
    }
    return self;
}

-(void)dealloc
{
    if(self.availableClients)
        [self.availableClients release];
    
    if(self.pubnub)
    {
        [self.pubnub unsubscribe:OS_HEARTBEAT_CHANNEL];
        
        [self.pubnub release];
    }
}

//pubsub delegate methods
- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveDictionary:(NSDictionary *)response onChannel:(NSString *)channel
{
    //check valid structure
    if([response objectForKey:HB_MSG_USER] && [response objectForKey:HB_MSG_MACHINE] && [response objectForKey:HB_MSG_REPLY] && [response objectForKey:HB_MSG_BROADCAST] && [response objectForKey:HB_MSG_KEY] && [response objectForKey:HB_MSG_TIME])
    {
        if(![self.availableClients objectForKey:[response objectForKey:HB_MSG_MACHINE]])
        {
            MSLoggerClient *client = [[MSLoggerClient alloc]initWithUserName:[response objectForKey:HB_MSG_USER] machineName:[response objectForKey:HB_MSG_MACHINE] receiverChannel:[response objectForKey:HB_MSG_BROADCAST] senderChannel:[response objectForKey:HB_MSG_REPLY] encrypedKey:[response objectForKey:HB_MSG_KEY]];
            
            [self.availableClients setObject:client forKey:[client machineName]];
            
            [client startListening];
        }
        
    }else{
        NSLog(@"Received invalid message");
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

//private properties
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

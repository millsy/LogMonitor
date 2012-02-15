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
#import "MSCommonDate.h"


@interface MSHeartbeatClient()

@property (strong, atomic) NSMutableDictionary* availableClients;
@property (strong, nonatomic) CEPubnub* pubnub;
@property (strong, atomic) NSTimer* loopTimer;
@property (strong, nonatomic) NSURL* privateKeyUrl;
@property (strong, nonatomic) NSString* privateKeyPassword;

-(void)checkAvailableClients;

@end

@implementation MSHeartbeatClient

//private properties
@synthesize availableClients = _availableClients;
@synthesize pubnub = _pubnub;
@synthesize loopTimer = _loopTimer;
@synthesize privateKeyUrl = _privateKeyUrl;
@synthesize privateKeyPassword = _privateKeyPassword;

static int period = -60;

-(id)initWithURL:(NSURL*)url password:(NSString*)password
{
    self = [super init];
    if(self)
    {
        self.privateKeyUrl = url;
        self.privateKeyPassword = password;
        
        _availableClients = [[NSMutableDictionary alloc]init];
        
        [self.pubnub subscribe:OS_HEARTBEAT_CHANNEL delegate:self];
        
        [self setLoopTimer:[NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(checkAvailableClients) userInfo:nil repeats:YES]];        
        
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
    
    [self.privateKeyUrl release];
    [self.privateKeyPassword release];
    
    [super dealloc];
}

-(NSArray*)clients
{
    return [self.availableClients allValues];
}

//timer method to check if clients should be removed from the availableClients dictionary
-(void)checkAvailableClients
{ 
    NSArray* keys = [self.availableClients allKeys];
    for (NSString* key in keys) {
        MSLoggerClient* client = [self.availableClients objectForKey:key];
        NSDate* now = [NSDate date];
        NSDate* earlier = [MSCommonDate date:now minusSeconds:period];
        if(![MSCommonDate date:client.lastSeen isBetweenDate:earlier andDate:now])
        {
            //do we need to stop it from listening before removing it?
            
            //this is an old one - remove it
            //NSLog(@"Old client %@", client.machineName);
            
            [self.availableClients removeObjectForKey:key];
            
            //this has to happen after removing it from the dictionary
            [[NSNotificationCenter defaultCenter]postNotificationName:NC_CLIENTS_UPDATED object:nil];
        }else
        {
            //NSLog(@"Keeping client %@", client.machineName);
        }
    }
}

//pubsub delegate methods
- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveDictionary:(NSDictionary *)response onChannel:(NSString *)channel
{
    //check valid structure
    if([response objectForKey:HB_MSG_USER] && [response objectForKey:HB_MSG_MACHINE] && [response objectForKey:HB_MSG_DOMAIN] && [response objectForKey:HB_MSG_REPLY] && [response objectForKey:HB_MSG_BROADCAST] && [response objectForKey:HB_MSG_KEY] && [response objectForKey:HB_MSG_TIME] && [response objectForKey:HB_MSG_COMPANY] && [response objectForKey:HB_MSG_PUBLIC_KEY])
    {
        if([[response objectForKey:MSG_TYPE] isEqualToString:MSG_HB_MESSAGE])
        {
            if(![self.availableClients objectForKey:[response objectForKey:HB_MSG_BROADCAST]])
            {
                MSLoggerClient *client = [[MSLoggerClient alloc]initWithUserName:[response objectForKey:HB_MSG_USER] machineName:[response objectForKey:HB_MSG_MACHINE] domainName:[response objectForKey:HB_MSG_DOMAIN] companyName:[response objectForKey:HB_MSG_COMPANY] receiverChannel:[response objectForKey:HB_MSG_BROADCAST] senderChannel:[response objectForKey:HB_MSG_REPLY] statsChannel:[response objectForKey:HB_STATS] encrypedKey:[response objectForKey:HB_MSG_KEY] publicKey:[response objectForKey:HB_MSG_PUBLIC_KEY] privateKeyURL:self.privateKeyUrl privateKeyPassword:self.privateKeyPassword];
                
                [self.availableClients setObject:client forKey:[client receiverChannel]];
                
                [client startListening];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:NC_CLIENTS_UPDATED object:nil];
                
            }else{
                MSLoggerClient *client = [self.availableClients objectForKey:[response objectForKey:HB_MSG_BROADCAST]];
                [client setLastSeen:[NSDate date]];
            }
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

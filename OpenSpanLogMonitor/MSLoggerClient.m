//
//  MSLoggerClient.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 07/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSLoggerClient.h"

@interface MSLoggerClient()

@property (strong, nonatomic) CEPubnub* pubnub;
@property (strong, nonatomic, readonly) NSString* publishKey;
@property (strong, nonatomic, readonly) NSString* subscribeKey;

@end

@implementation MSLoggerClient

//public
@synthesize userName = _userName;
@synthesize machineName = _machineName;
@synthesize receiverChannel = _receiverChannel;
@synthesize senderChannel = _senderChannel;
@synthesize encryptedKey = _encryptedKey;
@synthesize key = _key;
//private
@synthesize pubnub = _pubnub;
@synthesize publishKey = _publishKey;
@synthesize subscribeKey = _subscribeKey;

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
    }
    return self;
}

//public properties
-(NSString*)key
{
    if(!_key)
    {
        if(self.encryptedKey)
        {
            //we have an encrypted key
            //decrypt self.encryptedKey
            
            
        }
    }
    return _key;
}


//private properties
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

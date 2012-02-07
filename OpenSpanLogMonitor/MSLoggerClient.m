//
//  MSLoggerClient.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 07/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSLoggerClient.h"


@implementation MSLoggerClient

@synthesize userName = _userName;
@synthesize machineName = _machineName;
@synthesize receiverChannel = _receiverChannel;
@synthesize senderChannel = _senderChannel;
@synthesize encryptedKey = _encryptedKey;
@synthesize key = _key;

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

@end

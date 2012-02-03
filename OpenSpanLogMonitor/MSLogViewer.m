//
//  MSLogViewer.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 31/01/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSLogViewer.h"
#import "CEPubnub.h"

@interface MSLogViewer()

@property (nonatomic, strong, readonly) NSNumber* defaultTraceLevel;
@property (nonatomic, strong) NSArray* logTypes;

- (NSArray*)defaultLogTypes;
- (NSMutableDictionary*)defaultLogLevels;
-(void)sendMessage:(id)message toChannel:(NSString*)channel;
-(void)addImageNamed:(NSString*)name inFolder:(NSString*)folder;

@end

@implementation MSLogViewer

static NSMutableDictionary* defaultLogLevels = nil;
//static NSArray* logTypes = nil;

@synthesize logTypes = _logTypes;

-(void)dealloc
{
    if(defaultLogLevels) [defaultLogLevels dealloc];
    if(_logTypes) [_logTypes dealloc];
}

- (NSArray*)defaultLogTypes {
    if(!_logTypes)
    {
        _logTypes = [[NSArray alloc] initWithObjects:@"Default", @"Keys", @"Matching", @"Adapters", @"Java Adapter", @"Text Adapter", @"Text Screens", nil];
    }
    return _logTypes;
}

- (NSMutableDictionary*)defaultLogLevels {
    
    if (defaultLogLevels == nil)
    {
        NSArray* keys = [self defaultLogTypes];
        NSMutableArray* valueLevels = [[[NSMutableArray alloc]init]autorelease];
        for(int i = 0; i < [keys count]; i++)
        {
            [valueLevels addObject:[NSNumber numberWithInt:1]];
        }
        
        defaultLogLevels = [[NSMutableDictionary alloc] initWithObjects:valueLevels forKeys:[self defaultLogTypes]];
    }
    return [[defaultLogLevels mutableCopy]autorelease];
}

@synthesize machineName = _machineName;
@synthesize logLevels = _logLevels;
@synthesize defaultTraceLevel = _defaultTraceLevel;

static NSArray* _traceLevels;

@synthesize key = _key;
@synthesize publishKey = _publishKey;
@synthesize subscribeKey = _subscribeKey;
@synthesize images = _images;

-(NSMutableArray*)images
{
    if(!_images)
    {
        _images = [[NSMutableArray alloc]init];
    }
    return _images;
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

-(id)init
{
    return [self initWithMachineName:nil logLevels:nil machineKey:nil];
}

-(NSString*)key
{
    if([_key length] > 0)
    {
        return _key;
    }
    return nil;
}

-(NSString*)machineName
{
    if([_machineName length] > 0)
    {
        return _machineName;
    }
    return nil;
}

-(id)initWithMachineName:(NSString*)machineName
{
    return [self initWithMachineName:machineName logLevels:nil machineKey:nil];
}

-(id)initWithMachineName:(NSString*)machineName logLevels:(NSMutableDictionary *)logLevels
{
    return [self initWithMachineName:machineName logLevels:logLevels machineKey:nil];
}

-(id)initWithMachineName:(NSString *)machineName machineKey:(NSString*)machineKey
{
    return [self initWithMachineName:machineName logLevels:nil machineKey:machineKey];
}

-(id)initWithMachineName:(NSString *)machineName logLevels:(NSMutableDictionary*)logLevels machineKey:(NSString*)machineKey
{
    self = [super init];
    if(self)
    {
        if(!logLevels) logLevels = [self defaultLogLevels];
        
        if(![machineName isEqualToString:@""])
        {
            self.machineName = machineName;
        }
        
        if(![machineKey isEqualToString:@""])
        {
            self.key = machineKey;
        }
        
        self.logLevels = logLevels;
        
    }
    return self;
}

-(NSNumber*)defaultTraceLevel
{
    if(!_defaultTraceLevel)
    {
        _defaultTraceLevel = [NSNumber numberWithInt:1];
    }
    return _defaultTraceLevel;
}

+(NSArray*)traceLevels{
    if(!_traceLevels)
    {
        _traceLevels = [[NSArray alloc] initWithObjects:@"Off", @"Error", @"Warning", @"Info", @"Verbose", nil];
    }
    return _traceLevels;
}

-(NSString*)description{
    return [NSString stringWithFormat:@"Machine Name = %@\nMachine Key = %@\nLog Levels = %@\nTrace Levels = %@", self.machineName, self.key, self.logLevels, [[self class]traceLevels]];
}

-(void)sendLogLevels
{
    if((self.machineName) && (self.key))
    {
        NSDictionary* msg = [NSDictionary dictionaryWithObjectsAndKeys: self.machineName, @"MachineName", @"TraceLevel", @"Type", self.key, @"MachineKey", self.logLevels, @"Levels", nil];
        
        [self sendMessage:msg toChannel:@"LOGENABLER"];
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:self.logLevels forKey:@"logLevels"];
        
        [defaults synchronize];
    }
}

-(void)requestScreenShot
{
    if(self.machineName && self.key)
    {
        NSString* filename = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".jpg"];
        NSString* folder = self.machineName;
        NSString* bucket = @"openspanimages";
        
        NSDictionary* msg = [NSDictionary dictionaryWithObjectsAndKeys: self.machineName, @"MachineName", @"screenshot", @"Type", self.key, @"MachineKey", bucket, @"Bucket", filename, @"Filename", folder, @"Folder", nil];
        
        [self sendMessage:msg toChannel:@"LOGENABLER"];
        
        [self addImageNamed:filename inFolder:folder];
    }
}

-(void)addImageNamed:(NSString*)name inFolder:(NSString*)folder
{
    NSString* url = [NSString stringWithFormat:@"http://openspanimages.s3.amazonaws.com/%@/%@", folder , name];
    [self.images addObject:url];
}

-(void)sendMessage:(id)message toChannel:(NSString*)channel
{
    CEPubnub* pn = [[[CEPubnub alloc] autorelease]
                    publishKey:   self.publishKey
                    subscribeKey: self.subscribeKey 
                    secretKey:    @""//@"sec-649a5039-cb8d-40eb-beec-21b9c07aec64" 
                    sslOn:        YES
                    origin:       @"pubsub.pubnub.com"
                    ];
    [pn publish:channel message:message delegate:self];
}

@end

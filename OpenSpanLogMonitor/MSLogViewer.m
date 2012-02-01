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

- (NSArray*)defaultLogTypes;
- (NSMutableDictionary*)defaultLogLevels;

@end

@implementation MSLogViewer

static NSMutableDictionary* defaultLogLevels = nil;
static NSArray* logTypes = nil;

-(void)dealloc
{
    if(defaultLogLevels) [defaultLogLevels dealloc];
    if(logTypes) [logTypes dealloc];
}

- (NSArray*)defaultLogTypes {
    if(logTypes == nil)
    {
        logTypes = [NSArray arrayWithObjects:@"Default", @"Keys", @"Matching", @"Adapters", @"Java Adapter", @"Text Adapter", @"Text Screens", nil];
    }
    return logTypes;
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
@synthesize traceLevels = _traceLevels;
@synthesize key = _key;
@synthesize publishKey = _publishKey;
@synthesize subscribeKey = _subscribeKey;

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
        
        self.machineName = machineName;
        self.logLevels = logLevels;
        self.key = machineKey;
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

-(NSArray*)traceLevels{
    if(!_traceLevels)
    {
        _traceLevels = [[NSArray alloc] initWithObjects:@"Off", @"Error", @"Warning", @"Info", @"Verbose", nil];
    }
    return _traceLevels;
}

-(NSString*)description{
    return [NSString stringWithFormat:@"Machine Name = %@\nMachine Key = %@\nLog Levels = %@\nTrace Levels = %@", self.machineName, self.key, self.logLevels, self.traceLevels];
}

-(void)sendLogLevels
{
    if(self.key)
    {
        NSDictionary* msg = [NSDictionary dictionaryWithObjectsAndKeys: self.machineName, @"MachineName", self.key, @"MachineKey", self.logLevels, @"Levels", nil];
        
        CEPubnub* pn = [[[CEPubnub alloc] autorelease]
         publishKey:   self.publishKey
         subscribeKey: self.subscribeKey 
         secretKey:    @""//@"sec-649a5039-cb8d-40eb-beec-21b9c07aec64" 
         sslOn:        YES
         origin:       @"pubsub.pubnub.com"
         ]; 
        
        [pn publish:@"LOGENABLER" message:msg delegate:self];
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:self.logLevels forKey:@"logLevels"];
        
        [defaults synchronize];
    }
}

@end

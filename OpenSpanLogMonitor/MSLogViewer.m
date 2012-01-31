//
//  MSLogViewer.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 31/01/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSLogViewer.h"

@interface MSLogViewer()

@property (nonatomic, strong, readonly) NSNumber* defaultTraceLevel;

- (NSArray*)defaultLogTypes;
- (NSMutableDictionary*)defaultLogLevels;

@end

@implementation MSLogViewer

static NSMutableDictionary* defaultLogLevels = nil;
static NSArray* logTypes = nil;
//static NSArray* defaultTraceLevels = nil;

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

-(id)init
{
    return [self initWithMachineName:nil logLevels:[self defaultLogLevels]];
}

-(id)initWithMachineName:(NSString*)machineName
{
    return [self initWithMachineName:machineName logLevels:[self defaultLogLevels]];
}

-(id)initWithMachineName:(NSString*)machineName logLevels:(NSMutableDictionary *)logLevels
{
    self = [super init];
    if(self)
    {
        self.machineName = machineName;
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

-(NSArray*)traceLevels{
    if(!_traceLevels)
    {
        _traceLevels = [[NSArray alloc] initWithObjects:@"Off", @"Error", @"Warning", @"Info", @"Verbose", nil];
    }
    return _traceLevels;
}

-(NSString*)description{
    return [NSString stringWithFormat:@"Log Levels = %@\nTrace Levels = %@", self.logLevels, self.traceLevels];
}

@end

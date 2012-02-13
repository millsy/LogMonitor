//
//  MSRuntimeInfo.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 09/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSRuntimeInfo.h"

@implementation MSRuntimeInfo

@synthesize netVersions = _netVersions;
@synthesize windowsVersion = _windowsVersion;
@synthesize startTime = _startTime;
@synthesize virtualMemorySize = _virtualMemorySize;
@synthesize physicalMemorySize = _physicalMemorySize;
@synthesize privateMemorySize = _privateMemorySize;
@synthesize osVersion = _osVersion;

-(id)init
{
    return [self initWithNetVersions:nil windowsVersion:nil startTime:nil virtualMemory:0 physicalMemory:0 privateMemory:0];
}

-(id)initWithNetVersions:(NSArray*)netVersions windowsVersion:(NSString*)windowsVersion startTime:(NSDate*)startTime virtualMemory:(int)virtualMem physicalMemory:(int)physicalMem privateMemory:(int) privateMem
{
    self = [super init];
    if(self)
    {
        self.netVersions = netVersions;
        self.windowsVersion = windowsVersion;
        self.startTime = startTime;
        self.virtualMemorySize = virtualMem;
        self.physicalMemorySize = privateMem;
        self.privateMemorySize = privateMem;
    }
    return self;
}

-(NSString*)stringOfNetVersions
{
    NSString* result = @"";
    if(self.netVersions)
    {
        for(NSString* ver in self.netVersions)
        {
            result = [result stringByAppendingFormat:@"%@\n", ver];
        }
    }
    return result;
}

@end

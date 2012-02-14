//
//  MSLogEntry.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 02/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSLogEntry.h"
#import "MSCommonDate.h"

@implementation MSLogEntry

@synthesize logDate = _logDate;
@synthesize logMessage = _logMessage;
@synthesize traceLevel = _traceLevel;
@synthesize category = _category;
@synthesize designComp = _designComp;
@synthesize component = _component;
@synthesize verboseMsg = _verboseMsg;
@synthesize tag = _tag;

-(id)initWithDate:(NSString*)date message:(NSString*)msg traceLevel:(NSString*)traceLevel category:(NSString*)category designComponent:(NSString*)designComp component:(NSString*)component verboseMsg:(NSString*)verboseMsg tag:(NSString*)tag
{
    self = [super init];
    if(self)
    {
        _logDate = [[MSCommonDate string:date toDateWithFormat:nil] retain];
        _logMessage = [msg copy];
        _traceLevel = [traceLevel copy];
        _category = [category copy];
        _designComp = [designComp copy];
        _component = [component copy];
        _verboseMsg = [verboseMsg copy];
        _tag = [tag copy];
    }
    return self;
}

-(void)dealloc
{
    [_logDate release];
    [_logMessage release];
    [_traceLevel release];
    [_category release];
    [_designComp release];
    [_component release];
    [_verboseMsg release];
    [_tag release];
    [super dealloc];
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"%@ %@ %@", self.logDate, self.category, self.logMessage];
}

@end

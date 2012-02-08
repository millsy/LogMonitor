//
//  MSCommonDate.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 08/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSCommonDate.h"

@implementation MSCommonDate

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending) 
        return NO;
    
    return YES;
}

+(NSDate*)date:(NSDate*)date minusSeconds:(NSInteger)seconds
{
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
    NSDateComponents *offsetComponents = [[[NSDateComponents alloc] init]autorelease];
    [offsetComponents setSecond:seconds]; 
    return [gregorian dateByAddingComponents:offsetComponents toDate:date options:0];
}

@end

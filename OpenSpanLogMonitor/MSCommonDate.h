//
//  MSCommonDate.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 08/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSCommonDate : NSObject

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;
+(NSDate*)date:(NSDate*)date minusSeconds:(NSInteger)seconds;

@end

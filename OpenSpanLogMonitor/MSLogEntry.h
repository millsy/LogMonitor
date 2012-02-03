//
//  MSLogEntry.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 02/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSLogEntry : NSObject

@property (nonatomic, copy) NSDate* logDate;
@property (nonatomic, copy) NSString* logMessage;

@end

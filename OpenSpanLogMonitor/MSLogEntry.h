//
//  MSLogEntry.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 02/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSLogEntry : NSObject

@property (nonatomic, strong, readonly) NSDate* logDate;
@property (nonatomic, strong, readonly) NSString* logMessage;
@property (nonatomic, strong, readonly) NSString* traceLevel;
@property (nonatomic, strong, readonly) NSString* category;
@property (nonatomic, strong, readonly) NSString* designComp;
@property (nonatomic, strong, readonly) NSString* component;
@property (nonatomic, strong, readonly) NSString* verboseMsg;
@property (nonatomic, strong, readonly) NSString* tag;

-(id)initWithDate:(NSString*)date message:(NSString*)msg traceLevel:(NSString*)traceLevel category:(NSString*)category designComponent:(NSString*)designComp component:(NSString*)component verboseMsg:(NSString*)verboseMsg tag:(NSString*)tag;

@end

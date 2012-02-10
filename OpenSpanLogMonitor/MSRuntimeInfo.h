//
//  MSRuntimeInfo.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 09/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSRuntimeInfo : NSObject

@property (nonatomic, retain) NSArray* netVersions;
@property (nonatomic, retain) NSString* windowsVersion;
@property (nonatomic, retain) NSDate* startTime;
@property (nonatomic, assign) long virtualMemorySize;
@property (nonatomic, assign) long physicalMemorySize;
@property (nonatomic, assign) long privateMemorySize;

-(id)init;
-(id)initWithNetVersions:(NSArray*)netVersions windowsVersion:(NSString*)windowsVersion startTime:(NSDate*)startTime virtualMemory:(int)virtualMem physicalMemory:(int)physicalMem privateMemory:(int) privateMem;

-(NSString*)stringOfNetVersions;

@end

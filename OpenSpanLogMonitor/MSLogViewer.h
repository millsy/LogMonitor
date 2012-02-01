//
//  MSLogViewer.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 31/01/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSLogViewer : NSObject

@property (nonatomic, strong) NSString* machineName;
@property (nonatomic, strong) NSMutableDictionary* logLevels;
@property (nonatomic, strong) NSString* key;
@property (nonatomic, strong, readonly) NSString* publishKey;
@property (nonatomic, strong, readonly) NSString* subscribeKey;

@property (nonatomic, strong) NSMutableArray* images;

-(id)init;
-(id)initWithMachineName:(NSString*)machineName;
-(id)initWithMachineName:(NSString *)machineName logLevels:(NSMutableDictionary*)logLevels;
-(id)initWithMachineName:(NSString *)machineName machineKey:(NSString*)machineKey;
-(id)initWithMachineName:(NSString *)machineName logLevels:(NSMutableDictionary*)logLevels machineKey:(NSString*)machineKey;

-(void)sendLogLevels;
-(void)requestScreenShot;

+(NSArray*)traceLevels;
@end

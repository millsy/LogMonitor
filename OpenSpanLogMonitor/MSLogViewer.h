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

-(id)init;
-(id)initWithMachineName:(NSString*)machineName;
-(id)initWithMachineName:(NSString *)machineName logLevels:(NSMutableDictionary*)logLevels;

@end

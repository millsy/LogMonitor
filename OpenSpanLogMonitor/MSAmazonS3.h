//
//  MSAmazonS3.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 15/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSAmazonS3 : NSObject

+(NSArray*)getAvailableKeys;
+(NSURL*)getSignedURLForKey:(NSString*)key;
+(void)setCredentialsWithUserName:(NSString*)username password:(NSString*)password;
+(BOOL)getCredentialsWithUserName:(NSString**)username password:(NSString**)password;
+(BOOL)hasAmazonCredentials;
@end

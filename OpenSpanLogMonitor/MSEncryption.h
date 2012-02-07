//
//  MSEncryption.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 07/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSEncryption : NSObject

+(NSString*)decryptString:(NSString*)data withCertificate:(NSURL*)url andPassword:(NSString*)password;
+(NSString*)decryptString:(NSString*)data withKey:(NSString*)key vector:(NSString*)vector;
+(NSString*)base64DecodeString:(NSString*)data;
+(NSString*)base64EncodeString:(NSString*)data;

@end

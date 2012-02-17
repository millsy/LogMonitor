//
//  MSEncryption.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 07/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSEncryption : NSObject
{
@private
    NSData* pkcis12Data;
    NSURL* pkcis12URL;
    SecIdentityRef myIdentity;
    SecTrustRef myTrust;
}

@property (nonatomic, strong, readonly) NSData* privateKey;

-(id)init;
-(id)initWithURL:(NSURL*)url password:(NSString*)password;

-(void)decryptString:(NSString*)data;

+(NSData*)decryptString:(NSString*)data withCertificate:(NSURL*)url andPassword:(NSString*)password;
+(NSString*)decryptData:(NSData*)data withKey:(NSData*)key vector:(NSData*)vector trimWhitespace:(BOOL)trim;
+(NSString*)base64DecodeString:(NSString*)data;
+(NSString*)base64EncodeString:(NSString*)data;
+(NSData*)base64DecodeStringToData:(NSString*)data;
+(BOOL)validatePassword:(NSString*)password withCertificate:(NSURL*)url;

@end

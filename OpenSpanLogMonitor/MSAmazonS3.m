//
//  MSAmazonS3.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 15/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSAmazonS3.h"
#import <AWSiOSSDK/S3/AmazonS3Client.h>
#import "KeychainItemWrapper.h"

@interface MSAmazonS3()
{
    NSString* identifier;    
}
+(AmazonS3Client*)getClient;

@end

@implementation MSAmazonS3

static NSString* identifier = @"AmazonS3Credentials";

+(NSArray*)getAvailableKeys
{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    @try
    {
        AmazonS3Client* aws = [MSAmazonS3 getClient];
        if(aws)
        {
            S3ListObjectsRequest *listObjectRequest = [[[S3ListObjectsRequest alloc] initWithName:@"os-certs"] autorelease];
            //aws setTimeout:[NSDate timeIntervalSinceReferenceDate]
            listObjectRequest.prefix = @"private/";
            listObjectRequest.delimiter = @"/";
            
            S3ListObjectsResponse* resp = [aws listObjects:listObjectRequest];
            S3ListObjectsResult* res = resp.listObjectsResult;
            
            for (S3ObjectSummary *objectSummary in res.objectSummaries) {
                
                if([[objectSummary key] hasSuffix:@"p12"])
                {
                    [result addObject:[objectSummary key]];
                }
            }
        }
    }
    @catch (AmazonServiceException* ase) {
        NSLog(@"Amazon Exception %@", ase);
        result = nil;
    }
    
    return [result copy];
}

+(void)setCredentialsWithUserName:(NSString*)username password:(NSString*)password
{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:identifier accessGroup:nil];
    [keychainItem setObject:password forKey:kSecValueData];
    [keychainItem setObject:username forKey:kSecAttrAccount];
    [keychainItem release];
}

+(BOOL)getCredentialsWithUserName:(NSString**)username password:(NSString**)password
{
    if([MSAmazonS3 hasAmazonCredentials]){
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:identifier accessGroup:nil];
        *username = [keychainItem objectForKey:kSecAttrAccount];
        *password = [keychainItem objectForKey:kSecValueData];
        [keychainItem release];
        return true;
    }
    return false;
}

+(BOOL)hasAmazonCredentials
{
    BOOL result = false;
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:identifier accessGroup:nil];
    if([[keychainItem objectForKey:kSecValueData] length] > 0 && [[keychainItem objectForKey:kSecAttrAccount] length] > 0)
    {
        result = true;
    }
    
    [keychainItem release];
    return result;
}

+(NSURL*)getSignedURLForKey:(NSString*)key
{
    NSURL* url= nil;
    AmazonS3Client* aws = [MSAmazonS3 getClient];
    if(aws)
    {
        S3GetPreSignedURLRequest* urlReq = [[[S3GetPreSignedURLRequest alloc] init]autorelease];
        urlReq.key = key;
        urlReq.bucket = @"os-certs";
        urlReq.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
        
        url = [aws getPreSignedURL:urlReq];
    }
    return url;
}

+(AmazonS3Client*)getClient
{
    NSString* user; NSString* pwd;
    [MSAmazonS3 getCredentialsWithUserName:&user password:&pwd];
    return [[[AmazonS3Client alloc] initWithAccessKey:user withSecretKey:pwd]autorelease];
}
//@"AKIAJT345BW42EXBFUSA"
//@"TaIhmx1qXaT22Mz7N4UFCZ5CeU62QLN2MLNcjeta"
@end

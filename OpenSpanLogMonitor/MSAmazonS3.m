//
//  MSAmazonS3.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 15/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSAmazonS3.h"
#import <AWSiOSSDK/S3/AmazonS3Client.h>

@interface MSAmazonS3()

+(AmazonS3Client*)getClient;

@end

@implementation MSAmazonS3

+(NSArray*)getAvailableKeys
{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    @try
    {
        AmazonS3Client* aws = [MSAmazonS3 getClient];
        if(aws)
        {
            S3ListObjectsRequest *listObjectRequest = [[[S3ListObjectsRequest alloc] initWithName:@"os-certs"] autorelease];
            listObjectRequest.prefix = @"private/";
            listObjectRequest.delimiter = @"/";
            
            S3ListObjectsResponse* resp = [aws listObjects:listObjectRequest];
            S3ListObjectsResult* res = resp.listObjectsResult;
            
            for (S3ObjectSummary *objectSummary in res.objectSummaries) {
                
                if([[objectSummary key] hasSuffix:@"p12"])
                {
                    NSLog(@"Bucket Contents %@ " ,[objectSummary key]); // This returns the contents of the bucket
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

+(NSURL*)getSignedURLForKey:(NSString*)key
{
    NSURL* url;
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
    return [[[AmazonS3Client alloc] initWithAccessKey:@"AKIAJT345BW42EXBFUSA" withSecretKey:@"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"]autorelease];
}

@end

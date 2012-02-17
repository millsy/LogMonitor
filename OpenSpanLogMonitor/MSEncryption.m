//
//  MSEncryption.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 07/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSEncryption.h"
#import <Security/Security.h>
#import "NSData+Extension.h"
#import "NSString+Extension.h"
#import "NSData+Extension.h"

@interface MSEncryption()

OSStatus extractIdentityAndTrust(CFDataRef inPKCS12Data, NSString* password, SecIdentityRef *outIdentity,SecTrustRef *outTrust);

@end

@implementation MSEncryption

@synthesize privateKey = _privateKey;

-(void)dealloc
{
    [pkcis12Data release];
    [pkcis12URL release];
}

-(id)init
{
    return nil;
}

-(id)initWithURL:(NSURL*)url password:(NSString*)password
{
    self = [super init];
    if(self)
    {
        if(url && password){
            pkcis12URL = [url copy];
            pkcis12Data = [[[NSData alloc] initWithContentsOfURL:url] retain];
            if(pkcis12Data)
            {
                OSStatus status = extractIdentityAndTrust((CFDataRef)pkcis12Data,password,&myIdentity,&myTrust);
                if(status == noErr)
                    return self;
                
                NSLog(@"Error extracting identity");
            }
            [pkcis12Data release];
            [pkcis12URL release];
        }
    }  

    //didn't pass validation - return nil
    return nil;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"%@ \n %@", pkcis12URL, [pkcis12Data hexDump]];
}

-(NSData*)privateKey
{
    if(_privateKey)
        return _privateKey;
    
    NSLog(@"call -(void)decryptString:(NSString*)data before accessing privateKey property");
    return nil;
}

-(void)decryptString:(NSString*)data
{
    NSData* result = nil;
    
    //SecCertificateRef myReturnedCertificate = NULL;
    SecKeyRef privateKeyRef;
    OSStatus status;// = SecIdentityCopyCertificate (myIdentity, &myReturnedCertificate); 
    
    //if(status == 0)
    //{
        //get the private key
    status = SecIdentityCopyPrivateKey(myIdentity, &privateKeyRef);
    
    if(status == 0)
    {
        //decode the string
        
        NSData* decodeData = [data base64DecodedBytes];
        
        size_t plainBufferSize = 32;//the data is a fixed length of 16 bytes (256bits)
        uint8_t *plainBuffer = malloc(plainBufferSize);
        
        //decrypt the key
        status = SecKeyDecrypt(privateKeyRef,kSecPaddingPKCS1,(const uint8_t*)[decodeData bytes],[decodeData length],plainBuffer,&plainBufferSize); 
        
        if(status == 0)
        {            
            //got the key
            result = [NSData dataWithBytes:plainBuffer length:32];
        }
    }
    //}
    
    //CFRelease(myReturnedCertificate);
    if(privateKeyRef) CFRelease(privateKeyRef);
    
    _privateKey = result;
}

+(NSData*)base64DecodeStringToData:(NSString*)data
{
    NSData* decodedData = [data base64DecodedBytes];
    
    return decodedData;
}

+(NSString*)base64DecodeString:(NSString*)data
{
    NSData* decodedData = [MSEncryption base64DecodeStringToData:data];
    
    return [[[NSString alloc]initWithBytes:decodedData length:[decodedData length] encoding:NSUTF8StringEncoding]autorelease];
}

+(NSString*)base64EncodeString:(NSString*)data
{
    return [[data dataUsingEncoding:NSUTF8StringEncoding]base64EncodedString];
}

+(NSString*)decryptData:(NSData*)data withKey:(NSData*)key vector:(NSData*)vector trimWhitespace:(BOOL)trim
{   
    //NSLog(@"Key =\n %@ \n IV = \n %@ 'n", [key hexDump], [vector hexDump]);
    
    NSData* decrypted = [data aesDecryptWithKey:key initialVector:vector];
       
    NSString* decryptedString =  [[[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding]autorelease];
    
    if(trim)
    {
        decryptedString = [decryptedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    return decryptedString;
}

+(BOOL)validatePassword:(NSString*)password withCertificate:(NSURL*)url
{
    //errSecAuthFailed
    NSData *PKCS12Data = [[NSData alloc] initWithContentsOfURL:url];
    
    if(PKCS12Data){
        OSStatus status = noErr;
        SecIdentityRef myIdentity;
        SecTrustRef myTrust;
        
        status = extractIdentityAndTrust((CFDataRef)PKCS12Data,password,&myIdentity,&myTrust);
        
        [PKCS12Data release];
        
        if(status == noErr)
            return true;
    }
    
    return false;
}

+(NSData*)decryptString:(NSString*)data withCertificate:(NSURL*)url andPassword:(NSString*)password
{
    NSData* result = nil;
    
    NSData *PKCS12Data = [[NSData alloc] initWithContentsOfURL:url];
    
    if(!PKCS12Data)
    {
        //failed to get data from URL
        NSLog(@"Failed to load certificate from URL");
        return nil;
    }
    
    CFDataRef inPKCS12Data = (CFDataRef)PKCS12Data; 

    OSStatus status = noErr;
    SecIdentityRef myIdentity;
    SecTrustRef myTrust;
    
    status = extractIdentityAndTrust(inPKCS12Data,password,&myIdentity,&myTrust);
    
    if(status == 0)
    {
        SecCertificateRef myReturnedCertificate = NULL;
        status = SecIdentityCopyCertificate (myIdentity, &myReturnedCertificate); 
        
        if(status == 0)
        {
            //got the cert - get the private key
            SecKeyRef privateKeyRef;
            status = SecIdentityCopyPrivateKey(myIdentity, &privateKeyRef);
            
            if(status == 0)
            {
                //decode the string
                
                NSData* decodeData = [data base64DecodedBytes];
                
                size_t plainBufferSize = 32;//the data is a fixed length of 16 bytes (256bits)
                uint8_t *plainBuffer = malloc(plainBufferSize);
                
                //decrypt the key
                status = SecKeyDecrypt(privateKeyRef,kSecPaddingPKCS1,(const uint8_t*)[decodeData bytes],[decodeData length],plainBuffer,&plainBufferSize); 
                
                if(status == 0)
                {            
                    //got the key
                    result = [NSData dataWithBytes:plainBuffer length:32];
                }
            }
        }
    }
    
    if(PKCS12Data)[PKCS12Data release];
        
    return result;
}

OSStatus extractIdentityAndTrust(CFDataRef inPKCS12Data, NSString* password, SecIdentityRef *outIdentity,SecTrustRef *outTrust)
{
    OSStatus securityError = errSecSuccess;

    const void *keys[] =   { kSecImportExportPassphrase };
    const void *values[] = { (CFStringRef)password };
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL); 
    
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import(inPKCS12Data,optionsDictionary,&items);
    
    if (securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust,
                                             kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    }
    
    if (optionsDictionary)
        CFRelease(optionsDictionary);               
    
    return securityError;
}

@end

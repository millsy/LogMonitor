//
//  MSViewController.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 30/01/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSViewController.h"
#import "MSLogLevelViewController.h"
#import "MSLogLevelViewController.h"

@interface MSViewController()

@property (nonatomic) BOOL listening;

@end

@implementation MSViewController

@synthesize logViewer = _logViewer;
@synthesize pubnub = _pubnub;
@synthesize listening = _listening;
@synthesize customLogLevels = _customLogLevels;

-(NSMutableDictionary*)customLogLevels
{
    if(!_customLogLevels) 
    {
        [self setCustomLogLevels:[MSLogLevelViewController defaultLogLevels]];
    }
    return _customLogLevels;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"displayLogLevels"])
    {        
        //MSLogLevelViewController *view = segue.destinationViewController;
        NSLog(@"Logs %@", [self customLogLevels]);
        [segue.destinationViewController setCustomLevels:self.customLogLevels];
    }
}

-(void)awakeFromNib
{
    self.pubnub = [[CEPubnub alloc]
                   publishKey:   @"pub-fc91edb4-5379-47f0-a882-c2de5db4fbcb" 
                   subscribeKey: @"sub-1e9854a8-4b3c-11e1-be34-4103cb3c6424" 
                   secretKey:    @""//@"sec-649a5039-cb8d-40eb-beec-21b9c07aec64" 
                   sslOn:        YES
                   origin:       @"pubsub.pubnub.com"
                   ];    
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Logs %@", self.customLogLevels);
}

- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveDictionary:(NSDictionary *)response onChannel:(NSString *)channel
{
    
    NSString* message = [NSString stringWithFormat:@"%@ %@\n", [response objectForKey:@"DateTime"], [response objectForKey:@"Message"]];
    
    self.logViewer.text = [self.logViewer.text stringByAppendingString:message];
    
    [self.logViewer scrollRangeToVisible:NSMakeRange([self.logViewer.text length], 0)];
    
}
- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveArray:(NSArray *)response onChannel:(NSString *)channel
{
    
}
- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveString:(NSString *)response onChannel:(NSString *)channel
{
}
- (void)pubnub:(CEPubnub *)pubnub subscriptionDidFailWithResponse:(NSString *)response onChannel:(NSString *)channel
{
    
}
- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveHistoryArray:(NSArray *)response onChannel:(NSString *)channel
{
    
}
- (void)pubnub:(CEPubnub *)pubnub publishDidSucceedWithResponse:(NSString *)response onChannel:(NSString *)channel
{
    
}
- (void)pubnub:(CEPubnub *)pubnub publishDidFailWithResponse:(NSString *)response onChannel:(NSString *)channel
{
    
}
- (void)pubnub:(CEPubnub *)pubnub didReceiveTime:(NSString *)timestamp
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


- (void)dealloc {
    [_logViewer release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLogViewer:nil];
    [super viewDidUnload];
}


- (IBAction)stateChange:(id)sender {
    UIButton* btn = sender;
    if(self.listening)
    {
        [self.pubnub unsubscribe:@"OPENSPAN_LOGS"];
        [btn setTitle:@"Start" forState:UIControlStateNormal];
    }else{
        [self.pubnub subscribe: @"OPENSPAN_LOGS" delegate:self];
        self.listening = YES;
        [btn setTitle:@"Stop" forState:UIControlStateNormal];
    }
}

- (IBAction)clear {
    self.logViewer.text = @"";
}
@end

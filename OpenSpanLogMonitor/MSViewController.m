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


-(void)appendMessage:(NSString*)message andScroll:(BOOL)scroll;

@end

@implementation MSViewController

@synthesize logViewer = _logViewer;
@synthesize pubnub = _pubnub;
@synthesize listening = _listening;
@synthesize settings = _settings;

BOOL viewPushed = NO;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"displayLogLevels"])
    {        
        //NSLog(@"Logs %@", self.settings.logLevels);
        [segue.destinationViewController setSettings:self.settings];
        viewPushed = YES;
    }
}

-(CEPubnub*)pubnub
{
    if(!_pubnub)
    {
        _pubnub = [[CEPubnub alloc]
                       publishKey:   self.settings.publishKey
                       subscribeKey: self.settings.subscribeKey 
                       secretKey:    @""//@"sec-649a5039-cb8d-40eb-beec-21b9c07aec64" 
                       sslOn:        YES
                       origin:       @"pubsub.pubnub.com"
                       ]; 
    }
    
    return _pubnub;
}

-(void)awakeFromNib
{
   
}

- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveDictionary:(NSDictionary *)response onChannel:(NSString *)channel
{
    
    if(self.settings.machineName)
    {
        if(![[response allKeys]containsObject:@"MachineName"])
        {
            //message doesn't contain a MachineName - so ignore it
            NSLog(@"Message recevied without a required MachineName");
            return;
        }
        
        if(![self.settings.machineName isEqualToString:[response objectForKey:@"MachineName"]])
        {
            //message not from the monitored machine
            NSLog(@"Message recevied from a different machine");
            return;
        }
    }
    
    NSString* message = [NSString stringWithFormat:@"%@ %@ %@\n", [response objectForKey:@"DateTime"],[response objectForKey:@"Category"], [response objectForKey:@"Message"]];
    
    [self appendMessage:message andScroll:YES];
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

    [super dealloc];
}
- (void)viewDidUnload {
    [self setLogViewer:nil];
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (viewPushed) {
        viewPushed = NO;
    } else {
        // Here, you know that back button was pressed
        [self.pubnub unsubscribe:@"OPENSPAN_LOGS"];
    }   
}

- (IBAction)stateChange:(id)sender {
    UIButton* btn = sender;
    if(self.listening)
    {
        [self.pubnub unsubscribe:@"OPENSPAN_LOGS"];
        [btn setTitle:@"Start" forState:UIControlStateNormal];
        self.listening = NO;
    }else{
        [self.pubnub subscribe: @"OPENSPAN_LOGS" delegate:self];
        self.listening = YES;
        [btn setTitle:@"Stop" forState:UIControlStateNormal];
    }
}

- (IBAction)clear {
    self.logViewer.text = @"";
}

-(void)appendMessage:(NSString*)message andScroll:(BOOL)scroll
{
    self.logViewer.text = [self.logViewer.text stringByAppendingString:message];
    
    if(scroll)
    {
        [self.logViewer scrollRangeToVisible:NSMakeRange([self.logViewer.text length], 0)];
    }

}

@end

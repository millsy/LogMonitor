//
//  MSViewController.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 30/01/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CEPubnub.h"
#import "MSLogViewer.h"

@interface MSViewController : UIViewController <CEPubnubDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MSLogViewer* settings;
@property (nonatomic, retain, readonly) CEPubnub *pubnub;
@property (retain, nonatomic) IBOutlet UITableView *tableLogEntries;
@property (nonatomic, retain) NSMutableArray* logEntries;

- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveDictionary:(NSDictionary *)response onChannel:(NSString *)channel;
- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveArray:(NSArray *)response onChannel:(NSString *)channel;
- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveString:(NSString *)response onChannel:(NSString *)channel;
- (void)pubnub:(CEPubnub *)pubnub subscriptionDidFailWithResponse:(NSString *)response onChannel:(NSString *)channel;
- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveHistoryArray:(NSArray *)response onChannel:(NSString *)channel;
- (void)pubnub:(CEPubnub *)pubnub publishDidSucceedWithResponse:(NSString *)response onChannel:(NSString *)channel;
- (void)pubnub:(CEPubnub *)pubnub publishDidFailWithResponse:(NSString *)response onChannel:(NSString *)channel;
- (void)pubnub:(CEPubnub *)pubnub didReceiveTime:(NSString *)timestamp;

@property (retain, nonatomic) IBOutlet UITextView *logViewer;

- (IBAction)stateChange:(id)sender;
- (IBAction)clear;

@end

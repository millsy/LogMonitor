//
//  MSLoggerClientViewController.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 08/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSHeartbeatClient.h"

@interface MSLoggerClientViewController : UIViewController

@property (retain, nonatomic) MSHeartbeatClient* myHBClient;
@property (retain, nonatomic) IBOutlet UITableView *tableViewLoggerClients;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *buttonConnect;

@end

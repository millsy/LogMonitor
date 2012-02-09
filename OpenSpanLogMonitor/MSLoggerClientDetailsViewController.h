//
//  MSLoggerClientDetailsViewController.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 09/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLoggerClient.h"

@interface MSLoggerClientDetailsViewController : UITableViewController

@property (nonatomic, retain) MSLoggerClient* client;
@property (retain, nonatomic) IBOutlet UITableView *tableViewClientDetails;

@end

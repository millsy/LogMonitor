//
//  MSLogLevelViewController.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 30/01/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLogViewer.h"

@interface MSLogLevelViewController : UITableViewController

@property (nonatomic, retain) MSLogViewer *settings;

@property (retain, nonatomic) IBOutlet UITableView *logLevelTableView;

@end

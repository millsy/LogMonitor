//
//  MSLogEntryViewer.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 13/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLoggerClient.h"
#import "MSLogFilterViewController.h"

@interface MSLogEntryViewer : UITableViewController <MSLogFilterViewControllerDelegate>

@property (nonatomic, retain) MSLoggerClient* client;
@property (retain, nonatomic) IBOutlet UITableView *logEntriesView;

@property (strong, nonatomic) NSArray* logFilter;

@end

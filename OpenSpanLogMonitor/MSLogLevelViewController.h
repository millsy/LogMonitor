//
//  MSLogLevelViewController.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 30/01/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSLogLevelViewController : UITableViewController

//@property (nonatomic, retain) NSArray *logLevelsArray; 
@property (nonatomic, retain) NSArray *traceLevels;
@property (nonatomic, retain) NSMutableDictionary *customLevels;
@property (retain, nonatomic) IBOutlet UITableView *logLevelTableView;

@end

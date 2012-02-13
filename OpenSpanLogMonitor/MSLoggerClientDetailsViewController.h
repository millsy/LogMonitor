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

@property (retain, nonatomic) IBOutlet UILabel *userNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *domainNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *machineNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *heartbeatLabel;
@property (retain, nonatomic) IBOutlet UILabel *incomingLabel;
@property (retain, nonatomic) IBOutlet UILabel *outgoingLabel;
@property (retain, nonatomic) IBOutlet UILabel *statsLabel;
@property (retain, nonatomic) IBOutlet UILabel *keyLabel;
@property (retain, nonatomic) IBOutlet UILabel *windowsVersionLabel;
@property (retain, nonatomic) IBOutlet UILabel *netVersionLabel;
@property (retain, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *virtualMemoryLabel;
@property (retain, nonatomic) IBOutlet UILabel *privateMemoryLabel;
@property (retain, nonatomic) IBOutlet UILabel *physicalMemoryLabel;
@property (retain, nonatomic) IBOutlet UILabel *publicKeyLabel;
@property (retain, nonatomic) IBOutlet UITableViewCell *netVersionCell;
@property (retain, nonatomic) IBOutlet UITableViewCell *keyCell;
@property (retain, nonatomic) IBOutlet UILabel *runtimeVersionLabel;

@end

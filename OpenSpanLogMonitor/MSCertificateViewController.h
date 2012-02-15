//
//  MSCertificateViewController.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 15/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSCertificateViewController : UITableViewController
@property (retain, nonatomic) IBOutlet UITableView *certificateView;

- (IBAction)updateCredentials:(id)sender;

@end

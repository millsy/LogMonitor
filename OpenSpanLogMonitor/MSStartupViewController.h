//
//  MSStartupViewController.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 31/01/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLogViewer.h"

@protocol MSStartupViewControllerDelegate

@optional

- (void)didUpdateLogLevels:(NSMutableDictionary *)logLevels;

@end

@interface MSStartupViewController : UIViewController <MSStartupViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UITextField *machineName;
@property (retain, nonatomic) IBOutlet UITextField *machineKey;
@property (nonatomic, strong) MSLogViewer* settings;

-(NSMutableDictionary*)savedLogLevels;

@end

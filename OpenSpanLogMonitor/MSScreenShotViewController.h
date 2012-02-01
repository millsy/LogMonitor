//
//  MSScreenShotViewController.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 01/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSScreenShotViewController : UIViewController

-(void)showImageWithURL:(NSString*) url;

@property (retain, nonatomic) IBOutlet UIImageView *imageViewer;

@property (copy, nonatomic) NSArray* imageURLs;

@end

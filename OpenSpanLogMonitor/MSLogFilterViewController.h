//
//  MSLogFilterViewController.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 13/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSLogFilterViewControllerDelegate <NSObject>

-(NSSet*)availableFilters;

@optional
-(void)logFilterSaved:(NSArray*)filter;

@end

@interface MSLogFilterViewController : UIViewController 

@property (nonatomic, assign) id<MSLogFilterViewControllerDelegate> delegate;

- (IBAction)cancelClicked:(id)sender;
- (IBAction)saveClicked:(id)sender;

@end

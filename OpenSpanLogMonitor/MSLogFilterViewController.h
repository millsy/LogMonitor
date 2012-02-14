//
//  MSLogFilterViewController.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 13/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSLogFilterViewControllerDelegate <NSObject>

@optional
-(void)logFilterSaved:(NSMutableSet*)filter;

@end

@interface MSLogFilterViewController : UITableViewController 

@property (nonatomic, retain) NSMutableSet* filters;
@property (nonatomic, assign) id<MSLogFilterViewControllerDelegate> delegate;

- (IBAction)cancelClicked:(id)sender;
- (IBAction)saveClicked:(id)sender;
@property (retain, nonatomic) IBOutlet UITableView *logCategoriesView;

@end

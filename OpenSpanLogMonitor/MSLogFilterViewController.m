//
//  MSLogFilterViewController.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 13/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSLogFilterViewController.h"

@implementation MSLogFilterViewController
@synthesize logCategoriesView = _logCategoriesView;

@synthesize delegate = _delegate;
@synthesize filters = _filters;

- (IBAction)cancelClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveClicked:(id)sender {
    [self.delegate logFilterSaved:self.filters];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)setFilters:(NSMutableSet *)filters
{
    if(_filters)
    {
        [_filters release];
    }
    
    _filters = [filters mutableCopy];
}

-(void)viewDidAppear:(BOOL)animated
{
    int count = [self.logCategoriesView numberOfRowsInSection:0];
    for (int i = 0; i < count; i++) {
        UITableViewCell *cell = [self.logCategoriesView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if(cell)
        {
            if([self.filters containsObject:cell.textLabel.text]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell)
    {
        if(cell.accessoryType == UITableViewCellAccessoryNone)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.filters addObject:cell.textLabel.text];
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            if([self.filters containsObject:cell.textLabel.text]){
                [self.filters removeObject:cell.textLabel.text];
            }
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)dealloc
{
    [_logCategoriesView release];
    [_filters release];
}

- (void)viewDidUnload {
    [self setLogCategoriesView:nil];
    [super viewDidUnload];
}
@end

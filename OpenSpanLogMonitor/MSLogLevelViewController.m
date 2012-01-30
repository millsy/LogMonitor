//
//  MSLogLevelViewController.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 30/01/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSLogLevelViewController.h"

@implementation MSLogLevelViewController

@synthesize logLevelsArray = _logLevelsArray;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.logLevelsArray = [NSArray arrayWithObjects:@"Test", @"Test2", nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.logLevelsArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell"; 
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
    if (cell == nil) { 
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease]; 
    } 
    
    // Configure the cell. 
    cell.textLabel.text = [self.logLevelsArray objectAtIndex:indexPath.row]; 
    return cell;
}

@end

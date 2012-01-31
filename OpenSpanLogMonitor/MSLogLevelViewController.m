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
@synthesize traceLevels = _traceLevels;
@synthesize logLevelTableView = _logLevelTableView;
@synthesize customLevels = _customLevels;

-(void)setCustomLevels:(NSMutableDictionary *)customLevels
{
    _customLevels = customLevels;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.logLevelsArray = [NSArray arrayWithObjects:@"Default", @"Keys", nil];
    self.traceLevels = [NSArray arrayWithObjects:@"Off", @"Error", @"Warning", @"Info", @"Verbose", nil];
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
    
    UIStepper* stepper = [[[UIStepper alloc]initWithFrame:CGRectMake(10.0, 5.0, 220.0, 15.0)]autorelease];
    [stepper setMaximumValue:4];
    [stepper setMinimumValue:0];
    [stepper setStepValue:1];
    [stepper addTarget:self action:@selector(stepperPressed:) forControlEvents:UIControlEventValueChanged];

    CGFloat width = 100;
    
    UILabel* nameLabel = [[[UILabel alloc]initWithFrame:CGRectMake(stepper.bounds.size.width + 40, 0, width, cell.bounds.size.height)]autorelease];
    nameLabel.text = [self.logLevelsArray objectAtIndex:indexPath.row]; 
    
    UILabel* valueLabel = [[[UILabel alloc]initWithFrame:CGRectMake(stepper.bounds.size.width + 40+ nameLabel.bounds.size.width + 40, 0, width, cell.bounds.size.height)]autorelease];
    NSNumber* level = [self.customLevels objectForKey:nameLabel.text];
    
    [stepper setValue:[level intValue]];
    
    valueLabel.text = [self.traceLevels objectAtIndex:[level integerValue]];
    valueLabel.contentMode = UIViewContentModeRedraw;
    valueLabel.tag = 1;
    // Configure the cell. 

    [cell.contentView addSubview:stepper];
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:valueLabel];
    
    return cell;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{

}

- (void)stepperPressed:(UIStepper*)sender
{      
    UITableViewCell *cell = (UITableViewCell *) [[sender superview]superview];    
    NSIndexPath *indexPath = [self.logLevelTableView indexPathForCell:cell];
    UIStepper* stepper = sender;
    NSString* text = [self.logLevelsArray objectAtIndex:indexPath.row];
    NSNumber* value = [NSNumber numberWithDouble:[stepper value]];
    [self.customLevels setValue:value forKey:text];
    UILabel* valueLabel = (UILabel *)[cell.contentView viewWithTag:1];
    valueLabel.text = [self.traceLevels objectAtIndex:[value integerValue]];
}

- (void)dealloc {
    [_logLevelTableView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [[self customLevels]release];
    [self setLogLevelTableView:nil];
    [super viewDidUnload];
}
@end

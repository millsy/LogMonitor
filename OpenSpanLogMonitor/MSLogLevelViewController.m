//
//  MSLogLevelViewController.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 30/01/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSLogLevelViewController.h"

@implementation MSLogLevelViewController

@synthesize logLevelTableView = _logLevelTableView;
@synthesize logLevels = _logLevels;
@synthesize delegate = _delegate;

static BOOL edited = NO;

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.logLevels)
        return [self.logLevels count];
    
    return 0;
}

-(void)setLogLevels:(NSMutableDictionary *)logLevels
{
    if(_logLevels)
    {
        [_logLevels release];
    }
    
    _logLevels = [logLevels mutableCopy];
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

    CGFloat width = 200;
    
    UILabel* nameLabel = [[[UILabel alloc]initWithFrame:CGRectMake(stepper.bounds.size.width + 40, 0, width, cell.bounds.size.height)]autorelease];
    
    NSString* key = [[self.logLevels allKeys] objectAtIndex:indexPath.row];    
    nameLabel.text = key;
    
    UILabel* valueLabel = [[[UILabel alloc]initWithFrame:CGRectMake(stepper.bounds.size.width + 40+ nameLabel.bounds.size.width + 40, 0, width, cell.bounds.size.height)]autorelease];
    NSNumber* level = [self.logLevels objectForKey:nameLabel.text];
    
    [stepper setValue:[level intValue]];
    
    valueLabel.text = [[MSLogViewer traceLevels] objectAtIndex:[level integerValue]];
    valueLabel.contentMode = UIViewContentModeRedraw;
    valueLabel.tag = 1;
    // Configure the cell. 

    [cell.contentView addSubview:stepper];
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:valueLabel];
    
    return cell;
}

- (IBAction)saveLogLevels:(id)sender {
    [self.delegate didUpdateLogLevels:self.logLevels];
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)stepperPressed:(UIStepper*)sender
{      
    UITableViewCell *cell = (UITableViewCell *) [[sender superview]superview];    
    NSIndexPath *indexPath = [self.logLevelTableView indexPathForCell:cell];
    UIStepper* stepper = sender;
    NSString* text = [[self.logLevels allKeys] objectAtIndex:indexPath.row];
    NSNumber* value = [NSNumber numberWithDouble:[stepper value]];
    [self.logLevels setValue:value forKey:text];
    UILabel* valueLabel = (UILabel *)[cell.contentView viewWithTag:1];
    valueLabel.text = [[MSLogViewer traceLevels] objectAtIndex:[value integerValue]];
    
    edited = YES;
}

- (void)dealloc {
    [_logLevelTableView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setLogLevelTableView:nil];
    [super viewDidUnload];
}
@end

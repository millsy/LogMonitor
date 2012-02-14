//
//  MSLogEntryViewer.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 13/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSLogEntryViewer.h"
#import "MSLogEntry.h"

@implementation MSLogEntryViewer

@synthesize client = _client;
@synthesize logEntriesView = _logEntriesView;
@synthesize logFilter = _logFilter;

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.client.logEntries count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"logEntry"; 
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
    
    if(!cell)
        return nil;
    
    MSLogEntry* entry = [self.client.logEntries objectAtIndex:indexPath.row];
    cell.textLabel.text = entry.category;    
    cell.detailTextLabel.text = entry.logMessage;
    
    return cell;
}

-(void)newLogEntry:(NSNotification*)notification
{
    [self.logEntriesView reloadData];
    [self.logEntriesView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.client.logEntries count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(NSMutableSet*)logFilter
{
    if(!_logFilter){
        _logFilter = [[NSMutableSet alloc]init];
    }
    return _logFilter;
}

-(void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newLogEntry:) name:NC_NEW_LOG_ENTRY object:nil];
}

-(void)dealloc
{
    [_logEntriesView release];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self setLogEntriesView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"showLogFilter"])
    {
        MSLogFilterViewController* vc = (MSLogFilterViewController*) [((UINavigationController*)[segue destinationViewController])topViewController];
        vc.filters = self.logFilter;
        vc.delegate = self;
    }
}

-(void)logFilterSaved:(NSMutableSet *)filter
{
    self.logFilter = filter;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end

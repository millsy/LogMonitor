//
//  MSLoggerClientViewController.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 08/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSLoggerClientViewController.h"
#import "MSHeartbeatClient.h"
#import "MSLoggerClientDetailsViewController.h"
#import "MSLogEntryViewer.h"

@interface MSLoggerClientViewController()
{
    MSHeartbeatClient* myHBClient;
}
@end

@implementation MSLoggerClientViewController
@synthesize tableViewLoggerClients;
@synthesize buttonConnect;

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [self.logEntries count];
    return [myHBClient.clients count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"logEntryCell1"; 
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 

    if(!cell)
        return nil;
    
    MSLoggerClient* client = [myHBClient.clients objectAtIndex:indexPath.row];
    
    cell.textLabel.text = client.machineName;    
    cell.detailTextLabel.text = client.userName;
    
    return cell;
}

- (IBAction)connectToLoggerClient:(id)sender {
}

-(void)viewDidLoad
{
    //register for client change notifcations
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newClientNotification:) name:NC_CLIENTS_UPDATED object:nil];
    
    myHBClient = [[MSHeartbeatClient alloc]init];
    
    [super viewDidLoad];
}

-(void)newClientNotification:(NSNotification*)notification
{
    if([[notification name] isEqualToString:NC_CLIENTS_UPDATED])
    {
        //interesting
        [tableViewLoggerClients reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![buttonConnect isEnabled])
    {
        [buttonConnect setEnabled:YES];
    }
}

-(void)tableView:(UITableView*)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableViewLoggerClients indexPathForSelectedRow])
    {
        if(![buttonConnect isEnabled])
        {
            [buttonConnect setEnabled:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"AccessoryButton tapped %u", indexPath.row);
    [self performSegueWithIdentifier:@"loggerClientDetails" sender:[[myHBClient clients]objectAtIndex:indexPath.row]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"loggerClientDetails"]){        
        MSLoggerClientDetailsViewController* newController = [segue destinationViewController];
        [newController setClient:sender];
    }else if([[segue identifier] isEqualToString:@"loggerEntryViewer"]){
        MSLogEntryViewer* newController = [segue destinationViewController];
        MSLoggerClient* client = [[myHBClient clients]objectAtIndex:[[tableViewLoggerClients indexPathForSelectedRow] row]];
        [newController setClient:client];
    }
}

-(void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [myHBClient release];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end

//
//  MSViewController.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 30/01/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSViewController.h"
#import "MSLogLevelViewController.h"
#import "MSLogEntry.h"

@interface MSViewController()

@property (nonatomic) BOOL listening;


-(void)appendMessage:(NSString*)message andScroll:(BOOL)scroll;

@end

@implementation MSViewController 

@synthesize logViewer = _logViewer;
@synthesize pubnub = _pubnub;
@synthesize tableLogEntries = _tableLogEntries;
@synthesize logEntries = _logEntries;
@synthesize listening = _listening;
@synthesize settings = _settings;

BOOL viewPushed = NO;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showScreenshot"])
    {
        [segue.destinationViewController setImageURLs:self.settings.images];
    }
}

-(NSMutableArray*)logEntries{
    if(!_logEntries)
    {
        _logEntries = [[NSMutableArray alloc]init];
    }
    return _logEntries;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.logEntries count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"logEntryCell1"; 
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
    if (cell == nil) { 
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease]; 
        
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
    } 
    
    MSLogEntry* entry = [self.logEntries objectAtIndex:indexPath.row];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yy HH:mm:ss.SSS"];
    NSString* formattedDate = [df stringFromDate:entry.logDate];
    
    NSString* message = [NSString stringWithFormat:@"%@ %@ %@\n", formattedDate,@"", entry.logMessage];
    
    cell.textLabel.text = message;
    
    return cell;
}

-(CEPubnub*)pubnub
{
    if(!_pubnub)
    {
        _pubnub = [[CEPubnub alloc]
                       publishKey:   self.settings.publishKey
                       subscribeKey: self.settings.subscribeKey 
                       secretKey:    @""//@"sec-649a5039-cb8d-40eb-beec-21b9c07aec64" 
                       sslOn:        YES
                       origin:       @"pubsub.pubnub.com"
                       ]; 
    }
    
    return _pubnub;
}

-(void)awakeFromNib
{
    
}

- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveDictionary:(NSDictionary *)response onChannel:(NSString *)channel
{
    
    if(self.settings.machineName)
    {
        if(![[response allKeys]containsObject:@"MachineName"])
        {
            //message doesn't contain a MachineName - so ignore it
            NSLog(@"Message recevied without a required MachineName");
            return;
        }
        
        if(![self.settings.machineName isEqualToString:[response objectForKey:@"MachineName"]])
        {
            //message not from the monitored machine
            NSLog(@"Message recevied from a different machine");
            return;
        }
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSDate *myDate = [df dateFromString: [response objectForKey:@"DateTime"]];
    
    NSString* message = [response objectForKey:@"Message"];
    
    MSLogEntry* logEntry = [[[MSLogEntry alloc]init]autorelease];
    //logEntry.logMessage = message;
    //logEntry.logDate = myDate;
    
    [self.logEntries addObject:logEntry];
    
    self.logEntries = [[self.logEntries sortedArrayUsingComparator:^(id a, id b) {
        MSLogEntry* first = (MSLogEntry*) a;
        MSLogEntry* second = (MSLogEntry*) b;
        return [first.logDate compare:second.logDate];
    }] mutableCopy];
    
    [self.tableLogEntries reloadData];
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.logEntries count] - 1) inSection:0];
    [self.tableLogEntries scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    //[self appendMessage:message andScroll:YES];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


- (void)dealloc {

    [_tableLogEntries release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLogViewer:nil];
    [self setTableLogEntries:nil];

    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (viewPushed) {
        viewPushed = NO;
    } else {
        // Here, you know that back button was pressed
        [self.pubnub unsubscribe:@"OPENSPAN_LOGS"];
    }   
}

- (IBAction)stateChange:(id)sender {
    if(self.listening)
    {
        [self.pubnub unsubscribe:@"OPENSPAN_LOGS"];
        [sender setTitle:@"Start"];
        self.listening = NO;
    }else{
        [self.pubnub subscribe: @"OPENSPAN_LOGS" delegate:self];
        self.listening = YES;
        [sender setTitle:@"Stop"];
    }
}
- (IBAction)screenShot:(id)sender {
    [self.settings requestScreenShot];
}

- (IBAction)clear {
    self.logViewer.text = @"";
}

-(void)appendMessage:(NSString*)message andScroll:(BOOL)scroll
{
    self.logViewer.text = [self.logViewer.text stringByAppendingString:message];
    
    if(scroll)
    {
        [self.logViewer scrollRangeToVisible:NSMakeRange([self.logViewer.text length], 0)];
    }

}

@end

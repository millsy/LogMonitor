//
//  MSLoggerClientDetailsViewController.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 09/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSLoggerClientDetailsViewController.h"
#import "MSLoggerClient.h"

@implementation MSLoggerClientDetailsViewController

@synthesize client = _client;
@synthesize tableViewClientDetails = _tableViewClientDetails;

-(void)viewDidLoad
{
    if(self.client)
    {
        [self.client addObserver:self forKeyPath:@"lastSeen" options:NSKeyValueObservingOptionNew context:nil];
    }
}

-(void)viewWillUnload
{
    if(self.client)
    {
        [self.client removeObserver:self forKeyPath:@"lastSeen"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //NSLog(@"Value changed");
    [self.tableViewClientDetails reloadData];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.client){
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loggerClientDetailsCell"];
        
        if(!cell){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"loggerClientDetailsCell"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (cell) {
            NSString* details = nil;
            NSString* title = nil;
            
            if(indexPath.section == 0)
            {
                //Client details
                if(indexPath.row == 0){
                    //username
                    title = @"User Name";
                    details = self.client.userName;
                }else if(indexPath.row == 1){
                    //machineName
                    title = @"Machine Name";
                    details = self.client.machineName;
                }else if(indexPath.row == 2){
                    //lastHeartbeat
                    title = @"Last Heartbeat";
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    [df setDateFormat:@"dd-MM-yy HH:mm:ss"];
                    
                    details = [df stringFromDate:self.client.lastSeen];
                }
            }else if(indexPath.section == 1){
                //Client details
                if(indexPath.row == 0){
                    //incoming queue
                    title = @"Incoming Queue";
                    details = self.client.receiverChannel;
                }else if(indexPath.row == 1){
                    //outgoing queue
                    title = @"Outgoing Queue";
                    details = self.client.senderChannel;
                }
            }else if(indexPath.section == 2){
                //Encryption details
                if(indexPath.row == 0){
                    //encrypted key
                    title = @"Encrypted Key";
                    details = self.client.encryptedKey;
                    
                    cell.textLabel.lineBreakMode = UILineBreakModeCharacterWrap;
                    cell.detailTextLabel.lineBreakMode = UILineBreakModeCharacterWrap;
                    cell.textLabel.numberOfLines = 5;
                    cell.detailTextLabel.numberOfLines = 5; 
                }
            }
            
            cell.textLabel.text = title;
            cell.detailTextLabel.text = details;
            
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2 && indexPath.row == 0)
    {   
        CGSize size = [self.client.encryptedKey sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake(115,140) lineBreakMode:UILineBreakModeCharacterWrap];
        
        return size.height;
    }else{
        return 45;
    }
}

- (void)dealloc {
    [_tableViewClientDetails release];
    
    if(self.client)
    {
        [self.client removeObserver:self forKeyPath:@"lastSeen"];
        [self.client release];
    }
    
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableViewClientDetails:nil];
    [super viewDidUnload];
}
@end
//
//  MSCertificateViewController.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 15/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSCertificateViewController.h"
#import "MSAmazonS3.h"
#import "MSLoggerClientViewController.h"
#import "MSHeartbeatClient.h"

@interface MSCertificateViewController()

@property (retain, nonatomic) NSArray* certificates;

@end

@implementation MSCertificateViewController
@synthesize certificateView = _certificateView;

@synthesize certificates = _certificates;

-(void)awakeFromNib{
    self.certificates = [MSAmazonS3 getAvailableKeys];
}

-(void)viewWillAppear:(BOOL)animated
{
   
    NSLog(@"Certs = %@", self.certificates);
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.certificates count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"certificateCell"; 
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
    
    if(!cell)
        return nil;

    cell.textLabel.text = [self.certificates objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"Certificate password" message:nil  delegate:self  cancelButtonTitle:@"Cancel"  otherButtonTitles:@"Connect", nil];
    
    prompt.alertViewStyle = UIAlertViewStyleSecureTextInput;
    
    [prompt show];    
    [prompt release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSString* passwordValue = [[alertView textFieldAtIndex:0]text];
        [self performSegueWithIdentifier:@"showClients" sender:passwordValue];
    }else{
        //deselect row here
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"showClients"])
    {
        if(sender){
            
            NSString* key = [[[self.certificateView cellForRowAtIndexPath:[self.certificateView indexPathForSelectedRow]] textLabel]text];
            NSURL* url = [MSAmazonS3 getSignedURLForKey:key];
            MSLoggerClientViewController* vc = [segue destinationViewController];
            vc.myHBClient = [[MSHeartbeatClient alloc]initWithURL:url password:sender];            
        }
    }
}

- (void)dealloc {
    [_certificateView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCertificateView:nil];
    [super viewDidUnload];
}
@end

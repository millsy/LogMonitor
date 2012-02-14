//
//  MSLoggerClientDetailsViewController.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 09/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSLoggerClientDetailsViewController.h"
#import "MSLoggerClient.h"
#import "MSCommonDate.h"

@implementation MSLoggerClientDetailsViewController

@synthesize client = _client;

@synthesize tableViewClientDetails = _tableViewClientDetails;
@synthesize userNameLabel = _userNameLabel;
@synthesize domainNameLabel = _domainNameLabel;
@synthesize machineNameLabel = _machineNameLabel;
@synthesize companyNameLabel = _companyNameLabel;
@synthesize heartbeatLabel = _heartbeatLabel;
@synthesize incomingLabel = _incomingLabel;
@synthesize outgoingLabel = _outgoingLabel;
@synthesize statsLabel = _statsLabel;
@synthesize keyLabel = _keyLabel;
@synthesize windowsVersionLabel = _windowsVersionLabel;
@synthesize netVersionLabel = _netVersionLabel;
@synthesize startTimeLabel = _startTimeLabel;
@synthesize virtualMemoryLabel = _virtualMemoryLabel;
@synthesize privateMemoryLabel = _privateMemoryLabel;
@synthesize physicalMemoryLabel = _physicalMemoryLabel;
@synthesize netVersionCell = _netVersionCell;
@synthesize keyCell = _keyCell;
@synthesize runtimeVersionLabel = _runtimeVersionLabel;
@synthesize publicKeyLabel = _publicKeyLabel;

-(void)viewWillAppear:(BOOL)animated
{
    self.userNameLabel.text = self.client.userName;
    self.domainNameLabel.text = self.client.domainName;
    self.machineNameLabel.text = self.client.machineName;
    self.companyNameLabel.text = self.client.companyName;
    self.heartbeatLabel.text = [MSCommonDate date:self.client.lastSeen ToStringFormat:nil];
    self.incomingLabel.text = self.client.receiverChannel;
    self.outgoingLabel.text = self.client.senderChannel;
    self.statsLabel.text = self.client.statsChannel;
    self.keyLabel.text = self.client.encryptedKey;
    self.publicKeyLabel.text = self.client.publicKeyURL;
    self.windowsVersionLabel.text = self.client.runtimeInfo.windowsVersion;
    self.netVersionLabel.text = [self.client.runtimeInfo stringOfNetVersions];
    self.startTimeLabel.text = [MSCommonDate date:self.client.runtimeInfo.startTime ToStringFormat:nil];
    self.virtualMemoryLabel.text = [NSString stringWithFormat:@"%d bytes", self.client.runtimeInfo.virtualMemorySize];
    self.physicalMemoryLabel.text = [NSString stringWithFormat:@"%d bytes", self.client.runtimeInfo.physicalMemorySize];
    self.privateMemoryLabel.text = [NSString stringWithFormat:@"%d bytes", self.client.runtimeInfo.privateMemorySize];
    self.runtimeVersionLabel.text = self.client.runtimeInfo.osVersion;
}


-(void)viewDidLoad
{
    if(self.client)
    {
        [self.client addObserver:self forKeyPath:@"lastSeen" options:NSKeyValueObservingOptionNew context:nil];
        [self.client.runtimeInfo addObserver:self forKeyPath:@"netVersions" options:NSKeyValueObservingOptionNew context:nil];
        [self.client.runtimeInfo addObserver:self forKeyPath:@"windowsVersion" options:NSKeyValueObservingOptionNew context:nil];
        [self.client.runtimeInfo addObserver:self forKeyPath:@"virtualMemorySize" options:NSKeyValueObservingOptionNew context:nil];
        [self.client.runtimeInfo addObserver:self forKeyPath:@"physicalMemorySize" options:NSKeyValueObservingOptionNew context:nil];
        [self.client.runtimeInfo addObserver:self forKeyPath:@"privateMemorySize" options:NSKeyValueObservingOptionNew context:nil];
        
    }
}

-(void)viewWillUnload
{
    if(self.client)
    {
        [self.client removeObserver:self forKeyPath:@"lastSeen"];
        [self.client.runtimeInfo removeObserver:self forKeyPath:@"netVersions"];
        [self.client.runtimeInfo removeObserver:self forKeyPath:@"windowsVersion"];
        [self.client.runtimeInfo removeObserver:self forKeyPath:@"virtualMemorySize"];
        [self.client.runtimeInfo removeObserver:self forKeyPath:@"physicalMemorySize"];
        [self.client.runtimeInfo removeObserver:self forKeyPath:@"privateMemorySize"];//
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"lastSeen"])
    {
        self.heartbeatLabel.text = [MSCommonDate date:self.client.lastSeen ToStringFormat:nil];
    }else if([keyPath isEqualToString:@"netVersions"]){
        self.netVersionLabel.text = [self.client.runtimeInfo stringOfNetVersions];
        //[self.tableViewClientDetails reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:3]] withRowAnimation:NO];
    }else if([keyPath isEqualToString:@"windowsVersion"]){
        self.windowsVersionLabel.text = self.client.runtimeInfo.windowsVersion;
    }else if([keyPath isEqualToString:@"virtualMemorySize"]){
        self.virtualMemoryLabel.text = [NSString stringWithFormat:@"%d bytes", self.client.runtimeInfo.virtualMemorySize];
    }else if([keyPath isEqualToString:@"physicalMemorySize"]){
        self.physicalMemoryLabel.text = [NSString stringWithFormat:@"%d bytes", self.client.runtimeInfo.physicalMemorySize];
    }else if([keyPath isEqualToString:@"privateMemorySize"]){
        self.privateMemoryLabel.text = [NSString stringWithFormat:@"%d bytes", self.client.runtimeInfo.privateMemorySize];
    }
}

 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 2 && indexPath.row == 0)
    {   
        CGSize size = [self.client.encryptedKey sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake(400,9999) lineBreakMode:UILineBreakModeCharacterWrap];
        if(size.height > 44)
        {      
            return size.height;
        }
    }
    else if(indexPath.section == 3 && indexPath.row == 2 && self.client.runtimeInfo)
    {   
        CGSize size = [[self.client.runtimeInfo stringOfNetVersions] sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake(400,9999) lineBreakMode:UILineBreakModeWordWrap];
        if(size.height > 44)
        {
            return size.height;
        }
    }
    
    return 44.0f;
}
 
- (void)dealloc {
    
    if(self.client)
    {
        [self.client removeObserver:self forKeyPath:@"lastSeen"];
        [self.client.runtimeInfo removeObserver:self forKeyPath:@"netVersions"];
        [self.client.runtimeInfo removeObserver:self forKeyPath:@"windowsVersion"];
        [self.client.runtimeInfo removeObserver:self forKeyPath:@"virtualMemorySize"];
        [self.client.runtimeInfo removeObserver:self forKeyPath:@"physicalMemorySize"];
        [self.client.runtimeInfo removeObserver:self forKeyPath:@"privateMemorySize"];
        [self.client release];
    }
    
    [_userNameLabel release];
    [_domainNameLabel release];
    [_machineNameLabel release];
    [_companyNameLabel release];
    [_heartbeatLabel release];
    [_incomingLabel release];
    [_outgoingLabel release];
    [_statsLabel release];
    [_keyLabel release];
    [_windowsVersionLabel release];
    [_netVersionLabel release];
    [_startTimeLabel release];
    [_virtualMemoryLabel release];
    [_privateMemoryLabel release];
    [_physicalMemoryLabel release];
    [_tableViewClientDetails release];
    
    [_netVersionCell release];
    [_keyCell release];
    [_publicKeyLabel release];
    [_runtimeVersionLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableViewClientDetails:nil];
    [self setUserNameLabel:nil];
    [self setDomainNameLabel:nil];
    [self setMachineNameLabel:nil];
    [self setCompanyNameLabel:nil];
    [self setHeartbeatLabel:nil];
    [self setIncomingLabel:nil];
    [self setOutgoingLabel:nil];
    [self setStatsLabel:nil];
    [self setKeyLabel:nil];
    [self setWindowsVersionLabel:nil];
    [self setNetVersionLabel:nil];
    [self setStartTimeLabel:nil];
    [self setVirtualMemoryLabel:nil];
    [self setPrivateMemoryLabel:nil];
    [self setPhysicalMemoryLabel:nil];
    [self setNetVersionCell:nil];
    [self setKeyCell:nil];
    [self setPublicKeyLabel:nil];
    [self setRuntimeVersionLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
@end

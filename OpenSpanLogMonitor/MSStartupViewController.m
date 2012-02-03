//
//  MSStartupViewController.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 31/01/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSStartupViewController.h"
#import "MSViewController.h"
#import "MSLogLevelViewController.h"

@implementation MSStartupViewController 

@synthesize machineName = _machineName;
@synthesize machineKey = _machineKey;
@synthesize settings = _settings;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

-(MSLogViewer*)settings
{
    if(!_settings)
    {
        _settings = [[[MSLogViewer alloc]initWithMachineName:self.machineName.text logLevels:[self savedLogLevels] machineKey:self.machineKey.text]autorelease];
    }
    return _settings;
}

-(NSMutableDictionary*)savedLogLevels
{
    //check if we have stored prefs
    if ([[NSUserDefaults standardUserDefaults] dictionaryForKey:@"logLevels"]) {
        return [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"logLevels"]mutableCopy];
    }
    return nil;
}

- (void)dealloc {
    [_machineName release];
    [_machineKey release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMachineName:nil];
    [self setMachineKey:nil];
    [super viewDidUnload];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showLog"])
    {
        [(MSViewController*)segue.destinationViewController setSettings:self.settings];
    }
    else if([segue.identifier isEqualToString:@"displayLogLevels"])
    {
        MSLogLevelViewController* logVC = (MSLogLevelViewController*)segue.destinationViewController;
        logVC.delegate = self;
        [logVC setLogLevels:self.settings.logLevels];
    }
}

- (IBAction)validateInputValues:(UIButton*)sender {
    if([self.machineName.text length] > 0)
    {
        self.settings.machineName = self.machineName.text;
        self.settings.key = self.machineKey.text;
        
        if([sender.titleLabel.text isEqualToString:@"Log Levels"])
        {
            [self performSegueWithIdentifier:@"displayLogLevels" sender:self];
        }else{
            [self performSegueWithIdentifier:@"showLog" sender:self];
        }
    }
}

-(void)viewDidLoad{
    [NSThread sleepForTimeInterval:3];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)didUpdateLogLevels:(NSMutableDictionary *)logLevels
{
    [self.settings setLogLevels:logLevels];
    [self.settings sendLogLevels];
}

@end

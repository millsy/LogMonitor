//
//  MSStartupViewController.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 31/01/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSStartupViewController.h"
#import "MSViewController.h"
#import "MSLogViewer.h"

@implementation MSStartupViewController

@synthesize machineName = _machineName;
@synthesize machineKey = _machineKey;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
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
        MSLogViewer* logSettings = [[[MSLogViewer alloc]initWithMachineName:self.machineName.text logLevels:[self savedLogLevels] machineKey:self.machineKey.text]autorelease];
        [(MSViewController*)segue.destinationViewController setSettings:logSettings];
    }
}

@end

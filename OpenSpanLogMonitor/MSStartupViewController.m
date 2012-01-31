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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)dealloc {
    [_machineName release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMachineName:nil];
    [super viewDidUnload];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showLog"])
    {
        MSLogViewer* logSettings = [[[MSLogViewer alloc]initWithMachineName:self.machineName.text]autorelease];
        [(MSViewController*)segue.destinationViewController setSettings:logSettings];
    }
}

@end

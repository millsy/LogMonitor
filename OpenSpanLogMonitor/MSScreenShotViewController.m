//
//  MSScreenShotViewController.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 01/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSScreenShotViewController.h"

@interface MSScreenShotViewController()

-(void)loadImageWithURL:(NSString*)url;

@property (nonatomic, assign) int index;

@end

@implementation MSScreenShotViewController
@synthesize imageViewer;
@synthesize imageURLs = _imageURLs;
@synthesize index;

-(void)viewWillAppear:(BOOL)animated
{
    if(self.imageURLs && [self.imageURLs count] > 0)
    {
        [self showImageWithURL:[self.imageURLs objectAtIndex:index]];
    }
}
- (IBAction)previousImage:(id)sender {
    if(self.imageURLs && [self.imageURLs count] > 0 && self.index > 0)
    {
        self.index -= 1;
        [self showImageWithURL:[self.imageURLs objectAtIndex:index]];
    }
}
- (IBAction)nextImage:(id)sender {
    if(self.imageURLs && [self.imageURLs count] > 0 && self.index +1 < [self.imageURLs count])
    {
        self.index += 1;
        [self showImageWithURL:[self.imageURLs objectAtIndex:index]];
    }
}

-(void)showImageWithURL:(NSString*) url{
    
    [self performSelectorInBackground:@selector(loadImageWithURL:) withObject:url];
}

-(void)loadImageWithURL:(NSString*)url
{
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    [imageViewer setImage:image];
}


- (void)dealloc {
    [imageViewer release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setImageViewer:nil];
    [super viewDidUnload];
}
@end

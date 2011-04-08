//
//  FullScreenViewController.m
//  GithubBrowser
//
//  Created by Oscar Del Ben on 4/7/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import "FullScreenViewController.h"


@implementation FullScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    UIBarButtonItem *fullScreenItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"full_screen"] style:UIBarButtonItemStylePlain target:self action:@selector(showFullScreen)];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                               target:nil
                               action:nil];
    
    // TODO: disable when no view is loaded
    self.toolbar.items = [NSArray arrayWithObjects:spacer, fullScreenItem, nil];
    
    [fullScreenItem release];
    [spacer release];
     */
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissController:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    [doneButton release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)dismissController:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end

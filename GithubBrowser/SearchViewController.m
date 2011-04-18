//
//  SearchViewController.m
//  GithubBrowser
//
//  Created by Oscar Del Ben on 4/14/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import "SearchViewController.h"


@implementation SearchViewController

@synthesize usernameTextField;


- (void)dealloc
{
    [usernameTextField release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    [cancelButton release];
    [saveButton release];
}

- (void)viewDidUnload
{
    self.usernameTextField = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)cancel
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)save
{
    // TODO: if username is blank..
    [ApplicationHelper setCurrentUsername:usernameTextField.text notifyOfChange:YES];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end

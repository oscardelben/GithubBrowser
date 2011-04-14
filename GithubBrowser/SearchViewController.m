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

- (IBAction)save:(id)sender
{
    // TODO: if username is blank..
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:usernameTextField.text forKey:GBGithubCurrentUsername];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    NSNotification *notification = [NSNotification notificationWithName:GBCredentialsChanged object:nil];
    [notificationCenter postNotification:notification];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end

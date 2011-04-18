//
//  SettingsViewController.m
//  GithubBrowser
//
//  Created by Oscar Del Ben on 4/9/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import "SettingsViewController.h"
#import "DetailViewController.h"
#import "Constants.h"

@implementation SettingsViewController

@synthesize usernameTextField, passwordTextField;

- (void)dealloc
{
    [usernameTextField release];
    [passwordTextField release];
    [super dealloc];
}


- (void)viewDidLoad
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    usernameTextField.text = [userDefaults valueForKey:GBGithubUsername];
    passwordTextField.text = [userDefaults valueForKey:GBGithubPassword];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    [cancelButton release];
    [saveButton release];
}

- (void)viewDidUnload
{
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)save {
    // TODO: disable save button if username or password is blank

    NSString *username = usernameTextField.text;
    NSString *password = passwordTextField.text;
    
    [ApplicationHelper saveCredentials:username password:password notifyOfChange:YES];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end

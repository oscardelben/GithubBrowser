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

- (IBAction)save:(id)sender {
    // TODO: disable save button if username or password is blank
    // TODO: check if login is valid
    NSString *username = usernameTextField.text;
    NSString *password = passwordTextField.text;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:username forKey:GBGithubUsername];
    [userDefaults setObject:password forKey:GBGithubPassword];

    NSNotification *notification = [NSNotification notificationWithName:GBCredentialsChanged object:nil];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotification:notification];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end

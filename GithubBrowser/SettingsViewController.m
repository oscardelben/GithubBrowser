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

@synthesize usernameTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [usernameTextField release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setUsernameTextField:nil];
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
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:username forKey:GBGithubUsername];

    NSNotification *notification = [NSNotification notificationWithName:GBCredentialsChanged object:nil];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotification:notification];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end

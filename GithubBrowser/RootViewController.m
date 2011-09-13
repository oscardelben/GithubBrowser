//
//  RootViewController.m
//  GithubBrowser
//
//  Created by Oscar Del Ben on 4/6/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import "RootViewController.h"

#import "DetailViewController.h"
#import "SearchViewController.h"
#import "SettingsViewController.h"
#import "ReposViewController.h"

@implementation RootViewController

@synthesize detailViewController;
@synthesize githubEngine;
@synthesize username;

- (void)fetchUsername
{
    self.githubEngine = [[UAGithubEngine alloc] initWithUsername:nil password:nil delegate:self withReachability:NO];
    self.username = [ApplicationHelper currentUsername];
    
    if (!username || [username blank]) {
        return;
    }
    
    NSString *password = [ApplicationHelper password];
    
    self.githubEngine.username = username;
    self.githubEngine.password = password;
    
    self.navigationItem.title = username;
}

- (void)viewDidLoad
{
    // TODO: add activity indicator
    
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    
    [detailViewController loadUserPage];
    
    [self fetchUsername];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self.tableView selector:@selector(reloadData) name:GBCredentialsChanged object:nil];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    		
}

		
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Username
    // Organizations
    // Add Account
    
    return (!username || [username blank]) ? 1 :2;    		
}

		
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    }

    // Configure the cell.
    
    if (!username || [username blank])
    {
        cell.textLabel.text = @"Add Account";
    }
    else
    {        
        if (indexPath.row == 0) 
        {
            cell.textLabel.text = username;
        }
        else
        {
            cell.textLabel.text = @"Manage Account";
        }
    }
      
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (!username || [username blank])
    {
        [self showSettings];
    }
    else
    {
        
        if (indexPath.row == 0) 
        {
            ReposViewController *reposViewController = [[[ReposViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
            reposViewController.detailViewController = self.detailViewController;
            [self.navigationController pushViewController:reposViewController animated:YES];
        }
        else
        {
            [self showSettings];
        }
    }
}

- (void)dealloc
{
    [detailViewController release];
    [githubEngine release];
    [username release];
     
    [super dealloc];
}

#pragma mark Utility methods

- (void)showSettings
{
    SettingsViewController *viewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentModalViewController:navController animated:YES];
    
    [viewController release];
}

@end

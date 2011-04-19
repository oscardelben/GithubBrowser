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

@implementation RootViewController
		
@synthesize detailViewController;

@synthesize githubEngine;
@synthesize repos;

@synthesize activityIndicator;
@synthesize searchButton;
@synthesize currentPage;


-(void)configureButtons
{
    // navigation bar
    UIBarButtonItem *loadButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    self.navigationItem.leftBarButtonItem = loadButton;
    
    [loadButton release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // toolbar
    
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"53-house.png"] style:UIBarButtonItemStylePlain target:self.detailViewController action:@selector(showHome)];
    searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"06-magnify.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showSearchSheet)];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"19-gear.png"] style:UIBarButtonItemStylePlain target:self.detailViewController action:@selector(showSettings)];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolbarItems = [NSArray arrayWithObjects:homeButton, spacer, searchButton, spacer, settingsButton, nil];
    self.navigationController.toolbarHidden = NO;
    
    [homeButton release];
    [settingsButton release];
    [spacer release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(reloadRepos) name:GBCredentialsChanged object:nil];
    [notificationCenter addObserver:self selector:@selector(showLoadIndicator) name:GBShowLoadIndicator object:nil];
    [notificationCenter addObserver:self selector:@selector(hideLoadIndicator) name:GBHideLoadIndicator object:nil];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.hidesWhenStopped = YES;

    self.githubEngine = [[UAGithubEngine alloc] initWithUsername:nil password:nil delegate:self withReachability:NO];
    
    [self configureButtons];
    
    [self reloadRepos];
    
    // Todo: add pagination for repos
    // TODO: add error handling (no internet, error loading repos, etc)
}

- (void)viewDidUnload
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
    
    [super viewDidUnload];
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
    return [repos count];
    		
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
    NSDictionary *repo = [repos objectAtIndex:indexPath.row];

    cell.textLabel.text = [repo valueForKey:@"name"];
    cell.detailTextLabel.text = [repo valueForKey:@"description"];
    
    int private = [[repo valueForKey:@"private"] intValue];
    int fork = [[repo valueForKey:@"fork"] intValue];

    if (private == 1) 
    {
        if (fork == 1) 
        {
            cell.imageView.image = [UIImage imageNamed:@"private-fork.png"];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"private.png"];
        }
        
        // background color
        UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
        bg.backgroundColor = [UIColor colorWithRed:255/255.0 green:254/255.0 blue:235/255.0 alpha:1];
        cell.backgroundView = bg;
        [bg release];
    } 
    else
    {
        if (fork == 1) 
        {
            cell.imageView.image = [UIImage imageNamed:@"public-fork.png"];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"public.png"];
        }
        
        UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
        bg.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = bg;
        [bg release];
    }
    
    // TODO: try to change cell height
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSDictionary *currentRepo = [self.repos objectAtIndex:indexPath.row];

    detailViewController.detailItem = currentRepo;
}

- (void)dealloc
{
    [detailViewController release];
    [githubEngine release];
    [repos release];
    [activityIndicator release];
    [searchButton release];
    [super dealloc];
}

#pragma mark Utility methods

- (void)showSearchSheet
{
    NSArray *otherTitles = [NSArray arrayWithObjects:@"Search user", @"Random repo", nil];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (int i = 0; i < [otherTitles count]; i++) 
    {
        [actionSheet addButtonWithTitle:[otherTitles objectAtIndex:i]];
    }
    
    [actionSheet showFromBarButtonItem:self.searchButton animated:YES];
    
    [actionSheet release];
}

- (void)reloadRepos
{
    [self showLoadIndicator];
    
    NSString *username = [ApplicationHelper currentUsername];
    
    if (!username || [username blank]) {
        return;
    }
    
    NSString *password = [ApplicationHelper password];
    
    self.githubEngine.username = username;
    self.githubEngine.password = password;
    
    self.navigationItem.title = username;
    
    self.currentPage = 1;
    self.repos = [NSMutableArray array];

    [self.detailViewController loadUserPage];
    [self.githubEngine repositoriesForUser:githubEngine.username includeWatched:NO page:self.currentPage];
}

- (void)showLoadIndicator
{
    [self.activityIndicator startAnimating];
}

- (void)hideLoadIndicator
{
    [self.activityIndicator stopAnimating];
}

#pragma mark UAGithubEngineDelegate Methods

- (void)requestSucceeded:(NSString *)connectionIdentifier
{
	NSLog(@"Request succeeded: %@", connectionIdentifier);
}


- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error
{
    NSLog(@"Request failed: %@, error: %@ (%@)", connectionIdentifier, [error localizedDescription], [error userInfo]);	
}


#pragma mark Github api

#define MAX_PAGES 10

- (void)repositoriesReceived:(NSArray *)repositories forConnection:(NSString *)connectionIdentifier
{   
    [self.repos addObjectsFromArray:repositories];

    if ([repositories count] == 0 || self.currentPage > MAX_PAGES)
    {

        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"pushed_at" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];

        [self.repos sortUsingDescriptors:sortDescriptors];
                
        [self.tableView reloadData];
        
        [self hideLoadIndicator];
    } 
    else
    {
        self.currentPage += 1;
        [self.githubEngine repositoriesForUser:githubEngine.username includeWatched:NO page:self.currentPage];
    }
}

#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self.detailViewController showSearch];
            break;
            
        case 1:
            [self.detailViewController showRandomRepo];
            break;
    }
}

@end

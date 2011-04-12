//
//  RootViewController.m
//  GithubBrowser
//
//  Created by Oscar Del Ben on 4/6/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import "RootViewController.h"

#import "DetailViewController.h"
#import "NSString+DBExtensions.h"

@implementation RootViewController
		
@synthesize detailViewController;
@synthesize githubEngine;
@synthesize repos;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(reloadRepos) name:GBCredentialsChanged object:nil];
    
    [self reloadRepos];
    
    // Todo: differentiate forks
    // TODO: add errior handling (no internet, etc)
    // Todo: put a loding gif when loading
    // TODO: add error whehn internet connection is not available (use GithubEngine delegate method?)
    // Todo: test with hundreds of repos, perhaps use pagination?
    // TODO: if the user is logged out from github, it shows a 404 page when accessing a private repo
}

- (void)viewDidUnload
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
    
    [super viewDidUnload];
}

- (void)reloadRepos
{
    NSString *username = [ApplicationHelper currentUsername];
    
    if (!username || [username blank]) {
        return;
    }
    
    self.navigationItem.title = username;
    
    githubEngine = [[UAGithubEngine alloc] initWithUsername:username password:nil delegate:self withReachability:NO];
    
    [githubEngine repositoriesForUser:githubEngine.username includeWatched:NO];
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
    if (private == 1) 
    {
        cell.imageView.image = [UIImage imageNamed:@"private.png"];
        
        // background color
        UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
        bg.backgroundColor = [UIColor colorWithRed:255/255.0 green:254/255.0 blue:235/255.0 alpha:1];
        cell.backgroundView = bg;
        [bg release];
    } 
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"public.png"];
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
    [super dealloc];
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

- (void)repositoriesReceived:(NSArray *)repositories forConnection:(NSString *)connectionIdentifier
{
    NSLog(@"%@", repositories);
    
    self.repos = repositories;
    [self.tableView reloadData];
}


@end

//
//  RootViewController.m
//  GithubBrowser
//
//  Created by Oscar Del Ben on 4/6/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import "RootViewController.h"

#import "DetailViewController.h"

@implementation RootViewController
		
@synthesize detailViewController;
@synthesize githubEngine;
@synthesize repos;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    
    githubEngine = [[UAGithubEngine alloc] initWithUsername:@"oscardelben" password:@"4f4CwUjS" delegate:self withReachability:NO];
    
    // Todo: this doesn't include forks
    // Todo: put a loding gif when loading
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
    // Navigation logic may go here -- for example, create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
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

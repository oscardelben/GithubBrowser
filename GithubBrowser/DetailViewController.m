//
//  DetailViewController.m
//  GithubBrowser
//
//  Created by Oscar Del Ben on 4/6/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import "DetailViewController.h"

#import "RootViewController.h"
#import "SettingsViewController.h"
#import "NSString+DBExtensions.h"
#import "SearchViewController.h"
#import "GithubBrowserAppDelegate.h"

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize splitController;

@synthesize toolbar=_toolbar;
@synthesize detailItem=_detailItem;
@synthesize webView = _webView;
@synthesize popoverController=_myPopoverController;

@synthesize titleBarButtonItem;
@synthesize loadUserItem;
@synthesize activityIndicator;
@synthesize matchedUsername;

#pragma mark - Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [_detailItem release];
        _detailItem = [newDetailItem retain];
        
        // Update the view.
        [self configureView];
    }

    if (self.popoverController != nil) {
        [self.popoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{   
    // Update the user interface for the detail item.
    [ApplicationHelper loadWebViewFromUrl:self.webView url:[self.detailItem valueForKey:@"url"]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Split view support

- (void)setTitle
{
    NSString *username = [ApplicationHelper currentUsername];
    titleBarButtonItem.title = (username && ![username blank]) ? username : @"Select username";
}

- (void)splitViewController:(MGSplitViewController*)svc 
	 willHideViewController:(UIViewController *)aViewController 
		  withBarButtonItem:(UIBarButtonItem*)barButtonItem 
	   forPopoverController: (UIPopoverController*)pc
{
    self.titleBarButtonItem = barButtonItem;
    [self setTitle];
    
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(MGSplitViewController*)svc 
	 willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}

- (void)configureToolbar
{
    UIBarButtonItem *loadButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    UIBarButtonItem *fullScreenItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"full_screen"] style:UIBarButtonItemStylePlain target:self    action:@selector(toggleFullScreen)];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    loadUserItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(loadMatchedUserRepos)];
    loadUserItem.enabled = NO;

    self.toolbar.items = [NSArray arrayWithObjects:loadButton, loadUserItem, spacer, fullScreenItem, nil];
    
    [spacer release];
    [fullScreenItem release];
}

 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.delegate = self;

    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.hidesWhenStopped = YES;
    
    [self configureToolbar];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(setTitle) name:GBCredentialsChanged object:nil];
    [notificationCenter addObserver:self selector:@selector(showLoadIndicator) name:GBShowLoadIndicator object:nil];
    [notificationCenter addObserver:self selector:@selector(hideLoadIndicator) name:GBHideLoadIndicator object:nil];
    
}

- (void)viewDidUnload
{
    [self setWebView:nil];
	[super viewDidUnload];

	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.popoverController = nil;
}

#pragma mark loadButtonItem

- (void)hideLoadButtonItem
{
    self.matchedUsername = @"";
    loadUserItem.title = @"";
    loadUserItem.enabled = NO;
    loadUserItem.style = UIBarButtonItemStylePlain;
}

- (void)showLoadButtonItem
{
    // Only show if different than current username
    if ([self.matchedUsername isEqualToString:[ApplicationHelper currentUsername]])
        return;

    loadUserItem.title = [NSString stringWithFormat:@"Load %@", self.matchedUsername];
    loadUserItem.enabled = YES;   
    loadUserItem.style = UIBarButtonItemStyleBordered;
}

# pragma mark actions

- (void)showGithubHomepage
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://github.com"]]];
}

- (void)showHome
{
    NSString *username = [ApplicationHelper username];
    
    [ApplicationHelper setCurrentUsername:username notifyOfChange:YES];
}

- (void)showSearch
{
    /*
    SearchViewController *viewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentModalViewController:navController animated:YES];
    
    [viewController release];
     */
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://github.com/search"]]];
}

/*
- (void)showRandomRepo
{
    [ApplicationHelper loadWebViewFromUrl:self.webView url:@"https://github.com/repositories/random"];
}
*/

- (void)loadUsernameFromWebView:(UIWebView *)webView
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"https://github.com/(.+)/(.+)"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSString *string = [[webView.request URL] absoluteString];
    
    NSArray *matches = [regex matchesInString:string           
                                      options:0
                                        range:NSMakeRange(0, [string length])];
    
    if ([matches count] > 0) 
    {
        // show button
        NSTextCheckingResult *match = [matches objectAtIndex:0];
        
        NSRange firstHalfRange = [match rangeAtIndex:1];
        NSString *username = [string substringWithRange:firstHalfRange];

        // Check if username is valid
        if ([ApplicationHelper validUsername:username])
        {
            self.matchedUsername = [string substringWithRange:firstHalfRange];
            
            [self showLoadButtonItem];
        }
    } else
    {
        [self hideLoadButtonItem];
    }
    
}

- (void)loadUserPage
{
    NSString *url
    ;
    if ([ApplicationHelper usingDefaultUser]) 
    {
        url = @"https://github.com";
    }
    else
    {
        url = [NSString stringWithFormat:@"https://github.com/%@", [ApplicationHelper currentUsername]];
    }
    
    [ApplicationHelper loadWebViewFromUrl:self.webView url:url];
}

- (void)loadMatchedUserRepos
{
    [ApplicationHelper setCurrentUsername:self.matchedUsername notifyOfChange:YES];
    [self hideLoadButtonItem];
}

- (void)toggleFullScreen
{
    [splitController toggleMasterView:self];
}

- (void)showLoadIndicator
{
    [self.activityIndicator startAnimating];
}

- (void)hideLoadIndicator
{
    [self.activityIndicator stopAnimating];
}

#pragma mark - Memory management

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_myPopoverController release];
    [_toolbar release];
    [_detailItem release];
    [_webView release];
    [loadUserItem release];
    [matchedUsername release];
    [super dealloc];
}

#pragma mark - UIWebViewDelegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *notification = [NSNotification notificationWithName:GBShowLoadIndicator object:nil];
    
    [notificationCenter postNotification:notification];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self loadUsernameFromWebView:webView];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *notification = [NSNotification notificationWithName:GBHideLoadIndicator object:nil];
    
    [notificationCenter postNotification:notification];
}

@end

//
//  DetailViewController.m
//  GithubBrowser
//
//  Created by Oscar Del Ben on 4/6/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import "DetailViewController.h"

#import "RootViewController.h"
#import "FullScreenViewController.h"

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize toolbar=_toolbar;

@synthesize detailItem=_detailItem;

@synthesize webView = _webView;

@synthesize popoverController=_myPopoverController;

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
    
    NSURL *url = [NSURL URLWithString:[self.detailItem valueForKey:@"url"]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:req];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Split view support

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc
{
    barButtonItem.title = @"Repos";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *fullScreenItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"full_screen"] style:UIBarButtonItemStylePlain target:self action:@selector(showFullScreen)];

    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                               target:nil
                               action:nil];
    
    // TODO: disable when no view is loaded
    self.toolbar.items = [NSArray arrayWithObjects:spacer, fullScreenItem, nil];
    
    [fullScreenItem release];
    [spacer release];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
	[super viewDidUnload];

	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.popoverController = nil;
}

# pragma mark full screen

- (void)showFullScreen
{
    FullScreenViewController *fullScreenViewController = [[FullScreenViewController alloc] initWithNibName:@"FullScreenViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:fullScreenViewController];

    fullScreenViewController.parentController = self;
    

    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:navController animated:YES];
    
    [fullScreenViewController release];
    [navController release];
}

#pragma mark - Memory management

- (void)dealloc
{
    [_myPopoverController release];
    [_toolbar release];
    [_detailItem release];
    [_webView release];
    [super dealloc];
}

@end

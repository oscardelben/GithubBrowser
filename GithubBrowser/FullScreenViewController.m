//
//  FullScreenViewController.m
//  GithubBrowser
//
//  Created by Oscar Del Ben on 4/7/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import "FullScreenViewController.h"


@implementation FullScreenViewController
@synthesize webView, parentController;

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissController:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    // set the webView
    UIWebView *parentWebView = [parentController valueForKey:@"webView"];
    
    CGRect originalFrame = self.webView.frame;
    
    [self.webView removeFromSuperview];
    self.webView = [parentWebView retain]; // is this ok for memory?
    self.webView.frame = originalFrame;
    [self.view addSubview:self.webView];
    
    [doneButton release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#define toolbarHeight 44

- (IBAction)dismissController:(id)sender
{
    UIWebView *parentWebView;
    
    parentWebView = [parentController valueForKey:@"webView"];
    
    // Of course I hate to hardcode these values. It would be nice to get the frame from the parent controller
    CGRect targetFrame;
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait) 
    {
        targetFrame = CGRectMake(0, 44, 775, 960);
    }
    else
    {
        targetFrame = CGRectMake(0, 44, 710, 704); 
    }
    
    [parentWebView removeFromSuperview];
    [parentController setValue:self.webView forKey:@"webView"];

    // reload
    parentWebView = nil;
    parentWebView = [parentController valueForKey:@"webView"];
    
    parentWebView.frame = targetFrame;
    [[parentController valueForKey:@"view"] addSubview:parentWebView];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [webView release];
    [parentController release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end

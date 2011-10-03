//
//  DetailViewController.h
//  GithubBrowser
//
//  Created by Oscar Del Ben on 4/6/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSplitViewController.h"

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, MGSplitViewControllerDelegate, UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet MGSplitViewController *splitController;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) UIBarButtonItem *titleBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem *loadUserItem;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSString *matchedUsername;

- (void)showGithubHomepage;
- (void)showHome;
- (void)showSearch;
- (void)showRandomRepo;
- (void)loadMatchedUserRepos;
- (void)loadUserPage;

- (void)showLoadIndicator;
- (void)hideLoadIndicator;

@end

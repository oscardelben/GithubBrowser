//
//  DetailViewController.h
//  GithubBrowser
//
//  Created by Oscar Del Ben on 4/6/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UIWebViewDelegate> {

    UIWebView *_webView;
    UIBarButtonItem *titleBarButtonItem;
}


@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) UIBarButtonItem *loadButtonItem;
@property (nonatomic, retain) NSString *matchedUsername;
@property (nonatomic, assign) BOOL isFullScreen;

- (void)showHome;
- (void)showSearch;
- (void)showRandomRepo;
- (void)showSettings;
- (void)loadMatchedUserRepos;
- (void)loadUserPage;

@end

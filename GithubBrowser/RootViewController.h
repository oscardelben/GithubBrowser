//
//  RootViewController.h
//  GithubBrowser
//
//  Created by Oscar Del Ben on 4/6/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface RootViewController : UITableViewController <UAGithubEngineDelegate, UIActionSheetDelegate> {
}

		
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic, retain) UAGithubEngine *githubEngine;
@property (nonatomic, retain) NSMutableArray *repos;

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIBarButtonItem *searchButton;
@property (nonatomic, assign) int currentPage;

- (void)showSearchSheet;
- (void)reloadRepos;
- (void)showLoadIndicator;
- (void)hideLoadIndicator;

@end

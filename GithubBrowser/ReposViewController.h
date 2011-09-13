//
//  ReposViewController.h
//  GithubBrowser
//
//  Created by Oscar Del Ben on 9/13/11.
//  Copyright (c) 2011 DibiStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface ReposViewController : UITableViewController <UAGithubEngineDelegate, UIActionSheetDelegate> {
}


@property (nonatomic, retain) DetailViewController *detailViewController;

@property (nonatomic, retain) UAGithubEngine *githubEngine;
@property (nonatomic, retain) NSMutableArray *repos;

@property (nonatomic, retain) UIBarButtonItem *searchButton;
@property (nonatomic, assign) int currentPage;

- (void)showSearchSheet;
- (void)reloadRepos;

@end

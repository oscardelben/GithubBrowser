//
//  RootViewController.h
//  GithubBrowser
//
//  Created by Oscar Del Ben on 4/6/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface RootViewController : UITableViewController <UAGithubEngineDelegate> {
    UIActivityIndicatorView *activityIndicator;
}

		
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic, retain) UAGithubEngine *githubEngine;
@property (nonatomic, retain) NSArray *repos;

- (void)reloadRepos;

@end
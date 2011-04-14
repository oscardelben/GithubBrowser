//
//  SearchViewController.h
//  GithubBrowser
//
//  Created by Oscar Del Ben on 4/14/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchViewController : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet UITextField *usernameTextField;

- (IBAction)save:(id)sender;

@end

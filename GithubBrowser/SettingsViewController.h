//
//  SettingsViewController.h
//  GithubBrowser
//
//  Created by Oscar Del Ben on 4/9/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface SettingsViewController : UIViewController {
    
    UITextField *usernameTextField;
    UITextField *passwordTextField;
}

@property (nonatomic, retain) IBOutlet UITextField *usernameTextField;

- (IBAction)save:(id)sender;

@end

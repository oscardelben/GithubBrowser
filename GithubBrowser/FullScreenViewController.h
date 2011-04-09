//
//  FullScreenViewController.h
//  GithubBrowser
//
//  Created by Oscar Del Ben on 4/7/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullScreenViewController : UIViewController {
    
    UIWebView *webView;
}

- (IBAction)dismissController:(id)sender;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) id parentController;

@end

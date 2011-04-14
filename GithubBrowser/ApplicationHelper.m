//
//  ApplicationHelper.m
//  GithubBrowser
//
//  Created by Oscar Del Ben on 4/11/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import "ApplicationHelper.h"

@implementation ApplicationHelper

+ (NSString *)currentUsername
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currentUsername = [userDefaults valueForKey:GBGithubCurrentUsername];

    if (!currentUsername || [currentUsername blank]) 
    {
        return [userDefaults valueForKey:GBGithubUsername];
    }
    else
    {
        return currentUsername;
    }
}

@end

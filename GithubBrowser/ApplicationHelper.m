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
    return [userDefaults valueForKey:GBGithubUsername];
}

@end

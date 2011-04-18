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

+ (NSString *)username
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:GBGithubUsername];
}

+ (NSString *)password
{
    // Only return password if we're fetching the primary user
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *currentUsername = [self currentUsername];
    NSString *username = [self username];

    if ([currentUsername isEqualToString:username]) 
    {
        return [userDefaults valueForKey:GBGithubPassword];
    }
    else
    {
        return nil;
    }
}

+ (BOOL)validUsername:(NSString *)username
{
    return [username rangeOfString:@"/"].location == NSNotFound;
}

+ (void)sendCredentialsChangedNotification
{
    NSNotification *notification = [NSNotification notificationWithName:GBCredentialsChanged object:nil];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotification:notification];
}

+ (void)saveCredentials:(NSString *)username password:(NSString *)password notifyOfChange:(BOOL)notify
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:username forKey:GBGithubUsername];
    [userDefaults setObject:password forKey:GBGithubPassword];
    
    if (notify) 
    {
        [self sendCredentialsChangedNotification];
    }
}

+ (void)setCurrentUsername:(NSString *)username notifyOfChange:(BOOL)notify
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:username forKey:GBGithubCurrentUsername];
    
    if (notify) 
    {
        [self sendCredentialsChangedNotification];
    }
}

@end

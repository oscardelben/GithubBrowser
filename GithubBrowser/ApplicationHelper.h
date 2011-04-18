//
//  ApplicationHelper.h
//  GithubBrowser
//
//  Created by Oscar Del Ben on 4/11/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ApplicationHelper : NSObject {
    
}

+ (NSString *)currentUsername;
+ (NSString *)username;
+ (NSString *)password;

+ (BOOL)validUsername:(NSString *)username;

+ (void)sendCredentialsChangedNotification;
+ (void)saveCredentials:(NSString *)username password:(NSString *)password notifyOfChange:(BOOL)notify;
+ (void)setCurrentUsername:(NSString *)username notifyOfChange:(BOOL)notify;

@end

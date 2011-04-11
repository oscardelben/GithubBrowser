//
//  NSString+DBExtensions.m
//  NSStringExtensions
//
//  Created by Oscar Del Ben on 3/13/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import "NSString+DBExtensions.h"


@implementation NSString (DBExtensions)

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)blank
{
    return [[self trim] isEqualToString:@""];
}

@end

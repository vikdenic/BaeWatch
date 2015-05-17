//
//  Profile.m
//  BaeWatch
//
//  Created by Vik Denic on 5/16/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "Profile.h"

@implementation Profile

@dynamic name;
@dynamic user;
@dynamic profileImageFile;

+(void)load
{
    [self registerSubclass];
}

+(NSString *)parseClassName
{
    return @"Profile";
}

-(instancetype)initWithUser: (User *)user
{
    self = [super init];
    self.user = user;

    return self;
}

@end

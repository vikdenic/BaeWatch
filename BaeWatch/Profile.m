//
//  Profile.m
//  BaeWatch
//
//  Created by Vik Denic on 5/16/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "Profile.h"
#import <Parse/PFObject+Subclass.h>

@implementation Profile

@dynamic fullName;
@dynamic user;
@dynamic profileImageFile;

+(NSString *)parseClassName
{
    return @"Profile";
}

-(instancetype)initWithUser: (User *)user
{
    self = [super init];
    self.user = user;
    self.fullName = @"Your Name";

    return self;
}

@end

//
//  Profile.m
//  BaeWatch
//
//  Created by Vik Denic on 5/16/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "Activity.h"
#import <Parse/PFObject+Subclass.h>

@implementation Activity

@dynamic fromUser;
@dynamic toUser;
@dynamic type;

+(NSString *)parseClassName
{
    return @"Activity";
}

-(instancetype)initFromUser: (User *)fromUser toUser:(User *)toUser type:(NSString *)type
{
    self = [super init];
    self.fromUser = fromUser;
    self.toUser = toUser;
    self.type = type;

    return self;
}

@end

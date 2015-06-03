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

@dynamic fromProfile;
@dynamic toProfile;
@dynamic type;

+(NSString *)parseClassName
{
    return @"Activity";
}

-(instancetype)initFromUser: (Profile *)fromProfile toUser:(Profile *)toProfile type:(NSString *)type
{
    self = [super init];
    self.fromProfile = fromProfile;
    self.toProfile = toProfile;
    self.type = type;

    return self;
}

+(void)retrieveFollowingWithBlock:(void (^)(NSArray *activities, NSError *error))completionHandler
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query includeKey:@"fromProfile"];
    [query includeKey:@"toProfile"];

    [query whereKey:@"type" equalTo:kActivityTypeFollow];
    [query whereKey:@"fromProfile" equalTo:[UniversalProfile sharedInstance].profile];
    [query orderByDescending:@"createdAt"];
    [query setLimit:25];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        completionHandler(objects, error);
    }];
}

+(void)retrieveFollowersWithBlock:(void (^)(NSArray *activities, NSError *error))completionHandler
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query includeKey:@"fromProfile"];
    [query includeKey:@"toProfile"];

    [query whereKey:@"type" equalTo:kActivityTypeFollow];
    [query whereKey:@"toProfile" equalTo:[UniversalProfile sharedInstance].profile];
    [query orderByDescending:@"createdAt"];
    [query setLimit:25];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        completionHandler(objects, error);
    }];
}

@end

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

+(void)followToProfile:(Profile *)profile withCompletion:(void (^)(BOOL succeeded, NSError *error))completionHandler
{
    Activity *follow = [Activity new];

    follow.type = kActivityTypeFollow;
    follow.toProfile = profile;
    follow.fromProfile = [[UniversalProfile sharedInstance] profile];

    [follow saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        completionHandler(succeeded, error);
    }];
}

+(void)removeFollowFromProfile:(Profile *)profile withCompletion:(void (^)(BOOL succeeded, NSError *error))completionHandler
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];

    [query includeKey:@"toProfile"];
    [query includeKey:@"fromProfile"];

    [query whereKey:@"toProfile" equalTo:profile];
    [query whereKey:@"fromProfile" equalTo:[UniversalProfile sharedInstance].profile];

    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
    {
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            completionHandler(succeeded, error);
        }];
    }];
}
@end

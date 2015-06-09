//
//  User.m
//  BaeWatch
//
//  Created by Vik Denic on 5/15/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "User.h"

@implementation User

+(void)load
{
    [self registerSubclass];
}

@dynamic fbId;

+(User *)currentUser
{
    return (User *)[PFUser currentUser];
}

+(void)createUserWithUserName:(NSString *)username withPassword:(NSString *)password completion:(void (^)(BOOL, NSError *))completionHandler
{
    User *user = [[User alloc] initWithUsername:username withPassword:password];

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completionHandler(succeeded, error);
    }];
}

+(void)getProfilesFromUsers:(NSArray *)users completion:(void (^)(BOOL, NSError *))completionHandler
{
    PFQuery *query1 = [PFQuery queryWithClassName:@"User"];


    // Create a query for Places liked by People in Australia.
    PFQuery *query2 = [PFQuery queryWithClassName:@"Place"];
    [query2 whereKey:@"likes" matchesQuery:query1];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *results, NSError*error) {
        // results contains the places that are liked by people from Australia
    }];
}


-(instancetype)initWithUsername:(NSString *)username withPassword: (NSString *)password
{
    self = [super init];
    self.username = username;
    self.password = password;
    return self;
}

@end

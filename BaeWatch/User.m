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

-(instancetype)initWithUsername:(NSString *)username withPassword: (NSString *)password
{
    self = [super init];
    self.username = username;
    self.password = password;
    return self;
}

@end

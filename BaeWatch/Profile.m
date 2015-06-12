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
@dynamic fullNameLC;
@dynamic user;
@dynamic profileImageFile;
@dynamic phoneNumber;

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

+(void)queryAllProfilesWithSearchString:(NSString *)string andBlock:(void(^)(NSArray *profiles, NSError *error))completionHandler
{
    PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
    [query whereKey:@"fullNameLC" hasPrefix:string.lowercaseString];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (objects.count == 0)
        {
            PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
            [query whereKey:@"fullNameLC" containsString:string.lowercaseString];

            [query findObjectsInBackgroundWithBlock:^(NSArray *moreProfiles, NSError *error) {
                completionHandler(moreProfiles, error);
            }];
        }
        else
        {
            completionHandler(objects, error);
        }
    }];
}

+(void)queryAllProfilesFromUsers:(NSArray *)users withBlock:(void(^)(NSArray *profiles, NSError *error))completionHandler
{
    PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
    [query includeKey:@"user"];
    [query whereKey:@"user" containedIn:users];

    [query findObjectsInBackgroundWithBlock:^(NSArray *profiles, NSError *error) {
        completionHandler(profiles, error);
//        NSLog(@"Profiles are: %@", profiles);
    }];
}

@end

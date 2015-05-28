//
//  Profile.h
//  BaeWatch
//
//  Created by Vik Denic on 5/16/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import <Parse/Parse.h>

@interface Activity : PFObject <PFSubclassing>

@property Profile *fromProfile;
@property Profile *toProfile;
@property NSString *type;

+(NSString *)parseClassName;

-(instancetype)initFromUser: (Profile *)fromProfile toUser:(Profile *)toProfile type:(NSString *)type;
+(void)retrieveFollowingWithBlock:(void (^)(NSArray *activities, NSError *error))completionHandler;
+(void)retrieveFollowersWithBlock:(void (^)(NSArray *activities, NSError *error))completionHandler;

@end

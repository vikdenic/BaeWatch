//
//  FBManager.h
//  BaeWatch
//
//  Created by Vik Denic on 5/20/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBManager : NSObject

+(void)findFBFriendsWithBlock:(void (^)(NSArray *friends, NSError *error))completionHandler;

+(void)setUsersFbIdWithBlock:(void (^)(NSError *error))completionHandler;

+(void)retrieveFbUsersInfoAndCreateProfile;

@end

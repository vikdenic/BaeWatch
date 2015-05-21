//
//  FBManager.m
//  BaeWatch
//
//  Created by Vik Denic on 5/20/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "FBManager.h"

@implementation FBManager

+(void)findFBFriendsWithBlock:(void (^)(NSArray *friends, NSError *error))completionHandler
{
    FBSDKGraphRequest *friendsRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:nil];
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    [connection addRequest:friendsRequest
         completionHandler:^(FBSDKGraphRequestConnection *innerConnection, NSDictionary *result, NSError *error) {

             NSArray *friendObjects = [result objectForKey:@"data"];
             NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
             // Create a list of friends' Facebook IDs
             for (NSDictionary *friendObject in friendObjects)
             {
                 [friendIds addObject:[friendObject objectForKey:@"id"]];
             }

             // Construct a PFUser query that will find friends whose facebook ids
             // are contained in the current user's friend list.
             PFQuery *friendQuery = [User query];
             [friendQuery whereKey:@"fbId" containedIn:friendIds];

             // findObjects will return a list of PFUsers that are friends
             // with the current user
             [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

                 completionHandler(objects, error);
             }];
         }];
    // start the actual request
    [connection start];
}

@end

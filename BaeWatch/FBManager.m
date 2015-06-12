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

+(void)setUsersFbIdWithBlock:(void (^)(NSError *error))completionHandler
{
    FBSDKGraphRequest *friendsRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];

    [connection addRequest:friendsRequest
         completionHandler:^(FBSDKGraphRequestConnection *innerConnection, NSDictionary *result, NSError *error) {

             if (error == nil)
             {
                 [User currentUser].fbId = [result objectForKey:@"id"];
                 [[User currentUser] saveInBackground];
             }
             completionHandler(error);
         }];
    
    [connection start];
}

+(void)createFollowsFromFBFriends:(NSArray *)friends
{
    for (User *friend in friends)
    {
        [FBManager profileFromFbID:friend.fbId withCompletion:^(Profile *profile, NSError *error) {
            Activity *newFollow = [[Activity alloc] initFromUser:[UniversalProfile sharedInstance].profile toUser:profile type:kActivityTypeFollow];
            [newFollow saveInBackground];
        }];
    }
}

+(void)profileFromFbID:(NSString *)fbId withCompletion:(void (^)(Profile *profile, NSError *error))completionHandler
{
    // Using PFQuery
    PFQuery *profileQuery = [PFQuery queryWithClassName:@"Profile"];
    [profileQuery includeKey:@"user"];

    [profileQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        for (Profile *profile in objects)
        {
            if ([profile.user.fbId isEqualToString:fbId])
            {
                completionHandler(profile, error);
            }
        }
    }];
}

+(void)retrieveFbUsersInfoAndCreateProfile;
{
    // ...
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];

    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error)
        {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;

            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            //            NSString *location = userData[@"location"][@"name"];

            //            NSLog(@"%@ %@", facebookID, name);

            Profile *currentProfile = [[UniversalProfile sharedInstance] profile];
            currentProfile.fullName = name;
            currentProfile.fullNameLC = name.lowercaseString;

            [currentProfile saveInBackground];

            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];

            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];

            // Now add the data to the UI elements
            // Run network request asynchronously
            [NSURLConnection sendAsynchronousRequest:urlRequest
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:
             ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                 if (connectionError == nil && data != nil) {

                     PFFile *file = [PFFile fileWithData:data];
                     [currentProfile setProfileImageFile:file];
                     [currentProfile saveInBackground];
                 }
             }];
        }
    }];
}

//TODO: Set User's fbId string as well
+(void)linkFBtoUser:(User *)user withCompletion:(void(^)(NSError *error))completionHandler
{
    NSArray *permissionsArray = @[@"public_profile", @"user_friends", @"email"];

    [PFFacebookUtils linkUserInBackground:user withReadPermissions:permissionsArray block:^(BOOL succeeded, NSError *error) {

        [FBManager setUsersFbIdWithBlock:^(NSError *error) {
            completionHandler(error);
        }];
    }];
}

@end

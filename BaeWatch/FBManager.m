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
                 NSLog(@">>>fb id set");
                 [[User currentUser] saveInBackground];
             }
             completionHandler(error);
         }];
    
    [connection start];
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


            [currentProfile saveInBackground];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewUser object:self];

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

@end
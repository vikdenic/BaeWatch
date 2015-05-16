//
//  HomeViewController.m
//  BaeWatch
//
//  Created by Vik Denic on 5/15/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

NSString *const kHomeToRegisterSegue = @"HomeToRegisterSegue";

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ([User currentUser] == nil)
    {
        [self performSegueWithIdentifier:kHomeToRegisterSegue sender:self];
    }
    else
    {
        [self findFBFriends];
    }
}

-(void)findFBFriends
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
                  
                  NSLog(@"%@", [objects objectAtIndex:0]);
              }];
         }];
    // start the actual request
    [connection start];
}

@end

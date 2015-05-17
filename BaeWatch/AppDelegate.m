//
//  AppDelegate.m
//  BaeWatch
//
//  Created by Vik Denic on 5/15/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [Parse setApplicationId:@"Y5tuRfbwpGIbfTrnDOSpaOSpQQ9HXuvPynaPFZ36"
                  clientKey:@"GdCcTlS08ICJ52fnLMzb6KsLKEBBYA4CiqoSafQz"];


    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];

    if ([User currentUser])
    {
        [self setProfileSingleton];
    }
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

-(void)setProfileSingleton
{
    PFQuery *profileQuery = [PFQuery queryWithClassName:@"Profile"];
    [profileQuery includeKey:@"user"];
    [profileQuery whereKey:@"user" equalTo:[User currentUser]];

    [profileQuery getFirstObjectInBackgroundWithBlock:^(PFObject *profile, NSError *error) {

        Profile *currentProfile = (Profile *) profile;
        [[UniversalProfile sharedInstance] setProfile:currentProfile];
        NSLog(@"%@", currentProfile.name);
    }];
}

@end

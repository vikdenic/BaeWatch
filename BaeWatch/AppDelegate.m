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
    [Profile registerSubclass];

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

    [profileQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        Profile *profile = [objects firstObject];
        [[UniversalProfile sharedInstance] setProfile:profile];
        [self setTabBar];
     }];
}

-(void)setTabBar
{
    UITabBarController *tbc = (UITabBarController *)self.window.rootViewController;
    UITabBarItem *tabItem = [tbc.tabBar.items objectAtIndex:1];
    [tabItem setTitle:[UniversalProfile sharedInstance].profile.fullName];
}

@end

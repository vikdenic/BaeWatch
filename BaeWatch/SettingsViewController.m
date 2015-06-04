//
//  SettingsViewController.m
//  BaeWatch
//
//  Created by Vik Denic on 5/17/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

NSString *const kSegueLogoutToRegister = @"LogoutToRegisterSegue";

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)onLogoutTapped:(UIButton *)sender
{
    [User logOutInBackgroundWithBlock:^(NSError *error) {
        [self performSegueWithIdentifier:kSegueLogoutToRegister sender:self];
        [UniversalProfile sharedInstance].profile = nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.tabBarController setSelectedIndex:0];
    }];
}

- (IBAction)onLinkWithFBTapped:(UIButton *)sender
{
    User *currentUser = [User currentUser];

    [FBManager linkFBtoUser:currentUser withCompletion:^(NSError *error) {
        if (error == nil)
        {
            [FBManager setUsersFbIdWithBlock:^(NSError *error) {
                NSLog(@"%@", currentUser.fbId);
            }];

            NSLog(@"succeeded");
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
@end

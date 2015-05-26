//
//  ViewController.m
//  BaeWatch
//
//  Created by Vik Denic on 5/15/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

NSString *const kSegueIDRegisterToNameEntry = @"RegisterToNameEntrySegue";

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

//Registers a user via basic Parse
- (IBAction)onRegisterTapped:(UIButton *)sender
{
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        [User createUserWithUserName:self.usernameTextField.text withPassword:self.passwordTextField.text completion:^(BOOL result, NSError *error)
         {
             if (error == nil)
             {
                 [self createAndSaveProfile];
                 [self performSegueWithIdentifier:kSegueIDRegisterToNameEntry sender:self];
             }
             else
             {
                 [VZAlert showAlertWithTitle:@"Oops" message:error.localizedDescription viewController:self];
             }
         }];
    }
    else
    {
        [User logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error)
         {
             if (error == nil)
             {
                 [self dismissViewControllerAnimated:YES completion:^{
                     [self setProfileSingleton];
                }];
             }
             else
             {
                 [VZAlert showAlertWithTitle:@"Oops" message:error.localizedDescription viewController:self];
             }
         }];
    }
}

//Action when user taps the custom FB login button
- (IBAction)onFBLoginTapped:(FBSDKLoginButton *)sender
{
    [self _loginWithFacebook];
}

//Toggles whether the user is creating a new account or logging in
- (IBAction)onSegmentTapped:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0)
    {
        [self.registerButton setTitle:@"SIGN UP" forState:UIControlStateNormal];
    }
    else
    {
        [self.registerButton setTitle:@"LOG IN" forState:UIControlStateNormal];
    }
}

//Creates a new Profile object that will point to the current user
//If via FB, will make a graph request to get their name and profile pic
-(void)createAndSaveProfile
{
    Profile *profile = [[Profile alloc] initWithUser:[User currentUser]];
    [profile saveInBackground];

    [[UniversalProfile sharedInstance] setProfile:profile];

    if ([User currentUser].fbId != nil)
    {
        [FBManager retrieveFbUsersInfoAndCreateProfile];
    }
}

//Retrieves the current user's Profile
//Sets the profile singleton
-(void)setProfileSingleton
{
    PFQuery *profileQuery = [PFQuery queryWithClassName:@"Profile"];
    [profileQuery includeKey:@"user"];
    [profileQuery whereKey:@"user" equalTo:[User currentUser]];

    [profileQuery getFirstObjectInBackgroundWithBlock:^(PFObject *profile, NSError *error) {

        Profile *currentProfile = (Profile *) profile;
        [[UniversalProfile sharedInstance] setProfile:currentProfile];
    }];
}

//Executes login or registration with Facebook
//Asks for permissions to the user's info
//Will log them in, create the account AND log them in, or tell you it was cancelled
- (void)_loginWithFacebook
{
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[@"public_profile", @"user_friends", @"email"];

    // Login PFUser using Facebook
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (error == nil)
        {
            if (!user)
            {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            }
            //When a new user is registered through Facebook
            ////Set their unique fbid to the User class
            ////Create a Profile for them, with their info from FB graph set
            ////And set the share Profile singleton to this
            else if (user.isNew)
            {
                NSLog(@"User signed up and logged in through Facebook!");
                [FBManager setUsersFbIdWithBlock:^(NSError *error) {
                    [self createAndSaveProfile];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }
            else
            {
                NSLog(@"User logged in through Facebook!");
                [self setProfileSingleton];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
        else
        {
            [VZAlert showAlertWithTitle:@"Oops" message:error.localizedDescription viewController:self];
        }
    }];
}

@end

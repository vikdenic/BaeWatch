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

@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)onRegisterTapped:(UIButton *)sender
{
    [User createUserWithUserName:self.usernameTextField.text withPassword:self.passwordTextField.text completion:^(BOOL result, NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)onFBLoginTapped:(FBSDKLoginButton *)sender
{
    [self _loginWithFacebook];
}

- (void)_loginWithFacebook
{
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[@"public_profile", @"user_friends", @"email"];

    // Login PFUser using Facebook
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user)
        {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        }
        else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self setUsersFbId];
            [self createAndSaveProfile];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            NSLog(@"User logged in through Facebook!");
            [self setProfileSingleton];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

-(void)createAndSaveProfile
{
    Profile *profile = [[Profile alloc] initWithUser:[User currentUser]];
    [profile saveInBackground];

    [[UniversalProfile sharedInstance] setProfile:profile];
    [self _loadData];
}

-(void)setUsersFbId
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
    }];

    [connection start];
}

- (void)_loadData
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
            currentProfile.name = name;


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

-(void)setProfileSingleton
{
    PFQuery *profileQuery = [PFQuery queryWithClassName:@"Profile"];
    [profileQuery includeKey:@"user"];
    [profileQuery whereKey:@"user" equalTo:[User currentUser]];

    [profileQuery getFirstObjectInBackgroundWithBlock:^(PFObject *profile, NSError *error) {

        Profile *currentProfile = (Profile *) profile;
        [[UniversalProfile sharedInstance] setProfile:currentProfile];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewUser object:self];
        [self _loadData];
    }];
}

@end

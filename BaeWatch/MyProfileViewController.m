//
//  MyProfileViewController.m
//  BaeWatch
//
//  Created by Vik Denic on 5/17/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "MyProfileViewController.h"

@interface MyProfileViewController ()
@property (strong, nonatomic) IBOutlet UIButton *followersButton;
@property (strong, nonatomic) IBOutlet PFImageView *profilePicImageView;
@property (strong, nonatomic) IBOutlet UIButton *followingButton;

@end

@implementation MyProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self setProfileInfo];
}

-(void)setProfileInfo
{
    Profile *profile = [[UniversalProfile sharedInstance] profile];
    [self.navigationItem setTitle:profile.fullName];
    [self.profilePicImageView setFile:profile.profileImageFile];
    [self.profilePicImageView loadInBackground];
}

@end

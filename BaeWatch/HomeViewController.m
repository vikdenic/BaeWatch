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

NSString *const kSegueHomeToRegister = @"HomeToRegisterSegue";

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([User currentUser].fbId != nil)
    {
        [FBManager findFBFriendsWithBlock:^(NSArray *friends, NSError *error) {
            NSLog(@"Friends are: %@", friends);
        }];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ([User currentUser] == nil)
    {
        [self performSegueWithIdentifier:kSegueHomeToRegister sender:self];
    }
}

@end

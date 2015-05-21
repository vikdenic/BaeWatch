//
//  MyProfileViewController.m
//  BaeWatch
//
//  Created by Vik Denic on 5/17/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "MyProfileViewController.h"

@interface MyProfileViewController ()

@end

@implementation MyProfileViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification) name:kNotificationNewUser object:nil];
    }

    return self;
}

-(void)receiveNotification
{
    self.title = [UniversalProfile sharedInstance].profile.fullName;
}


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
//    self.title = [[UniversalProfile sharedInstance] profile].fullName;
}

@end

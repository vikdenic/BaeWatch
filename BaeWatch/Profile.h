//
//  Profile.h
//  BaeWatch
//
//  Created by Vik Denic on 5/16/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import <Parse/Parse.h>

@interface Profile : PFObject <PFSubclassing>

@property User *user;
@property NSString *fullName;
@property PFFile *profileImageFile;
@property NSString *phoneNumber;

+(NSString *)parseClassName;

-(instancetype)initWithUser: (User *)user;

@end

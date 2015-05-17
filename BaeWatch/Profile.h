//
//  Profile.h
//  BaeWatch
//
//  Created by Vik Denic on 5/16/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import <Parse/Parse.h>

@interface Profile : PFObject <PFSubclassing>

@property NSString *name;
@property User *user;
@property PFFile *profileImageFile;

+(void)load;
+(NSString *)parseClassName;

-(instancetype)initWithUser: (User *)user;

@end

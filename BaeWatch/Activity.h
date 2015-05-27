//
//  Profile.h
//  BaeWatch
//
//  Created by Vik Denic on 5/16/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import <Parse/Parse.h>

@interface Activity : PFObject <PFSubclassing>

@property User *fromUser;
@property User *toUser;
@property NSString *type;

+(NSString *)parseClassName;

-(instancetype)initFromUser: (User *)fromUser toUser:(User *)toUser type:(NSString *)type;

@end

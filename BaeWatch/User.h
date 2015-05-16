//
//  User.h
//  BaeWatch
//
//  Created by Vik Denic on 5/15/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import <Parse/Parse.h>

@interface User : PFUser <PFSubclassing>

+(void)load;

+(User *)currentUser;

+(void)createUserWithUserName: (NSString *)username withPassword:(NSString *)password completion:(void(^)(BOOL result, NSError *error))completionHandler;

@end

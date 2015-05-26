//
//  VZAlert.h
//  BaeWatch
//
//  Created by Vik Denic on 5/25/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VZAlert : NSObject

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message viewController:(UIViewController *)viewController;

@end

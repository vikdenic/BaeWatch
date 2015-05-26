//
//  VZAlert.m
//  BaeWatch
//
//  Created by Vik Denic on 5/25/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "VZAlert.h"

@implementation VZAlert

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message viewController:(UIViewController *)viewController
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [viewController presentViewController:alert animated:YES completion:nil];
}


@end

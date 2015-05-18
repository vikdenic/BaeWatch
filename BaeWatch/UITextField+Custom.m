//
//  UITextField+Custom.m
//  BaeWatch
//
//  Created by Vik Denic on 5/17/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "UITextField+Custom.h"

@implementation UITextField (Custom)

-(void)addBottomBorder
{
    CALayer *bottomBorder = [CALayer new];
    bottomBorder.frame = CGRectMake(0.0, self.frame.size.height - 1, self.frame.size.width, 1.0);
    bottomBorder.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [self.layer addSublayer:bottomBorder];
}

@end

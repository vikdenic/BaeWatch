//
//  SearchResultTableViewCell.m
//  BaeWatch
//
//  Created by Vik Denic on 6/11/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "SearchResultTableViewCell.h"

@implementation SearchResultTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.profileImageView.layer.cornerRadius = 25.0;
    self.profileImageView.layer.masksToBounds = YES;
}

@end

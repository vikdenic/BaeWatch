//
//  NameEntryTableViewCell.m
//  BaeWatch
//
//  Created by Vik Denic on 5/17/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "NameEntryTableViewCell.h"

@implementation NameEntryTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    [self.firstNameTextField addBottomBorder];
    [self.lastNameTextField addBottomBorder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onEditButtonTapped:(UIButton *)sender
{
    [self.delegate nameEntryCell:self didTapEditButton:self.editButton];
}

@end

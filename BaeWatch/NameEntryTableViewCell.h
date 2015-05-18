//
//  NameEntryTableViewCell.h
//  BaeWatch
//
//  Created by Vik Denic on 5/17/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NameEntryTableViewCellDelegate <NSObject>

@optional

-(void)nameEntryCell:(id)cell didTapEditButton:(UIButton *)button;

@end

@interface NameEntryTableViewCell : UITableViewCell

@property (nonatomic, assign) id <NameEntryTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) IBOutlet UIButton *editButton;

@end

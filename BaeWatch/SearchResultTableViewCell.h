//
//  SearchResultTableViewCell.h
//  BaeWatch
//
//  Created by Vik Denic on 6/11/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet PFImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end

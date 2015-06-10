//
//  SocialSearchResultsTableViewController.h
//  BaeWatch
//
//  Created by Vik Denic on 6/3/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialSearchResultsTableViewController : UITableViewController <UISearchResultsUpdating>

@property BOOL searchingContacts;
@property BOOL searchingFacebook;

@end

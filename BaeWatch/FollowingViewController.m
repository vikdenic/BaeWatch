//
//  FollowingViewController.m
//  BaeWatch
//
//  Created by Vik Denic on 5/28/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "FollowingViewController.h"

@interface FollowingViewController () <UITableViewDataSource>

@property NSArray *activitesArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

NSString *const kCellFollowing = @"FollowingCell";

@implementation FollowingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self retrieveFollowing];
}


-(void)retrieveFollowing
{
    [Activity retrieveFollowingWithBlock:^(NSArray *activities, NSError *error) {
        self.activitesArray = activities;
        [self.tableView reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.activitesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellFollowing];
    Profile *profile = [[self.activitesArray objectAtIndex:indexPath.row] toProfile];
    cell.textLabel.text = profile.fullName;
    return cell;
}

@end

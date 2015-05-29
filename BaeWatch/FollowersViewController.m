//
//  FollowersViewController.m
//  BaeWatch
//
//  Created by Vik Denic on 5/28/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "FollowersViewController.h"

@interface FollowersViewController () <UITableViewDataSource>

@property NSArray *activitiesArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

NSString *const kCellFollower = @"FollowerCell";

@implementation FollowersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self retrieveFollowers];
}

-(void)retrieveFollowers
{
    [Activity retrieveFollowersWithBlock:^(NSArray *activites, NSError *error) {
        self.activitiesArray = activites;
        [self.tableView reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.activitiesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellFollower];
    Profile *profile = [[self.activitiesArray objectAtIndex:indexPath.row] fromProfile];
    cell.textLabel.text = profile.fullName;
    return cell;
}

@end

//
//  FollowingViewController.m
//  BaeWatch
//
//  Created by Vik Denic on 5/28/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "FollowingViewController.h"

@interface FollowingViewController () <UITableViewDataSource, UIScrollViewDelegate>

@property NSArray *activitesArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

NSString *const kCellFollowing = @"FollowingCell";

@implementation FollowingViewController{
    BOOL _statusBarHidden;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self retrieveFollowing];

    [self.navigationController setHidesBarsOnSwipe:YES];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

-(void)moveStatusBar
{
    NSString *referenceString = [NSString stringWithFormat:@"%@%@%@", kStatus, kBar, kWindow];
    UIWindow *statusBarWindow = [(UIWindow *)[UIApplication sharedApplication] valueForKey:referenceString];
    statusBarWindow.center = CGPointMake(self.navigationController.navigationBar.center.x, self.navigationController.navigationBar.center.y - 10);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
    NSLog(@"scrollView.y=%f", scrollView.contentOffset.y);

    CGFloat yOffset = scrollView.contentOffset.y;

    UIWindow *statusBarWindow = (UIWindow *)[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];

    if(yOffset > 0)
    {
        [statusBarWindow setFrame:CGRectMake(0,
                                             -1*yOffset,
                                             statusBarWindow.frame.size.width,
                                             statusBarWindow.frame.size.height)];
    } else
    {
        [statusBarWindow setFrame:CGRectMake(0,
                                             0,
                                             statusBarWindow.frame.size.width,
                                             statusBarWindow.frame.size.height)];
    }
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

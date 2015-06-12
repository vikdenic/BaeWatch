//
//  SocialSearchResultsTableViewController.m
//  BaeWatch
//
//  Created by Vik Denic on 6/3/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "SocialSearchResultsTableViewController.h"
#import "SearchResultTableViewCell.h"
#import "ContactsManager.h"
#import "FBManager.h"
#import "Activity.h"

@interface SocialSearchResultsTableViewController ()

@property NSArray *profiles;
@property NSMutableArray *followingProfiles;

@end

@implementation SocialSearchResultsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshProfiles];
    [self setupPullToRefresh];
}

#pragma mark - Search results updater

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [Profile queryAllProfilesWithSearchString:searchController.searchBar.text andBlock:^(NSArray *profiles, NSError *error) {
        self.profiles = profiles;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.profiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SocialResultCell" forIndexPath:indexPath];
    Profile *profile = [self.profiles objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = profile.fullName;

    [profile.profileImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
    {
        cell.profileImageView.file = profile.profileImageFile;
        [cell.profileImageView loadInBackground];
    }];

    if ([self.followingProfiles containsObject:profile.objectId])
    {
        [self handleAccessoryTap:cell isFollowing:NO];
    }
    else
    {
        [self handleAccessoryTap:cell isFollowing:YES];
    }

    if ([profile.user.objectId isEqualToString:[User currentUser].objectId])
    {
        cell.accessoryView = nil;
    }

    return cell;
}

#pragma mark - Helpers

-(void)setupPullToRefresh
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshProfiles) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = self.refreshControl;
}

-(void)refreshProfiles
{
    self.followingProfiles = [NSMutableArray new];

    [Activity retrieveFollowingWithBlock:^(NSArray *activities, NSError *error) {
        for (Activity *activity in activities)
        {
            Profile *profile = activity.toProfile;
            [self.followingProfiles addObject:profile.objectId];
        }
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];

    if (self.searchingContacts)
    {
        [ContactsManager requestContactsAccess:^(BOOL success, ABAddressBookRef addressBook, CFErrorRef error) {
            [ContactsManager listPeopleInAddressBook:addressBook withCompletion:^(NSArray *numbers) {
                [ContactsManager findProfilesFromNumbers:numbers withCompletion:^(NSArray *profiles) {
                    self.profiles = profiles;
                    [self.tableView reloadData];
                    [self.refreshControl endRefreshing];
                }];
            }];
        }];
    }

    if (self.searchingFacebook)
    {
        [FBManager findFBFriendsWithBlock:^(NSArray *users, NSError *error) {
            [Profile queryAllProfilesFromUsers:users withBlock:^(NSArray *profiles, NSError *error) {
                self.profiles = profiles;
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            }];
        }];
    }
}

-(void)handleAccessoryTap:(UITableViewCell *)cell isFollowing:(BOOL)isFollowing
{
    UIImage *image = [UIImage imageNamed:@"checkmarkAccessoryImage"];
    SEL selector = @selector(onCheckmarkAccessoryTapped:event:);

    if (isFollowing)
    {
        image = [UIImage imageNamed:@"addAccessoryImage"];
        selector = @selector(onAddAccessoryTapped:event:);
    }

    UIButton *checkmarkButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [checkmarkButton setImage:image forState:UIControlStateNormal];
    [checkmarkButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = checkmarkButton;
}

-(void)onCheckmarkAccessoryTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];

    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil)
    {
        [self presentAlertController:indexPath];
    }
}

-(void)onAddAccessoryTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];

    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil)
    {
        [Activity followToProfile:self.profiles[indexPath.row] withCompletion:^(BOOL succeeded, NSError *error) {
            SearchResultTableViewCell *cell = (SearchResultTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
            [self handleAccessoryTap:cell isFollowing:NO];
        }];
    }
}

-(void)presentAlertController:(NSIndexPath *)indexPath
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Unfollow?" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *unfollowAction = [UIAlertAction actionWithTitle:@"Unfollow" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        SearchResultTableViewCell *cell = (SearchResultTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
        [Activity removeFollowFromProfile:self.profiles[indexPath.row] withCompletion:^(BOOL succeeded, NSError *error) {
            [self handleAccessoryTap:cell isFollowing:YES];
        }];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    [controller addAction:unfollowAction];
    [controller addAction:cancelAction];

    [self presentViewController:controller animated:YES completion:nil];
}

@end

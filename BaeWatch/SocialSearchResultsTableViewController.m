//
//  SocialSearchResultsTableViewController.m
//  BaeWatch
//
//  Created by Vik Denic on 6/3/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "SocialSearchResultsTableViewController.h"
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
    self.followingProfiles = [NSMutableArray new];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;


    [Activity retrieveFollowingWithBlock:^(NSArray *activities, NSError *error) {
        for (Activity *activity in activities)
        {
            Profile *profile = activity.toProfile;
            [self.followingProfiles addObject:profile.objectId];
        }
        [self.tableView reloadData];
    }];

    if (self.searchingContacts)
    {
        [ContactsManager requestContactsAccess:^(BOOL success, ABAddressBookRef addressBook, CFErrorRef error) {
            [ContactsManager listPeopleInAddressBook:addressBook withCompletion:^(NSArray *numbers) {
                [ContactsManager findProfilesFromNumbers:numbers withCompletion:^(NSArray *profiles) {
                    self.profiles = profiles;
                    [self.tableView reloadData];
                }];
            }];
        }];
    }

    if (self.searchingFacebook)
    {
        [FBManager findFBFriendsWithBlock:^(NSArray *users, NSError *error) {
            //TODO: Return profiles of FB friends here
//            self.profiles = [NSMutableArray arrayWithArray:users];
            [Profile queryAllProfilesFromUsers:users withBlock:^(NSArray *profiles, NSError *error) {
                self.profiles = profiles;
                [self.tableView reloadData];
            }];
        }];
    }
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [Profile queryAllProfilesWithSearchString:searchController.searchBar.text andBlock:^(NSArray *profiles, NSError *error) {

        self.profiles = profiles;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return 0;
//}
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.profiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SocialResultCell" forIndexPath:indexPath];
    Profile *profile = [self.profiles objectAtIndex:indexPath.row];
    cell.textLabel.text = profile.fullName;

    if ([self.followingProfiles containsObject:profile.objectId])
    {
        [self handleAccessoryTap:cell isFollowing:NO];
    }
    else
    {
        [self handleAccessoryTap:cell isFollowing:YES];
    }

    return cell;
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
        [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];

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
            [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];

            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [self handleAccessoryTap:cell isFollowing:NO];
        }];
    }
}

-(void)presentAlertController:(NSIndexPath *)indexPath
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Unfollow?" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *unfollowAction = [UIAlertAction actionWithTitle:@"Unfollow" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [Activity removeFollowFromProfile:self.profiles[indexPath.row] withCompletion:^(BOOL succeeded, NSError *error) {
            [self handleAccessoryTap:cell isFollowing:YES];
        }];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    [controller addAction:unfollowAction];
    [controller addAction:cancelAction];

    [self presentViewController:controller animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

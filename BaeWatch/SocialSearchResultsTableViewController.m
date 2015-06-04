//
//  SocialSearchResultsTableViewController.m
//  BaeWatch
//
//  Created by Vik Denic on 6/3/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "SocialSearchResultsTableViewController.h"
#import "ContactsManager.h"
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
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
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

//
//  ExploreViewController.m
//  BaeWatch
//
//  Created by Vik Denic on 5/30/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "ExploreViewController.h"
#import "SocialSearchResultsTableViewController.h"

@interface ExploreViewController () <UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property UISearchController *controller;

@end

@implementation ExploreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self implementSearchBar];
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchOptionCell"];

    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"Your Facebook Friends";
        cell.imageView.image = [UIImage imageNamed:@"facebookIcon"];
        return cell;
    }
    else
    {
        cell.textLabel.text = @"Your Contacts";
        cell.imageView.image = [UIImage imageNamed:@"contactsIcon"];
        return cell;
    }
}

#pragma mark - Table view delegate

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    if (indexPath.row == 0)
    {
        if ([User currentUser].fbId == nil)
        {
            [self presentFBLinkAlertController];
            return NO;
        }
    }

    if (indexPath.row == 1)
    {
        if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized)
        {
            [self presentAddressBookAlertController];
            return NO;
        }
    }

    return YES;
}

#pragma mark - Helpers

-(void)implementSearchBar
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SocialSearchResultsTableViewController *resultsVC = [storyboard instantiateViewControllerWithIdentifier:@"SocialSearchResultsTableViewController"];

    self.controller = [[UISearchController alloc] initWithSearchResultsController:resultsVC];
    [self.controller setSearchResultsUpdater:resultsVC];

    self.controller.hidesNavigationBarDuringPresentation = NO;
    self.controller.dimsBackgroundDuringPresentation = YES;
    self.definesPresentationContext = YES;

    [self.navigationItem setTitleView:self.controller.searchBar];
    [self.controller.searchBar setPlaceholder:@"Search for a user"];
    [self.controller.searchBar sizeToFit];
}

-(void)presentFBLinkAlertController
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Link your Facebook?" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *unfollowAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        [FBManager linkFBtoUser:[User currentUser] withCompletion:^(NSError *error) {
            [self performSegueWithIdentifier:@"ExploreToSocialResultsSegue" sender:self];
        }];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    [controller addAction:unfollowAction];
    [controller addAction:cancelAction];

    [self presentViewController:controller animated:YES completion:nil];
}

-(void)presentAddressBookAlertController
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Access Disabled" message:@"To switch on Contacts, go to this phone's Settings > BaeWatch" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:nil];

    [controller addAction:okayAction];

    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ExploreToSocialResultsSegue"])
    {
        SocialSearchResultsTableViewController *socialSearchTVC = segue.destinationViewController;
        BOOL selectedRow = [[[self.tableView indexPathsForSelectedRows] firstObject] row];

        if (selectedRow == 0)
        {
            [socialSearchTVC setSearchingFacebook:YES];
        }

        if (selectedRow == 1)
        {
            [socialSearchTVC setSearchingContacts:YES];
        }
    }
}

@end

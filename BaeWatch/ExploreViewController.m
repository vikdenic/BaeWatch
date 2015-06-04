//
//  ExploreViewController.m
//  BaeWatch
//
//  Created by Vik Denic on 5/30/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "ExploreViewController.h"
#import "SearchResultsTableViewController.h"
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

    [self.navigationController hidesBarsOnSwipe];
}

-(void)implementSearchBar
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchResultsTableViewController *resultsVC = [storyboard instantiateViewControllerWithIdentifier:@"SearchResultsTVC"];

    self.controller = [[UISearchController alloc] initWithSearchResultsController:resultsVC];
    [self.controller setSearchResultsUpdater:resultsVC];

    self.controller.hidesNavigationBarDuringPresentation = NO;
    self.controller.dimsBackgroundDuringPresentation = YES;
    self.definesPresentationContext = YES;
    
    [self.navigationItem setTitleView:self.controller.searchBar];
    [self.controller.searchBar setPlaceholder:@"Search for a user"];
    [self.controller.searchBar sizeToFit];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ExploreToSocialResultsSegue"])
    {
        SocialSearchResultsTableViewController *socialSearchTVC = segue.destinationViewController;
        BOOL selectedRow = [[[self.tableView indexPathsForSelectedRows] firstObject] row];
        [socialSearchTVC setSearchingContacts:selectedRow];
    }
}

@end

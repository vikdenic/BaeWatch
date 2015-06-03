//
//  ExploreViewController.m
//  BaeWatch
//
//  Created by Vik Denic on 5/30/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "ExploreViewController.h"
#import "SearchResultsTableViewController.h"

@interface ExploreViewController () <UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property UISearchController *controller;

@property NSMutableArray *resultsArray;

@end

@implementation ExploreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self implementSearchBar];

    self.resultsArray = [NSMutableArray arrayWithObjects:@"Explore", @"Content", @"Here", nil];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"];
    cell.textLabel.text = [self.resultsArray objectAtIndex:indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultsArray.count;
}

@end

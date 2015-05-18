//
//  NameEntryViewController.m
//  BaeWatch
//
//  Created by Vik Denic on 5/17/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "NameEntryViewController.h"
#import "NameEntryTableViewCell.h"

@interface NameEntryViewController () <UITableViewDataSource, UITableViewDelegate, NameEntryTableViewCellDelegate>

@end

@implementation NameEntryViewController

NSString *const kCellIDNameEntry =  @"NameEntryCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIDNameEntry];
    cell.delegate = self;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(void)nameEntryCell:(id)cell didTapEditButton:(UIButton *)button
{

}

@end

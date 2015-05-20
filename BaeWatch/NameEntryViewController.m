//
//  NameEntryViewController.m
//  BaeWatch
//
//  Created by Vik Denic on 5/17/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "NameEntryViewController.h"
#import "NameEntryTableViewCell.h"

@interface NameEntryViewController () <UITableViewDataSource, UITableViewDelegate, NameEntryTableViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property UIImage *selectedImage;
@property (strong, nonatomic) IBOutlet UITableView *entryTableView;

@end

@implementation NameEntryViewController

NSString *const kCellIDNameEntry =  @"NameEntryCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(void)nameEntryCell:(id)cell didTapEditButton:(UIButton *)button
{
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;

    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.selectedImage = info[UIImagePickerControllerEditedImage];
        NameEntryTableViewCell *cell = (NameEntryTableViewCell *) [self.entryTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.profileImageView.image = self.selectedImage;
    }];
}

@end

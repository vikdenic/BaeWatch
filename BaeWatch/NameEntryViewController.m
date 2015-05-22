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
@property (strong, nonatomic) NameEntryTableViewCell *entryCell;

@end

@implementation NameEntryViewController

NSString *const kCellIDNameEntry =  @"NameEntryCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.entryCell = (NameEntryTableViewCell *) [self.entryTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
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
        self.entryCell.profileImageView.image = self.selectedImage;
    }];
}

- (IBAction)onNextButtonTapped:(UIBarButtonItem *)sender
{
    if ([self.entryCell.firstNameTextField.text isEqualToString:@""] || [self.entryCell.lastNameTextField.text isEqualToString:@""] || self.entryCell.profileImageView.image == nil)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Make sure you enter your name and pick a photo!" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [self createAndSaveProfile];
        }];
    }
}

-(void)createAndSaveProfile
{
    Profile *profile = [[Profile alloc] initWithUser:[User currentUser]];
    profile.fullName = [NSString stringWithFormat:@"%@ %@", self.entryCell.firstNameTextField.text, self.entryCell.lastNameTextField.text];
    [profile saveInBackground];

    [[UniversalProfile sharedInstance] setProfile:profile];

    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewUser object:self];
}

@end

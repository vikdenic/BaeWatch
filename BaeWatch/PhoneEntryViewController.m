//
//  PhoneEntryViewController.m
//  BaeWatch
//
//  Created by Vik Denic on 5/26/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "PhoneEntryViewController.h"
#import <AddressBook/AddressBook.h>
#import "ContactsManager.h"

@interface PhoneEntryViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;

@end
 
@implementation PhoneEntryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];

    [ContactsManager requestContactsAccess:^(BOOL success, ABAddressBookRef addressBook, CFErrorRef error) {
        [ContactsManager listPeopleInAddressBook:addressBook withCompletion:^(NSArray *numbers) {
            [ContactsManager findProfilesFromNumbers:numbers withCompletion:^(NSArray *profiles) {
                [ContactsManager createsFollowsFromProfiles:profiles];
            }];
        }];
    }];
}

- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender
{
    if (self.phoneTextField.text.length == 14)
    {
        Profile *currentProfile = [[UniversalProfile sharedInstance] profile];

        NSString *usersNumber = [[self.phoneTextField.text componentsSeparatedByCharactersInSet:
                                    [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                   componentsJoinedByString:@""];
        if ([usersNumber hasPrefix:@"1"] && [usersNumber length] > 1)
        {
            usersNumber = [usersNumber substringFromIndex:1];
        }
        
        [currentProfile setPhoneNumber:usersNumber];

        [currentProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error == nil)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                [VZAlert showAlertWithTitle:@"Oops" message:error.localizedDescription viewController:self];
            }
        }];
    }
    else
    {
        [VZAlert showAlertWithTitle:@"Oops" message:@"Please enter your full phone number, beginning with the area code" viewController:self];
    }
}

#pragma mark - textfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];

    // if it's the phone number textfield format it.
    if(textField.tag == 102 ) {
        if (range.length == 1) {
            // Delete button was hit.. so tell the method to delete the last char.
            textField.text = [self formatPhoneNumber:totalString deleteLastChar:YES];
        } else {
            textField.text = [self formatPhoneNumber:totalString deleteLastChar:NO ];
        }
        return false;
    }

    return YES;
}

#pragma mark - helpers
//Phone number formatter for textfield
//via http://stackoverflow.com/questions/1246439/uitextfield-for-phone-number
////Fun fact: I rewrote this in Swift and submitted to link above
-(NSString*) formatPhoneNumber:(NSString*) simpleNumber deleteLastChar:(BOOL)deleteLastChar
{
    if(simpleNumber.length==0) return @"";
    // use regex to remove non-digits(including spaces) so we are left with just the numbers
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];

    // check if the number is to long
    if(simpleNumber.length>10) {
        // remove last extra chars.
        simpleNumber = [simpleNumber substringToIndex:10];
    }

    if(deleteLastChar) {
        // should we delete the last digit?
        simpleNumber = [simpleNumber substringToIndex:[simpleNumber length] - 1];
    }

    // 123 456 7890
    // format the number.. if it's less then 7 digits.. then use this regex.
    if(simpleNumber.length<7)
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d+)"
                                                               withString:@"($1) $2"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];

    else   // else do this one..
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{3})(\\d+)"
                                                               withString:@"($1) $2-$3"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    return simpleNumber;
}
@end

//
//  PhoneEntryViewController.m
//  BaeWatch
//
//  Created by Vik Denic on 5/26/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "PhoneEntryViewController.h"
#import <AddressBook/AddressBook.h>

@interface PhoneEntryViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;

@end

@implementation PhoneEntryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];

    [self addressBook];
}

- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender
{
    if (self.phoneTextField.text.length == 14)
    {
        Profile *currentProfile = [[UniversalProfile sharedInstance] profile];
        [currentProfile setPhoneNumber:self.phoneTextField.text];
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

-(void)addressBook
{
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);

    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (!granted){
            //4
            NSLog(@"Just denied");
            return;
        }
        //5
        NSLog(@"Just authorized");
        [self listPeopleInAddressBook:addressBook];
    });
}

- (void)listPeopleInAddressBook:(ABAddressBookRef)addressBook
{
    NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    NSInteger numberOfPeople = [allPeople count];

    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];

//        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
//        NSString *lastName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
//        NSLog(@"Name:%@ %@", firstName, lastName);

        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);

        CFIndex numberOfPhoneNumbers = ABMultiValueGetCount(phoneNumbers);
        for (CFIndex i = 0; i < numberOfPhoneNumbers; i++)
        {
            NSString *phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
            NSString *trimmedNumber = [[phoneNumber componentsSeparatedByCharactersInSet:
                                    [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                   componentsJoinedByString:@""];
            if ([trimmedNumber hasPrefix:@"1"] && [trimmedNumber length] > 1)
            {
                trimmedNumber = [trimmedNumber substringFromIndex:1];
            }
            NSLog(@"  phone:%@", trimmedNumber);
        }

        CFRelease(phoneNumbers);

        NSLog(@"=============================================");
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

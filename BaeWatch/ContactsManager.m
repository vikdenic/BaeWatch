//
//  ContactsManager.m
//  BaeWatch
//
//  Created by Vik Denic on 6/3/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import "ContactsManager.h"

@implementation ContactsManager

+(void)requestContactsAccess:(void (^)(BOOL success, ABAddressBookRef addressBook, CFErrorRef error))completionHandler
{
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);

    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (!granted)
        {
            NSLog(@"Just denied");
            completionHandler(NO, addressBook,error);
        }

        NSLog(@"Just authorized");
        completionHandler(YES, addressBook, error);
    });
}

+(void)listPeopleInAddressBook:(ABAddressBookRef)addressBook withCompletion:(void (^)(NSArray *numbers))completionHandler
{
    NSMutableArray *numbersArray = [NSMutableArray new];

    NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    NSInteger numberOfPeople = [allPeople count];

    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];

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
            [numbersArray addObject:trimmedNumber];
        }
        CFRelease(phoneNumbers);
    }
    completionHandler(numbersArray);
}

+(void)findProfilesFromNumbers:(NSArray *)numbers withCompletion:(void (^)(NSArray *profiles))completionHandler
{
    // Using PFQuery
    PFQuery *profileQuery = [PFQuery queryWithClassName:@"Profile"];
    [profileQuery includeKey:@"user"];

    [profileQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        NSMutableArray *matches = [NSMutableArray new];

        for (Profile *profile in objects)
        {
            if ([numbers containsObject:profile.phoneNumber])
            {
                [matches addObject:profile];
            }
        }
        completionHandler(matches);
    }];
}

+(void)createsFollowsFromProfiles:(NSArray *)profiles withCompletion:(void (^)(BOOL succeeded))completionHandler
{
    for (Profile *profile in profiles)
    {
        Activity *newFollow = [[Activity alloc] initFromUser:[UniversalProfile sharedInstance].profile toUser:profile type:kActivityTypeFollow];
        [newFollow saveInBackground];
    }
    completionHandler(YES);
}

@end

//
//  ContactsManager.h
//  BaeWatch
//
//  Created by Vik Denic on 6/3/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface ContactsManager : NSObject

+(void)requestContactsAccess:(void (^)(BOOL success, ABAddressBookRef addressBook, CFErrorRef error))completionHandler;
+(void)listPeopleInAddressBook:(ABAddressBookRef)addressBook withCompletion:(void (^)(NSArray *numbers))completionHandler;
+(void)findProfilesFromNumbers:(NSArray *)numbers withCompletion:(void (^)(NSArray *profiles))completionHandler;
+(void)createsFollowsFromProfiles:(NSArray *)profiles;

@end

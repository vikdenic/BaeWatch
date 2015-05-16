//
//  UniversalProfile.h
//  BaeWatch
//
//  Created by Vik Denic on 5/16/15.
//  Copyright (c) 2015 nektar labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UniversalProfile : NSObject {
    Profile *profile;
}

@property (nonatomic, retain) Profile *profile;

+ (UniversalProfile *)sharedInstance;

@end

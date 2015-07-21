//
//  DivvyStation.h
//  CodeChallenge3
//
//  Created by Brittany Kimbrough on 6/3/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DivvyStation : NSObject

@property NSNumber *longitude;
@property NSNumber *latitude;
@property NSString *bikeSpots;
@property NSString *name;
@property NSString *address;

-(instancetype)initWithName:(NSString *)name address:(NSString *)address longitude:(NSNumber *)lng latitude:(NSNumber *)lat
                  bikeSpots:(NSString *)bikeSpots;


@end

//
//  DivvyStation.m
//  CodeChallenge3
//
//  Created by Brittany Kimbrough on 6/3/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "DivvyStation.h"

@implementation DivvyStation

-(instancetype)initWithName:(NSString *)name address:(NSString *)address longitude:(NSNumber *)lng latitude:(NSNumber *)lat
                  bikeSpots:(NSString *)bikeSpots {
    
    self = [super init]; {
    
        if (self) {
            self.name = name;
            self.address = address;
            self.latitude = lat;
            self.longitude = lng;
            self.bikeSpots = bikeSpots;
        }
        return self;
    }
}

@end

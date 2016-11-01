//
//  PHAEventStoring.m
//  PhunApp
//
//  Created by Samuel Cornejo on 11/1/16.
//  Copyright © 2016 Applaudo Studios. All rights reserved.
//

#import "PHAEventStoring.h"

@implementation PHAEventStoring

- (id)initWithMantleModel:(PHAEvent *)eventModel {
    self = [super init];
    
    if (!self) return nil;
    
    self.eventID = eventModel.eventID;
    self.eventDescription = eventModel.eventDescription;
    self.eventTitle = eventModel.eventTitle;
    self.imageURL = eventModel.imageURL;
    self.phoneNumber = eventModel.phoneNumber;
    self.eventDate = eventModel.eventDate;
    self.locationOne = eventModel.locationOne;
    self.locationTwo = eventModel.locationTwo;
    
    return self;
}

@end

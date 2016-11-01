//
//  PHAEventStoring.h
//  PhunApp
//
//  Created by Samuel Cornejo on 11/1/16.
//  Copyright © 2016 Applaudo Studios. All rights reserved.
//

#import <Realm/RLMObject.h>
#import "PHAEvent.h"

@interface PHAEventStoring : RLMObject

@property (strong, nonatomic) NSNumber *eventID;
@property (strong, nonatomic) NSString *eventDescription;
@property (strong, nonatomic) NSString *eventTitle;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSDate *eventDate;
@property (strong, nonatomic) NSString *locationOne;
@property (strong, nonatomic) NSString *locationTwo;

- (id)initWithMantleModel:(PHAEvent *)eventModel;

@end
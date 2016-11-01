//
//  PHAEventList.h
//  PhunApp
//
//  Created by Samuel Cornejo on 11/1/16.
//  Copyright © 2016 Applaudo Studios. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "PHAEvent.h"

@interface PHAEventList : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSArray *events;

@end

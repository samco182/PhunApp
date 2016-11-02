//
//  PHASpotlightHelper.h
//  PhunApp
//
//  Created by Samuel Cornejo on 11/1/16.
//  Copyright © 2016 Applaudo Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/RLMResults.h>
#import "PHAEventStoring.h"
#import <MobileCoreServices/MobileCoreServices.h>
@import CoreSpotlight;

@interface PHASpotlightHelper : NSObject

- (void)indexIntoSpotlight:(RLMResults *)events;

@end

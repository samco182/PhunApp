//
//  PHAEventList.m
//  PhunApp
//
//  Created by Samuel Cornejo on 11/1/16.
//  Copyright © 2016 Applaudo Studios. All rights reserved.
//

#import "PHAEventList.h"

@implementation PHAEventList

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"events" : @"response"
             };
}

#pragma mark - JSON Transformer

+ (NSValueTransformer *)eventsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:PHAEvent.class];
}

@end

//
//  PHAEvent.m
//  PhunApp
//
//  Created by Samuel Cornejo on 11/1/16.
//  Copyright © 2016 Applaudo Studios. All rights reserved.
//

#import "PHAEvent.h"

@implementation PHAEvent

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM dd, yyyy 'at' HH:mm";
    return dateFormatter;
}

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"eventID": @"id",
             @"eventDescription": @"description",
             @"eventTitle": @"title",
             @"imageURL": @"image",
             @"phoneNumber": @"phone",
             @"eventDate": @"date",
             @"locationOne": @"locationline1",
             @"locationTwo": @"locationline2"
             };
}

#pragma mark - JSON Transformers

+ (NSValueTransformer *)eventDateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success,
                                                                 NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

@end

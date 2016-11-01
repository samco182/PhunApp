//
//  PHADataFetcher.h
//  PhunApp
//
//  Created by Samuel Cornejo on 10/31/16.
//  Copyright © 2016 Applaudo Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "PHAEventList.h"

@interface PHADataFetcher : NSObject

- (void)getDataFromURL:(NSString *)URLString onSuccess:(void(^)(PHAEventList *response))success failure:(void (^)(NSError *error))failure;

@end

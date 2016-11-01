//
//  PHADataFetcher.h
//  PhunApp
//
//  Created by Samuel Cornejo on 10/31/16.
//  Copyright © 2016 Applaudo Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface PHADataFetcher : NSObject

- (void)getDataFromURL:(NSString *)URLString onSuccess:(void(^)(id responseObject))success;

@end

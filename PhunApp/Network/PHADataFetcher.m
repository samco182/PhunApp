//
//  PHADataFetcher.m
//  PhunApp
//
//  Created by Samuel Cornejo on 10/31/16.
//  Copyright © 2016 Applaudo Studios. All rights reserved.
//

#import "PHADataFetcher.h"

@implementation PHADataFetcher

- (void)getDataFromURL:(NSString *)URLString onSuccess:(void (^)(id responseObject))success{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    ((AFHTTPResponseSerializer *)manager.responseSerializer).acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"Error: %@", error);
                                                    } else {
                                                        success(responseObject);
                                                    }
                                                }];
    [dataTask resume];
}

@end

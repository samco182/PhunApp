//
//  PHADataFetcher.m
//  PhunApp
//
//  Created by Samuel Cornejo on 10/31/16.
//  Copyright © 2016 Applaudo Studios. All rights reserved.
//

#import "PHADataFetcher.h"

@implementation PHADataFetcher

- (void)getDataFromURL:(NSString *)URLString
             onSuccess:(void (^)(PHAEventList *response))success
               failure:(void (^)(NSError *error))failure {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    ((AFHTTPResponseSerializer *)manager.responseSerializer).acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    if (!error) {
                                                        NSDictionary *responseDictionary = @{@"response" : (NSArray *)responseObject};
                                                        PHAEventList *list = [MTLJSONAdapter modelOfClass:PHAEventList.class
                                                                                       fromJSONDictionary:responseDictionary
                                                                                                    error:&error];
                                                        success(list);
                                                    } else {
                                                        failure(error);
                                                    }
                                                }];
    [dataTask resume];
}

@end

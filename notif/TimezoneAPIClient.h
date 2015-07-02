//
//  TimezoneAPIClient.h
//  notif
//
//  Created by Eunice Saldivar on 7/1/15.
//  Copyright (c) 2015 jumpdigital. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

extern NSString * const timeAPIKey;
extern NSString * const timeBaseURLString;

@interface TimezoneAPIClient : AFHTTPSessionManager

+ (TimezoneAPIClient *)sharedClient;

- (void)getTimeForZone:(NSString *)zone
               success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
               failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end

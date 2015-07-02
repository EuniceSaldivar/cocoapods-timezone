//
//  TimezoneAPIClient.m
//  notif
//
//  Created by Eunice Saldivar on 7/1/15.
//  Copyright (c) 2015 jumpdigital. All rights reserved.
//

#import "TimezoneAPIClient.h"

NSString * const timeAPIKey = @"3XAOGOH2AGT7";
NSString * const timeBaseURLString = @"http://api.timezonedb.com";

@implementation TimezoneAPIClient

+ (TimezoneAPIClient *)sharedClient {
    static TimezoneAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:timeBaseURLString]];
    });
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    return self;
}

- (void)getTimeForZone:(NSString *)zone
               success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
               failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;
{
    //    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateFormat = @"yyyyMMdd";
    //    NSString* dateString = [formatter stringFromDate:date];
    //    [AFJSONResponseSerializer acceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSString* path = [NSString stringWithFormat:@"%@/?zone=%@&format=json&key=%@",
                      timeBaseURLString, zone, timeAPIKey];
    
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

@end
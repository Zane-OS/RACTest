//
//  FRPApi.m
//  FunctionalReativePixels
//
//  Created by Zane wang on 2018/7/27.
//  Copyright © 2018年 Zane wang. All rights reserved.
//

#import "FRPApi.h"

@implementation FRPApi

- (NSString *)baseUrl {
    return @"https://www.apiopen.top/meituApi";
}

- (id)requestArgument {
    return @{@"page":@1};
}

//- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary {
//    NSMutableDictionary *dict = @{}.mutableCopy;
//    [dict setValue:@"application/json; encoding=utf-8" forKey:@"Content-Type"];
//    [dict setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" forKey:@"Accept"];
//    return dict;
//}

- (NSTimeInterval)requestTimeoutInterval {
    return 5;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)jsonValidator {
    NSInteger statusCode = [self responseStatusCode];
    if (statusCode>400 && statusCode<500) {
        switch (statusCode) {
            case 401: {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LogoutConstrait" object:self.error];
            }
                break;
            case 403: {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SystemHandleConstrait" object:@{@"statusCode":@"403",@"desc":@"无权限"}];
            }
                break;
            default: {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SystemHandleConstrait" object:@{@"statusCode":@"405",@"desc":@"服务器错误"}];
            }
                break;
        }
        // 返回一个不用的key就行
        return @{@"abcxxx":[NSObject class]};
    } else {
        return @{
                 @"message" : [NSString class],
                 @"result" : [NSString class],
                 };
    }
}


- (void)startWithRACSubscriber:(id<RACSubscriber>)subscriber {
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *responseDict = request.responseJSONObject;
        
        if ([[responseDict valueForKey:@"result"] isEqualToString:@"FAIL"]) {
            NSError *error = [NSError errorWithDomain:DZErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey:[responseDict valueForKey:@"message"]}];
            [subscriber sendError:error];
        } else {
            [subscriber sendNext:responseDict];
            [subscriber sendCompleted];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [subscriber sendError:request.error];
    }];
}

@end

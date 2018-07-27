//
//  FRPSever.m
//  FunctionalReativePixels
//
//  Created by Zane wang on 2018/7/27.
//  Copyright © 2018年 Zane wang. All rights reserved.
//

#import "FRPSever.h"
#import "FRPApi.h"

@implementation FRPSever

- (RACSignal *)getData {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        FRPApi *api = [FRPApi new];
        [api startWithRACSubscriber:subscriber];
        return nil;
    }];
}

@end

//
//  FRPViewModel.m
//  FunctionalReativePixels
//
//  Created by Zane wang on 2018/7/27.
//  Copyright © 2018年 Zane wang. All rights reserved.
//

#import "FRPViewModel.h"
#import "FRPSever.h"
#import "FRPModel.h"

@implementation FRPViewModel

- (instancetype)initWithSignal:(RACSignal *)signal {
    if (self = [super init]) {
        self.sever = [FRPSever new];
        self.dataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [self.sever getData];
        }];
        [[self.dataCommand.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
            NSLog(@"xxx>>>%@",x);
        }];
        [self.dataCommand.errors subscribeNext:^(NSError * _Nullable x) {
            NSLog(@"xxx>>>%@",x);
        }];
    }
    return self;
}

@end

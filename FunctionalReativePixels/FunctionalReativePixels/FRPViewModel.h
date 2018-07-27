//
//  FRPViewModel.h
//  FunctionalReativePixels
//
//  Created by Zane wang on 2018/7/27.
//  Copyright © 2018年 Zane wang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FRPModel;
@class FRPSever;

@interface FRPViewModel : NSObject

@property (nonatomic, strong) FRPSever *sever;
@property (nonatomic, strong) NSArray <FRPModel *> *modelList;
@property (nonatomic, strong) RACCommand *dataCommand;
@property (nonatomic, strong) NSError *error;

- (instancetype)initWithSignal:(RACSignal *)signal;

@end

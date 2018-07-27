//
//  FRPApi.h
//  FunctionalReativePixels
//
//  Created by Zane wang on 2018/7/27.
//  Copyright © 2018年 Zane wang. All rights reserved.
//

#import "YTKRequest.h"

@interface FRPApi : YTKRequest

- (void)startWithRACSubscriber:(id<RACSubscriber>)subscriber;

@end

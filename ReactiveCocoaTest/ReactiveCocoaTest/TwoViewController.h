//
//  TwoViewController.h
//  ReactiveCocoaTest
//
//  Created by Zane wang on 2018/8/20.
//  Copyright © 2018年 Zane wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoViewController : UIViewController

@property (nonatomic, strong) RACSubject *delegateSubject;
@property (nonatomic, copy) void(^delegateBlock)(NSNumber *);

@end

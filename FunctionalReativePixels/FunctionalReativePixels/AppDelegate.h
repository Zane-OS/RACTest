//
//  AppDelegate.h
//  FunctionalReativePixels
//
//  Created by Zane wang on 2018/7/27.
//  Copyright © 2018年 Zane wang. All rights reserved.
// https://500px.com/editors

#import <UIKit/UIKit.h>
#import "FRPViewModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, readonly) FRPViewModel *viewModel;

@end


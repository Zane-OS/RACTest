//
//  AppDelegate.m
//  RXCollectionsTest
//
//  Created by Zane wang on 2018/7/25.
//  Copyright © 2018年 Zane wang. All rights reserved.
//

#import "AppDelegate.h"
#import <RXCollections/RXCollection.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self test1];
    return YES;
}

- (void)test1 {
    
    NSArray *array = @[@1,@2,@3];
    NSArray *mappedArray = [array rx_mapWithBlock:^id(id each) {
        /*
         * 将array中元素的值分别平方后存入新的数组
         */
        return @(pow([each integerValue], 2));
    }];
    NSLog(@"\n********************\n --->> %@\n********************",mappedArray);
    
    
    NSArray *filteredArray = [array rx_filterWithBlock:^BOOL(id each) {
        /*
         * 将array中的元素按条件放入新数组
         */
        return ([each integerValue] % 2 == 0);
    }];
    NSLog(@"\n********************\n --->> %@\n********************",filteredArray);
    
    NSNumber *sum = [array rx_foldWithBlock:^id(id memo, id each) {
        /*
         * 遍历array操作
         */
        return @([memo integerValue] + [each integerValue]);
    }];
    NSLog(@"\n********************\n --->> %@\n********************",sum);
    
    NSString *appendstr = [[array rx_mapWithBlock:^id(id each) {
        /*
         * 转换string值
         */
        return [each stringValue];
    }] rx_foldInitialValue:@"" block:^id(id memo, id each) {
        /*
         * 拼接折叠
         */
        return [memo stringByAppendingString:each];
    }];
    NSLog(@"\n********************\n --->> %@\n********************",appendstr);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

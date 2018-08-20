//
//  ViewController.m
//  ReactiveCocoaTest
//
//  Created by Zane wang on 2018/8/20.
//  Copyright © 2018年 Zane wang. All rights reserved.
//

// [st](https://www.jianshu.com/p/87ef6720a096)

#import "ViewController.h"
#import "TwoViewController.h"
#import "Dic_To_Object.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self rac_signalTest];
//    [self rac_subjectTest];
//    [self rac_replaySubject];
    [self rac_tuple];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)nextPage:(UIBarButtonItem *)sender {
    [self subject_replaceDelegate];
}

#pragma mark - RACSignal使用步骤:
- (void)rac_signalTest {
    
    // RACSignal使用步骤:
    /*
     * 1、创建信号
     * + (RACSignal *)createSignal:<#^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber)didSubscribe#>
     * 2、订阅信号，才会激活信号
     * - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
     * 3、发送信号
     * - (void)sendNext:(id)value
     */
    
    // RACSignal的底层实现
    /*
     * 1、创建信号，首先把didSubscribe保存到信号中，还不会触发。
     * 2、当信号被订阅，也就是调用signal的subscribeNext:nextBlock。
     subscribeNext内部会创建订阅者subscriber，并把nextBlock保存到subscriber中。
     subscribeNext内部会调用signal的didSubscribe
     * 3、signal的didSubscribe中调用[subscriber sendNext:@1];
     sendNext底层其实就是执行subscriber的nextBlock
     */
    
    // 1、创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // block 调用时刻：每当有订阅者订阅信号，就会调用blcok
        
        // 2、发送信号
        /*@2*/  [subscriber sendNext:@1];
        
        // 如果不再发送数据，最好发送数据完成，内部会自动调用[RACDisposable disposable]取消信号订阅。
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            /*@4*/     NSLog(@"---->>  信号销毁了！！！");
        }];
    }];
    
    // 3、订阅信号，才会激活信号。
    /*@1*/[signal subscribeNext:^(id  _Nullable x) {
        // block调用时刻：每当信号发出数据，就会调用block。
        /*@3*/         NSLog(@"---->> 接收到数据：%@",x);
    }];
    
}

# pragma mark - RACSubject简单使用:
- (void)rac_subjectTest {
    
    // RACSubject简单使用:
    
    // RACSubject使用步骤
    /*
     * 1、创建信号：[RACSubject subject]，跟RACSignal不一样，创建信号时没有block。
     * 2、订阅信号：- (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock。
     * 3、发送信号：sendNext:(id)value。
     *
     */
    
    /*
     * RACSubject:底层实现和RACSignal不一样。
     * 1、调用subscribeNext订阅信号，只是吧订阅者保存起来，并且订阅者的nextBlock已经赋值了。
     * 2、调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个个调用订阅者的nextBlock。
     */
    
    // 1、创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2、订阅信号
    [subject subscribeNext:^(id  _Nullable x) {
       // block调用时刻：当信号发出新值，就会调用。
        NSLog(@"---->> 第一个订阅者%@",x);
    }];
    
    [subject subscribeNext:^(id  _Nullable x) {
        // block调用时刻：当信号发出新值，就会调用。
        NSLog(@"---->> 第二个订阅者%@",x);
    }];
    
    //3、发送信号
    [subject sendNext:@"1"];
    
}

#pragma mark - RACReplaySubject简单使用:
- (void)rac_replaySubject {
    
    //RACReplaySubject简单使用:
    
    //RACReplaySubject使用步骤:
    /*
     * 1、创建信号[RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
     * 2、可以先订阅信号，也可以先发送信号。
     * 3、订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock。
     * 4、发送信号 sendNext:(id)value。
     */
    
    // RACReplaySubject:底层实现和RACSubject不一样。
    /*
     * 1、调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
     * 2、调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock。
     * 3、如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。（也就是先保存值，在订阅值。）
     *
     */
    
    // 1、创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    // 2、发送信号
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
    // 3、订阅信号
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"---->> 第一个订阅者%@",x);
    }];
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"---->> 第二个订阅者%@",x);
    }];
}

#pragma mark - RAC使用replaceDelegate
- (void)subject_replaceDelegate {
    
    // 需求:
    // 1.给当前控制器添加一个按钮，push到另一个控制器界面
    // 2.另一个控制器view中有个按钮，点击按钮，通知当前控制器
    TwoViewController *vc = [[TwoViewController alloc] init];
    [vc.delegateSubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"---->> sub 点击了two——page!!!");
    }];
    vc.delegateBlock = ^(NSNumber *x) {
        NSLog(@"---->> blo 点击了two——page!!!");
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - RACTuple元组类
- (void)rac_tuple {
    
    //RACTuple简单使用：
    // 1、遍历数组
    NSArray *numbers = @[@1,@2,@3,@4];
    
    // 第一步：把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步：把集合RACSequence转换RACSignal信号类，numbers.rac_sequence.signal
    // 第三步：订阅信号，激活信号，自动把集合中的所有值，遍历出来。
    [numbers.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"---->> %@",x);
    }];
    
    // 2、遍历字典，遍历出来的键值对会包装成RACTuple（元组对象）
    NSDictionary *dict = @{@"name":@"zzw", @"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        // 解包元组
        RACTupleUnpack(NSString *key, NSString *value) = x;
        NSLog(@"---->> \nkey=%@\nvalue=%@",key, value);
    }];
    
    // 3、字典转模型
    // rac 写法
    NSArray *dictArr = @[@{@"name":@"zzw", @"age":@18},
                         @{@"name":@"ztr", @"age":@18},
                         @{@"name":@"zdd", @"age":@18}];
    NSMutableArray __block *tempArr = @[].mutableCopy;
    [dictArr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        [tempArr addObject:[Dic_To_Object modelWithDict:x]];
    }];
    // rac 高级写法
    NSArray *models = [[dictArr.rac_sequence.signal map:^id _Nullable(id  _Nullable value) {
        return [Dic_To_Object modelWithDict:value];
    }] toArray];
    NSLog(@"---->> %@",models);
}

@end

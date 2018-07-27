//
//  ViewController.m
//  RXCollectionsTest
//
//  Created by Zane wang on 2018/7/25.
//  Copyright © 2018年 Zane wang. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *testTF;
@property (weak, nonatomic) IBOutlet UIButton *testBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test4];
    // Do any additional setup after loading the view, typically from a nib.
}

/*
 * 流和序列
 * 流是值的序列化的抽象，你可以认为“流就像一条水管，而值就会死流淌在水管中的水，值从管道的一段流入从另一端流出”。
 * 在此过程中我们可以读取过去的所有值，甚至是刚刚进入管道的值（即当前值）。
 */
- (void)test1 {
    NSArray * array = @[@1,@2,@3];
    RACSequence * stream = [array rac_sequence];
    //sequence 是两种特定类型的流， 实际上RACSequence 是RACStream的子类。
    stream = [stream map:^id _Nullable(id  _Nullable value) {
        //将流中的值平方
        NSLog(@"\n--------\n --->>%@\n---------",value);

        return @(pow([value integerValue], 3));
    }];
    //再将流转化为数组输出
    NSArray * streamArray = [stream array];
    NSLog(@"\n--------\n --->>%@\n---------",streamArray);
    
    //将一个序列流合并为单个值
    NSString * streamStr = [[stream map:^id _Nullable(id  _Nullable value) {
        return [value stringValue];
    }] foldLeftWithStart:@"" reduce:^id _Nullable(id  _Nullable accumulator, id  _Nullable value) {
        return [accumulator stringByAppendingString:value];
    }];
    NSLog(@"\n--------\n --->>%@\n---------",streamStr);
}


/*
 * 信号
 * 信号是另一种流，与顺序流相反，信号是 push-driven 的。
 * 新值能通过管道发布但是不能像 pull-driven 一样在管道中获取。
 * push-driven : 在创建信号的时候，信号不会被立即赋值（滞后某个时刻复制类似于网络请求的resp）
 * pull-driven : 在创建信号的同时序列中的值会被确定下来，我我们可以从流中获取
 *
 * 信号发送三种类型的值 （注意：一个事件响应发送了一个Error或者Completion就不会再发送其他任何value）
 * Next Value ：代表下一个发送到管道内的值
 * Error Value ：代表信号Signal无法完成
 * Completion Value ：代表信号Signal完成
 *
 * 信号是ReactiveCocoa的核心组件之一，ReactiveCocoa为UIKit的每一个控件内置了一套信号选择器
 */


/*
 * 订阅
 * 当你想知道某一个值的改变（不管是next、error、completion）, 你就需要订阅流（一种常见的信号）。
 * 
 *
 *
 *
 */
- (void)test2 {
    //以下是订阅的代码
    /*
     [[self.testTF.rac_textSignal skip:1] subscribeNext:^(NSString * _Nullable x) {
     //next
     NSLog(@"next value ==>> %@", x);
     } error:^(NSError * _Nullable error) {
     //error
     NSLog(@"error ==>> %@",error);
     } completed:^{
     //compl
     NSLog(@"completion !!");
     }];
     */

    //因为这个特殊的信号不会发送错误的值，仅仅在释放的时候发送一个完成的值，所以error和completed这两个订阅通常不会被调用，可以简写为：
    /*
     * 当你订阅一个信号的时候，实际上创建了一个订阅着，它是自动保留的，并同时保留它订阅的信号。
     * 你可以指定这个订阅着，但这不是一种典型的行为。
     */
    [[self.testTF.rac_textSignal skip:1] subscribeNext:^(NSString * _Nullable x) {
        //next
        NSLog(@"next value ==>> %@", x);
    }];
}

/*
 * 状态推导
 * 它是ReactiveCocoa的另一个核心组件，这里并非指的是类的某个属性（调用属性的set方法代表状态改变❌），这里我们指的是把属性抽象为流
 * 下边我们设置一个场景：
 * 假设上边视图是用来创建账户的，当且仅当textfield的文本是包涵@的email地址的时候按钮可以点击，并且我们希望textfield中text的颜色给用户提供一个反馈。
 */
- (void)test3 {
    /*
     RAC(self.testBtn,enabled) = [[self.testTF.rac_textSignal skip:1] map:^id _Nullable(NSString * _Nullable value) {
     return @([value rangeOfString:@"@"].location != NSNotFound);
     }];
     */
    //以上代码仅仅完成了交互行的绑定，但我们要实现的包括文字颜色的修改，那我们该怎么办呢？具体操作如下：
    RACSignal *validEmailSignal = [self.testTF.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        BOOL hasat = [value rangeOfString:@"@"].location != NSNotFound;
        BOOL hascom = [value rangeOfString:@".com"].location != NSNotFound;
        return @(hasat && hascom);
    }];
    RAC(self.testBtn, enabled) = validEmailSignal;
    RAC(self.testTF, textColor) = [validEmailSignal map:^id _Nullable(id  _Nullable value) {
        if ([value boolValue]) {
            return [UIColor greenColor];
        } else {
            return [UIColor redColor];
        }
    }];
}

/*
 * 指令：
 * RACCommand类的代表，创建并订阅动作的信号相应，可以很容易的实现用户交互的边界效果（交互过程中的条件判断）。
 * 指令（行为触发的）通常是UI驱动的，指令也可以通过信号自动禁用，这种禁用的状态呈现在UI上就是禁用与该指令相关的任何操作。
 * 因此，使用状态推导实现的按钮交互状态并不是最佳实现，因为ReactiveCocoa为UIButton增加了一个类别可以绑定指令。
 */
- (void)test4 {
    RACSignal *validEmailSignal = [self.testTF.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        BOOL hasat = [value rangeOfString:@"@"].location != NSNotFound;
        BOOL hascom = [value rangeOfString:@".com"].location != NSNotFound;
        return @(hasat && hascom);
    }];
    self.testBtn.rac_command = [[RACCommand alloc] initWithEnabled:validEmailSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
    
        NSLog(@"button was pressed !");
        return [RACSignal empty];
    }];
}

/*
 * RACSubject
 * 它是一种有趣的信号类型，它是一个你可以主动发送新值的信号，（出于这个原因，不推荐使用）。
 */


/*
 * 热信号与冷信号
 * 信号是典型的懒鬼，除非有人订阅，否则它们不会启动并发送，每添加一个订阅，它们就会多发送一个信号，这种信号被称为“冷信号”。
 * 有时候我们希望让信号立即工作，这种信号我们称为“热信号”。
 */

/*
 * 组播
 * 是用于多个订阅着订阅同一个信号的术语。
 * 信号默认是冷的，但是往往我们不希望一个冷信号在每次被订阅的时候工作。
 * 因此，从这样的信号中创建一个RACMulticastConnection,不如使用RACSignal的publish或multicast:方法，两者都为您创建一个组播链接，但后者需要一个RACSubject参数，当它被调用的时候这个RACSubject可以通过底层信号发送一个值来，任何一个对这个只有兴趣，都可以用这个底层信号发送一个值到链接的信号来替代你提供的RACSubject，这信号恰好就等同于你这个RACSubject。
 
 */

@end

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

@property (nonatomic, strong) RACCommand *command;
@property (weak, nonatomic) IBOutlet UIView *redV;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self rac_signalTest];
//    [self rac_subjectTest];
//    [self rac_replaySubject];
//    [self rac_tuple];
//    [self rac_command];
    [self rac_use];
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

#pragma mark - RAC使用replaceDelegate:
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

#pragma mark - RACTuple元组类和RACSequence集合类的简单使用：
- (void)rac_tuple {
    
    //RACTuple和RACSequence的简单使用：
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

#pragma mark - RACCommand处理事件的类的简单使用：
- (void)rac_command {
    
    // 使用场景：监听按钮的点击，网络请求
    /*
     // 1、RACCommand使用步骤
          创建命令 - initWithSignalBlock:<#^RACSignal * _Nonnull(id  _Nullable input)signalBlock#>
          在signalBlock中，创建RACSignal，并作为signalBlock的返回值。
          执行命令 - (RACSignal *)execute:(id)input
     // 2、RACCommand使用注意
          signalBlock必须返回一个信号，不能穿nil。
          如果不想传递信号，直接创建空信号return [RACSignal empty];
          RACCommand中的信号数据传递完成必须调用[subscriber sendCompleted]结束命令执行。
          RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。
     // 3、RACCommand设计思想
          在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
          当RACCommand内部请求结束后，需要把请求的结果传递给外界，这个时候就需要signalBlock返回的信号来传递。
     // 4、如何拿到RACCommand中返回的信号发出的数据
          RACCommand有个执行信号源executionSignals，这个是signal of signals（信号的信号），意思是信号发出的是信号，不是普通的类型。
          订阅executionSignals就能拿到RACCommand中的信号，然后订阅signalBlock返回的信号，就能获取信号发出的值。
     // 5、监听当前命令是否正在执行executing
     // 6、RACCommand使用场景，监听按钮点击/网络请求
     */
   
    
    // 1、创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        NSLog(@"---->> 执行命令");
        // 如果要创建空信号，必须返回信号 return [RACSignal empty];
        
        // 2、创建信号，用来传递数据
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [subscriber sendNext:@"request network"];
            
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    _command = command; //强引用，保持不被销毁，否则接收不到数据。
    
    // 3、订阅RACCommand中的信号
    [command.executionSignals subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(id  _Nullable y) {
            NSLog(@"---->> \n接收到的信号%@\n信号发送的内容%@",x,y);
        }];
    }];
    // RAC高级用法
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"---->> \n信号发送的内容%@",x);
    }];
    
    // 4、监听命令是否执行完毕，默认会来一次，可以直接跳过，skip表示跳过一次信号。
    [[command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue] == YES) {
            // 正在执行
        } else {
            // 执行完毕
        }
    }];
    
    // 5、执行命令
    [self.command execute:@1];
}

#pragma mark - RACMulticastConnection简单使用:
- (void)rac_multicastConnection {
    
    // RACMulticastConnection避免多次订阅导致多次调用创建信号中的block造成的副作用。
    // RACMulticastConnection使用步骤：
    /*
     * 1、创建信号+ (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe。
     * 2、创建连接 RACMulticastConnection *connect = [signal publish];
     * 3、订阅信号,注意：订阅的不在是之前的信号，而是连接的信号。 [connect.signal subscribeNext:nextBlock];
     * 4、连接 [connect connect]
     */
    
    // RACMulticastConnection底层原理：
    /*
     * 1、创建connect，connect.sourceSignal -> RACSignal(原始信号)  connect.signal -> RACSubject
     * 2、订阅connect.signal，会调用RACSubject的subscribeNext，创建订阅者，而且把订阅者保存起来，不会执行block。
     * 3、[connect connect]内部会订阅RACSignal(原始信号)，并且订阅者是RACSubject
          订阅原始信号，就会调用原始信号中的didSubscribe
          didSubscribe，拿到订阅者调用sendNext，其实是调用RACSubject的sendNext
     * 4、RACSubject的sendNext,会遍历RACSubject所有订阅者发送信号。
          因为刚刚第二步，都是在订阅RACSubject，因此会拿到第二步所有的订阅者，调用他们的nextBlock
     *
     */
    
    // 需求：假设在一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求。
    // 解决：使用RACMulticastConnection就能解决.
    
    /*
     // 1、创建信号
     RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
     NSLog(@"send request");
     return nil;
     }];
     // 2、订阅信号
     [signal subscribeNext:^(id  _Nullable x) {
     NSLog(@"received request results");
     }];
     // 2、订阅信号
     [signal subscribeNext:^(id  _Nullable x) {
     NSLog(@"received request results");
     }];
     // 3、执行结果：订阅多少次就会输出多少次的send request
     */
    
    // RACMulticastConnection:解决重复请求问题
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"send request");
        [subscriber sendNext:@1];
        return nil;
    }];
    // 2.创建连接
    RACMulticastConnection *connect = [signal publish];
    // 3.订阅信号，
    // 注意：订阅信号，也不能激活信号，只是保存订阅者到数组，必须通过连接,当调用连接，就会一次性调用所有订阅者的sendNext:
    [connect.signal subscribeNext:^(id  _Nullable x) {
          NSLog(@"订阅者一信号");
    }];
    [connect.signal subscribeNext:^(id  _Nullable x) {
          NSLog(@"订阅者二信号");
    }];
    // 4.连接,激活信号
    [connect connect];
}

#pragma mark - RAC补充：
/*
  RACScheduler:RAC中的队列，用GCD封装的。
 
  RACUnit :表⽰stream不包含有意义的值,也就是看到这个，可以直接理解为nil.
 
  RACEvent: 把数据包装成信号事件(signal event)。它主要通过RACSignal的-materialize来使用，然并卵。
 */
/*
  ReactiveCocoa开发中常见用法。
 
   代替代理:
 rac_signalForSelector：用于替代代理。
 
   代替KVO :
 rac_valuesAndChangesForKeyPath：用于监听某个对象的属性改变。
 
   监听事件:
 rac_signalForControlEvents：用于监听某个事件。
 
   代替通知:
 rac_addObserverForName:用于监听某个通知。
 
   监听文本框文字改变:
 rac_textSignal:只要文本框发出改变就会发出这个信号。
 
  处理当界面有多次请求时，需要都获取到数据时，才能展示界面
 rac_liftSelector:withSignalsFromArray:Signals:当传入的Signals(信号数组)，每一个signal都至少sendNext过一次，就会去触发第一个selector参数的方法。
 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。

 */
- (void)rac_use {
    
    // 1.代替代理
    // 需求：自定义redView,监听红色view中按钮点击
    // 之前都是需要通过代理监听，给红色View添加一个代理属性，点击按钮的时候，通知代理做事情
    // rac_signalForSelector:把调用某个对象的方法的信息转换成信号，就要调用这个方法，就会发送信号。
    // 这里表示只要redV调用btnClick:,就会发出信号，订阅就好了。
    [[_redV rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"点击红色按钮");
    }];
    
    // 2.KVO
    // 把监听redV的center属性改变转换成信号，只要值改变就会发送信号
    // observer:可以传入nil
    [[_redV rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
    // 3.监听事件
    // 把按钮点击事件转换为信号，点击按钮，就会发送信号
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"按钮被点击了");
    }];
    
    // 4.代替通知
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"键盘弹出");
    }];
    
    // 5.监听文本框的文字改变
    [_textField.rac_textSignal subscribeNext:^(id x) {
        
        NSLog(@"文字改变了%@",x);
    }];
    
    // 6.处理多个请求，都返回结果的时候，统一做处理.
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求1
        [subscriber sendNext:@"发送请求1"];
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];

}

// 更新UI
- (void)updateUIWithR1:(id)data r2:(id)data1 {
    NSLog(@"更新UI%@  %@",data,data1);
}

#pragma mark - ReactiveCocoa常见宏
- (void)rac_def {
    
    // RAC(TARGET, [KEYPATH, [NIL_VALUE]]):用于给某个对象的某个属性绑定。
    // 只要文本框文字改变，就会修改label的文字
    RAC(self.btn,titleLabel.text) = _textField.rac_textSignal;
    
    // RACObserve(self, name):监听某个对象的某个属性,返回的是信号。
    [RACObserve(self.view, center) subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // @weakify(Obj)和@strongify(Obj),一般两个都是配套使用,在主头文件(ReactiveCocoa.h)中并没有导入，需要自己手动导入，RACEXTScope.h才可以使用。但是每次导入都非常麻烦，只需要在主头文件自己导入就好了。
    
    // RACTuplePack：把数据包装成RACTuple（元组类）
    // 把参数中的数据包装成元组
    RACTuple *tuple1 = RACTuplePack(@10,@20);
    
    // RACTupleUnpack：把RACTuple（元组类）解包成对应的数据。
    // 把参数中的数据包装成元组
    RACTuple *tuple2 = RACTuplePack(@"xmg",@20);
    
    // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
    // name = @"xmg" age = @20
    RACTupleUnpack(NSString *name,NSNumber *age) = tuple2;
}

@end

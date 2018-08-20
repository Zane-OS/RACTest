//
//  TwoViewController.m
//  ReactiveCocoaTest
//
//  Created by Zane wang on 2018/8/20.
//  Copyright © 2018年 Zane wang. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController ()

@end

@implementation TwoViewController

- (RACSubject *)delegateSubject {
    if(!_delegateSubject){
        _delegateSubject = [RACSubject subject];
    }
    return _delegateSubject;
}

- (IBAction)notice:(id)sender {
    [self.delegateSubject sendNext:@1];
    self.delegateBlock(@1);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

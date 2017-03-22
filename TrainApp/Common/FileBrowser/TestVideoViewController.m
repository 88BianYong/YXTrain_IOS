//
//  TestVideoViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TestVideoViewController.h"

@interface TestVideoViewController ()

@end

@implementation TestVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 50, 100, 100);
    [button setTitle:@"正确" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.mutableDictionary[@"answer"] = @"0";
        [self dismissViewControllerAnimated:YES completion:^{
            BLOCK_EXEC(self.testVideoViewControllerBlock, YES);
        }];
    }];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(250, 50, 100, 100);
    button1.backgroundColor = [UIColor blueColor];
    [button1 setTitle:@"错误" forState:UIControlStateNormal];
    [[button1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.mutableDictionary[@"answer"] = @"1";
        [self dismissViewControllerAnimated:YES completion:^{
            BLOCK_EXEC(self.testVideoViewControllerBlock, NO);
        }];
    }];
    [self.view addSubview:button1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0) {
    return UIInterfaceOrientationMaskLandscapeRight;
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

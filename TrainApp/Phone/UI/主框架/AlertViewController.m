//
//  AlertViewController.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/12/8.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "AlertViewController.h"
#import "LSTAlertView.h"
@interface AlertViewController ()

@end

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"alertView";
    self.view.backgroundColor = [UIColor yellowColor];
    [self showlertWithTitle:@"测试一哈" imageName:@"胶卷"];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - show
- (void)showlertWithTitle:(NSString *)title imageName:(NSString *)imageName {
    LSTAlertView *alert = [[LSTAlertView alloc]init];
    alert.title = title;
    alert.imageName = imageName;
    [alert addButtonWithTitle:@"确定" style:LSTAlertActionStyle_Alone action:^{
        DDLogDebug(@"确定按钮点击了");
    }];
    [alert addButtonWithTitle:@"取消" style:LSTAlertActionStyle_Default action:^{
        DDLogDebug(@"取消按钮点击了");
    }];
    [alert show];
}
@end

//
//  YXWorkViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWorkViewController.h"
@interface YXWorkViewController ()
{
    
}
@end
@implementation YXWorkViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 100);
    button.backgroundColor = [UIColor redColor];
    button.center = self.view.center;
    [button addTarget:self action:@selector(gotoTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)gotoTest{
    NSString *string = @"YXVideoRecordViewController";
    UIViewController *VC = [[NSClassFromString(string) alloc] init];
    [[self visibleViewController] presentViewController:VC animated:YES completion:nil];
}
@end

//
//  YXTOWebViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXTOWebViewController.h"

@interface YXTOWebViewController ()

@end

@implementation YXTOWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [b setTitle:@"返回" forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont systemFontOfSize:16];
    [b addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:b];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneButtonTapped:(UIBarButtonItem *)item
{
    [self dismissViewControllerAnimated:YES completion:nil];
    SAFE_CALL(self.exitDelegate, browserExit);
}

@end

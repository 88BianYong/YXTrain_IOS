//
//  YXSideMenuViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXSideMenuViewController.h"
#import "YXTestPushViewController.h"
#import "YXDatumViewController.h"
#import "YXLoginViewController.h"


@interface YXSideMenuViewController ()

@end

@implementation YXSideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(20, 100, 60, 40)];
    [b setTitle:@"Push" forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)btnAction{
    YXLoginViewController *vc = [[YXLoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

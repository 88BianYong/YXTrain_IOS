//
//  YXProjectMainViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXProjectMainViewController.h"
#import "YXDrawerController.h"
#import "YXExamViewController.h"
#import "YXTaskViewController.h"
#import "YXNotificationViewController.h"
#import "YXBulletinViewController.h"
#import "YXProjectContainerView.h"

@interface YXProjectMainViewController ()

@end

@implementation YXProjectMainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [b setTitle:@"Menu" forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:b];
    self.navigationItem.leftBarButtonItem = item;
    
//    UIButton *testButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 100, 80, 50)];
//    [testButton setTitle:@"Test" forState:UIControlStateNormal];
//    [testButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [testButton addTarget:self action:@selector(testAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:testButton];
    
    YXProjectContainerView *containerView = [[YXProjectContainerView alloc]initWithFrame:self.view.bounds];
    YXExamViewController *examVC = [[YXExamViewController alloc]init];
    YXTaskViewController *taskVC = [[YXTaskViewController alloc]init];
    YXNotificationViewController *notiVC = [[YXNotificationViewController alloc]init];
    YXBulletinViewController *bulletinVC = [[YXBulletinViewController alloc]init];
    containerView.viewControllers = @[examVC,taskVC,notiVC,bulletinVC];
    [self.view addSubview:containerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)btnAction{
    [YXDrawerController showDrawer];
}

- (void)testAction{
    YXFileDocItem *item = [[YXFileDocItem alloc]init];
    item.name = @"测试测试";
    item.url = @"http://upload.ugc.yanxiu.com/getpdurl?id=12134349";
    [YXFileBrowseManager sharedManager].fileItem = item;
    [YXFileBrowseManager sharedManager].baseViewController = self;
    [[YXFileBrowseManager sharedManager]addFavorWithData:[NSObject new] completion:^{
        NSLog(@"Item favor success!");
    }];
    [[YXFileBrowseManager sharedManager] browseFile];
}

@end

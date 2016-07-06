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
#import "YXNoticeViewController.h"
#import "YXBulletinViewController.h"
#import "YXProjectContainerView.h"
#import "YXTrainListRequest.h"

@interface YXProjectMainViewController ()

@end

@implementation YXProjectMainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupRightWithTitle:@"测试"];
    
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    b.backgroundColor = [UIColor redColor];
    [b addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setupLeftWithCustomView:b];
    
    [self getProjectList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getProjectList{
    [self startLoading];
    WEAK_SELF
    [[YXTrainManager sharedInstance]getProjectsWithCompleteBlock:^(NSArray *projects, NSError *error) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            [self showToast:error.localizedDescription];
            return;
        }
        [self dealWithProjects:projects];
    }];
}

- (void)dealWithProjects:(NSArray *)projects{
    [YXTrainManager sharedInstance].currentProjectIndex = 0;
    YXTrainListRequestItem_body_train *train = projects.firstObject;
    self.title = train.name;
    YXProjectContainerView *containerView = [[YXProjectContainerView alloc]initWithFrame:self.view.bounds];
    YXExamViewController *examVC = [[YXExamViewController alloc]init];
    YXTaskViewController *taskVC = [[YXTaskViewController alloc]init];
    YXNoticeViewController *notiVC = [[YXNoticeViewController alloc]init];
    notiVC.flag = YXFlag_Notice;
    YXNoticeViewController *bulletinVC = [[YXNoticeViewController alloc]init];
    bulletinVC.flag = YXFlag_Bulletin;
    containerView.viewControllers = @[examVC,taskVC,notiVC,bulletinVC];
    [self.view addSubview:containerView];
}

- (void)naviRightAction{
    NSLog(@"right action！！！");
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

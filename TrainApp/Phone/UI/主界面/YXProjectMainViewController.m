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
@property (nonatomic, strong) YXTrainListRequest *request;
@property (nonatomic, strong) YXTrainListRequestItem *trainlistItem;
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
    
    [self getTrainList];
//    UIButton *testButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 100, 80, 50)];
//    [testButton setTitle:@"Test" forState:UIControlStateNormal];
//    [testButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [testButton addTarget:self action:@selector(testAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:testButton];
    
//    YXProjectContainerView *containerView = [[YXProjectContainerView alloc]initWithFrame:self.view.bounds];
//    YXExamViewController *examVC = [[YXExamViewController alloc]init];
//    YXTaskViewController *taskVC = [[YXTaskViewController alloc]init];
//    YXNoticeViewController *notiVC = [[YXNoticeViewController alloc]init];
//    YXBulletinViewController *bulletinVC = [[YXBulletinViewController alloc]init];
//    containerView.viewControllers = @[examVC,taskVC,notiVC,bulletinVC];
//    [self.view addSubview:containerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getTrainList{
    [self.request stopRequest];
    self.request = [[YXTrainListRequest alloc]init];
    [self startLoading];
    WEAK_SELF
    [self.request startRequestWithRetClass:[YXTrainListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            [self showToast:error.localizedDescription];
            return;
        }
        [self dealWithRetItem:retItem];
    }];
}

- (void)dealWithRetItem:(YXTrainListRequestItem *)retItem{
    self.trainlistItem = retItem;
    YXTrainListRequestItem_body_train *train = retItem.body.trains.firstObject;
    self.title = train.name;
    YXProjectContainerView *containerView = [[YXProjectContainerView alloc]initWithFrame:self.view.bounds];
    YXExamViewController *examVC = [[YXExamViewController alloc]init];
    YXTaskViewController *taskVC = [[YXTaskViewController alloc]init];
    YXNoticeViewController *notiVC = [[YXNoticeViewController alloc]init];
    YXBulletinViewController *bulletinVC = [[YXBulletinViewController alloc]init];
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

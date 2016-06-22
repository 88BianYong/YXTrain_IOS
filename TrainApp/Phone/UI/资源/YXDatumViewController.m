//
//  YXDatumViewController.m
//  TrainApp
//
//  Created by 李五民 on 16/6/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXDatumViewController.h"
#import "YXAllDatumViewController.h"
#import "YXMyDatumViewController.h"
#import "YXDatumSearchViewController.h"

@interface YXDatumViewController ()

@property (nonatomic,strong) UIViewController *currentViewController;

@end

@implementation YXDatumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configSegmentUI];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonClicked)];
    //[self yx_setupRightButtonItemWithImage:nil title:@"搜索"];
    
}

- (void)configSegmentUI {
    UISegmentedControl *seg = [[UISegmentedControl alloc]initWithItems:@[@"全部资源",@"我的资源"]];
    seg.frame = CGRectMake(0, 0, 160, 30);
    seg.selectedSegmentIndex = 0;
    [seg addTarget:self action:@selector(datumSourceChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = seg;
    
    YXAllDatumViewController *allDatumViewController = [[YXAllDatumViewController alloc] init];
    [self addChildViewController:allDatumViewController];
    YXMyDatumViewController *myDatumViewController = [[YXMyDatumViewController alloc] init];
    [self addChildViewController:myDatumViewController];
    
    [self.view addSubview:allDatumViewController.view];
    [allDatumViewController didMoveToParentViewController:self];
    self.currentViewController = allDatumViewController;
}

- (void)datumSourceChanged:(UISegmentedControl *)seg{
    UIViewController *viewController = self.childViewControllers[seg.selectedSegmentIndex];
    if (![viewController isKindOfClass:[self.currentViewController class]]) {
        [self.currentViewController willMoveToParentViewController:nil];
        [self transitionFromViewController:self.currentViewController toViewController:viewController duration:0.1 options:UIViewAnimationOptionTransitionNone animations:^{
        }  completion:^(BOOL finished) {
            self.currentViewController=viewController;
            [viewController didMoveToParentViewController:self];
        }];
    }
}

- (void)searchButtonClicked{
    YXDatumSearchViewController *vc = [[YXDatumSearchViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:^{
//        [self foldOrderView];
//        [self foldFilterView];
    }];
}


@end

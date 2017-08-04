//
//  NoticeBriefMangerViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "NoticeBriefMangerViewController_17.h"
#import "NoticeListViewController_17.h"
#import "BriefListViewController_17.h"
@interface NoticeBriefMangerViewController_17 ()
@property (nonatomic,strong) UIViewController *currentViewController;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation NoticeBriefMangerViewController_17

- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedIndex = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupUI];
}

- (void)setupUI {
    [self setNoticeBriefTitleView];
    NoticeListViewController_17 *noticeVC = [[NoticeListViewController_17 alloc] init];
    [self addChildViewController:noticeVC];
    BriefListViewController_17 *electiveVC = [[BriefListViewController_17 alloc] init];
    [self addChildViewController:electiveVC];
    [electiveVC didMoveToParentViewController:self];
    [self.view addSubview:noticeVC.view];
    self.currentViewController = noticeVC;
}
- (void)setNoticeBriefTitleView {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 30.0f)];
    UISegmentedControl *seg = [[UISegmentedControl alloc]initWithItems:@[@"通知",@"简报"]];
    seg.tintColor = [UIColor whiteColor];
    seg.backgroundColor = [UIColor whiteColor];
    [seg setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"41c694"]] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [seg setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"a1a7ae"],NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} forState:UIControlStateNormal];
    [seg setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"334466"],NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} forState:UIControlStateSelected];
    seg.frame = CGRectMake(0, 0, 100, 30);
    seg.selectedSegmentIndex = _selectedIndex;
    [seg addTarget:self action:@selector(noticeBriefChanged:) forControlEvents:UIControlEventValueChanged];
    [titleView addSubview:seg];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1.0f, 17.0f)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"334466"];
    lineView.center = seg.center;
    [titleView addSubview:lineView];
    self.navigationItem.titleView = titleView;
}

- (void)noticeBriefChanged:(UISegmentedControl *)seg{
    _selectedIndex = seg.selectedSegmentIndex;
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
@end

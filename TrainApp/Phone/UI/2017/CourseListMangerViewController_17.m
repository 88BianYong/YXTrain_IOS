//
//  CourseListMangerViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseListMangerViewController_17.h"
#import "CourseListCompulsoryViewController_17.h"
#import "CourseListElectiveViewController_17.h"
#import "CourseHistoryViewController_17.h"
@interface CourseListMangerViewController_17 ()
@property (nonatomic,strong) UIViewController *currentViewController;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation CourseListMangerViewController_17
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
    [self setDatumTitleView];
    CourseListCompulsoryViewController_17 *compulsoryVC = [[CourseListCompulsoryViewController_17 alloc] init];
    [self addChildViewController:compulsoryVC];
    CourseListElectiveViewController_17 *electiveVC = [[CourseListElectiveViewController_17 alloc] init];
    [self addChildViewController:electiveVC];
    [compulsoryVC didMoveToParentViewController:self];
    [self.view addSubview:compulsoryVC.view];
    self.currentViewController = compulsoryVC;
    [self setupRightWithTitle:@"看课记录"];
}
- (void)naviRightAction{
    CourseHistoryViewController_17 *vc = [[CourseHistoryViewController_17 alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setDatumTitleView {
    UISegmentedControl *seg = [[UISegmentedControl alloc]initWithItems:@[@"必修课程",@"选修课程"]];
    seg.tintColor = [UIColor whiteColor];
    seg.backgroundColor = [UIColor whiteColor];
    [seg setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"41c694"]] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [seg setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"a1a7ae"],NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} forState:UIControlStateNormal];
    [seg setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"334466"],NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} forState:UIControlStateSelected];
    seg.frame = CGRectMake(0, 0, 160, 30);
    seg.selectedSegmentIndex = _selectedIndex;
    [seg addTarget:self action:@selector(courseListChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = seg;
}

- (void)courseListChanged:(UISegmentedControl *)seg{
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

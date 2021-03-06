//
//  CourseListMangerViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseListMangerViewController_17.h"
#import "CourseWatchListViewController_17.h"
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
    self.navigationItem.title = @"课程";
    if ([LSTSharedInstance sharedInstance].trainManager.currentProject.isOpenTheme.boolValue) {
        self.emptyView = [[YXEmptyView alloc]init];
        self.emptyView.title = @"请先等待主题选学";
        self.emptyView.imageName = @"没选课";
        [self.view addSubview:self.emptyView];
        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        return;
    }
    _selectedIndex = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupUI];
}

- (void)setupUI {
    if (self.isShowChoose) {
        [self setCourseTitleView];
        CourseWatchListViewController_17 *compulsoryVC = [[CourseWatchListViewController_17 alloc] init];
        compulsoryVC.segmentString = self.segmentString;
        compulsoryVC.studyString = self.studyString;
        compulsoryVC.stageString = self.stageString;
        compulsoryVC.typeString = @"102";
        [self addChildViewController:compulsoryVC];
       CourseWatchListViewController_17 *electiveVC = [[CourseWatchListViewController_17 alloc] init];
        electiveVC.segmentString = self.segmentString;
        electiveVC.studyString = self.studyString;
        electiveVC.stageString = self.stageString;
        electiveVC.typeString = @"101";
        [self addChildViewController:electiveVC];
        [compulsoryVC didMoveToParentViewController:self];
        [self.view addSubview:compulsoryVC.view];
        self.currentViewController = compulsoryVC;
    }else {
        self.navigationItem.title = @"课程";
        CourseWatchListViewController_17 *compulsoryVC = [[CourseWatchListViewController_17 alloc] init];
        compulsoryVC.segmentString = self.segmentString;
        compulsoryVC.studyString = self.studyString;
        compulsoryVC.stageString = self.stageString;
        compulsoryVC.typeString = @"0";
        [self addChildViewController:compulsoryVC];
        [compulsoryVC didMoveToParentViewController:self];
        [self.view addSubview:compulsoryVC.view];
        self.currentViewController = compulsoryVC;
    }
    [self setupRightWithTitle:@"看课记录"];
}
- (void)naviRightAction{
    CourseHistoryViewController_17 *VC = [[CourseHistoryViewController_17 alloc]init];
    VC.stageString = self.stageString;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)setCourseTitleView {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 30.0f)];
    UISegmentedControl *seg = [[UISegmentedControl alloc]initWithItems:@[@"必修课程",@"选修课程"]];
    seg.tintColor = [UIColor whiteColor];
    seg.backgroundColor = [UIColor whiteColor];
    [seg setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"41c694"]] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [seg setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"a1a7ae"],NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} forState:UIControlStateNormal];
    [seg setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"334466"],NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} forState:UIControlStateSelected];
    seg.frame = CGRectMake(0, 0, 160, 30);
    seg.selectedSegmentIndex = _selectedIndex;
    [seg addTarget:self action:@selector(courseListChanged:) forControlEvents:UIControlEventValueChanged];
    [titleView addSubview:seg];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1.0f, 17.0f)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"334466"];
    lineView.center = seg.center;
    [titleView addSubview:lineView];
    self.navigationItem.titleView = titleView;
}

- (void)courseListChanged:(UISegmentedControl *)seg{
    if (_selectedIndex == seg.selectedSegmentIndex) {
        return;
    }
    _selectedIndex = seg.selectedSegmentIndex;
    UIViewController *viewController = self.childViewControllers[seg.selectedSegmentIndex];
    [self.currentViewController willMoveToParentViewController:nil];
    [self transitionFromViewController:self.currentViewController toViewController:viewController duration:0.1 options:UIViewAnimationOptionTransitionNone animations:^{
    }  completion:^(BOOL finished) {
        self.currentViewController=viewController;
        [viewController didMoveToParentViewController:self];
        [viewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }];
}
@end

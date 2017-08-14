//
//  CourseCenterManagerViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/3.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseCenterManagerViewController_17.h"
#import "CourseCenterListViewController_17.h"
#import "CourseCenterListViewController_17.h"
#import "CourseHistoryViewController_17.h"
#import "CourseCenterConditionRequest_17.h"
#import "CourseRecordListViewController_17.h"
#import "CourseListRequest_17.h"
@interface CourseCenterManagerViewController_17 ()
@property (nonatomic,strong) UIViewController *currentViewController;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) CourseCenterConditionRequest_17 *conditionRequest;
@property (nonatomic, strong) CourseListRequest_17Item_SearchTerm *conditionItem;

@end

@implementation CourseCenterManagerViewController_17

- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选课中心";
    self.selectedIndex = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self requestForCenterCondition];
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForCenterCondition];
    };
    
    self.dataErrorView = [[DataErrorView alloc] init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForCenterCondition];
    };
    
    self.emptyView = [[YXEmptyView alloc] init];
    self.emptyView.title = @"没有符合条件的课程";
    self.emptyView.imageName = @"没有符合条件的课程";
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
#pragma mark - set
- (void)setConditionItem:(CourseListRequest_17Item_SearchTerm *)conditionItem {
    if (conditionItem == nil) {
        return;
    }
    _conditionItem = conditionItem;
    [self setupUI];
}
- (void)setupUI {
    if (self.conditionItem.coursetypes.count == 2){
      [self setCourseTitleView];
        CourseCenterListViewController_17 *centerListVC = [[CourseCenterListViewController_17 alloc] init];
        centerListVC.conditionItem = self.conditionItem;
        centerListVC.tabString = @"all";
        [self addChildViewController:centerListVC];
        CourseCenterListViewController_17 *localListVC = [[CourseCenterListViewController_17 alloc] init];
        localListVC.isCourseTypeBool = YES;
        localListVC.conditionItem = self.conditionItem;
        localListVC.tabString = @"all";
        [self addChildViewController:localListVC];
        [centerListVC didMoveToParentViewController:self];
        [self.view addSubview:centerListVC.view];
        [centerListVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        self.currentViewController = centerListVC;
    }else {
        self.navigationItem.title = @"选课中心";
        CourseCenterListViewController_17 *centerListVC = [[CourseCenterListViewController_17 alloc] init];
        centerListVC.conditionItem = self.conditionItem;
        centerListVC.tabString = @"all";
        [self addChildViewController:centerListVC];
        [centerListVC didMoveToParentViewController:self];
        [self.view addSubview:centerListVC.view];
        self.currentViewController = centerListVC;
        [centerListVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    [self setupRightWithTitle:@"看课记录"];
}
- (void)naviRightAction{
    CourseRecordListViewController_17 *VC = [[CourseRecordListViewController_17 alloc]init];
    VC.courseType = self.conditionItem.coursetypes[self.selectedIndex];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)setCourseTitleView {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 30.0f)];   
    UISegmentedControl *seg = [[UISegmentedControl alloc]initWithItems:@[@"选修课程",@"本地课程"]];
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
    self.selectedIndex = seg.selectedSegmentIndex;
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
#pragma mark - request
- (void)requestForCenterCondition{
    [self startLoading];
    CourseCenterConditionRequest_17 *request = [[CourseCenterConditionRequest_17 alloc] init];
    WEAK_SELF
    [request startRequestWithRetClass:[CourseListRequest_17Item_SearchTerm class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        CourseListRequest_17Item_SearchTerm *item = retItem;
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = item.coursetypes.count > 0;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        self.conditionItem = retItem;
    }];
    self.conditionRequest = request;
}
@end

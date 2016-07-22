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
#import "YXDatumSearchView.h"
#import "YXNavigationController.h"
#import "UIWindow+YXAddtion.h"

@interface YXDatumViewController ()

@property (nonatomic,strong) UIViewController *currentViewController;
@property (nonatomic,strong) YXAllDatumViewController *allDatumViewController;
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) YXDatumSearchView *seachView;

@property (nonatomic, assign) NSInteger selectedIndex;


@end

@implementation YXDatumViewController
- (void)dealloc{
    DDLogInfo(@"release====>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedIndex = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configSegmentUI];
    [self setupRightWithImageNamed:@"搜索" highlightImageNamed:@"搜索"];
}

- (void)configSegmentUI {
    [self setDatumTitleView];
    self.allDatumViewController = [[YXAllDatumViewController alloc] init];
    [self addChildViewController:self.allDatumViewController];
    YXMyDatumViewController *myDatumViewController = [[YXMyDatumViewController alloc] init];
    [self addChildViewController:myDatumViewController];
    
    [self.view addSubview:self.allDatumViewController.view];
    [self.allDatumViewController didMoveToParentViewController:self];
    self.currentViewController = self.allDatumViewController;
}

- (void)setDatumTitleView {
    UISegmentedControl *seg = [[UISegmentedControl alloc]initWithItems:@[@"全部资源",@"我的资源"]];
    seg.tintColor = [UIColor whiteColor];
    seg.backgroundColor = [UIColor whiteColor];
    [seg setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"41c694"]] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [seg setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"505f84"],NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} forState:UIControlStateNormal];
    [seg setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0067be"],NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} forState:UIControlStateSelected];
    seg.frame = CGRectMake(0, 0, 160, 30);
    seg.selectedSegmentIndex = _selectedIndex;
    [seg addTarget:self action:@selector(datumSourceChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = seg;
}

- (void)datumSourceChanged:(UISegmentedControl *)seg{
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

- (void)naviRightAction{
    self.seachView = [[YXDatumSearchView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.seachView.backgroundColor = [UIColor whiteColor];
    [self.seachView setFirstResponse];
    @weakify(self);
    self.seachView.textBeginEdit = ^{
        @strongify(self);
        if (!self.maskView) {
            self.maskView = [[UIView alloc] init];
            UITapGestureRecognizer *maskTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTapGesture:)];
            [self.maskView addGestureRecognizer:maskTapGesture];
            self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            [self.view addSubview:self.maskView];
            [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
        }
    };
    self.seachView.texEndEdit = ^{
        @strongify(self);
        if (self.maskView) {
            [self.maskView removeFromSuperview];
            self.maskView = nil;
        }
        [super setupLeftBack];
        [self setupRightWithImageNamed:@"搜索" highlightImageNamed:@"搜索"];
        [self setDatumTitleView];
    };
    self.seachView.textShouldClear = ^{
    };
    self.seachView.textShouldReturn = ^(NSString *text){
        @strongify(self);
        //[super setupLeftBack];
        //[self setupRightWithTitle:@"搜索"];
        //[self setDatumTitleView];
        YXDatumSearchViewController *vc = [[YXDatumSearchViewController alloc] init];
        YXNavigationController *navi = [[YXNavigationController alloc] initWithRootViewController:vc];
        vc.keyWord = text;
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        UIViewController *rootVC = [window visibleViewController];
        [rootVC presentViewController:navi animated:YES completion:^{
            if (self.maskView) {
                [self.maskView removeFromSuperview];
                self.maskView = nil;
            }
        }];        
    };
    self.navigationItem.titleView = self.seachView;
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.leftBarButtonItems = nil;
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (void)maskTapGesture:(UIGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.seachView endEditing:YES];
    }
}


@end

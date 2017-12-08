//
//  MasterOffActiveContainerView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/28.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterOffActiveContainerView_17.h"
@interface MasterOffActiveContainerView_17 ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation MasterOffActiveContainerView_17
- (void)dealloc {
    DDLogDebug(@"release======>>%@",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, 5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self addSubview:lineView];
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 5,kScreenWidth, 45.0f)];
    [self addSubview:self.topView];
    
    self.bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.topView.frame.origin.y+self.topView.frame.size.height, self.frame.size.width, self.frame.size.height-self.topView.frame.size.height)];
    self.bottomScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    self.bottomScrollView.directionalLockEnabled = YES;
    self.bottomScrollView.bounces = NO;
    self.bottomScrollView.delegate = self;
    self.bottomScrollView.contentSize = CGSizeMake(kScreenWidth * 5, 200.f);
    [self addSubview:self.bottomScrollView];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50.0f,kScreenWidth, 1.0f)];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self addSubview:self.lineView];
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"reloadParticipantButton" object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        UIButton *button = [self.topView viewWithTag:10086 + self.containerViewControllers.count - 1];
        [button setTitle:x.object forState:UIControlStateSelected];
    }];
}
- (void)setContainerViewControllers:(NSArray<__kindof UIViewController *> *)containerViewControllers {
    _containerViewControllers = containerViewControllers;
    [_containerViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.view.frame = CGRectMake(self.bottomScrollView.frame.size.width*idx, 0, self.bottomScrollView.frame.size.width, self.bottomScrollView.frame.size.height);
        obj.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.bottomScrollView addSubview:obj.view];
        UIButton *b = [self buttonWithTitle:obj.title];
        b.tag = 10086 + idx;
        b.frame = CGRectMake(100.0f * idx, 0, 100.0f, 45.0f);
        [self.topView addSubview:b];
        if (idx == 0) {
            b.selected = YES;
        }
    }];
    self.bottomScrollView.contentSize = CGSizeMake(self.bottomScrollView.frame.size.width*self.containerViewControllers.count, self.bottomScrollView.frame.size.height);
}
- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:[UIColor colorWithHexString:@"85898f"] forState:UIControlStateNormal];
    [b setTitleColor:[UIColor colorWithHexString:@"334466"] forState:UIControlStateSelected];
    b.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [b addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return b;
}
- (void)layoutSubviews{
    self.bottomScrollView.contentSize = CGSizeMake(self.bottomScrollView.frame.size.width*self.containerViewControllers.count, self.bottomScrollView.frame.size.height);
}

- (void)btnAction:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    for (UIButton *b in self.topView.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            b.selected = NO;
        }
    }
    sender.selected = YES;
    NSInteger index = sender.tag - 10086;
    self.bottomScrollView.contentOffset = CGPointMake(self.bottomScrollView.frame.size.width*index, 0);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    for (UIButton *b in self.topView.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            b.selected = NO;
            if (b.tag - 10086 == index) {
                b.selected = YES;
            }
        }
    }
}
@end

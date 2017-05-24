//
//  CourseDetailContainerView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseDetailContainerView.h"
const NSInteger kTagBase = 10086;
@interface CourseDetailContainerView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation CourseDetailContainerView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.tabItemArray = @[@"章节",@"简介",@"评论"];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.topView = [[UIView alloc]init];
    [self addSubview:self.topView];
    
    self.bottomScrollView = [[UIScrollView alloc] init];
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    self.bottomScrollView.directionalLockEnabled = YES;
    self.bottomScrollView.bounces = NO;
    self.bottomScrollView.delegate = self;
    self.bottomScrollView.backgroundColor = [UIColor redColor];
    [self addSubview:self.bottomScrollView];
    
    self.sliderView = [[UIView alloc]init];
    self.sliderView.backgroundColor = [UIColor colorWithHexString:@"0070c9"];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"d2d8df"];
    [self addSubview:self.lineView];
}
- (void)setupLayout {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.size.mas_offset(CGSizeMake(kScreenWidth, 45));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left);
        make.right.equalTo(self.topView.mas_right);
        make.top.equalTo(self.topView.mas_bottom);
        make.height.mas_offset(1.0f);
    }];
    
    [self.bottomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.lineView.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
}
#pragma mark - set
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers {
    _viewControllers = viewControllers;
    for (UIView *v in self.topView.subviews) {
        [v removeFromSuperview];
    }
    for (UIView *v in self.bottomScrollView.subviews) {
        [v removeFromSuperview];
    }
    [self.sliderView removeFromSuperview];
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.bottomScrollView addSubview:vc.view];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomScrollView.mas_left).offset(kScreenWidth * idx);
            make.top.equalTo(self.bottomScrollView.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.mas_offset(kScreenWidth);
        }];
        // top
        UIButton *b = [self buttonWithTitle:self.tabItemArray[idx]];
        
        CGFloat btnWidth = kScreenWidth/self->_viewControllers.count;
        b.tag = kTagBase + idx;
        [self.topView addSubview:b];
        [b mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topView.mas_left).offset(btnWidth * idx);
            make.top.equalTo(self.topView.mas_top);
            make.size.mas_offset(CGSizeMake(btnWidth, 45.0f));
        }];
        if (idx == 0) {
            b.selected = YES;
        }
    }];
    [self addSubview:self.sliderView];
    UIButton *selectedButton = [self.topView viewWithTag:kTagBase];
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(45.0f, 2.0f));
        make.bottom.equalTo(self.topView.mas_bottom);
        make.centerX.equalTo(selectedButton.mas_centerX);
    }];
}
- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *b = [[UIButton alloc]init];
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:[UIColor colorWithHexString:@"bbc2c9"] forState:UIControlStateNormal];
    [b setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateSelected];
    b.titleLabel.font = [UIFont systemFontOfSize:13];
    [b addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return b;
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
    NSInteger index = sender.tag - kTagBase;
    [UIView animateWithDuration:0.3 animations:^{
        [self.sliderView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(45.0f, 2.0f));
            make.bottom.equalTo(self.topView.mas_bottom);
            make.centerX.equalTo(sender.mas_centerX);
        }];
    }];
    self.bottomScrollView.contentOffset = CGPointMake(self.bottomScrollView.frame.size.width*index, 0);
}
- (void)layoutSubviews{
    self.bottomScrollView.contentSize = CGSizeMake(self.bottomScrollView.frame.size.width*self.viewControllers.count, 0);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UIButton *selectedButton = [self.topView viewWithTag:kTagBase + (scrollView.contentOffset.x / 375.0f)];
    [self.sliderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(45.0f, 2.0f));
        make.bottom.equalTo(self.topView.mas_bottom);
        make.centerX.equalTo(selectedButton.mas_centerX);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    for (UIButton *b in self.topView.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            b.selected = NO;
            if (b.tag-kTagBase == index) {
                b.selected = YES;
            }
        }
    }
}

@end

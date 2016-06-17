//
//  YXProjectContainerView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/17.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXProjectContainerView.h"

static const NSUInteger kTagBase = 3333;

@interface YXProjectContainerView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *seperatorView;
@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;
@end

@implementation YXProjectContainerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    [self addSubview:self.topView];
    
    self.seperatorView = [[UIView alloc]initWithFrame:CGRectMake(0, self.topView.frame.origin.y+self.topView.frame.size.height, self.frame.size.width, 1/[UIScreen mainScreen].scale)];
    self.seperatorView.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:self.seperatorView];
    
    self.bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.seperatorView.frame.origin.y+self.seperatorView.frame.size.height, self.frame.size.width, self.frame.size.height-self.topView.frame.size.height-self.seperatorView.frame.size.height)];
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.bounces = NO;
    self.bottomScrollView.delegate = self;
    [self addSubview:self.bottomScrollView];
    
    self.sliderView = [[UIView alloc]init];
    self.sliderView.backgroundColor = [UIColor redColor];
}

- (void)setViewControllers:(NSArray *)viewControllers{
    _viewControllers = viewControllers;
    // clear old views first
    for (UIView *v in self.topView.subviews) {
        [v removeFromSuperview];
    }
    for (UIView *v in self.bottomScrollView.subviews) {
        [v removeFromSuperview];
    }
    [self.sliderView removeFromSuperview];
    
    // set new views
    [viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // bottom
        UIViewController *vc = (UIViewController *)obj;
        vc.view.frame = CGRectMake(self.bottomScrollView.frame.size.width*idx, 0, self.bottomScrollView.frame.size.width, self.bottomScrollView.frame.size.height);
        [self.bottomScrollView addSubview:vc.view];
        // top
        CGFloat btnWidth = self.topView.frame.size.width/viewControllers.count;
        UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(btnWidth*idx, 0, btnWidth, self.topView.frame.size.height)];
        [b setTitle:vc.title forState:UIControlStateNormal];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        b.tag = kTagBase + idx;
        [b addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:b];
        
    }];
    self.sliderView.frame = CGRectMake(0, self.seperatorView.frame.origin.y+self.seperatorView.frame.size.height-3, self.topView.frame.size.width/viewControllers.count, 3);
    [self addSubview:self.sliderView];
    self.bottomScrollView.contentSize = CGSizeMake(self.bottomScrollView.frame.size.width*viewControllers.count, self.bottomScrollView.frame.size.height);
}

- (void)btnAction:(UIButton *)sender{
    NSInteger index = sender.tag - kTagBase;
    CGRect rect = self.sliderView.frame;
    rect.origin.x = rect.size.width*index;
    self.sliderView.frame = rect;
    
    self.bottomScrollView.contentOffset = CGPointMake(self.bottomScrollView.frame.size.width*index, 0);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat sliderX = offsetX/scrollView.contentSize.width*self.topView.frame.size.width;
    CGRect rect = self.sliderView.frame;
    rect.origin.x = sliderX;
    self.sliderView.frame = rect;
}

@end

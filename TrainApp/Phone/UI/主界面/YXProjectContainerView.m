//
//  YXProjectContainerView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/17.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXProjectContainerView.h"

@interface YXProjectTabItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *defaultImage;
@end
@implementation YXProjectTabItem
@end

static const NSUInteger kTagBase = 3333;

@interface YXProjectContainerView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;

@property (nonatomic, strong) NSArray *tabItemArray;
@end

@implementation YXProjectContainerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupTabItems];
        [self setupUI];
    }
    return self;
}

- (void)setupTabItems{
    YXProjectTabItem *tab1 = [self tabItemWithName:@"考核" selectedImage:[UIImage imageNamed:@"考核当前态"] defaultImage:[UIImage imageNamed:@"考核默认态"]];
    YXProjectTabItem *tab2 = [self tabItemWithName:@"任务" selectedImage:[UIImage imageNamed:@"任务当前态"] defaultImage:[UIImage imageNamed:@"任务默认态"]];
    YXProjectTabItem *tab3 = [self tabItemWithName:@"通知" selectedImage:[UIImage imageNamed:@"通知当前态"] defaultImage:[UIImage imageNamed:@"通知默认态"]];
    YXProjectTabItem *tab4 = [self tabItemWithName:@"简报" selectedImage:[UIImage imageNamed:@"简报当前态"] defaultImage:[UIImage imageNamed:@"简报默认态"]];
    self.tabItemArray = @[tab1,tab2,tab3,tab4];
}

- (YXProjectTabItem *)tabItemWithName:(NSString *)name selectedImage:(UIImage *)selectedImage defaultImage:(UIImage *)defaultImage{
    YXProjectTabItem *item = [[YXProjectTabItem alloc]init];
    item.name = name;
    item.selectedImage = selectedImage;
    item.defaultImage = defaultImage;
    return item;
}

- (void)setupUI{
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    [self addSubview:self.topView];
    
    self.bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.topView.frame.origin.y+self.topView.frame.size.height, self.frame.size.width, self.frame.size.height-self.topView.frame.size.height)];
    self.bottomScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    self.bottomScrollView.directionalLockEnabled = YES;
    self.bottomScrollView.bounces = NO;
    self.bottomScrollView.delegate = self;
    [self addSubview:self.bottomScrollView];
    
    self.sliderView = [[UIView alloc]init];
    self.sliderView.backgroundColor = [UIColor colorWithHexString:@"0070c9"];
    self.sliderView.frame = CGRectMake(0, 0, 64, 2);
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
        vc.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.bottomScrollView addSubview:vc.view];
        // top
        YXProjectTabItem *tabItem = self.tabItemArray[idx];
        UIButton *b = [self buttonWithTitle:tabItem.name image:tabItem.defaultImage selectedImage:tabItem.selectedImage];
        CGFloat btnWidth = self.topView.frame.size.width/viewControllers.count;
        b.frame = CGRectMake(btnWidth*idx, 0, btnWidth, self.topView.frame.size.height);
        b.tag = kTagBase + idx;
        [self.topView addSubview:b];
        if (idx == 0) {
            b.selected = YES;
        }
    }];
    self.sliderView.center = CGPointMake(self.topView.frame.size.width/4/2, self.topView.frame.size.height-1);
    [self addSubview:self.sliderView];
}

- (UIButton *)buttonWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage{
    UIButton *b = [[UIButton alloc]init];
    [b setTitle:title forState:UIControlStateNormal];
    [b setImage:image forState:UIControlStateNormal];
    [b setImage:selectedImage forState:UIControlStateSelected];
    [b setTitleColor:[UIColor colorWithHexString:@"bbc2c9"] forState:UIControlStateNormal];
    [b setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateSelected];
    b.titleLabel.font = [UIFont systemFontOfSize:13];
    b.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
    b.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
    [b addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return b;
}

- (void)layoutSubviews{
    self.bottomScrollView.contentSize = CGSizeMake(self.bottomScrollView.frame.size.width*self.viewControllers.count, self.bottomScrollView.frame.size.height);
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
        self.sliderView.center = CGPointMake(self.topView.frame.size.width/4/2*(1+index*2), self.sliderView.center.y);
    }];
    self.bottomScrollView.contentOffset = CGPointMake(self.bottomScrollView.frame.size.width*index, 0);
    if (self.selectedViewContrller && self.viewControllers.count > index) {
        self.selectedViewContrller(self.viewControllers[index]);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat sliderX = offsetX/scrollView.contentSize.width*self.topView.frame.size.width;
    self.sliderView.center = CGPointMake(self.topView.frame.size.width/4/2+sliderX, self.sliderView.center.y);
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
    if (self.selectedViewContrller && self.viewControllers.count > index) {
        self.selectedViewContrller(self.viewControllers[index]);
    }

}

@end

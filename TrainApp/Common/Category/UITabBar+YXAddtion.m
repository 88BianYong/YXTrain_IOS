//
//  UITabBar+YXAddtion.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/4.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UITabBar+YXAddtion.h"
@implementation UITabBar (YXAddtion)
//显示小红点
- (void)showBadgeOnItemIndex:(NSInteger)index withTabbarItem:(NSInteger)total{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 2.5;//圆形
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    CGFloat percentX = (index + 0.6) / total;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.15 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 5.0, 5.0);//圆形大小为10
    badgeView.clipsToBounds = YES;
    [self addSubview:badgeView];
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(NSInteger)index withTabbarItem:(NSInteger)total{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(NSInteger)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}


@end

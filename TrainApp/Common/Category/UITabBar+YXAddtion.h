//
//  UITabBar+YXAddtion.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/4.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (YXAddtion)
- (void)showBadgeOnItemIndex:(NSInteger)index withTabbarItem:(NSInteger)total;
- (void)hideBadgeOnItemIndex:(NSInteger)index withTabbarItem:(NSInteger)total;
@end

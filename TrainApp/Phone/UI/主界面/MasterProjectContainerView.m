//
//  MasterProjectContainerView.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterProjectContainerView.h"

@implementation MasterProjectContainerView
- (void)setupTabItems{
    YXProjectTabItem *tab1 = [self tabItemWithName:@"学情" selectedImage:[UIImage imageNamed:@"考核当前态"] defaultImage:[UIImage imageNamed:@"考核默认态"]];
    YXProjectTabItem *tab2 = [self tabItemWithName:@"管理" selectedImage:[UIImage imageNamed:@"任务当前态"] defaultImage:[UIImage imageNamed:@"任务默认态"]];
    YXProjectTabItem *tab3 = [self tabItemWithName:@"任务" selectedImage:[UIImage imageNamed:@"简报当前态"] defaultImage:[UIImage imageNamed:@"简报默认态"]];
    self.tabItemArray = @[tab1,tab2,tab3];
}
- (YXProjectTabItem *)tabItemWithName:(NSString *)name selectedImage:(UIImage *)selectedImage defaultImage:(UIImage *)defaultImage{
    YXProjectTabItem *item = [[YXProjectTabItem alloc]init];
    item.name = name;
    item.selectedImage = selectedImage;
    item.defaultImage = defaultImage;
    return item;
}
@end

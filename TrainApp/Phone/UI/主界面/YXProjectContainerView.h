//
//  YXProjectContainerView.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/17.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXProjectContainerView : UIView
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, copy) void (^selectedViewContrller)(UIViewController *vc);
@end

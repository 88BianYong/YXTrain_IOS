//
//  YXProjectContainerView.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/17.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YXProjectTabItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *defaultImage;
@end
@interface YXProjectContainerView : UIView
@property (nonatomic, strong) NSArray *tabItemArray;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, copy) void (^selectedViewContrller)(UIViewController *vc);
- (void)setupTabItems;
@end

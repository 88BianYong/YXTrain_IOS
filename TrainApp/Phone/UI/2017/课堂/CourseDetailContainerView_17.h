//
//  CourseDetailContainerView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/25.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDetailContainerView_17 : UIView
@property (nonatomic, strong) NSArray<NSString *> *tabItemArray;
@property (nonatomic, strong) NSArray<UIViewController *> *viewControllers;
@property (nonatomic, strong) NSString *contentString;
@property (nonatomic, copy) void(^courseDetailContainerButtonBlock)();
@end

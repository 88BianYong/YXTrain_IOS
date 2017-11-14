//
//  CourseDetailContainerView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDetailContainerView : UIView
@property (nonatomic, strong) NSArray<NSString *> *tabItemArray;
@property (nonatomic, strong) NSArray<UIViewController *> *viewControllers;

@end

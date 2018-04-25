//
//  YXProjectSelectionView.h
//  TrainApp
//
//  Created by niuzhaowang on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TrainListProjectGroup;

@interface YXProjectSelectionView : UIView
@property (nonatomic, strong) void(^showProjectChangeBlock)(void);
@end

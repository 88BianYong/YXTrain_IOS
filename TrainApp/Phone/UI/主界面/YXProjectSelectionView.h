//
//  YXProjectSelectionView.h
//  TrainApp
//
//  Created by niuzhaowang on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXProjectSelectionView : UIView
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray *projectArray;
@property (nonatomic, strong) void(^projectChangeBlock)(NSInteger index);
@end

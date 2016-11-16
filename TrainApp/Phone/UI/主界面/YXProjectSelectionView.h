//
//  YXProjectSelectionView.h
//  TrainApp
//
//  Created by niuzhaowang on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YXProjectSelectionView : UIView
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSArray *trainingProjectArray;
@property (nonatomic, strong) NSArray *trainedProjectArray;
@property (nonatomic, strong) void(^projectChangeBlock)(NSIndexPath *indexPath);
@end
